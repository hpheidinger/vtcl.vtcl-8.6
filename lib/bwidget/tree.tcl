# ------------------------------------------------------------------------------
#  tree.tcl
#  This file is part of Unifix BWidget Toolkit
#  $Id: tree.tcl,v 1.2 2003/05/04 20:00:37 cgavin Exp $
# ------------------------------------------------------------------------------
#  Index of commands:
#     - Tree::create
#     - Tree::configure
#     - Tree::cget
#     - Tree::insert
#     - Tree::itemconfigure
#     - Tree::itemcget
#     - Tree::bindText
#     - Tree::bindImage
#     - Tree::delete
#     - Tree::move
#     - Tree::reorder
#     - Tree::selection
#     - Tree::exists
#     - Tree::parent
#     - Tree::index
#     - Tree::nodes
#     - Tree::see
#     - Tree::opentree
#     - Tree::closetree
#     - Tree::edit
#     - Tree::xview
#     - Tree::yview
#     - Tree::_update_edit_size
#     - Tree::_destroy
#     - Tree::_see
#     - Tree::_recexpand
#     - Tree::_subdelete
#     - Tree::_update_scrollregion
#     - Tree::_cross_event
#     - Tree::_draw_node
#     - Tree::_draw_subnodes
#     - Tree::_update_nodes
#     - Tree::_draw_tree
#     - Tree::_redraw_tree
#     - Tree::_redraw_selection
#     - Tree::_redraw_idle
#     - Tree::_drag_cmd
#     - Tree::_drop_cmd
#     - Tree::_over_cmd
#     - Tree::_auto_scroll
#     - Tree::_scroll
# ------------------------------------------------------------------------------

namespace eval Tree {
    namespace eval Node {
        Widget::declare Tree::Node {
            {-text       String     ""      0}
            {-font       TkResource ""      0 listbox}
            {-image      TkResource ""      0 label}
            {-window     String     ""      0}
            {-fill       TkResource black   0 {listbox -foreground}}
            {-data       String     ""      0}
            {-open       Boolean    0       0}
	    {-selectable Boolean    1       0}
            {-drawcross  Enum       auto    0 {auto allways never}}
        }
    }

    Widget::tkinclude Tree canvas .c \
	    remove     {
	-insertwidth -insertbackground -insertborderwidth -insertofftime
	-insertontime -selectborderwidth -closeenough -confine -scrollregion 
	-xscrollincrement -yscrollincrement -width -height
    } \
	    initialize {
	-relief sunken -borderwidth 2 -takefocus 1 
	-highlightthickness 1 -width 200
    }

    Widget::declare Tree {
        {-deltax           Int 10 0 "%d >= 0"}
        {-deltay           Int 15 0 "%d >= 0"}
        {-padx             Int 0 0 "%d >= 0"}
        {-background       TkResource "" 0 listbox}
        {-selectbackground TkResource "" 0 listbox}
        {-selectforeground TkResource "" 0 listbox}
	{-selectcommand    String     "" 0}
        {-width            TkResource "" 0 listbox}
        {-height           TkResource "" 0 listbox}
        {-selectfill       Boolean 0  0}
        {-showlines        Boolean 1  0}
        {-linesfill        TkResource black  0 {listbox -foreground}}
        {-linestipple      TkResource ""     0 {label -bitmap}}
        {-redraw           Boolean 1  0}
        {-opencmd          String  "" 0}
        {-closecmd         String  "" 0}
        {-dropovermode     Flag    "wpn" 0 "wpn"}
        {-bg               Synonym -background}
    }
    DragSite::include Tree "TREE_NODE" 1
    DropSite::include Tree {
        TREE_NODE {copy {} move {}}
    }

    Widget::addmap Tree "" .c {-deltay -yscrollincrement}

    # Trees on windows have a white (system window) background
    if { $::tcl_platform(platform) == "windows" } {
	option add *Tree.c.background SystemWindow widgetDefault
	option add *TreeNode.fill SystemWindowText widgetDefault
    }

    bind TreeSentinalStart <Button-1> {
	if { $::Tree::sentinal(%W) } {
	    set ::Tree::sentinal(%W) 0
	    break
	}
    }
    
    bind TreeSentinalEnd <Button-1> {
	set ::Tree::sentinal(%W) 0
    }
    
    bind TreeFocus <Button-1> [list focus %W]

    proc ::Tree { path args } { return [eval Tree::create $path $args] }
    proc use {} {}

    variable _edit
}


# ------------------------------------------------------------------------------
#  Command Tree::create
# ------------------------------------------------------------------------------
proc Tree::create { path args } {
    variable $path
    upvar 0  $path data

    Widget::init Tree $path $args
    set ::Tree::sentinal($path.c) 0
    
    set data(root)         {{}}
    set data(selnodes)     {}
    set data(upd,level)    0
    set data(upd,nodes)    {}
    set data(upd,afterid)  ""
    set data(dnd,scroll)   ""
    set data(dnd,afterid)  ""
    set data(dnd,selnodes) {}
    set data(dnd,node)     ""

    frame $path -class Tree -bd 0 -highlightthickness 0 -relief flat \
	    -takefocus 0
    eval canvas $path.c [Widget::subcget $path .c] -xscrollincrement 8
    bindtags $path.c [list TreeSentinalStart TreeFocus $path.c Canvas \
	    [winfo toplevel $path] all TreeSentinalEnd]
    pack $path.c -expand yes -fill both
    $path.c bind cross <ButtonPress-1> [list Tree::_cross_event $path]

    # Added by ericm@scriptics.com
    # These allow keyboard traversal of the tree
    bind $path.c <KeyPress-Up>    "Tree::_keynav up $path"
    bind $path.c <KeyPress-Down>  "Tree::_keynav down $path"
    bind $path.c <KeyPress-Right> "Tree::_keynav right $path"
    bind $path.c <KeyPress-Left>  "Tree::_keynav left $path"
    bind $path.c <KeyPress-space> "+Tree::_keynav space $path"

    # These allow keyboard control of the scrolling
    bind $path.c <Control-KeyPress-Up>    "$path.c yview scroll -1 units"
    bind $path.c <Control-KeyPress-Down>  "$path.c yview scroll  1 units"
    bind $path.c <Control-KeyPress-Left>  "$path.c xview scroll -1 units"
    bind $path.c <Control-KeyPress-Right> "$path.c xview scroll  1 units"
    # ericm@scriptics.com

    bind $path <Configure> "Tree::_update_scrollregion $path"
    bind $path <Destroy>   "Tree::_destroy $path"
    bind $path <FocusIn>   [list after idle {BWidget::refocus %W %W.c}]

    DragSite::setdrag $path $path.c Tree::_init_drag_cmd \
	    [Widget::cget $path -dragendcmd] 1
    DropSite::setdrop $path $path.c Tree::_over_cmd Tree::_drop_cmd 1

    rename $path ::$path:cmd
    proc ::$path { cmd args } "return \[eval Tree::\$cmd $path \$args\]"

    set w [Widget::cget $path -width]
    set h [Widget::cget $path -height]
    set dy [Widget::cget $path -deltay]
    $path.c configure -width [expr {$w*8}] -height [expr {$h*$dy}]

    # ericm
    # Bind <Button-1> to select the clicked node -- no reason not to, right?
    Tree::bindText  $path <Button-1> "$path selection set"
    Tree::bindImage $path <Button-1> "$path selection set"


    # Add sentinal bindings for double-clicking on items, to handle the 
    # gnarly Tk bug wherein:
    # ButtonClick
    # ButtonClick
    # On a canvas item translates into button click on the item, button click
    # on the canvas, double-button on the item, single button click on the
    # canvas (which can happen if the double-button on the item causes some
    # other event to be handled in between when the button clicks are examined
    # for the canvas)
    $path.c bind TreeItemSentinal <Double-Button-1> \
	    "set ::Tree::sentinal($path.c) 1"
    # ericm

    return $path
}


# ------------------------------------------------------------------------------
#  Command Tree::configure
# ------------------------------------------------------------------------------
proc Tree::configure { path args } {
    variable $path
    upvar 0  $path data

    set res [Widget::configure $path $args]

    set ch1 [expr {[Widget::hasChanged $path -deltax val] |
                   [Widget::hasChanged $path -deltay dy]  |
                   [Widget::hasChanged $path -padx val]   |
                   [Widget::hasChanged $path -showlines val]}]

    set ch2 [expr {[Widget::hasChanged $path -selectbackground val] |
                   [Widget::hasChanged $path -selectforeground val]}]

    if { [Widget::hasChanged $path -linesfill   fill] |
         [Widget::hasChanged $path -linestipple stipple] } {
        $path.c itemconfigure line  -fill $fill -stipple $stipple
        $path.c itemconfigure cross -foreground $fill
    }

    if { $ch1 } {
        _redraw_idle $path 3
    } elseif { $ch2 } {
        _redraw_idle $path 1
    }

    if { [Widget::hasChanged $path -height h] } {
        $path.c configure -height [expr {$h*$dy}]
    }
    if { [Widget::hasChanged $path -width w] } {
        $path.c configure -width [expr {$w*8}]
    }

    if { [Widget::hasChanged $path -redraw bool] && $bool } {
        set upd $data(upd,level)
        set data(upd,level) 0
        _redraw_idle $path $upd
    }

    set force [Widget::hasChanged $path -dragendcmd dragend]
    DragSite::setdrag $path $path.c Tree::_init_drag_cmd $dragend $force
    DropSite::setdrop $path $path.c Tree::_over_cmd Tree::_drop_cmd

    return $res
}


# ------------------------------------------------------------------------------
#  Command Tree::cget
# ------------------------------------------------------------------------------
proc Tree::cget { path option } {
    return [Widget::cget $path $option]
}


# ------------------------------------------------------------------------------
#  Command Tree::insert
# ------------------------------------------------------------------------------
proc Tree::insert { path index parent node args } {
    variable $path
    upvar 0  $path data

    if { [info exists data($node)] } {
        return -code error "node \"$node\" already exists"
    }
    if { ![info exists data($parent)] } {
        return -code error "node \"$parent\" does not exist"
    }

    Widget::init Tree::Node $path.$node $args
    if { ![string compare $index "end"] } {
        lappend data($parent) $node
    } else {
        incr index
        set data($parent) [linsert $data($parent) $index $node]
    }
    set data($node) [list $parent]

    if { ![string compare $parent "root"] } {
        _redraw_idle $path 3
    } elseif { [visible $path $parent] } {
        # parent is visible...
        if { [Widget::getMegawidgetOption $path.$parent -open] } {
            # ...and opened -> redraw whole
            _redraw_idle $path 3
        } else {
            # ...and closed -> redraw cross
            lappend data(upd,nodes) $parent 8
            _redraw_idle $path 2
        }
    }
    return $node
}


# ------------------------------------------------------------------------------
#  Command Tree::itemconfigure
# ------------------------------------------------------------------------------
proc Tree::itemconfigure { path node args } {
    variable $path
    upvar 0  $path data

    if { ![string compare $node "root"] || ![info exists data($node)] } {
        return -code error "node \"$node\" does not exist"
    }

    set result [Widget::configure $path.$node $args]
    if { [visible $path $node] } {
        set lopt   {}
        set flag   0
        foreach opt {-window -image -drawcross -font -text -fill} {
            set flag [expr {$flag << 1}]
            if { [Widget::hasChanged $path.$node $opt val] } {
                set flag [expr {$flag | 1}]
            }
        }

        if { [Widget::hasChanged $path.$node -open val] } {
            if {[llength $data($node)] > 1} {
                # node have subnodes - full redraw
                _redraw_idle $path 3
            } else {
                # force a redraw of the plus/minus sign
                set flag [expr {$flag | 8}]
            }
        } 
	if { $data(upd,level) < 3 && $flag } {
            if { [set idx [lsearch $data(upd,nodes) $node]] == -1 } {
                lappend data(upd,nodes) $node $flag
            } else {
                incr idx
                set flag [expr {[lindex $data(upd,nodes) $idx] | $flag}]
                set data(upd,nodes) [lreplace $data(upd,nodes) $idx $idx $flag]
            }
            _redraw_idle $path 2
        }
    }
    return $result
}


# ------------------------------------------------------------------------------
#  Command Tree::itemcget
# ------------------------------------------------------------------------------
proc Tree::itemcget { path node option } {
    # Instead of upvar'ing $path as data for this test, just directly refer to
    # it, as that is faster.
    if { ![string compare $node "root"] || \
	    ![info exists ::Tree::${path}($node)] } {
        return -code error "node \"$node\" does not exist"
    }

    return [Widget::cget $path.$node $option]
}


# ------------------------------------------------------------------------------
#  Command Tree::bindText
# ------------------------------------------------------------------------------
proc Tree::bindText { path event script } {
    if { $script != "" } {
        $path.c bind "node" $event \
            "$script \[Tree::_get_node_name $path current 2\]"
    } else {
        $path.c bind "node" $event {}
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::bindImage
# ------------------------------------------------------------------------------
proc Tree::bindImage { path event script } {
    if { $script != "" } {
        $path.c bind "img" $event \
		"$script \[Tree::_get_node_name $path current 2\]"
    } else {
        $path.c bind "img" $event {}
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::delete
# ------------------------------------------------------------------------------
proc Tree::delete { path args } {
    variable $path
    upvar 0  $path data

    foreach lnodes $args {
        foreach node $lnodes {
            if { [string compare $node "root"] && [info exists data($node)] } {
                set parent [lindex $data($node) 0]
                set idx    [lsearch $data($parent) $node]
                set data($parent) [lreplace $data($parent) $idx $idx]
                _subdelete $path [list $node]
            }
        }
    }

    set sel $data(selnodes)
    set data(selnodes) {}
    eval selection $path set $sel
    _redraw_idle $path 3
}


# ------------------------------------------------------------------------------
#  Command Tree::move
# ------------------------------------------------------------------------------
proc Tree::move { path parent node index } {
    variable $path
    upvar 0  $path data

    if { ![string compare $node "root"] || ![info exists data($node)] } {
        return -code error "node \"$node\" does not exist"
    }
    if { ![info exists data($parent)] } {
        return -code error "node \"$parent\" does not exist"
    }
    set p $parent
    while { [string compare $p "root"] } {
        if { ![string compare $p $node] } {
            return -code error "node \"$parent\" is a descendant of \"$node\""
        }
        set p [parent $path $p]
    }

    set oldp        [lindex $data($node) 0]
    set idx         [lsearch $data($oldp) $node]
    set data($oldp) [lreplace $data($oldp) $idx $idx]
    set data($node) [concat [list $parent] [lrange $data($node) 1 end]]
    if { ![string compare $index "end"] } {
        lappend data($parent) $node
    } else {
        incr index
        set data($parent) [linsert $data($parent) $index $node]
    }
    if { (![string compare $oldp "root"] ||
          ([visible $path $oldp] && [Widget::getoption $path.$oldp   -open])) ||
         (![string compare $parent "root"] ||
          ([visible $path $parent] && [Widget::getoption $path.$parent -open])) } {
        _redraw_idle $path 3
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::reorder
# ------------------------------------------------------------------------------
proc Tree::reorder { path node neworder } {
    variable $path
    upvar 0  $path data

    if { ![info exists data($node)] } {
        return -code error "node \"$node\" does not exist"
    }
    set children [lrange $data($node) 1 end]
    if { [llength $children] } {
        set children [BWidget::lreorder $children $neworder]
        set data($node) [linsert $children 0 [lindex $data($node) 0]]
        if { [visible $path $node] && [Widget::getoption $path.$node -open] } {
            _redraw_idle $path 3
        }
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::selection
# ------------------------------------------------------------------------------
proc Tree::selection { path cmd args } {
    variable $path
    upvar 0  $path data

    switch -- $cmd {
        set {
            set data(selnodes) {}
            foreach node $args {
                if { [info exists data($node)] } {
		    if { [Widget::getoption $path.$node -selectable] } {
			if { [lsearch $data(selnodes) $node] == -1 } {
			    lappend data(selnodes) $node
			}
		    }
                }
            }

	    if { ![string equal $data(selnodes) ""] } {
		set selectcmd [Widget::getoption $path -selectcommand]
		if { ![string equal $selectcmd ""] } {
		    lappend selectcmd $path
		    lappend selectcmd $data(selnodes)
		    uplevel \#0 $selectcmd
		}
	    }
        }
        add {
            foreach node $args {
                if { [info exists data($node)] } {
		    if { [Widget::getoption $path.$node -selectable] } {
			if { [lsearch $data(selnodes) $node] == -1 } {
			    lappend data(selnodes) $node
			}
		    }
                }
            }
        }
	range {
	    # Here's our algorithm:
	    #   make a list of all nodes, then take the range from node1
	    #       to node2 and select those nodes
	    # This works because of how this widget handles redraws:
	    # the tree is always completely redraw, always from top to bottom.
	    # So the list of visible nodes *is* the list of nodes, and we can
	    # use that to decide which nodes to select.
	    foreach {node1 node2} $args break
	    if { [info exists data($node1)] && [info exists data($node2)] } {
		set nodes {}
		foreach nodeItem [$path.c find withtag node] {
		    set node [Tree::_get_node_name $path $nodeItem 2]
		    if { [Widget::getoption $path.$node -selectable] } {
			lappend nodes $node
		    }
		}
		# surles: Set the root string to the first element on the list.
		if {$node1 == "root"} {
		    set node1 [lindex $nodes 0]
		}
		if {$node2 == "root"} {
		    set node2 [lindex $nodes 0]
		}

		# Find the first visible ancestor of node1, starting with node1
		while {[set index1 [lsearch -exact $nodes $node1]] == -1} {
		    set node1 [lindex $data($node1) 0]
		}
		# Find the first visible ancestor of node2, starting with node2
		while {[set index2 [lsearch -exact $nodes $node2]] == -1} {
		    set node2 [lindex $data($node2) 0]
		}
		# If the nodes were given in backwards order, flip the
		# indices now
		if { $index2 < $index1 } {
		    incr index1 $index2
		    set index2 [expr {$index1 - $index2}]
		    set index1 [expr {$index1 - $index2}]
		}
		set data(selnodes) [lrange $nodes $index1 $index2]
	    }
	}
        remove {
            foreach node $args {
                if { [set idx [lsearch $data(selnodes) $node]] != -1 } {
                    set data(selnodes) [lreplace $data(selnodes) $idx $idx]
                }
            }
        }
        clear {
            set data(selnodes) {}
        }
        get {
            return $data(selnodes)
        }
        includes {
            return [expr {[lsearch $data(selnodes) $args] != -1}]
        }
        default {
            return
        }
    }
    _redraw_idle $path 1
}


# ------------------------------------------------------------------------------
#  Command Tree::exists
# ------------------------------------------------------------------------------
proc Tree::exists { path node } {
    variable $path
    upvar 0  $path data

    return [info exists data($node)]
}


# ------------------------------------------------------------------------------
#  Command Tree::visible
# ------------------------------------------------------------------------------
proc Tree::visible { path node } {
    set idn [$path.c find withtag n:$node]
    return [llength $idn]
}


# ------------------------------------------------------------------------------
#  Command Tree::parent
# ------------------------------------------------------------------------------
proc Tree::parent { path node } {
    variable $path
    upvar 0  $path data

    if { ![info exists data($node)] } {
        return -code error "node \"$node\" does not exist"
    }
    return [lindex $data($node) 0]
}


# ------------------------------------------------------------------------------
#  Command Tree::index
# ------------------------------------------------------------------------------
proc Tree::index { path node } {
    variable $path
    upvar 0  $path data

    if { ![string compare $node "root"] || ![info exists data($node)] } {
        return -code error "node \"$node\" does not exist"
    }
    set parent [lindex $data($node) 0]
    return [expr {[lsearch $data($parent) $node] - 1}]
}


# ------------------------------------------------------------------------------
#  Tree::find
#     Returns the node given a position.
#  findInfo     @x,y ?confine?
#               lineNumber
# ------------------------------------------------------------------------------
proc Tree::find {path findInfo {confine ""}} {
    if {[regexp -- {^@([0-9]+),([0-9]+)$} $findInfo match x y]} {
        set x [$path.c canvasx $x]
        set y [$path.c canvasy $y]
    } elseif {[regexp -- {^[0-9]+$} $findInfo lineNumber]} {
        set dy [Widget::getoption $path -deltay]
        set y  [expr {$dy*($lineNumber+0.5)}]
        set confine ""
    } else {
        return -code error "invalid find spec \"$findInfo\""
    }

    set found  0
    set region [$path.c bbox all]
    if {[llength $region]} {
        set xi [lindex $region 0]
        set xs [lindex $region 2]
        foreach id [$path.c find overlapping $xi $y $xs $y] {
            set ltags [$path.c gettags $id]
            set item  [lindex $ltags 1]
            if { ![string compare $item "node"] ||
                 ![string compare $item "img"]  ||
                 ![string compare $item "win"] } {
                # item is the label or image/window of the node
                set node  [Tree::_get_node_name $path $id 2]
                set found 1
                break
            }
        }
    }

    if {$found} {
        if {[string compare $confine "confine"] == 0} {
            # test if x stand inside node bbox
            set xi [expr {[lindex [$path.c coords n:$node] 0]-[Widget::cget $path -padx]}]
            set xs [lindex [$path.c bbox n:$node] 2]
            if {$x >= $xi && $x <= $xs} {
                return $node
            }
        } else {
            return $node
        }
    }
    return ""
}


# ------------------------------------------------------------------------------
#  Command Tree::line
#     Returns the line where is drawn a node.
# ------------------------------------------------------------------------------
proc Tree::line {path node} {
    set item [$path.c find withtag n:$node]
    if {[string length $item]} {
        set dy   [Widget::getoption $path -deltay]
        set y    [lindex [$path.c coords $item] 1]
        set line [expr {int($y/$dy)}]
    } else {
        set line -1
    }
    return $line
}


# ------------------------------------------------------------------------------
#  Command Tree::nodes
# ------------------------------------------------------------------------------
proc Tree::nodes { path node {first ""} {last ""} } {
    variable $path
    upvar 0  $path data

    if { ![info exists data($node)] } {
        return -code error "node \"$node\" does not exist"
    }

    if { ![string length $first] } {
        return [lrange $data($node) 1 end]
    }

    if { ![string length $last] } {
        return [lindex [lrange $data($node) 1 end] $first]
    } else {
        return [lrange [lrange $data($node) 1 end] $first $last]
    }
}


# Tree::visiblenodes --
#
#	Retrieve a list of all the nodes in a tree.
#
# Arguments:
#	path	tree to retrieve nodes for.
#
# Results:
#	nodes	list of nodes in the tree.

proc Tree::visiblenodes { path } {
    variable $path
    upvar 0  $path data

    # Root is always open (?), so all of its children automatically get added
    # to the result, and to the stack.
    set st [lrange $data(root) 1 end]
    set result $st

    while { [llength $st] } { 
	set node [lindex $st end]
	set st [lreplace $st end end]
	# Danger, danger!  Using getMegawidgetOption is fragile, but much
	# much faster than going through cget.
	if { [Widget::getMegawidgetOption $path.$node -open] } {
	    set nodes [lrange $data($node) 1 end]
	    set result [concat $result $nodes]
	    set st [concat $st $nodes]
	}
    }
    return $result
}

# ------------------------------------------------------------------------------
#  Command Tree::see
# ------------------------------------------------------------------------------
proc Tree::see { path node } {
    variable $path
    upvar 0  $path data

    if { [Widget::getoption $path -redraw] && $data(upd,afterid) != "" } {
        after cancel $data(upd,afterid)
        _redraw_tree $path
    }
    set idn [$path.c find withtag n:$node]
    if { $idn != "" } {
        Tree::_see $path $idn right
        Tree::_see $path $idn left
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::opentree
# ------------------------------------------------------------------------------
proc Tree::opentree { path node } {
    variable $path
    upvar 0  $path data

    if { ![string compare $node "root"] || ![info exists data($node)] } {
        return -code error "node \"$node\" does not exist"
    }

    _recexpand $path $node 1 [Widget::getoption $path -opencmd]
    _redraw_idle $path 3
}


# ------------------------------------------------------------------------------
#  Command Tree::closetree
# ------------------------------------------------------------------------------
proc Tree::closetree { path node } {
    variable $path
    upvar 0  $path data

    if { ![string compare $node "root"] || ![info exists data($node)] } {
        return -code error "node \"$node\" does not exist"
    }

    _recexpand $path $node 0 [Widget::getoption $path -closecmd]
    _redraw_idle $path 3
}


# ------------------------------------------------------------------------------
#  Command Tree::edit
# ------------------------------------------------------------------------------
proc Tree::edit { path node text {verifycmd ""} {clickres 0} {select 1}} {
    variable _edit
    variable $path
    upvar 0  $path data

    if { [Widget::getoption $path -redraw] && $data(upd,afterid) != "" } {
        after cancel $data(upd,afterid)
        _redraw_tree $path
    }
    set idn [$path.c find withtag n:$node]
    if { $idn != "" } {
        Tree::_see $path $idn right
        Tree::_see $path $idn left

        set oldfg  [$path.c itemcget $idn -fill]
        set sbg    [Widget::getoption $path -selectbackground]
        set coords [$path.c coords $idn]
        set x      [lindex $coords 0]
        set y      [lindex $coords 1]
        set bd     [expr {[$path.c cget -borderwidth]+[$path.c cget -highlightthickness]}]
        set w      [expr {[winfo width $path] - 2*$bd}]
        set wmax   [expr {[$path.c canvasx $w]-$x}]

        set _edit(text) $text
        set _edit(wait) 0

        $path.c itemconfigure $idn    -fill [Widget::getoption $path -background]
        $path.c itemconfigure s:$node -fill {} -outline {}

        set frame  [frame $path.edit \
                        -relief flat -borderwidth 0 -highlightthickness 0 \
                        -background [Widget::getoption $path -background]]
        set ent    [entry $frame.edit \
                        -width              0     \
                        -relief             solid \
                        -borderwidth        1     \
                        -highlightthickness 0     \
                        -foreground         [Widget::getoption $path.$node -fill] \
                        -background         [Widget::getoption $path -background] \
                        -selectforeground   [Widget::getoption $path -selectforeground] \
                        -selectbackground   $sbg  \
                        -font               [Widget::getoption $path.$node -font] \
                        -textvariable       Tree::_edit(text)]
        pack $ent -ipadx 8 -anchor w

        set idw [$path.c create window $x $y -window $frame -anchor w]
        trace variable Tree::_edit(text) w "Tree::_update_edit_size $path $ent $idw $wmax"
        tkwait visibility $ent
        grab  $frame
        BWidget::focus set $ent

        _update_edit_size $path $ent $idw $wmax
        update
        if { $select } {
            $ent selection range 0 end
            $ent icursor end
            $ent xview end
        }

        bindtags $ent [list $ent Entry]
        bind $ent <Escape> {set Tree::_edit(wait) 0}
        bind $ent <Return> {set Tree::_edit(wait) 1}
        if { $clickres == 0 || $clickres == 1 } {
            bind $frame <Button>  "set Tree::_edit(wait) $clickres"
        }

        set ok 0
        while { !$ok } {
            tkwait variable Tree::_edit(wait)
            if { !$_edit(wait) || $verifycmd == "" ||
                 [uplevel \#0 $verifycmd [list $_edit(text)]] } {
                set ok 1
            }
        }

        trace vdelete Tree::_edit(text) w "Tree::_update_edit_size $path $ent $idw $wmax"
        grab release $frame
        BWidget::focus release $ent
        destroy $frame
        $path.c delete $idw
        $path.c itemconfigure $idn    -fill $oldfg
        $path.c itemconfigure s:$node -fill $sbg -outline $sbg

        if { $_edit(wait) } {
            return $_edit(text)
        }
    }
    return ""
}


# ------------------------------------------------------------------------------
#  Command Tree::xview
# ------------------------------------------------------------------------------
proc Tree::xview { path args } {
    return [eval $path.c xview $args]
}


# ------------------------------------------------------------------------------
#  Command Tree::yview
# ------------------------------------------------------------------------------
proc Tree::yview { path args } {
    return [eval $path.c yview $args]
}


# ------------------------------------------------------------------------------
#  Command Tree::_update_edit_size
# ------------------------------------------------------------------------------
proc Tree::_update_edit_size { path entry idw wmax args } {
    set entw [winfo reqwidth $entry]
    if { $entw+8 >= $wmax } {
        $path.c itemconfigure $idw -width $wmax
    } else {
        $path.c itemconfigure $idw -width 0
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::_destroy
# ------------------------------------------------------------------------------
proc Tree::_destroy { path } {
    variable $path
    upvar 0  $path data

    if { $data(upd,afterid) != "" } {
        after cancel $data(upd,afterid)
    }
    if { $data(dnd,afterid) != "" } {
        after cancel $data(dnd,afterid)
    }
    _subdelete $path [lrange $data(root) 1 end]
    Widget::destroy $path
    unset data
    rename $path {}
}


# ------------------------------------------------------------------------------
#  Command Tree::_see
# ------------------------------------------------------------------------------
proc Tree::_see { path idn side } {
    set bbox [$path.c bbox $idn]
    set scrl [$path.c cget -scrollregion]

    set ymax [lindex $scrl 3]
    set dy   [$path.c cget -yscrollincrement]
    set yv   [$path yview]
    set yv0  [expr {round([lindex $yv 0]*$ymax/$dy)}]
    set yv1  [expr {round([lindex $yv 1]*$ymax/$dy)}]
    set y    [expr {int([lindex [$path.c coords $idn] 1]/$dy)}]
    if { $y < $yv0 } {
        $path.c yview scroll [expr {$y-$yv0}] units
    } elseif { $y >= $yv1 } {
        $path.c yview scroll [expr {$y-$yv1+1}] units
    }

    set xmax [lindex $scrl 2]
    set dx   [$path.c cget -xscrollincrement]
    set xv   [$path xview]
    if { ![string compare $side "right"] } {
        set xv1 [expr {round([lindex $xv 1]*$xmax/$dx)}]
        set x1  [expr {int([lindex $bbox 2]/$dx)}]
        if { $x1 >= $xv1 } {
            $path.c xview scroll [expr {$x1-$xv1+1}] units
        }
    } else {
        set xv0 [expr {round([lindex $xv 0]*$xmax/$dx)}]
        set x0  [expr {int([lindex $bbox 0]/$dx)}]
        if { $x0 < $xv0 } {
            $path.c xview scroll [expr {$x0-$xv0}] units
        }
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::_recexpand
# ------------------------------------------------------------------------------
proc Tree::_recexpand { path node expand cmd } {
    variable $path
    upvar 0  $path data

    if { [Widget::getoption $path.$node -open] != $expand } {
        Widget::setoption $path.$node -open $expand
        if { $cmd != "" } {
            uplevel \#0 $cmd $node
        }
    }

    foreach subnode [lrange $data($node) 1 end] {
        _recexpand $path $subnode $expand $cmd
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::_subdelete
# ------------------------------------------------------------------------------
proc Tree::_subdelete { path lnodes } {
    variable $path
    upvar 0  $path data

    while { [llength $lnodes] } {
        set lsubnodes [list]
        foreach node $lnodes {
            foreach subnode [lrange $data($node) 1 end] {
                lappend lsubnodes $subnode
            }
            unset data($node)
            if { [set win [Widget::getoption $path.$node -window]] != "" } {
                destroy $win
            }
            Widget::destroy $path.$node
        }
        set lnodes $lsubnodes
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::_update_scrollregion
# ------------------------------------------------------------------------------
proc Tree::_update_scrollregion { path } {
    set bd   [expr {2*([$path.c cget -borderwidth]+[$path.c cget -highlightthickness])}]
    set w    [expr {[winfo width  $path] - $bd}]
    set h    [expr {[winfo height $path] - $bd}]
    set xinc [$path.c cget -xscrollincrement]
    set yinc [$path.c cget -yscrollincrement]
    set bbox [$path.c bbox node]
    if { [llength $bbox] } {
        set xs [lindex $bbox 2]
        set ys [lindex $bbox 3]

        if { $w < $xs } {
            set w [expr {int($xs)}]
            if { [set r [expr {$w % $xinc}]] } {
                set w [expr {$w+$xinc-$r}]
            }
        }
        if { $h < $ys } {
            set h [expr {int($ys)}]
            if { [set r [expr {$h % $yinc}]] } {
                set h [expr {$h+$yinc-$r}]
            }
        }
    }

    $path.c configure -scrollregion [list 0 0 $w $h]

    if {[Widget::getoption $path -selectfill]} {
        _redraw_selection $path
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::_cross_event
# ------------------------------------------------------------------------------
proc Tree::_cross_event { path } {
    variable $path
    upvar 0  $path data

    set node [Tree::_get_node_name $path current 1]
    if { [Widget::getoption $path.$node -open] } {
        Tree::itemconfigure $path $node -open 0
        if { [set cmd [Widget::getoption $path -closecmd]] != "" } {
            uplevel \#0 $cmd $node
        }
    } else {
        Tree::itemconfigure $path $node -open 1
        if { [set cmd [Widget::getoption $path -opencmd]] != "" } {
            uplevel \#0 $cmd $node
        }
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::_draw_node
# ------------------------------------------------------------------------------
proc Tree::_draw_node { path node x0 y0 deltax deltay padx showlines } {
    global   env
    variable $path
    upvar 0  $path data

    set x1 [expr {$x0+$deltax+5}]
    set y1 $y0
    if { $showlines } {
        $path.c create line $x0 $y0 $x1 $y0 \
            -fill    [Widget::getoption $path -linesfill]   \
            -stipple [Widget::getoption $path -linestipple] \
            -tags    line
    }
    $path.c create text [expr {$x1+$padx}] $y0 \
        -text   [Widget::getoption $path.$node -text] \
        -fill   [Widget::getoption $path.$node -fill] \
        -font   [Widget::getoption $path.$node -font] \
        -anchor w \
        -tags   "TreeItemSentinal node n:$node"
    set len [expr {[llength $data($node)] > 1}]
    set dc  [Widget::getoption $path.$node -drawcross]
    set exp [Widget::getoption $path.$node -open]

    if { $len && $exp } {
        set y1 [_draw_subnodes $path [lrange $data($node) 1 end] \
                    [expr {$x0+$deltax}] $y0 $deltax $deltay $padx $showlines]
    }

    if { [string compare $dc "never"] && ($len || ![string compare $dc "allways"]) } {
        if { $exp } {
            set bmp [file join $::BWIDGET::LIBRARY "images" "minus.xbm"]
        } else {
            set bmp [file join $::BWIDGET::LIBRARY "images" "plus.xbm"]
        }
        $path.c create bitmap $x0 $y0 \
            -bitmap     @$bmp \
            -background [$path.c cget -background] \
            -foreground [Widget::getoption $path -linesfill] \
            -tags       "cross c:$node" -anchor c
    }

    if { [set win [Widget::getoption $path.$node -window]] != "" } {
        $path.c create window $x1 $y0 -window $win -anchor w \
		-tags "TreeItemSentinal win i:$node"
    } elseif { [set img [Widget::getoption $path.$node -image]] != "" } {
        $path.c create image $x1 $y0 -image $img -anchor w \
		-tags "TreeItemSentinal img i:$node"
    }
    return $y1
}


# ------------------------------------------------------------------------------
#  Command Tree::_draw_subnodes
# ------------------------------------------------------------------------------
proc Tree::_draw_subnodes { path nodes x0 y0 deltax deltay padx showlines } {
    set y1 $y0
    foreach node $nodes {
        set yp $y1
        set y1 [_draw_node $path $node $x0 [expr {$y1+$deltay}] $deltax $deltay $padx $showlines]
    }
    if { $showlines && [llength $nodes] } {
        set id [$path.c create line $x0 $y0 $x0 [expr {$yp+$deltay}] \
                    -fill    [Widget::getoption $path -linesfill]   \
                    -stipple [Widget::getoption $path -linestipple] \
                    -tags    line]

        $path.c lower $id
    }
    return $y1
}


# ------------------------------------------------------------------------------
#  Command Tree::_update_nodes
# ------------------------------------------------------------------------------
proc Tree::_update_nodes { path } {
    global   env
    variable $path
    upvar 0  $path data

    set deltax [Widget::getoption $path -deltax]
    set padx   [Widget::getoption $path -padx]
    foreach {node flag} $data(upd,nodes) {
        set idn [$path.c find withtag "n:$node"]
        if { $idn == "" } {
            continue
        }
        set c  [$path.c coords $idn]
        set x0 [expr {[lindex $c 0]-$padx}]
        set y0 [lindex $c 1]
        if { $flag & 48 } {
            # -window or -image modified
            set win  [Widget::getoption $path.$node -window]
            set img  [Widget::getoption $path.$node -image]
            set idi  [$path.c find withtag i:$node]
            set type [lindex [$path.c gettags $idi] 1]
            if { [string length $win] } {
                if { ![string compare $type "win"] } {
                    $path.c itemconfigure $idi -window $win
                } else {
                    $path.c delete $idi
                    $path.c create window $x0 $y0 -window $win -anchor w \
			    -tags "TreeItemSentinal win i:$node"
                }
            } elseif { [string length $img] } {
                if { ![string compare $type "img"] } {
                    $path.c itemconfigure $idi -image $img
                } else {
                    $path.c delete $idi
                    $path.c create image $x0 $y0 -image $img -anchor w \
			    -tags "TreeItemSentinal img i:$node"
                }
            } else {
                $path.c delete $idi
            }
        }

        if { $flag & 8 } {
            # -drawcross modified
            set len [expr {[llength $data($node)] > 1}]
            set dc  [Widget::getoption $path.$node -drawcross]
            set exp [Widget::getoption $path.$node -open]
            set idc [$path.c find withtag c:$node]

            if { [string compare $dc "never"] && ($len || ![string compare $dc "allways"]) } {
                if { $exp } {
                    set bmp [file join $::BWIDGET::LIBRARY "images" "minus.xbm"]
                } else {
                    set bmp [file join $::BWIDGET::LIBRARY "images" "plus.xbm"]
                }
                if { $idc == "" } {
                    $path.c create bitmap [expr {$x0-$deltax-5}] $y0 \
                        -bitmap     @$bmp \
                        -background [$path.c cget -background] \
                        -foreground [Widget::getoption $path -linesfill] \
                        -tags       "cross c:$node" -anchor c
                } else {
                    $path.c itemconfigure $idc -bitmap @$bmp
                }
            } else {
                $path.c delete $idc
            }
        }

        if { $flag & 7 } {
            # -font, -text or -fill modified
            $path.c itemconfigure $idn \
                -text [Widget::getoption $path.$node -text] \
                -fill [Widget::getoption $path.$node -fill] \
                -font [Widget::getoption $path.$node -font]
        }
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::_draw_tree
# ------------------------------------------------------------------------------
proc Tree::_draw_tree { path } {
    variable $path
    upvar 0  $path data

    $path.c delete all
    set cursor [$path.c cget -cursor]
    $path.c configure -cursor watch
    _draw_subnodes $path [lrange $data(root) 1 end] 8 \
        [expr {-[Widget::getoption $path -deltay]/2}] \
        [Widget::getoption $path -deltax] \
        [Widget::getoption $path -deltay] \
        [Widget::getoption $path -padx]   \
        [Widget::getoption $path -showlines]
    $path.c configure -cursor $cursor
}


# ------------------------------------------------------------------------------
#  Command Tree::_redraw_tree
# ------------------------------------------------------------------------------
proc Tree::_redraw_tree { path } {
    variable $path
    upvar 0  $path data

    if { [Widget::getoption $path -redraw] } {
        if { $data(upd,level) == 2 } {
            _update_nodes $path
        } elseif { $data(upd,level) == 3 } {
            _draw_tree $path
        }
        _redraw_selection $path
        _update_scrollregion $path
        set data(upd,nodes)   {}
        set data(upd,level)   0
        set data(upd,afterid) ""
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::_redraw_selection
# ------------------------------------------------------------------------------
proc Tree::_redraw_selection { path } {
    variable $path
    upvar 0  $path data

    set selbg [Widget::getoption $path -selectbackground]
    set selfg [Widget::getoption $path -selectforeground]
    set fill  [Widget::getoption $path -selectfill]
    if {$fill} {
        set scroll [$path.c cget -scrollregion]
        if {[llength $scroll]} {
            set xmax [expr {[lindex $scroll 2]-1}]
        } else {
            set xmax [winfo width $path]
        }
    }
    foreach id [$path.c find withtag sel] {
        set node [Tree::_get_node_name $path $id 1]
        $path.c itemconfigure "n:$node" -fill [Widget::getoption $path.$node -fill]
    }
    $path.c delete sel
    foreach node $data(selnodes) {
        set bbox [$path.c bbox "n:$node"]
        if { [llength $bbox] } {
            if {$fill} {
                set bbox [list 0 [lindex $bbox 1] $xmax [lindex $bbox 3]]
            }
            set id [eval $path.c create rectangle $bbox \
		    -fill $selbg -outline $selbg -tags [list "sel s:$node"]]
            $path.c itemconfigure "n:$node" -fill $selfg
            $path.c lower $id
        }
    }
}


# ------------------------------------------------------------------------------
#  Command Tree::_redraw_idle
# ------------------------------------------------------------------------------
proc Tree::_redraw_idle { path level } {
    variable $path
    upvar 0  $path data

    if { [Widget::getoption $path -redraw] && $data(upd,afterid) == "" } {
        set data(upd,afterid) [after idle Tree::_redraw_tree $path]
    }
    if { $level > $data(upd,level) } {
        set data(upd,level) $level
    }
    return ""
}


# ------------------------------------------------------------------------------
#  Command Tree::_init_drag_cmd
# ------------------------------------------------------------------------------
proc Tree::_init_drag_cmd { path X Y top } {
    set path [winfo parent $path]
    set ltags [$path.c gettags current]
    set item  [lindex $ltags 1]
    if { ![string compare $item "node"] ||
         ![string compare $item "img"]  ||
         ![string compare $item "win"] } {
        set node [Tree::_get_node_name $path current 2]
        if { [set cmd [Widget::getoption $path -draginitcmd]] != "" } {
            return [uplevel \#0 $cmd [list $path $node $top]]
        }
        if { [set type [Widget::getoption $path -dragtype]] == "" } {
            set type "TREE_NODE"
        }
        if { [set img [Widget::getoption $path.$node -image]] != "" } {
            pack [label $top.l -image $img -padx 0 -pady 0]
        }
        return [list $type {copy move link} $node]
    }
    return {}
}


# ------------------------------------------------------------------------------
#  Command Tree::_drop_cmd
# ------------------------------------------------------------------------------
proc Tree::_drop_cmd { path source X Y op type dnddata } {
    set path [winfo parent $path]
    variable $path
    upvar 0  $path data

    $path.c delete drop
    if { [string length $data(dnd,afterid)] } {
        after cancel $data(dnd,afterid)
        set data(dnd,afterid) ""
    }
    set data(dnd,scroll) ""
    if { [llength $data(dnd,node)] } {
        if { [set cmd [Widget::getoption $path -dropcmd]] != "" } {
            return [uplevel \#0 $cmd [list $path $source $data(dnd,node) $op $type $dnddata]]
        }
    }
    return 0
}


# ------------------------------------------------------------------------------
#  Command Tree::_over_cmd
# ------------------------------------------------------------------------------
proc Tree::_over_cmd { path source event X Y op type dnddata } {
    set path [winfo parent $path]
    variable $path
    upvar 0  $path data

    if { ![string compare $event "leave"] } {
        # we leave the window tree
        $path.c delete drop
        if { [string length $data(dnd,afterid)] } {
            after cancel $data(dnd,afterid)
            set data(dnd,afterid) ""
        }
        set data(dnd,scroll) ""
        return 0
    }

    if { ![string compare $event "enter"] } {
        # we enter the window tree - dnd data initialization
        set mode [Widget::getoption $path -dropovermode]
        set data(dnd,mode) 0
        foreach c {w p n} {
            set data(dnd,mode) [expr {($data(dnd,mode) << 1) | ([string first $c $mode] != -1)}]
        }
        set bbox [$path.c bbox all]
        if { [llength $bbox] } {
            set data(dnd,xs) [lindex $bbox 2]
            set data(dnd,empty) 0
        } else {
            set data(dnd,xs) 0
            set data(dnd,empty) 1
        }
        set data(dnd,node) {}
    }

    set x [expr {$X-[winfo rootx $path]}]
    set y [expr {$Y-[winfo rooty $path]}]
    $path.c delete drop
    set data(dnd,node) {}

    # test for auto-scroll unless mode is widget only
    if { $data(dnd,mode) != 4 && [_auto_scroll $path $x $y] != "" } {
        return 2
    }

    if { $data(dnd,mode) & 4 } {
        # dropovermode includes widget
        set target [list widget]
        set vmode  4
    } else {
        set target [list ""]
        set vmode  0
    }
    if { ($data(dnd,mode) & 2) && $data(dnd,empty) } {
        # dropovermode includes position and tree is empty
        lappend target [list root 0]
        set vmode  [expr {$vmode | 2}]
    }

    set xc [$path.c canvasx $x]
    set xs $data(dnd,xs)
    if { $xc <= $xs } {
        set yc   [$path.c canvasy $y]
        set dy   [$path.c cget -yscrollincrement]
        set line [expr {int($yc/$dy)}]
        set xi   0
        set yi   [expr {$line*$dy}]
        set ys   [expr {$yi+$dy}]
        set found 0
        foreach id [$path.c find overlapping $xi $yi $xs $ys] {
            set ltags [$path.c gettags $id]
            set item  [lindex $ltags 1]
            if { ![string compare $item "node"] ||
                 ![string compare $item "img"]  ||
                 ![string compare $item "win"] } {
                # item is the label or image/window of the node
                set node [Tree::_get_node_name $path $id 2]
		set found 1
		break
	    }
	}
	if {$found} {
            set xi [expr {[lindex [$path.c coords n:$node] 0]-[Widget::getoption $path -padx]-1}]
                if { $data(dnd,mode) & 1 } {
                    # dropovermode includes node
                    lappend target $node
                    set vmode [expr {$vmode | 1}]
                } else {
                    lappend target ""
                }

                if { $data(dnd,mode) & 2 } {
                    # dropovermode includes position
                    if { $yc >= $yi+$dy/2 } {
                        # position is after $node
                        if { [Widget::getoption $path.$node -open] &&
                             [llength $data($node)] > 1 } {
                            # $node is open and have subnodes
                            # drop position is 0 in children of $node
                            set parent $node
                            set index  0
                            set xli    [expr {$xi-5}]
                        } else {
                            # $node is not open and doesn't have subnodes
                            # drop position is after $node in children of parent of $node
                            set parent [lindex $data($node) 0]
                            set index  [lsearch $data($parent) $node]
                            set xli    [expr {$xi-[Widget::getoption $path -deltax]-5}]
                        }
                        set yl $ys
                    } else {
                        # position is before $node
                        # drop position is before $node in children of parent of $node
                        set parent [lindex $data($node) 0]
                        set index  [expr {[lsearch $data($parent) $node] - 1}]
                        set xli    [expr {$xi-[Widget::getoption $path -deltax]-5}]
                        set yl     $yi
                    }
                    lappend target [list $parent $index]
                    set vmode  [expr {$vmode | 2}]
                } else {
                    lappend target {}
                }

                if { ($vmode & 3) == 3 } {
                    # result have both node and position
                    # we compute what is the preferred method
                    if { $yc-$yi <= 3 || $ys-$yc <= 3 } {
                        lappend target "position"
                    } else {
                        lappend target "node"
                    }
                }
            }
        }

    if { $vmode && [set cmd [Widget::getoption $path -dropovercmd]] != "" } {
        # user-defined dropover command
        set res     [uplevel \#0 $cmd [list $path $source $target $op $type $dnddata]]
        set code    [lindex $res 0]
        set newmode 0
        if { $code & 1 } {
            # update vmode
            set mode [lindex $res 1]
            if { ($vmode & 1) && ![string compare $mode "node"] } {
                set newmode 1
            } elseif { ($vmode & 2) && ![string compare $mode "position"] } {
                set newmode 2
            } elseif { ($vmode & 4) && ![string compare $mode "widget"] } {
                set newmode 4
            }
        }
        set vmode $newmode
    } else {
        if { ($vmode & 3) == 3 } {
            # result have both item and position
            # we choose the preferred method
            if { ![string compare [lindex $target 3] "position"] } {
                set vmode [expr {$vmode & ~1}]
            } else {
                set vmode [expr {$vmode & ~2}]
            }
        }

        if { $data(dnd,mode) == 4 || $data(dnd,mode) == 0 } {
            # dropovermode is widget or empty - recall is not necessary
            set code 1
        } else {
            set code 3
        }
    }

    if {!$data(dnd,empty)} {
	# draw dnd visual following vmode
	if { $vmode & 1 } {
	    set data(dnd,node) [list "node" [lindex $target 1]]
	    $path.c create rectangle $xi $yi $xs $ys -tags drop
	} elseif { $vmode & 2 } {
	    set data(dnd,node) [concat "position" [lindex $target 2]]
	    $path.c create line $xli [expr {$yl-$dy/2}] $xli $yl $xs $yl -tags drop
	} elseif { $vmode & 4 } {
	    set data(dnd,node) [list "widget"]
	} else {
	    set code [expr {$code & 2}]
	}
    }

    if { $code & 1 } {
        DropSite::setcursor based_arrow_down
    } else {
        DropSite::setcursor dot
    }
    return $code
}


# ------------------------------------------------------------------------------
#  Command Tree::_auto_scroll
# ------------------------------------------------------------------------------
proc Tree::_auto_scroll { path x y } {
    variable $path
    upvar 0  $path data

    set xmax   [winfo width  $path]
    set ymax   [winfo height $path]
    set scroll {}
    if { $y <= 6 } {
        if { [lindex [$path.c yview] 0] > 0 } {
            set scroll [list yview -1]
            DropSite::setcursor sb_up_arrow
        }
    } elseif { $y >= $ymax-6 } {
        if { [lindex [$path.c yview] 1] < 1 } {
            set scroll [list yview 1]
            DropSite::setcursor sb_down_arrow
        }
    } elseif { $x <= 6 } {
        if { [lindex [$path.c xview] 0] > 0 } {
            set scroll [list xview -1]
            DropSite::setcursor sb_left_arrow
        }
    } elseif { $x >= $xmax-6 } {
        if { [lindex [$path.c xview] 1] < 1 } {
            set scroll [list xview 1]
            DropSite::setcursor sb_right_arrow
        }
    }

    if { [string length $data(dnd,afterid)] && [string compare $data(dnd,scroll) $scroll] } {
        after cancel $data(dnd,afterid)
        set data(dnd,afterid) ""
    }

    set data(dnd,scroll) $scroll
    if { [string length $scroll] && ![string length $data(dnd,afterid)] } {
        set data(dnd,afterid) [after 200 Tree::_scroll $path $scroll]
    }
    return $data(dnd,afterid)
}


# ------------------------------------------------------------------------------
#  Command Tree::_scroll
# ------------------------------------------------------------------------------
proc Tree::_scroll { path cmd dir } {
    variable $path
    upvar 0  $path data

    if { ($dir == -1 && [lindex [$path.c $cmd] 0] > 0) ||
         ($dir == 1  && [lindex [$path.c $cmd] 1] < 1) } {
        $path.c $cmd scroll $dir units
        set data(dnd,afterid) [after 100 Tree::_scroll $path $cmd $dir]
    } else {
        set data(dnd,afterid) ""
        DropSite::setcursor dot
    }
}

# Tree::_keynav --
#
#	Handle navigational keypresses on the tree.
#
# Arguments:
#	which      tag indicating the direction of motion:
#                  up         move to the node graphically above current
#                  down       move to the node graphically below current
#                  left       close current if open, else move to parent
#                  right      open current if closed, else move to child
#                  open       open current if closed, close current if open
#       win        name of the tree widget
#
# Results:
#	None.

proc Tree::_keynav {which win} {
    # Keyboard navigation is riddled with special cases.  In order to avoid
    # the complex logic, we will instead make a list of all the visible,
    # selectable nodes, then do a simple next or previous operation.

    # One easy way to get all of the visible nodes is to query the canvas
    # object for all the items with the "node" tag; since the tree is always
    # completely redrawn, this list will be in vertical order.
    set nodes {}
    foreach nodeItem [$win.c find withtag node] {
	set node [Tree::_get_node_name $win $nodeItem 2]
	if { [Widget::cget $win.$node -selectable] } {
	    lappend nodes $node
	}
    }
	
    # Keyboard navigation is all relative to the current node
    # surles: Get the current node for single or multiple selection schemas.
    set node [_get_current_node $win]

    switch -exact -- $which {
	"up" {
	    # Up goes to the node that is vertically above the current node
	    # (NOT necessarily the current node's parent)
	    if { [string equal $node ""] } {
		return
	    }
	    set index [lsearch $nodes $node]
	    incr index -1
	    if { $index >= 0 } {
		$win selection set [lindex $nodes $index]
		_set_current_node $win [lindex $nodes $index]
		$win see [lindex $nodes $index]
		return
	    }
	}
	"down" {
	    # Down goes to the node that is vertically below the current node
	    if { [string equal $node ""] } {
		$win selection set [lindex $nodes 0]
		_set_current_node $win [lindex $nodes 0]
		$win see [lindex $nodes 0]
		return
	    }

	    set index [lsearch $nodes $node]
	    incr index
	    if { $index < [llength $nodes] } {
		$win selection set [lindex $nodes $index]
		_set_current_node $win [lindex $nodes $index]
		$win see [lindex $nodes $index]
		return
	    }
	}
	"right" {
	    # On a right arrow, if the current node is closed, open it.
	    # If the current node is open, go to its first child
	    if { [string equal $node ""] } {
		return
	    }
	    set open [$win itemcget $node -open]
            if { $open } {
                if { [llength [$win nodes $node]] } {
		    set index [lsearch $nodes $node]
		    incr index
		    if { $index < [llength $nodes] } {
			$win selection set [lindex $nodes $index]
			_set_current_node $win [lindex $nodes $index]
			$win see [lindex $nodes $index]
			return
		    }
                }
            } else {
                $win itemconfigure $node -open 1
                if { [set cmd [Widget::getoption $win -opencmd]] != "" } {
                    uplevel \#0 $cmd $node
                }
                return
            }
	}
	"left" {
	    # On a left arrow, if the current node is open, close it.
	    # If the current node is closed, go to its parent.
	    if { [string equal $node ""] } {
		return
	    }
	    set open [$win itemcget $node -open]
	    if { $open } {
		$win itemconfigure $node -open 0
                if { [set cmd [Widget::getoption $win -closecmd]] != "" } {
                    uplevel \#0 $cmd $node
                }
		return
	    } else {
		set parent [$win parent $node]
	        if { [string equal $parent "root"] } {
		    set parent $node
                } else {
                    while { ![$win itemcget $parent -selectable] } {
		        set parent [$win parent $parent]
		        if { [string equal $parent "root"] } {
			    set parent $node
			    break
		        }
                    }
		}
		$win selection set $parent
		_set_current_node $win $parent
		$win see $parent
		return
	    }
	}
	"space" {
	    if { [string equal $node ""] } {
		return
	    }
	    set open [$win itemcget $node -open]
	    if { [llength [$win nodes $node]] } {
		$win itemconfigure $node -open [expr {$open?0:1}]
	    }
	}
    }
    return
}

# Tree::_get_current_node --
#
#	Get the current node for either single or multiple
#	node selection trees.  If the tree allows for 
#	multiple selection, return the cursor node.  Otherwise,
#	if there is a selection, return the first node in the
#	list.  If there is no selection, return the root node.
#
# arguments:
#       win        name of the tree widget
#
# Results:
#	The current node.

proc Tree::_get_current_node {win} {
    if {[info exists selectTree::selectCursor($win)]} {
	set result $selectTree::selectCursor($win)
    } elseif {[set selList [$win selection get]] != {}} {
	set result [lindex $selList 0]
    } else {
	set result ""
    }
    return $result
}

# Tree::_set_current_node --
#
#	Set the current node for either single or multiple
#	node selection trees.
#
# arguments:
#       win        Name of the tree widget
#	node	   The current node.
#
# Results:
#	None.

proc Tree::_set_current_node {win node} {
    if {[info exists selectTree::selectCursor($win)]} {
	set selectTree::selectCursor($win) $node
    }
    return
}

# Tree::_get_node_name --
#
#	Given a canvas item, get the name of the tree node represented by that
#	item.
#
# Arguments:
#	path		tree to query
#	item		Optional canvas item to examine; if omitted, 
#			defaults to "current"
#	tagindex	Optional tag index, since the n:nodename tag is not
#			in the same spot for all canvas items.  If omitted,
#			defaults to "end-1", so it works with "current" item.
#
# Results:
#	node	name of the tree node.

proc Tree::_get_node_name {path {item current} {tagindex end-1}} {
    return [string range [lindex [$path.c gettags $item] $tagindex] 2 end]
}



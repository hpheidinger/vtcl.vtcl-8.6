#############################################################################
# Visual Tcl v1.60 Compound Library
#
namespace eval {vTcl::compounds::user::{List Viewer}} {

set bindtags {}

set libraries {
    bwidget
    core
}

set source .top79.meg80

set class MegaWidget

set procs {
    ::list_viewer::init
    ::list_viewer::main
    ::list_viewer::configureCmd
    ::list_viewer::myWidgetProc
    ::list_viewer::cgetCmd
    ::list_viewer::setlistCmd
    ::list_viewer::treeWidget
    ::list_viewer::doubleClickNode
    ::list_viewer::fillNode
}


proc bindtagsCmd {} {}


proc infoCmd {target} {
    namespace eval ::widgets::$target {
        array set save {-class 1 -widgetProc 1}
    }
    set site_3_0 $target
    namespace eval ::widgets::$site_3_0.scr79 {
        array set save {}
    }
    namespace eval ::widgets::$site_3_0.scr79.f.tre80 {
        array set save {}
    }

}


proc vTcl:DefineAlias {target alias args} {
    if {![info exists ::vTcl(running)]} {
        return [eval ::vTcl:DefineAlias $target $alias $args]
    }
    set class [vTcl:get_class $target]
    vTcl:set_alias $target [vTcl:next_widget_name $class $target $alias] -noupdate
}


proc compoundCmd {target} {
    ::list_viewer::init $target

    set items [split $target .]
    set parent [join [lrange $items 0 end-1] .]
    set top [winfo toplevel $parent]
    vTcl::widgets::core::megawidget::createCmd $target  -widgetProc ::list_viewer::myWidgetProc 
    vTcl:DefineAlias "$target" "MegaWidget1" vTcl::widgets::core::megawidget::widgetProc "Toplevel1" 1
    set site_3_0 $target
    vTcl::widgets::bwidgets::scrolledwindow::createCmd $site_3_0.scr79
    vTcl:DefineAlias "$site_3_0.scr79" "ScrolledWindow1" vTcl:WidgetProc "Toplevel1" 1
    Tree $site_3_0.scr79.f.tre80
    vTcl:DefineAlias "$site_3_0.scr79.f.tre80" "Tree1" vTcl:WidgetProc "Toplevel1" 1
    bind $site_3_0.scr79.f.tre80 <Configure> {
        Tree::_update_scrollregion %W
    }
    bind $site_3_0.scr79.f.tre80 <Destroy> {
        Tree::_destroy %W
    }
    bind $site_3_0.scr79.f.tre80 <FocusIn> {
        after idle {BWidget::refocus %W %W.c}
    }
    pack $site_3_0.scr79.f.tre80 -fill both -expand 1
    $site_3_0.scr79 setwidget $site_3_0.scr79.f
    pack $site_3_0.scr79  -in $site_3_0 -anchor center -expand 1 -fill both -side top 

    ::list_viewer::main $target
}


proc procsCmd {} {
#############################################################################
## Procedure:  ::list_viewer::init

namespace eval ::list_viewer {
proc init {w} {
    ## this procedure is executed before the megawidget UI gets created
    ## you can prepare any internal data here
}
}

#############################################################################
## Procedure:  ::list_viewer::main

namespace eval ::list_viewer {
proc main {w} {
    ## this procedure is called after the megawidget UI gets created
    [treeWidget $w] bindText <Double-Button-1> "::list_viewer::doubleClickNode $w"
}
}

#############################################################################
## Procedure:  ::list_viewer::configureCmd

namespace eval ::list_viewer {
proc configureCmd {w args} {
    ## TODO: handle megawidget configuration here
    ##
    ## examples of args:
    ##    -background white -foreground red
    ##        configure the -background and -foreground options
    ##    {}
    ##        empty list to return all options
    ##    -background
    ##        returns the -background configuration option
    
    ## delegate configuration to tree widget
    return [eval [treeWidget $w] configure $args]
}
}

#############################################################################
## Procedure:  ::list_viewer::myWidgetProc

namespace eval ::list_viewer {
proc myWidgetProc {w args} {
    ## this is the widget procedure that receives all the commands
    ## for the megawidget
    set command [lindex $args 0]
    set args [lrange $args 1 end]

    if {$command == "configure"} {
        return [eval configureCmd $w $args]
    } elseif {$command == "cget"} {
        return [eval cgetCmd $w $args]
    } elseif {$command == "setlist"} {
        return [eval setlistCmd $w $args]
    }
}
}

#############################################################################
## Procedure:  ::list_viewer::cgetCmd

namespace eval ::list_viewer {
proc cgetCmd {w args} {
    set option $args
    ## TODO: return the value for the option $option
}
}

#############################################################################
## Procedure:  ::list_viewer::setlistCmd

namespace eval ::list_viewer {
proc setlistCmd {w args} {
set t [treeWidget $w]
$t delete [$t nodes root]

fillNode $w root [join $args]
}
}

#############################################################################
## Procedure:  ::list_viewer::treeWidget

namespace eval ::list_viewer {
proc treeWidget {w} {
return $w.scr79.f.tre80
}
}

#############################################################################
## Procedure:  ::list_viewer::doubleClickNode

namespace eval ::list_viewer {
proc doubleClickNode {w node} {
set t [treeWidget $w]
set children [$t nodes $node]

## if empty and more than one child, fill the node
if {$children != "" } {
    return
}

## fill it
set data [$t itemcget $node -data]
if {[llength $data] == 1} {
    ## nah, it's not a list
    return
}
fillNode $w $node $data

## open it
$t opentree $node
}
}

#############################################################################
## Procedure:  ::list_viewer::fillNode

namespace eval ::list_viewer {
proc fillNode {w parent args} {
set t [treeWidget $w]
set i 0
foreach item [join $args] {
    regsub -all \n $item {\\n} item
    $t insert end $parent ${parent}_$i -text $item -data $item
    incr i
}
}
}

}

}



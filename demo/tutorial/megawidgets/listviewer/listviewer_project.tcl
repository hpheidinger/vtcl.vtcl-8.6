#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

    # Provoke name search
    catch {package require bogus-package-name}
    set packageNames [package names]

    package require BWidget
    switch $tcl_platform(platform) {
	windows {
	}
	default {
	    option add *ScrolledWindow.size 14
	}
    }
    
    package require Tk
    switch $tcl_platform(platform) {
	windows {
            option add *Button.padY 0
	}
	default {
            option add *Scrollbar.width 10
            option add *Scrollbar.highlightThickness 0
            option add *Scrollbar.elementBorderWidth 2
            option add *Scrollbar.borderWidth 2
	}
    }
    
}

#############################################################################
# Visual Tcl v1.60 Project
#


#################################
# VTCL LIBRARY PROCEDURES
#

if {![info exists vTcl(sourcing)]} {
#############################################################################
## Library Procedure:  Window

proc ::Window {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global vTcl
    foreach {cmd name newname} [lrange $args 0 2] {}
    set rest    [lrange $args 3 end]
    if {$name == "" || $cmd == ""} { return }
    if {$newname == ""} { set newname $name }
    if {$name == "."} { wm withdraw $name; return }
    set exists [winfo exists $newname]
    switch $cmd {
        show {
            if {$exists} {
                wm deiconify $newname
            } elseif {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[winfo exists $newname] && [wm state $newname] == "normal"} {
                vTcl:FireEvent $newname <<Show>>
            }
        }
        hide    {
            if {$exists} {
                wm withdraw $newname
                vTcl:FireEvent $newname <<Hide>>
                return}
        }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}
#############################################################################
## Library Procedure:  ::vTcl::widgets::bwidgets::scrollchildsite::widgetProc

namespace eval ::vTcl::widgets::bwidgets::scrollchildsite {
proc widgetProc {w args} {
        set command [lindex $args 0]
        set args [lrange $args 1 end]
        set children [winfo children $w]
        set child [lindex $children 0]

        ## we have renamed the default widgetProc _<widgetpath>
        if {$command == "configure" && $args == ""} {
            if {$children == ""} {
                return [concat [uplevel _$w configure]  [list {-xscrollcommand xScrollCommand ScrollCommand {} {}}]  [list {-yscrollcommand yScrollCommand ScrollCommand {} {}}]]
            } else {
                return [concat [uplevel _$w configure]  [list [$child configure -xscrollcommand]]  [list [$child configure -yscrollcommand]]]
            }
        } elseif {$command == "configure" && [llength $args] > 1} {
            return [uplevel $child configure $args]
        } elseif {[string match ?view $command]} {
            return [uplevel $child $command $args]
        }

        uplevel _$w $command $args
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::bwidgets::scrolledwindow::createCmd

namespace eval vTcl::widgets::bwidgets::scrolledwindow {
proc createCmd {target args} {
        eval ScrolledWindow $target $args
        ## create a frame where user can insert widget to scroll
        frame $target.f -class ScrollChildsite

        ## change the widget procedure
        rename ::$target.f ::_$target.f
        proc ::$target.f {command args}  "eval ::vTcl::widgets::bwidgets::scrollchildsite::widgetProc $target.f \$command \$args"
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::megawidget::cgetProc

namespace eval vTcl::widgets::core::megawidget {
proc cgetProc {w args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        upvar ::${w}::widgetProc  widgetProc

        set option [lindex $args 0]
        switch -- $option {
            -class         {return MegaWidget}
            -widgetProc    {return $widgetProc}
            default        {error "unknown option $option"}
        }
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::megawidget::configureProc

namespace eval vTcl::widgets::core::megawidget {
proc configureProc {w args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        upvar ::${w}::widgetProc  widgetProc

        if {[lempty $args]} {
            return [concat [configureProc $w -class]  [configureProc $w -widgetProc]]
        }
        if {[llength $args] == 1} {
            set option [lindex $args 0]
            switch -- $option {
                -class {
                    return [list "-class class Class Frame MegaWidget"]
                }
                -widgetProc {
                    return [list "-widgetProc widgetproc WidgetProc {} [list $widgetProc]"]
                }
                default {
                    error "unknown option $option"
                }
            }
        }

        foreach {option value} $args {
            if {$option == "-widgetProc"} {
                set widgetProc $value
            }
        }
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::megawidget::createCmd

namespace eval vTcl::widgets::core::megawidget {
proc createCmd {path args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        frame $path -class MegaWidget
        namespace eval ::$path "set widgetProc {}"

        ## change the widget procedure
        rename ::$path ::_$path
        proc ::$path {command args}  "eval ::vTcl::widgets::core::megawidget::widgetProc $path \$command \$args"

        ## widgetProc specified ? if so, store it
        if {[llength $args] == 2 && [lindex $args 0] == "-widgetProc"} {
            upvar ::${path}::widgetProc  widgetProc
            set widgetProc [lindex $args 1]
        }
        
        return $path
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::megawidget::widgetProc

namespace eval vTcl::widgets::core::megawidget {
proc widgetProc {w args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        if {[llength $args] == 0} {
            ## If no arguments, returns the path the alias points to
            return $w
        }

        set command [lindex $args 0]
        set args [lrange $args 1 end]
        switch $command {
            configure {
                return [eval configureProc $w $args]
            }
            cget {
                return [eval cgetProc $w $args]
            }
            widget {
                ## this calls the custom widgetProc
                upvar ::${w}::widgetProc  widgetProc
                return [eval $widgetProc $w $args]
            }
            default {
                ## we have renamed the default widgetProc _<widgetpath>
                uplevel _$w $command $args
            }
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:DefineAlias

proc ::vTcl:DefineAlias {target alias widgetProc top_or_alias cmdalias} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global widget
    set widget($alias) $target
    set widget(rev,$target) $alias
    if {$cmdalias} {
        interp alias {} $alias {} $widgetProc $target
    }
    if {$top_or_alias != ""} {
        set widget($top_or_alias,$alias) $target
        if {$cmdalias} {
            interp alias {} $top_or_alias.$alias {} $widgetProc $target
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:DoCmdOption

proc ::vTcl:DoCmdOption {target cmd} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## menus are considered toplevel windows
    set parent $target
    while {[winfo class $parent] == "Menu"} {
        set parent [winfo parent $parent]
    }

    regsub -all {\%widget} $cmd $target cmd
    regsub -all {\%top} $cmd [winfo toplevel $parent] cmd

    uplevel #0 [list eval $cmd]
}
#############################################################################
## Library Procedure:  vTcl:FireEvent

proc ::vTcl:FireEvent {target event {params {}}} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## The window may have disappeared
    if {![winfo exists $target]} return
    ## Process each binding tag, looking for the event
    foreach bindtag [bindtags $target] {
        set tag_events [bind $bindtag]
        set stop_processing 0
        foreach tag_event $tag_events {
            if {$tag_event == $event} {
                set bind_code [bind $bindtag $tag_event]
                foreach rep "\{%W $target\} $params" {
                    regsub -all [lindex $rep 0] $bind_code [lindex $rep 1] bind_code
                }
                set result [catch {uplevel #0 $bind_code} errortext]
                if {$result == 3} {
                    ## break exception, stop processing
                    set stop_processing 1
                } elseif {$result != 0} {
                    bgerror $errortext
                }
                break
            }
        }
        if {$stop_processing} {break}
    }
}
#############################################################################
## Library Procedure:  vTcl:Toplevel:WidgetProc

proc ::vTcl:Toplevel:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }
    set command [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- [string tolower $command] {
        "setvar" {
            foreach {varname value} $args {}
            if {$value == ""} {
                return [set ::${w}::${varname}]
            } else {
                return [set ::${w}::${varname} $value]
            }
        }
        "hide" - "show" {
            Window [string tolower $command] $w
        }
        "showmodal" {
            ## modal dialog ends when window is destroyed
            Window show $w; raise $w
            grab $w; tkwait window $w; grab release $w
        }
        "startmodal" {
            ## ends when endmodal called
            Window show $w; raise $w
            set ::${w}::_modal 1
            grab $w; tkwait variable ::${w}::_modal; grab release $w
        }
        "endmodal" {
            ## ends modal dialog started with startmodal, argument is var name
            set ::${w}::_modal 0
            Window hide $w
        }
        default {
            uplevel $w $command $args
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:WidgetProc

proc ::vTcl:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }
    ## The first argument is a switch, they must be doing a configure.
    if {[string index $args 0] == "-"} {
        set command configure
        ## There's only one argument, must be a cget.
        if {[llength $args] == 1} {
            set command cget
        }
    } else {
        set command [lindex $args 0]
        set args [lrange $args 1 end]
    }
    uplevel $w $command $args
}
#############################################################################
## Library Procedure:  vTcl:toplevel

proc ::vTcl:toplevel {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {set _modal 0}
}
}


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top79
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 1
    }
    namespace eval ::widgets::$base.meg80 {
        array set save {-class 1 -widgetProc 1}
    }
    set site_3_0 $base.meg80
    namespace eval ::widgets::$site_3_0.scr79 {
        array set save {}
    }
    namespace eval ::widgets::$site_3_0.scr79.f.tre80 {
        array set save {}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
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
        set compounds {
        }
        set projectType single
    }
}
}

#################################
# USER DEFINED PROCEDURES
#
#############################################################################
## Procedure:  main

proc ::main {argc argv} {
## At run time main will be automatically called, but not at design time.
::list_viewer::main [MegaWidget1]

## Note: megawidget commands are invoked by prefixing them with "widget"
MegaWidget1 widget setlist [MegaWidget1 widget configure]
}
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

#############################################################################
## Initialization Procedure:  init

proc ::init {argc argv} {}

init $argc $argv

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {base} {
    if {$base == ""} {
        set base .
    }
    ###################
    # CREATING WIDGETS
    ###################
    wm focusmodel $top passive
    wm geometry $top 200x200+154+175; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm withdraw $top
    wm title $top "vtcl"
    bindtags $top "$top Vtcl all"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top79 {base} {
    if {$base == ""} {
        set base .top79
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel
    wm focusmodel $top passive
    wm geometry $top 408x331+248+211; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "New Toplevel 1"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    vTcl::widgets::core::megawidget::createCmd $top.meg80 \
        -widgetProc ::list_viewer::myWidgetProc 
    vTcl:DefineAlias "$top.meg80" "MegaWidget1" vTcl::widgets::core::megawidget::widgetProc "Toplevel1" 1
    set site_3_0 $top.meg80
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
    pack $site_3_0.scr79 \
        -in $site_3_0 -anchor center -expand 1 -fill both -side top 
    ###################
    # SETTING GEOMETRY
    ###################
    place $top.meg80 \
        -in $top -x 14 -y 15 -width 371 -height 291 -anchor nw \
        -bordermode ignore 

    vTcl:FireEvent $base <<Ready>>
}

#############################################################################
## Binding tag:  _TopLevel

bind "_TopLevel" <<Create>> {
    if {![info exists _topcount]} {set _topcount 0}; incr _topcount
}
bind "_TopLevel" <<DeleteWindow>> {
    if {[set ::%W::_modal]} {
                vTcl:Toplevel:WidgetProc %W endmodal
            } else {
                destroy %W; if {$_topcount == 0} {exit}
            }
}
bind "_TopLevel" <Destroy> {
    if {[winfo toplevel %W] == "%W"} {incr _topcount -1}
}

Window show .
Window show .top79

main $argc $argv


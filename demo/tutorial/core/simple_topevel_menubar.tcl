#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

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

proc {Window} {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global vTcl
    set cmd     [lindex $args 0]
    set name    [lindex $args 1]
    set newname [lindex $args 2]
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
## Library Procedure:  vTcl:DefineAlias

proc {vTcl:DefineAlias} {target alias widgetProc top_or_alias cmdalias} {
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

proc {vTcl:DoCmdOption} {target cmd} {
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

proc {vTcl:FireEvent} {target event {params {}}} {
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

proc {vTcl:Toplevel:WidgetProc} {w args} {
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
    switch -- $command {
        "hide" - "Hide" - "show" - "Show" {
            Window [string tolower $command] $w
        }
        "ShowModal" {
            Window show $w
            raise $w
            grab $w
            tkwait window $w
            grab release $w
        }
        default {
            uplevel $w $command $args
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:WidgetProc

proc {vTcl:WidgetProc} {w args} {
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

proc {vTcl:toplevel} {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {}
}
}


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top80
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
    }
    namespace eval ::widgets::$base.lab81 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.but82 {
        array set save {-command 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$base.m80 {
        array set save {-activeborderwidth 1 -borderwidth 1 -tearoff 1}
    }
    set site_3_0 $base.m80
    namespace eval ::widgets::$site_3_0.men81 {
        array set save {-activeborderwidth 1 -borderwidth 1 -tearoff 1}
    }
    set site_3_0 $base.m80
    namespace eval ::widgets::$site_3_0.men82 {
        array set save {-activeborderwidth 1 -borderwidth 1 -tearoff 1}
    }
    namespace eval ::widgets::$base.lab83 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.lab84 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.lab86 {
        array set save {-text 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
            show_about
        }
    }
}
}

#################################
# USER DEFINED PROCEDURES
#
#############################################################################
## Procedure:  main

proc {main} {argc argv} {}
#############################################################################
## Procedure:  show_about

proc {show_about} {} {
tk_messageBox -message "Simple Toplevel with Menu Bar"
}

#############################################################################
## Initialization Procedure:  init

proc {init} {argc argv} {}

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
    wm focusmodel $base passive
    wm geometry $base 200x200+154+175; update
    wm maxsize $base 1284 1006
    wm minsize $base 111 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm withdraw $base
    wm title $base "vtcl"
    bindtags $base "$base Vtcl all"
    vTcl:FireEvent $base <<Create>>
    wm protocol $base WM_DELETE_WINDOW "vTcl:FireEvent $base <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top80 {base} {
    if {$base == ""} {
        set base .top80
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $base -class Toplevel \
        -menu "$base.m80" 
    wm focusmodel $base passive
    wm geometry $base 313x185+221+244; update
    wm maxsize $base 1284 1006
    wm minsize $base 111 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "Simple Toplevel With Menu Bar"
    vTcl:DefineAlias "$base" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $base "$base Toplevel all _TopLevel"
    bind $base <Control-Key-q> {
        exit
    }
    bind $base <Key-F1> {
        show_about
    }
    vTcl:FireEvent $base <<Create>>
    wm protocol $base WM_DELETE_WINDOW "vTcl:FireEvent $base <<DeleteWindow>>"

    label $base.lab81 \
        -text {This is a simple toplevel with a menu bar.} 
    vTcl:DefineAlias "$base.lab81" "Label1" vTcl:WidgetProc "Toplevel1" 1
    button $base.but82 \
        -command exit -pady 0 -text {Click here to exit} 
    vTcl:DefineAlias "$base.but82" "Button1" vTcl:WidgetProc "Toplevel1" 1
    menu $base.m80 \
        -activeborderwidth 1 -borderwidth 1 -tearoff 1 
    $base.m80 add cascade \
        -menu "$base.m80.men81" -label File 
    set site_3_0 $base.m80
    menu $site_3_0.men81 \
        -activeborderwidth 1 -borderwidth 1 -tearoff 0 
    $site_3_0.men81 add command \
        -accelerator {Ctrl + Q} -command exit -label Exit 
    $base.m80 add cascade \
        -menu "$base.m80.men82" -label Help 
    set site_3_0 $base.m80
    menu $site_3_0.men82 \
        -activeborderwidth 1 -borderwidth 1 -tearoff 0 
    $site_3_0.men82 add command \
        -accelerator F1 -command show_about -label About 
    label $base.lab83 \
        -text {Two accelerators are defined:} 
    vTcl:DefineAlias "$base.lab83" "Label2" vTcl:WidgetProc "Toplevel1" 1
    label $base.lab84 \
        -text {Ctrl + Q quits the application.} 
    vTcl:DefineAlias "$base.lab84" "Label3" vTcl:WidgetProc "Toplevel1" 1
    label $base.lab86 \
        -text {F1 shows the about box.} 
    vTcl:DefineAlias "$base.lab86" "Label4" vTcl:WidgetProc "Toplevel1" 1
    ###################
    # SETTING GEOMETRY
    ###################
    place $base.lab81 \
        -x 50 -y 15 -anchor nw -bordermode ignore 
    place $base.but82 \
        -x 95 -y 50 -anchor nw -bordermode ignore 
    place $base.lab83 \
        -x 20 -y 95 -anchor nw -bordermode ignore 
    place $base.lab84 \
        -x 20 -y 125 -anchor nw -bordermode ignore 
    place $base.lab86 \
        -x 20 -y 145 -anchor nw -bordermode ignore 

    vTcl:FireEvent $base <<Ready>>
}

#############################################################################
## Binding tag:  _TopLevel

bind "_TopLevel" <<Create>> {
    if {![info exists _topcount]} {set _topcount 0}; incr _topcount
}
bind "_TopLevel" <<DeleteWindow>> {
    destroy %W; if {$_topcount == 0} {exit}
}
bind "_TopLevel" <Destroy> {
    if {[winfo toplevel %W] == "%W"} {incr _topcount -1}
}

Window show .
Window show .top80

main $argc $argv


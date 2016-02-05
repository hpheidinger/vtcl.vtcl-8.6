#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

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
    switch -- $command {
        "setvar" {
            set varname [lindex $args 0]
            set value [lindex $args 1]
            if {$value == ""} {
                return [set ::${w}::${varname}]
            } else {
                return [set ::${w}::${varname} $value]
            }
        }
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
    namespace eval ::$target {}
}
}


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top72
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 1
    }
    namespace eval ::widgets::$base.lab73 {
        array set save {-anchor 1 -background 1 -justify 1 -text 1}
    }
    namespace eval ::widgets::$base.cpd74 {
        array set save {-borderwidth 1}
    }
    set site_3_0 $base.cpd74
    namespace eval ::widgets::$site_3_0.01 {
        array set save {-command 1 -orient 1}
    }
    namespace eval ::widgets::$site_3_0.02 {
        array set save {-command 1}
    }
    namespace eval ::widgets::$site_3_0.03 {
        array set save {-borderwidth 1 -closeenough 1 -height 1 -highlightthickness 1 -relief 1 -width 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::$base.but72 {
        array set save {-command 1 -pady 1 -text 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
            button_down
            button_motion
            button_release
        }
        set compounds {
        }
    }
}
}

#################################
# USER DEFINED PROCEDURES
#
#############################################################################
## Procedure:  main

proc ::main {argc argv} {
## to make it simple, the scrolling region is what's visible on
## startup

## make sure UI is all done first
update

set region [list 0 0 [winfo width [Canvas1]] [winfo height [Canvas1]]]
Canvas1 configure -scrollregion $region
}
#############################################################################
## Procedure:  button_down

proc ::button_down {w sx sy} {
global x y obj

set x $sx
set y $sy
set x1 [$w canvasx $sx]
set y1 [$w canvasy $sy]
set obj [$w create line $x1 $y1 $x1 $y1]
}
#############################################################################
## Procedure:  button_motion

proc ::button_motion {w nx ny} {
global x y obj

## notice we ask the canvas what the real coordinate will be
## (eg. after scrolling)
set x1 [$w canvasx $x]
set y1 [$w canvasy $y]
set x2 [$w canvasx $nx]
set y2 [$w canvasy $ny]

$w coords $obj $x1 $y1 $x2 $y2
}
#############################################################################
## Procedure:  button_release

proc ::button_release {w x y} {
## as a matter of fact, we have nothing to do here...
## a new line will be created as the user clicks the button
## again
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
    wm geometry $top 200x200+22+25; update
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

proc vTclWindow.top72 {base} {
    if {$base == ""} {
        set base .top72
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
    wm geometry $top 376x325+208+157; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Canvas tutorial"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    label $top.lab73 \
        -anchor w -background #cf4ed799ecec -justify left \
        -text {This sample demonstrates simple drawing with the mouse.

Click the left button to start drawing a line, and release it when you are done.} 
    vTcl:DefineAlias "$top.lab73" "Label1" vTcl:WidgetProc "Toplevel1" 1
    frame $top.cpd74 \
        -borderwidth 1 
    vTcl:DefineAlias "$top.cpd74" "Frame2" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.cpd74
    scrollbar $site_3_0.01 \
        -command "$site_3_0.03 xview" -orient horizontal 
    vTcl:DefineAlias "$site_3_0.01" "Scrollbar1" vTcl:WidgetProc "Toplevel1" 1
    scrollbar $site_3_0.02 \
        -command "$site_3_0.03 yview" 
    vTcl:DefineAlias "$site_3_0.02" "Scrollbar2" vTcl:WidgetProc "Toplevel1" 1
    canvas $site_3_0.03 \
        -borderwidth 2 -closeenough 1.0 -height 0 -highlightthickness 1 \
        -relief sunken -width 0 -xscrollcommand "$site_3_0.01 set" \
        -yscrollcommand "$site_3_0.02 set" 
    vTcl:DefineAlias "$site_3_0.03" "Canvas1" vTcl:WidgetProc "Toplevel1" 1
    bind $site_3_0.03 <B1-Motion> {
        button_motion %W %x %y
    }
    bind $site_3_0.03 <Button-1> {
        button_down %W %x %y
    }
    bind $site_3_0.03 <ButtonRelease-1> {
        button_release %W %x %y
    }
    grid $site_3_0.01 \
        -in $site_3_0 -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky ew 
    grid $site_3_0.02 \
        -in $site_3_0 -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky ns 
    grid $site_3_0.03 \
        -in $site_3_0 -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky nesw 
    button $top.but72 \
        -command {Canvas1 delete all} -pady 0 -text {Clear the Canvas!} 
    vTcl:DefineAlias "$top.but72" "Button1" vTcl:WidgetProc "Toplevel1" 1
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.lab73 \
        -in $top -anchor center -expand 0 -fill x -padx 5 -pady 5 -side top 
    pack $top.cpd74 \
        -in $top -anchor center -expand 1 -fill both -side top 
    grid columnconf $top.cpd74 0 -weight 1
    grid rowconf $top.cpd74 0 -weight 1
    pack $top.but72 \
        -in $top -anchor center -expand 0 -fill x -padx 5 -pady 5 -side top 

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
Window show .top72

main $argc $argv


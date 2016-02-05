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
    set base .top82
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
    }
    namespace eval ::widgets::$base.lab84 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$base.fra83 {
        array set save {-background 1 -borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra83
    namespace eval ::widgets::$site_3_0.fra85 {
        array set save {-background 1 -borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_4_0 $site_3_0.fra85
    namespace eval ::widgets::$site_4_0.but86 {
        array set save {-pady 1 -text 1}
    }
    namespace eval ::widgets::$site_4_0.lab87 {
        array set save {-background 1 -text 1}
    }
    namespace eval ::widgets::$site_4_0.ent88 {
        array set save {-background 1 -textvariable 1}
    }
    namespace eval ::widgets::$site_4_0.sca98 {
        array set save {-background 1 -bigincrement 1 -from 1 -highlightthickness 1 -orient 1 -resolution 1 -tickinterval 1 -to 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.fra89 {
        array set save {-background 1 -borderwidth 1 -height 1 -width 1}
    }
    set site_4_0 $site_3_0.fra89
    namespace eval ::widgets::$site_4_0.lab90 {
        array set save {-background 1 -text 1}
    }
    namespace eval ::widgets::$site_4_0.che91 {
        array set save {-background 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_4_0.che92 {
        array set save {-background 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_4_0.lab93 {
        array set save {-background 1 -text 1}
    }
    namespace eval ::widgets::$site_4_0.rad94 {
        array set save {-background 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_4_0.rad95 {
        array set save {-background 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.lab97 {
        array set save {-anchor 1 -background 1 -borderwidth 1 -justify 1 -text 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
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

proc ::main {argc argv} {}

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

proc vTclWindow.top82 {base} {
    if {$base == ""} {
        set base .top82
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
    wm geometry $top 469x378+125+331; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Frames"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    label $top.lab84 \
        -text {Frames can be used to group widgets together.} 
    vTcl:DefineAlias "$top.lab84" "Label1" vTcl:WidgetProc "Toplevel1" 1
    frame $top.fra83 \
        -background #d3d3ececc2c2 -borderwidth 2 -height 75 -relief groove \
        -width 125 
    vTcl:DefineAlias "$top.fra83" "Frame1" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.fra83
    frame $site_3_0.fra85 \
        -background #e0e0cfcfecec -borderwidth 2 -height 175 -relief ridge \
        -width 180 
    vTcl:DefineAlias "$site_3_0.fra85" "Frame2" vTcl:WidgetProc "Toplevel1" 1
    set site_4_0 $site_3_0.fra85
    button $site_4_0.but86 \
        -pady 0 -text button 
    vTcl:DefineAlias "$site_4_0.but86" "Button1" vTcl:WidgetProc "Toplevel1" 1
    label $site_4_0.lab87 \
        -background #e0e0cfcfecec -text label 
    vTcl:DefineAlias "$site_4_0.lab87" "Label2" vTcl:WidgetProc "Toplevel1" 1
    entry $site_4_0.ent88 \
        -background white -textvariable "$top\::ent88" 
    vTcl:DefineAlias "$site_4_0.ent88" "Entry1" vTcl:WidgetProc "Toplevel1" 1
    scale $site_4_0.sca98 \
        -background #e0c8cf4eecec -bigincrement 0.0 -from 0.0 \
        -highlightthickness 0 -orient horizontal -resolution 1.0 \
        -tickinterval 0.0 -to 100.0 -variable "$top\::sca98" 
    vTcl:DefineAlias "$site_4_0.sca98" "Scale1" vTcl:WidgetProc "Toplevel1" 1
    place $site_4_0.but86 \
        -x 23 -y 24 -anchor nw -bordermode ignore 
    place $site_4_0.lab87 \
        -x 25 -y 60 -anchor nw -bordermode ignore 
    place $site_4_0.ent88 \
        -x 25 -y 90 -anchor nw -bordermode ignore 
    place $site_4_0.sca98 \
        -x 15 -y 120 -width 148 -height 44 -anchor nw -bordermode ignore 
    frame $site_3_0.fra89 \
        -background #ececcdcd5d5d -borderwidth 2 -height 130 -width 425 
    vTcl:DefineAlias "$site_3_0.fra89" "Frame3" vTcl:WidgetProc "Toplevel1" 1
    set site_4_0 $site_3_0.fra89
    label $site_4_0.lab90 \
        -background #ececcdcd5d5d \
        -text {Frames also allow you to use a different manager.} 
    vTcl:DefineAlias "$site_4_0.lab90" "Label3" vTcl:WidgetProc "Toplevel1" 1
    checkbutton $site_4_0.che91 \
        -background #ececcdcd5d5d -text check -variable "$top\::che91" 
    vTcl:DefineAlias "$site_4_0.che91" "Checkbutton1" vTcl:WidgetProc "Toplevel1" 1
    checkbutton $site_4_0.che92 \
        -background #ececcdcd5d5d -text check -variable "$top\::che92" 
    vTcl:DefineAlias "$site_4_0.che92" "Checkbutton2" vTcl:WidgetProc "Toplevel1" 1
    label $site_4_0.lab93 \
        -background #ececcdcd5d5d \
        -text {For example, this frame contains a grid.} 
    vTcl:DefineAlias "$site_4_0.lab93" "Label4" vTcl:WidgetProc "Toplevel1" 1
    radiobutton $site_4_0.rad94 \
        -background #ececcdcd5d5d -text radio \
        -variable "$top\::selectedButton" 
    vTcl:DefineAlias "$site_4_0.rad94" "Radiobutton1" vTcl:WidgetProc "Toplevel1" 1
    radiobutton $site_4_0.rad95 \
        -background #ececcdcd5d5d -text radio \
        -variable "$top\::selectedButton" 
    vTcl:DefineAlias "$site_4_0.rad95" "Radiobutton2" vTcl:WidgetProc "Toplevel1" 1
    grid $site_4_0.lab90 \
        -in $site_4_0 -column 0 -row 0 -columnspan 2 -rowspan 1 
    grid $site_4_0.che91 \
        -in $site_4_0 -column 0 -row 1 -columnspan 1 -rowspan 1 
    grid $site_4_0.che92 \
        -in $site_4_0 -column 1 -row 1 -columnspan 1 -rowspan 1 
    grid $site_4_0.lab93 \
        -in $site_4_0 -column 0 -row 3 -columnspan 2 -rowspan 1 
    grid $site_4_0.rad94 \
        -in $site_4_0 -column 0 -row 2 -columnspan 1 -rowspan 1 
    grid $site_4_0.rad95 \
        -in $site_4_0 -column 1 -row 2 -columnspan 1 -rowspan 1 
    label $site_3_0.lab97 \
        -anchor nw -background #d3d3ececc2c2 -borderwidth 0 -justify left \
        -text {With frames, you can:

- group widgets together
- copy/paste/move widgets together
- visually highlight a group of widgets
(for example with a different background color)
- you can create a compound out of a frame
and reuse it later on in another project
- frames have different border types
(sunken, raised, groove, ridge, flat)} 
    vTcl:DefineAlias "$site_3_0.lab97" "Label5" vTcl:WidgetProc "Toplevel1" 1
    place $site_3_0.fra85 \
        -x 20 -y 20 -width 180 -height 175 -anchor nw -bordermode ignore 
    place $site_3_0.fra89 \
        -x 20 -y 210 -width 425 -height 130 -anchor nw -bordermode ignore 
    place $site_3_0.lab97 \
        -x 212 -y 24 -width 233 -height 169 -anchor nw -bordermode ignore 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.lab84 \
        -in $top -anchor center -expand 0 -fill none -side top 
    pack $top.fra83 \
        -in $top -anchor center -expand 1 -fill both -side bottom 

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
Window show .top82

main $argc $argv


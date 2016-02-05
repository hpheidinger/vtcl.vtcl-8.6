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
        set set,size 0
        set runvisible 1
    }
    namespace eval ::widgets::$base.fra74 {
        array set save {-borderwidth 1}
    }
    set site_3_0 $base.fra74
    namespace eval ::widgets::$site_3_0.lab75 {
        array set save {-anchor 1 -background 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.che76 {
        array set save {-anchor 1 -command 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.che77 {
        array set save {-anchor 1 -command 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.che78 {
        array set save {-anchor 1 -command 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.che79 {
        array set save {-anchor 1 -command 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.che80 {
        array set save {-anchor 1 -command 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.lab91 {
        array set save {-anchor 1 -background 1 -text 1 -textvariable 1}
    }
    namespace eval ::widgets::$base.fra81 {
        array set save {-borderwidth 1}
    }
    set site_3_0 $base.fra81
    namespace eval ::widgets::$site_3_0.lab82 {
        array set save {-anchor 1 -background 1 -justify 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.rad83 {
        array set save {-anchor 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.rad84 {
        array set save {-anchor 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.rad85 {
        array set save {-anchor 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.rad86 {
        array set save {-anchor 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.rad87 {
        array set save {-anchor 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::$site_3_0.fra88 {
        array set save {-borderwidth 1}
    }
    set site_4_0 $site_3_0.fra88
    namespace eval ::widgets::$site_4_0.lab89 {
        array set save {-text 1}
    }
    namespace eval ::widgets::$site_4_0.lab90 {
        array set save {-background 1 -text 1 -textvariable 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
            showCheckedLabel
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
showCheckedLabel
}
#############################################################################
## Procedure:  showCheckedLabel

proc ::showCheckedLabel {} {
set a [Toplevel1 setvar tomatoes]
set b [Toplevel1 setvar onions]
set c [Toplevel1 setvar mushrooms]
set d [Toplevel1 setvar artichokes]
set e [Toplevel1 setvar redbellpeppers]

Toplevel1 setvar checkedLabel "$a $b $c $d $e"
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
    wm geometry $top 200x200+110+125; update
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
    wm geometry $top +252+136; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Check and Radio Buttons"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    frame $top.fra74 \
        -borderwidth 2 
    vTcl:DefineAlias "$top.fra74" "Frame1" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.fra74
    label $site_3_0.lab75 \
        -anchor w -background #e4dec4a5ecec \
        -text {A checkbutton shows an off / on state. It is associated with a variable.} 
    vTcl:DefineAlias "$site_3_0.lab75" "Label1" vTcl:WidgetProc "Toplevel1" 1
    checkbutton $site_3_0.che76 \
        -anchor w -command showCheckedLabel -text Tomatoes \
        -variable "$top\::tomatoes" 
    vTcl:DefineAlias "$site_3_0.che76" "Checkbutton1" vTcl:WidgetProc "Toplevel1" 1
    checkbutton $site_3_0.che77 \
        -anchor w -command showCheckedLabel -text Onions \
        -variable "$top\::onions" 
    vTcl:DefineAlias "$site_3_0.che77" "Checkbutton2" vTcl:WidgetProc "Toplevel1" 1
    checkbutton $site_3_0.che78 \
        -anchor w -command showCheckedLabel -text Mushrooms \
        -variable "$top\::mushrooms" 
    vTcl:DefineAlias "$site_3_0.che78" "Checkbutton3" vTcl:WidgetProc "Toplevel1" 1
    checkbutton $site_3_0.che79 \
        -anchor w -command showCheckedLabel -text Artichokes \
        -variable "$top\::artichokes" 
    vTcl:DefineAlias "$site_3_0.che79" "Checkbutton4" vTcl:WidgetProc "Toplevel1" 1
    checkbutton $site_3_0.che80 \
        -anchor w -command showCheckedLabel -text {Red bell peppers} \
        -variable "$top\::redbellpeppers" 
    vTcl:DefineAlias "$site_3_0.che80" "Checkbutton5" vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab91 \
        -anchor w -background #a708de3fecec -text {0 0 0 0 0} \
        -textvariable "$top\::checkedLabel" 
    vTcl:DefineAlias "$site_3_0.lab91" "Label5" vTcl:WidgetProc "Toplevel1" 1
    pack $site_3_0.lab75 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.che76 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.che77 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.che78 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.che79 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.che80 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.lab91 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    frame $top.fra81 \
        -borderwidth 2 
    vTcl:DefineAlias "$top.fra81" "Frame2" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.fra81
    label $site_3_0.lab82 \
        -anchor w -background #e4dec4a5ecec -justify left \
        -text {Radio buttons allow to choose one of several options.

Several radio buttons share the same variable.} 
    vTcl:DefineAlias "$site_3_0.lab82" "Label2" vTcl:WidgetProc "Toplevel1" 1
    radiobutton $site_3_0.rad83 \
        -anchor w -text Tee -value tee -variable "$top\::selectedButton" 
    vTcl:DefineAlias "$site_3_0.rad83" "Radiobutton1" vTcl:WidgetProc "Toplevel1" 1
    radiobutton $site_3_0.rad84 \
        -anchor w -text Coffee -value coffee \
        -variable "$top\::selectedButton" 
    vTcl:DefineAlias "$site_3_0.rad84" "Radiobutton2" vTcl:WidgetProc "Toplevel1" 1
    radiobutton $site_3_0.rad85 \
        -anchor w -text {Spring water} -value water \
        -variable "$top\::selectedButton" 
    vTcl:DefineAlias "$site_3_0.rad85" "Radiobutton3" vTcl:WidgetProc "Toplevel1" 1
    radiobutton $site_3_0.rad86 \
        -anchor w -text {Orange juice} -value orangejuice \
        -variable "$top\::selectedButton" 
    vTcl:DefineAlias "$site_3_0.rad86" "Radiobutton4" vTcl:WidgetProc "Toplevel1" 1
    radiobutton $site_3_0.rad87 \
        -anchor w -text {Iced tea} -value icedtea \
        -variable "$top\::selectedButton" 
    vTcl:DefineAlias "$site_3_0.rad87" "Radiobutton5" vTcl:WidgetProc "Toplevel1" 1
    frame $site_3_0.fra88 \
        -borderwidth 2 
    vTcl:DefineAlias "$site_3_0.fra88" "Frame3" vTcl:WidgetProc "Toplevel1" 1
    set site_4_0 $site_3_0.fra88
    label $site_4_0.lab89 \
        -text {You selected:} 
    vTcl:DefineAlias "$site_4_0.lab89" "Label3" vTcl:WidgetProc "Toplevel1" 1
    label $site_4_0.lab90 \
        -background #a708de3fecec -text {} \
        -textvariable "$top\::selectedButton" 
    vTcl:DefineAlias "$site_4_0.lab90" "Label4" vTcl:WidgetProc "Toplevel1" 1
    pack $site_4_0.lab89 \
        -in $site_4_0 -anchor center -expand 0 -fill none -side left 
    pack $site_4_0.lab90 \
        -in $site_4_0 -anchor center -expand 1 -fill x -side left 
    pack $site_3_0.lab82 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.rad83 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.rad84 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.rad85 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.rad86 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.rad87 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    pack $site_3_0.fra88 \
        -in $site_3_0 -anchor center -expand 0 -fill x -side top 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.fra74 \
        -in $top -anchor center -expand 0 -fill x -side top 
    pack $top.fra81 \
        -in $top -anchor center -expand 0 -fill x -side top 

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


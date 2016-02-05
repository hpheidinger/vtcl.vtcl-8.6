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
    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {}
}
}


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top22
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
    }
    namespace eval ::widgets::$base.fra23 {
        array set save {-background 1 -borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra23
    namespace eval ::widgets::$site_3_0.01 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.02 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.03 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$base.fra24 {
        array set save {-background 1 -borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra24
    namespace eval ::widgets::$site_3_0.01 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.02 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$base.fra25 {
        array set save {-background 1 -borderwidth 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra25
    namespace eval ::widgets::$site_3_0.01 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -state 1 -text 1 -width 1}
    }
    namespace eval ::widgets::$site_3_0.02 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1 -width 1}
    }
    namespace eval ::widgets::$site_3_0.03 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1 -width 1}
    }
    namespace eval ::widgets::$site_3_0.04 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1 -width 1}
    }
    namespace eval ::widgets::$site_3_0.05 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1 -width 1}
    }
    namespace eval ::widgets::$site_3_0.06 {
        array set save {-highlightthickness 1 -padx 1 -pady 1 -text 1 -width 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
}
}

#################################
# USER DEFINED PROCEDURES
#
#############################################################################
## Procedure:  main

proc {main} {argc argv} {

}

#############################################################################
## Initialization Procedure:  init

proc {init} {argc argv} {

}

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
    wm geometry $base 1x1+0+0; update
    wm maxsize $base 1265 994
    wm minsize $base 1 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm withdraw $base
    wm title $base "vtcl.tcl"
    bindtags $base "$base Vtcl.tcl all"
    vTcl:FireEvent $base <<Create>>
    wm protocol $base WM_DELETE_WINDOW "vTcl:FireEvent $base <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top22 {base} {
    if {$base == ""} {
        set base .top22
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $base -class Toplevel
    wm focusmodel $base passive
    wm geometry $base 237x202+199+235; update
    wm maxsize $base 1137 870
    wm minsize $base 96 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "Geometry Combo"
    bindtags $base "$base Toplevel all _TopLevel"
    vTcl:FireEvent $base <<Create>>
    wm protocol $base WM_DELETE_WINDOW "vTcl:FireEvent $base <<DeleteWindow>>"

    frame $base.fra23 \
        -background #a0d9d9 -borderwidth 1 -height 108 -relief sunken \
        -width 93 
    set site_3_0 $base.fra23
    button $site_3_0.01 \
        -highlightthickness 0 -padx 9 -pady 3 -text We 
    button $site_3_0.02 \
        -highlightthickness 0 -padx 9 -pady 3 -text are 
    button $site_3_0.03 \
        -highlightthickness 0 -padx 9 -pady 3 -text placed 
    place $site_3_0.01 \
        -x 10 -y 10 -anchor nw -bordermode ignore 
    place $site_3_0.02 \
        -x 50 -y 40 -width 55 -height 24 -anchor nw -bordermode ignore 
    place $site_3_0.03 \
        -x 20 -y 70 -anchor nw -bordermode ignore 
    frame $base.fra24 \
        -background #d9a0d9 -borderwidth 1 -height 30 -relief sunken \
        -width 30 
    set site_3_0 $base.fra24
    button $site_3_0.01 \
        -highlightthickness 0 -padx 9 -pady 3 -text We're 
    button $site_3_0.02 \
        -highlightthickness 0 -padx 9 -pady 3 -text packed 
    pack $site_3_0.01 \
        -in $site_3_0 -anchor center -expand 1 -fill both -padx 2 -pady 2 \
        -side top 
    pack $site_3_0.02 \
        -in $site_3_0 -anchor center -expand 0 -fill x -padx 2 -pady 2 \
        -side top 
    frame $base.fra25 \
        -background #d9d9a0 -borderwidth 1 -relief sunken -width 30 
    set site_3_0 $base.fra25
    button $site_3_0.01 \
        -highlightthickness 0 -padx 9 -pady 3 -state active -text And \
        -width 5 
    button $site_3_0.02 \
        -highlightthickness 0 -padx 9 -pady 3 -text a -width 5 
    button $site_3_0.03 \
        -highlightthickness 0 -padx 9 -pady 3 -text grid -width 5 
    button $site_3_0.04 \
        -highlightthickness 0 -padx 9 -pady 3 -text this -width 5 
    button $site_3_0.05 \
        -highlightthickness 0 -padx 9 -pady 3 -text is -width 5 
    button $site_3_0.06 \
        -highlightthickness 0 -padx 9 -pady 3 -text layout -width 5 
    grid $site_3_0.01 \
        -in $site_3_0 -column 0 -row 0 -columnspan 1 -rowspan 1 -padx 2 \
        -pady 2 
    grid $site_3_0.02 \
        -in $site_3_0 -column 0 -row 1 -columnspan 1 -rowspan 1 -padx 2 \
        -pady 2 
    grid $site_3_0.03 \
        -in $site_3_0 -column 1 -row 1 -columnspan 1 -rowspan 1 -padx 2 \
        -pady 2 
    grid $site_3_0.04 \
        -in $site_3_0 -column 1 -row 0 -columnspan 1 -rowspan 1 -padx 2 \
        -pady 2 
    grid $site_3_0.05 \
        -in $site_3_0 -column 2 -row 0 -columnspan 1 -rowspan 1 -padx 2 \
        -pady 2 
    grid $site_3_0.06 \
        -in $site_3_0 -column 2 -row 1 -columnspan 1 -rowspan 1 -padx 2 \
        -pady 2 
    ###################
    # SETTING GEOMETRY
    ###################
    grid columnconf $base 0 -weight 1
    grid columnconf $base 1 -weight 1
    grid rowconf $base 1 -weight 1
    grid $base.fra23 \
        -in $base -column 0 -row 0 -columnspan 1 -rowspan 1 -padx 5 -pady 5 \
        -sticky nesw 
    grid $base.fra24 \
        -in $base -column 1 -row 0 -columnspan 1 -rowspan 1 -padx 5 -pady 5 \
        -sticky nesw 
    grid $base.fra25 \
        -in $base -column 0 -row 1 -columnspan 2 -rowspan 1 -padx 5 -pady 5 \
        -sticky nesw 

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
Window show .top22

main $argc $argv

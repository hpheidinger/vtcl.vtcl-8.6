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
    namespace eval ::widgets::$base.lab73 {
        array set save {-justify 1 -text 1}
    }
    namespace eval ::widgets::$base.cpd76 {
        array set save {-height 1 -width 1}
    }
    set site_3_0 $base.cpd76
    namespace eval ::widgets::$site_3_0.01 {
        array set save {-background 1 -height 1 -listvariable 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::$site_3_0.02 {
        array set save {-command 1 -orient 1}
    }
    namespace eval ::widgets::$site_3_0.03 {
        array set save {-command 1}
    }
    namespace eval ::widgets::$base.lab77 {
        array set save {-anchor 1 -justify 1 -text 1}
    }
    namespace eval ::widgets::$base.ent78 {
        array set save {-background 1 -textvariable 1}
    }
    namespace eval ::widgets::$base.lab74 {
        array set save {-anchor 1 -background 1 -text 1}
    }
    namespace eval ::widgets::$base.lab75 {
        array set save {-anchor 1 -text 1}
    }
    namespace eval ::widgets::$base.but76 {
        array set save {-command 1 -pady 1 -text 1}
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

proc ::main {argc argv} {
Toplevel1 setvar listboxContents "apples oranges bananas peaches pears pineapples mangoes {passion fruit} raisins tomatoes prunes"
}

#############################################################################
## Initialization Procedure:  init

proc ::init {argc argv} {
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
    wm geometry $top +172+249; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Listbox Widget"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    label $top.lab73 \
        -justify left \
        -text {The listbox widget displays a list of items. You can select items with single, multiple or extended selection.

You can add scrollbars to the listbox widget.} 
    vTcl:DefineAlias "$top.lab73" "Label1" vTcl:WidgetProc "Toplevel1" 1
    frame $top.cpd76 \
        -height 30 -width 30 
    vTcl:DefineAlias "$top.cpd76" "Frame8" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.cpd76
    listbox $site_3_0.01 \
        -background white -height 8 -xscrollcommand "$site_3_0.02 set" \
        -yscrollcommand "$site_3_0.03 set" \
        -listvariable "$top\::listboxContents" 
    vTcl:DefineAlias "$site_3_0.01" "Listbox1" vTcl:WidgetProc "Toplevel1" 1
    scrollbar $site_3_0.02 \
        -command "$site_3_0.01 xview" -orient horizontal 
    vTcl:DefineAlias "$site_3_0.02" "Scrollbar3" vTcl:WidgetProc "Toplevel1" 1
    scrollbar $site_3_0.03 \
        -command "$site_3_0.01 yview" 
    vTcl:DefineAlias "$site_3_0.03" "Scrollbar4" vTcl:WidgetProc "Toplevel1" 1
    grid $site_3_0.01 \
        -in $site_3_0 -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky nesw 
    grid $site_3_0.02 \
        -in $site_3_0 -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky ew 
    grid $site_3_0.03 \
        -in $site_3_0 -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky ns 
    label $top.lab77 \
        -anchor w -justify left \
        -text {A listbox may have a variable associated with it.

When the variable changes, the listbox refreshes automatically.} 
    vTcl:DefineAlias "$top.lab77" "Label2" vTcl:WidgetProc "Toplevel1" 1
    entry $top.ent78 \
        -background white -textvariable "$top\::listboxContents" 
    vTcl:DefineAlias "$top.ent78" "Entry1" vTcl:WidgetProc "Toplevel1" 1
    label $top.lab74 \
        -anchor w -background #f5c2d8db8e8a \
        -text {Try typing in the entry field above and watch the list as it changes.} 
    vTcl:DefineAlias "$top.lab74" "Label3" vTcl:WidgetProc "Toplevel1" 1
    label $top.lab75 \
        -anchor w \
        -text {Items can also be added one by one by using the insert subcommand.} 
    vTcl:DefineAlias "$top.lab75" "Label4" vTcl:WidgetProc "Toplevel1" 1
    button $top.but76 \
        -command {Listbox1 insert end "One more item"} -pady 0 \
        -text {Add one more item!} 
    vTcl:DefineAlias "$top.but76" "Button1" vTcl:WidgetProc "Toplevel1" 1
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.lab73 \
        -in $top -anchor center -expand 0 -fill none -padx 5 -pady 5 \
        -side top 
    pack $top.cpd76 \
        -in $top -anchor center -expand 1 -fill both -padx 5 -pady 5 \
        -side top 
    grid columnconf $top.cpd76 0 -weight 1
    grid rowconf $top.cpd76 0 -weight 1
    pack $top.lab77 \
        -in $top -anchor center -expand 0 -fill x -padx 5 -pady 5 -side top 
    pack $top.ent78 \
        -in $top -anchor center -expand 0 -fill x -padx 5 -pady 5 -side top 
    pack $top.lab74 \
        -in $top -anchor center -expand 0 -fill x -padx 5 -pady 5 -side top 
    pack $top.lab75 \
        -in $top -anchor center -expand 0 -fill x -padx 5 -pady 5 -side top 
    pack $top.but76 \
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


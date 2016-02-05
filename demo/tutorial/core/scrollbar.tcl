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
    namespace eval ::widgets::$base.scr73 {
        array set save {}
    }
    namespace eval ::widgets::$base.lis74 {
        array set save {-background 1 -listvariable 1}
    }
    namespace eval ::widgets::$base.scr75 {
        array set save {-orient 1}
    }
    set base .top76
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 0
        set runvisible 1
    }
    namespace eval ::widgets::$base.lab77 {
        array set save {-background 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::$base.lab73 {
        array set save {-justify 1 -padx 1 -pady 1 -text 1}
    }
    set base .top78
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 1
    }
    namespace eval ::widgets::$base.scr73 {
        array set save {-command 1}
    }
    namespace eval ::widgets::$base.lis74 {
        array set save {-background 1 -listvariable 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::$base.scr75 {
        array set save {-command 1 -orient 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
            fillbox
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

}
#############################################################################
## Procedure:  fillbox

proc ::fillbox {w} {
$w delete 0 end
$w insert end apple banana orange tomato raisin peach prune pear hazelnut cherry apricot avocado pineapple grapefruit lemon mandarines {navel oranges}
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
    wm geometry $top 200x200+132+150; update
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
    wm geometry $top 231x223+181+305; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Scrollbars unbound"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    bind $top <<Ready>> {
        fillbox [Toplevel1.Listbox1]
    }
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    scrollbar $top.scr73
    vTcl:DefineAlias "$top.scr73" "Scrollbar1" vTcl:WidgetProc "Toplevel1" 1
    listbox $top.lis74 \
        -background white -listvariable "$top\::lis74" 
    vTcl:DefineAlias "$top.lis74" "Listbox1" vTcl:WidgetProc "Toplevel1" 1
    scrollbar $top.scr75 \
        -orient horizontal 
    vTcl:DefineAlias "$top.scr75" "Scrollbar2" vTcl:WidgetProc "Toplevel1" 1
    ###################
    # SETTING GEOMETRY
    ###################
    grid columnconf $top 0 -weight 1
    grid rowconf $top 0 -weight 1
    grid $top.scr73 \
        -in $top -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky ns 
    grid $top.lis74 \
        -in $top -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky nesw 
    grid $top.scr75 \
        -in $top -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky ew 

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top76 {base} {
    if {$base == ""} {
        set base .top76
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
    wm geometry $top +414+592; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Scrollbar tutorial"
    vTcl:DefineAlias "$top" "Toplevel2" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    label $top.lab77 \
        -background #ececd8746cfc -padx 5 -pady 5 \
        -text {Open this project in vTcl and try yourself!} 
    vTcl:DefineAlias "$top.lab77" "Label1" vTcl:WidgetProc "Toplevel2" 1
    label $top.lab73 \
        -justify left -padx 5 -pady 5 \
        -text {It's easy.
1) Make sure the "Widget Tree" window is open.
2) Select the "Scrollbars unbound" toplevel.
   This is the window with which you can practice.
3) Select the vertical scrollbar.
   - Right-click on it.
   - Select "Widget" > "Attach to widget".
   - Click on the listbox.
4) Select the horizontal scrollbar.
   - Right-click on it.
   - Select "Widget" > "Attach to widget".
   - Click on the listbox.
5) That's it! Try resizing the window and see how the scrollbars change.} 
    vTcl:DefineAlias "$top.lab73" "Label2" vTcl:WidgetProc "Toplevel2" 1
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.lab77 \
        -in $top -anchor center -expand 0 -fill x -side top 
    pack $top.lab73 \
        -in $top -anchor center -expand 0 -fill none -side top 

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top78 {base} {
    if {$base == ""} {
        set base .top78
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
    wm geometry $top 231x223+498+153; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Scrollbars bound"
    vTcl:DefineAlias "$top" "Toplevel3" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    bind $top <<Ready>> {
        fillbox [Toplevel3.Listbox1]
    }
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    scrollbar $top.scr73 \
        -command "$top.lis74 yview" 
    vTcl:DefineAlias "$top.scr73" "Scrollbar1" vTcl:WidgetProc "Toplevel3" 1
    listbox $top.lis74 \
        -background white -xscrollcommand "$top.scr75 set" \
        -yscrollcommand "$top.scr73 set" -listvariable "$top\::lis74" 
    vTcl:DefineAlias "$top.lis74" "Listbox1" vTcl:WidgetProc "Toplevel3" 1
    scrollbar $top.scr75 \
        -command "$top.lis74 xview" -orient horizontal 
    vTcl:DefineAlias "$top.scr75" "Scrollbar2" vTcl:WidgetProc "Toplevel3" 1
    ###################
    # SETTING GEOMETRY
    ###################
    grid columnconf $top 0 -weight 1
    grid rowconf $top 0 -weight 1
    grid $top.scr73 \
        -in $top -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky ns 
    grid $top.lis74 \
        -in $top -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky nesw 
    grid $top.scr75 \
        -in $top -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky ew 

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
Window show .top76
Window show .top78

main $argc $argv


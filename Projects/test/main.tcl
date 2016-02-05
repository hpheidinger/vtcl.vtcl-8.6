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

    set command [lindex $args 0]
    set args [lrange $args 1 end]
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
    set base .top59
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 1
    }
    set site_3_0 $base.cpd60
    set site_3_0 $base.fra61
    set site_4_0 $site_3_0.fra57
    set site_4_0 $site_3_0.fra58
    set site_6_0 [$site_4_0.not63 getframe page1]
    set site_6_1 [$site_4_0.not63 getframe page2]
    set site_6_2 [$site_4_0.not63 getframe page3]
    set site_4_0 $site_3_0.fra59
    set site_5_0 $site_4_0.fra56
    set site_5_0 $site_4_0.fra57
    set site_3_0 $base.fra64
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

}

#############################################################################
## Initialization Procedure:  init

proc ::init {argc argv} {
set ::product    TestME
set ::version    1.0

package require itcl
package require Tix
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
    wm geometry $top 1x1+0+0; update
    wm maxsize $top 1905 1170
    wm minsize $top 1 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm withdraw $top
    wm title $top "vtcl.tcl"
    bindtags $top "$top Vtcl.tcl all"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top59 {base} {
    if {$base == ""} {
        set base .top59
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel \
        -highlightcolor black 
    wm focusmodel $top passive
    wm geometry $top 842x569+366+233; update
    wm maxsize $top 1905 1170
    wm minsize $top 1 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "New Toplevel 1"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    frame $top.cpd60 \
        -borderwidth 1 -relief sunken -height 25 -highlightcolor black \
        -width 225 
    vTcl:DefineAlias "$top.cpd60" "Frame1" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.cpd60
    menubutton $site_3_0.01 \
        -activebackground {#f9f9f9} -activeforeground black -anchor w \
        -foreground black -highlightcolor black -menu "$site_3_0.01.02" \
        -padx 4 -pady 3 -text File -width 4 
    vTcl:DefineAlias "$site_3_0.01" "Menubutton1" vTcl:WidgetProc "Toplevel1" 1
    menu $site_3_0.01.02 \
        -activebackground {#f9f9f9} -activeforeground black -font {Tahoma 8} \
        -foreground black -tearoff 0 
    vTcl:DefineAlias "$site_3_0.01.02" "Menu1" vTcl:WidgetProc "" 1
    $site_3_0.01.02 add command \
        -accelerator Ctrl+O -label Open 
    $site_3_0.01.02 add command \
        -accelerator Ctrl+W -label Close 
    menubutton $site_3_0.03 \
        -activebackground {#f9f9f9} -activeforeground black -anchor w \
        -foreground black -highlightcolor black -menu "$site_3_0.03.04" \
        -padx 4 -pady 3 -text Edit -width 4 
    vTcl:DefineAlias "$site_3_0.03" "Menubutton2" vTcl:WidgetProc "Toplevel1" 1
    menu $site_3_0.03.04 \
        -activebackground {#f9f9f9} -activeforeground black -font {Tahoma 8} \
        -foreground black -tearoff 0 
    vTcl:DefineAlias "$site_3_0.03.04" "Menu1" vTcl:WidgetProc "" 1
    $site_3_0.03.04 add command \
        -accelerator Ctrl+X -label Cut 
    $site_3_0.03.04 add command \
        -accelerator Ctrl+C -label Copy 
    $site_3_0.03.04 add command \
        -accelerator Ctrl+V -label Paste 
    $site_3_0.03.04 add command \
        -accelerator Del -label Delete 
    menubutton $site_3_0.05 \
        -activebackground {#f9f9f9} -activeforeground black -anchor w \
        -foreground black -highlightcolor black -menu "$site_3_0.05.06" \
        -padx 4 -pady 3 -text Help -width 4 
    vTcl:DefineAlias "$site_3_0.05" "Menubutton3" vTcl:WidgetProc "Toplevel1" 1
    menu $site_3_0.05.06 \
        -activebackground {#f9f9f9} -activeforeground black -font {Tahoma 8} \
        -foreground black -tearoff 0 
    vTcl:DefineAlias "$site_3_0.05.06" "Menu1" vTcl:WidgetProc "" 1
    $site_3_0.05.06 add command \
        -label About 
    pack $site_3_0.01 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side left 
    pack $site_3_0.03 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side left 
    pack $site_3_0.05 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side right 
    frame $top.fra61 \
        -borderwidth 2 -relief groove -height 75 -highlightcolor black \
        -width 125 
    vTcl:DefineAlias "$top.fra61" "Frame2" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.fra61
    frame $site_3_0.fra57 \
        -borderwidth 2 -relief groove -height 75 -highlightcolor black \
        -width 125 
    vTcl:DefineAlias "$site_3_0.fra57" "Frame4" vTcl:WidgetProc "Toplevel1" 1
    set site_4_0 $site_3_0.fra57
    button $site_4_0.but60 \
        -activebackground {#f9f9f9} -activeforeground black -foreground black \
        -highlightcolor black -takefocus 0 -text button 
    vTcl:DefineAlias "$site_4_0.but60" "Button1" vTcl:WidgetProc "Toplevel1" 1
    button $site_4_0.cpd61 \
        -activebackground {#f9f9f9} -activeforeground black -foreground black \
        -highlightcolor black -takefocus 0 -text button 
    vTcl:DefineAlias "$site_4_0.cpd61" "Button2" vTcl:WidgetProc "Toplevel1" 1
    button $site_4_0.cpd62 \
        -activebackground {#f9f9f9} -activeforeground black -foreground black \
        -highlightcolor black -takefocus 0 -text button 
    vTcl:DefineAlias "$site_4_0.cpd62" "Button3" vTcl:WidgetProc "Toplevel1" 1
    button $site_4_0.cpd63 \
        -activebackground {#f9f9f9} -activeforeground black -foreground black \
        -highlightcolor black -takefocus 0 -text button 
    vTcl:DefineAlias "$site_4_0.cpd63" "Button4" vTcl:WidgetProc "Toplevel1" 1
    button $site_4_0.cpd64 \
        -activebackground {#f9f9f9} -activeforeground black -foreground black \
        -highlightcolor black -takefocus 0 -text button 
    vTcl:DefineAlias "$site_4_0.cpd64" "Button5" vTcl:WidgetProc "Toplevel1" 1
    Tree $site_4_0.tre55 \
        -highlightcolor black -selectbackground {#c4c4c4} \
        -selectforeground black -takefocus 0 
    vTcl:DefineAlias "$site_4_0.tre55" "Tree1" vTcl:WidgetProc "Toplevel1" 1
    bind $site_4_0.tre55 <Configure> {
        Tree::_update_scrollregion %W
    }
    bind $site_4_0.tre55 <Destroy> {
        Tree::_destroy %W
    }
    bind $site_4_0.tre55 <FocusIn> {
        after idle {BWidget::refocus %W %W.c}
    }
    pack $site_4_0.but60 \
        -in $site_4_0 -anchor center -expand 0 -fill none -side top 
    pack $site_4_0.cpd61 \
        -in $site_4_0 -anchor center -expand 0 -fill none -side top 
    pack $site_4_0.cpd62 \
        -in $site_4_0 -anchor center -expand 0 -fill none -side top 
    pack $site_4_0.cpd63 \
        -in $site_4_0 -anchor center -expand 0 -fill none -side top 
    pack $site_4_0.cpd64 \
        -in $site_4_0 -anchor center -expand 0 -fill none -side top 
    pack $site_4_0.tre55 \
        -in $site_4_0 -anchor center -expand 0 -fill none -side top 
    frame $site_3_0.fra58 \
        -borderwidth 2 -relief groove -height 75 -highlightcolor black \
        -width 125 
    vTcl:DefineAlias "$site_3_0.fra58" "Frame5" vTcl:WidgetProc "Toplevel1" 1
    set site_4_0 $site_3_0.fra58
    NoteBook $site_4_0.not63 \
        \
        -font {-family {Nimbus Sans L} -size 16 -weight normal -slant roman -underline 0 -overstrike 0} \
        -height 200 -width 300 
    vTcl:DefineAlias "$site_4_0.not63" "NoteBook1" vTcl:WidgetProc "Toplevel1" 1
    $site_4_0.not63 insert end page1 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -disabledforeground {#a3a3a3} -foreground black \
        -text {Page 1} 
    $site_4_0.not63 insert end page2 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -disabledforeground {#a3a3a3} -foreground black \
        -text {Page 2} 
    $site_4_0.not63 insert end page3 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -disabledforeground {#a3a3a3} -foreground black \
        -text {Page 3} 
    set site_6_0 [$site_4_0.not63 getframe page1]
    set site_6_1 [$site_4_0.not63 getframe page2]
    set site_6_2 [$site_4_0.not63 getframe page3]
    $site_4_0.not63 raise page1
    pack $site_4_0.not63 \
        -in $site_4_0 -anchor center -expand 1 -fill both -side top 
    frame $site_3_0.fra59 \
        -borderwidth 2 -relief groove -height 75 -highlightcolor black \
        -width 125 
    vTcl:DefineAlias "$site_3_0.fra59" "Frame6" vTcl:WidgetProc "Toplevel1" 1
    set site_4_0 $site_3_0.fra59
    frame $site_4_0.fra56 \
        -borderwidth 2 -relief groove -height 75 -highlightcolor black \
        -width 125 
    vTcl:DefineAlias "$site_4_0.fra56" "Frame7" vTcl:WidgetProc "Toplevel1" 1
    set site_5_0 $site_4_0.fra56
    label $site_5_0.lab58 \
        -activebackground {#f9f9f9} -activeforeground black \
        -font {MuseJazz 14 bold} -foreground black -highlightcolor black \
        -text Preview 
    vTcl:DefineAlias "$site_5_0.lab58" "Label1" vTcl:WidgetProc "Toplevel1" 1
    pack $site_5_0.lab58 \
        -in $site_5_0 -anchor center -expand 0 -fill x -side top 
    frame $site_4_0.fra57 \
        -borderwidth 2 -relief groove -height 75 -highlightcolor black \
        -width 125 
    vTcl:DefineAlias "$site_4_0.fra57" "Frame8" vTcl:WidgetProc "Toplevel1" 1
    set site_5_0 $site_4_0.fra57
    canvas $site_5_0.can59 \
        -borderwidth 2 -closeenough 1.0 -height 265 -highlightcolor black \
        -insertbackground black -relief ridge -selectbackground {#c4c4c4} \
        -selectforeground black -takefocus 0 -width 150 
    vTcl:DefineAlias "$site_5_0.can59" "Canvas1" vTcl:WidgetProc "Toplevel1" 1
    pack $site_5_0.can59 \
        -in $site_5_0 -anchor center -expand 1 -fill y -side top 
    pack $site_4_0.fra56 \
        -in $site_4_0 -anchor center -expand 0 -fill x -side top 
    pack $site_4_0.fra57 \
        -in $site_4_0 -anchor center -expand 1 -fill both -side top 
    pack $site_3_0.fra57 \
        -in $site_3_0 -anchor center -expand 0 -fill y -side left 
    pack $site_3_0.fra58 \
        -in $site_3_0 -anchor center -expand 1 -fill both -side left 
    pack $site_3_0.fra59 \
        -in $site_3_0 -anchor center -expand 0 -fill y -side right 
    frame $top.fra64 \
        -borderwidth 2 -relief ridge -height 32 -highlightcolor black \
        -width 209 
    vTcl:DefineAlias "$top.fra64" "Frame3" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.fra64
    message $site_3_0.mes65 \
        -foreground black -highlightcolor black -text Vtcl -width 70 
    vTcl:DefineAlias "$site_3_0.mes65" "Message1" vTcl:WidgetProc "Toplevel1" 1
    message $site_3_0.cpd66 \
        -foreground black -highlightcolor black -text 8.6 -width 70 
    vTcl:DefineAlias "$site_3_0.cpd66" "Message2" vTcl:WidgetProc "Toplevel1" 1
    message $site_3_0.cpd67 \
        -foreground black -highlightcolor black -text TCL-Vers. -width 70 
    vTcl:DefineAlias "$site_3_0.cpd67" "Message3" vTcl:WidgetProc "Toplevel1" 1
    message $site_3_0.cpd68 \
        -foreground black -highlightcolor black -text 8.6 \
        -textvariable tcl_version -width 70 
    vTcl:DefineAlias "$site_3_0.cpd68" "Message4" vTcl:WidgetProc "Toplevel1" 1
    message $site_3_0.cpd69 \
        -foreground black -highlightcolor black -text 1.0 \
        -textvariable ::version -width 70 
    vTcl:DefineAlias "$site_3_0.cpd69" "Message5" vTcl:WidgetProc "Toplevel1" 1
    message $site_3_0.cpd70 \
        -foreground black -highlightcolor black -text TestME \
        -textvariable ::product -width 70 
    vTcl:DefineAlias "$site_3_0.cpd70" "Message6" vTcl:WidgetProc "Toplevel1" 1
    ProgressBar $site_3_0.pro56 \
        -height 15 -variable "$top\::pro56" 
    vTcl:DefineAlias "$site_3_0.pro56" "ProgressBar1" vTcl:WidgetProc "Toplevel1" 1
    pack $site_3_0.mes65 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side left 
    pack $site_3_0.cpd66 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side left 
    pack $site_3_0.cpd67 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side left 
    pack $site_3_0.cpd68 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side left 
    pack $site_3_0.cpd69 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side right 
    pack $site_3_0.cpd70 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side right 
    pack $site_3_0.pro56 \
        -in $site_3_0 -anchor center -expand 0 -fill none -side top 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.cpd60 \
        -in $top -anchor center -expand 0 -fill x -side top 
    pack $top.fra61 \
        -in $top -anchor w -expand 1 -fill both -side top 
    pack $top.fra64 \
        -in $top -anchor s -expand 0 -fill x -side bottom 

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
Window show .top59

main $argc $argv

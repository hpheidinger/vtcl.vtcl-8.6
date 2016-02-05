#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {
    # Provoke name search
    catch {package require bogus-package-name}
    set packageNames [package names]

    switch $tcl_platform(platform) {
	windows {
	    option add *Scrollbar.width 16
	}
	default {
	    option add *Scrollbar.width 10
	}
    }
    
    # Check if Itcl is available
    if {[lsearch -exact $packageNames Itcl] != -1} {
	package require Itcl 3.0
    }

    # Check if Itk is available
    if {[lsearch -exact $packageNames Itk] != -1} {
	package require Itk 3.0
    }

    # Check if Iwidgets is available
    if {[lsearch -exact $packageNames Iwidgets] != -1} {
	package require Iwidgets 4.0

	switch $tcl_platform(platform) {
	    windows {
		option add *Scrolledhtml.sbWidth    16
		option add *Scrolledtext.sbWidth    16
		option add *Scrolledlistbox.sbWidth 16
	    }
	    default {
		option add *Scrolledhtml.sbWidth    10
		option add *Scrolledtext.sbWidth    10
		option add *Scrolledlistbox.sbWidth 10
	    }
	}
    }
    
}
#############################################################################
# Visual Tcl v1.51 Project
#

#################################
# VTCL LIBRARY PROCEDURES
#

if {![info exists vTcl(sourcing)]} {
proc Window {args} {
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
            if {$exists} { wm deiconify $newname; return }
            if {[info procs vTclWindow(pre)$name] != ""} {
                eval "vTclWindow(pre)$name $newname $rest"
            }
            if {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[info procs vTclWindow(post)$name] != ""} {
                eval "vTclWindow(post)$name $newname $rest"
            }
        }
        hide    { if $exists {wm withdraw $newname; return} }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}
}

if {![info exists vTcl(sourcing)]} {
proc {vTcl:Toplevel:WidgetProc} {w args} {
    if {[llength $args] == 0} {
        return -code error "wrong # args: should be \"$w option ?arg arg ...?\""
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
        "hide" -
        "Hide" {
            Window hide $w
        }

        "show" -
        "Show" {
            Window show $w
        }

        "ShowModal" {
            Window show $w
            raise $w
            grab $w
            tkwait window $w
            grab release $w
        }

        default {
            eval $w $command $args
        }
    }
}

proc {vTcl:WidgetProc} {w args} {
    if {[llength $args] == 0} {
        return -code error "wrong # args: should be \"$w option ?arg arg ...?\""
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

    eval $w $command $args
}
}

if {[info exists vTcl(sourcing)]} {
proc vTcl:project:info {} {
    namespace eval ::widgets::.top36 {
        array set save {-background 1 -highlightbackground 1 -highlightcolor 1}
    }
    namespace eval ::widgets::.top36.pan37 {
        array set save {}
    }
    namespace eval ::widgets::.top36.pan37.pane0.childsite {
        array set save {}
    }
    namespace eval ::widgets::.top36.pan37.pane0.childsite.lab40 {
        array set save {-text 1}
    }
    namespace eval ::widgets::.top36.pan37.pane0.childsite.cpd39 {
        array set save {}
    }
    namespace eval ::widgets::.top36.pan37.pane0.childsite.cpd39.01 {
        array set save {-command 1 -orient 1}
    }
    namespace eval ::widgets::.top36.pan37.pane0.childsite.cpd39.02 {
        array set save {-command 1}
    }
    namespace eval ::widgets::.top36.pan37.pane0.childsite.cpd39.03 {
        array set save {-xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::.top36.pan37.pane1.childsite {
        array set save {}
    }
    namespace eval ::widgets::.top36.pan37.pane1.childsite.scr42 {
        array set save {}
    }
    namespace eval ::widgets_bindings {
        set tagslist {}
    }
}
}
#################################
# USER DEFINED PROCEDURES
#

proc {main} {argc argv} {
global widget
wm protocol .top36 WM_DELETE_WINDOW {exit}

set pane1 [lindex [$widget(pane) childsite] 0]
set pane2 [lindex [$widget(pane) childsite] 1]

$widget(pane) fraction 50 50

# add some data in the text widget

$pane1.cpd39.03 insert end [info body main]

# add some data in the listbox
for {set i 1} {$i <= 10} {incr i} {

    $pane2.scr42 insert end line$i
}
}

proc init {argc argv} {

}

init $argc $argv

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {base {container 0}} {
    if {$base == ""} {
        set base .
    }
    ###################
    # CREATING WIDGETS
    ###################
    if {!$container} {
    wm focusmodel $base passive
    wm geometry $base 1x1+0+0; update
    wm maxsize $base 1009 738
    wm minsize $base 1 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm withdraw $base
    wm title $base "vtcl.tcl"
    bindtags $base "$base Vtcl.tcl all"
    }
    ###################
    # SETTING GEOMETRY
    ###################
}

proc vTclWindow.top36 {base {container 0}} {
    if {$base == ""} {
        set base .top36
    }
    if {[winfo exists $base] && (!$container)} {
        wm deiconify $base; return
    }

    global widget
    set widget(rev,$base.pan37) {pane}
    set {widget(pane)} "$base.pan37"
    set widget($base,pane) "$base.pan37"
    interp alias {} pane {} .top36.pan37 $base.pan37
    interp alias {} $base.pane {} .top36.pan37 $base.pan37

    ###################
    # CREATING WIDGETS
    ###################
    if {!$container} {
    toplevel $base -class Toplevel \
        -background #bcbcbc -highlightbackground #bcbcbc \
        -highlightcolor #000000 
    wm focusmodel $base passive
    wm geometry $base 380x317+80+120; update
    wm maxsize $base 1009 738
    wm minsize $base 1 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "Paned window"
    }
    ::iwidgets::panedwindow $base.pan37
    bindtags $base.pan37 "pw-config-::.top36.pan37 itk-delete-.top36.pan37 $base.pan37 Panedwindow $base all"
    $base.pan37 add pane0 \

    $base.pan37 add pane1 \
        
    label $base.pan37.pane0.childsite.lab40 \
        -text {This is pane 1!} 
    frame $base.pan37.pane0.childsite.cpd39
    scrollbar $base.pan37.pane0.childsite.cpd39.01 \
        -command "$base.pan37.pane0.childsite.cpd39.03 xview" \
        -orient horizontal 
    scrollbar $base.pan37.pane0.childsite.cpd39.02 \
        -command "$base.pan37.pane0.childsite.cpd39.03 yview" 
    text $base.pan37.pane0.childsite.cpd39.03 \
        -xscrollcommand "$base.pan37.pane0.childsite.cpd39.01 set" \
        -yscrollcommand "$base.pan37.pane0.childsite.cpd39.02 set" 
    pack $base.pan37.pane0.childsite.lab40 \
        -in $base.pan37.pane0.childsite -anchor center -expand 0 -fill none \
        -side top 
    pack $base.pan37.pane0.childsite.cpd39 \
        -in $base.pan37.pane0.childsite -anchor center -expand 1 -fill both \
        -side bottom 
    grid columnconf $base.pan37.pane0.childsite.cpd39 0 -weight 1
    grid rowconf $base.pan37.pane0.childsite.cpd39 0 -weight 1
    grid $base.pan37.pane0.childsite.cpd39.01 \
        -in $base.pan37.pane0.childsite.cpd39 -column 0 -row 1 -columnspan 1 \
        -rowspan 1 -sticky ew 
    grid $base.pan37.pane0.childsite.cpd39.02 \
        -in $base.pan37.pane0.childsite.cpd39 -column 1 -row 0 -columnspan 1 \
        -rowspan 1 -sticky ns 
    grid $base.pan37.pane0.childsite.cpd39.03 \
        -in $base.pan37.pane0.childsite.cpd39 -column 0 -row 0 -columnspan 1 \
        -rowspan 1 -sticky nesw 
    ::iwidgets::scrolledlistbox $base.pan37.pane1.childsite.scr42
    bindtags $base.pan37.pane1.childsite.scr42 "itk-delete-.top36.pan37.pane1.childsite.scr42 $base.pan37.pane1.childsite.scr42 Scrolledlistbox $base all"
    pack $base.pan37.pane1.childsite.scr42 \
        -in $base.pan37.pane1.childsite -anchor center -expand 1 -fill both \
        -side top 
    grid columnconf $base.pan37.pane1.childsite.scr42 0 -weight 1
    grid rowconf $base.pan37.pane1.childsite.scr42 0 -weight 1
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.pan37 \
        -in $base -anchor center -expand 1 -fill both -side top 
}

Window show .
Window show .top36

main $argc $argv

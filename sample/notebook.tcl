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
	package require Iwidgets 3.0

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
    namespace eval ::widgets::.top35 {
        array set save {-background 1 -highlightbackground 1 -highlightcolor 1}
    }
    namespace eval ::widgets::.top35.tab36 {
        array set save {-tabpos 1}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page1.cs {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page1.cs.fra36 {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che37 {
        array set save {-background 1 -labeltext 1}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che38 {
        array set save {-background 1 -labeltext 1}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page1.cs.fra34 {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 {
        array set save {-background 1 -labeltext 1}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page2.cs {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page3.cs {
        array set save {}
    }
    namespace eval ::widgets::.top35.fra37 {
        array set save {-background 1 -borderwidth 1 -height 1 -highlightbackground 1 -highlightcolor 1 -width 1}
    }
    namespace eval ::widgets::.top35.fra37.but38 {
        array set save {-activebackground 1 -activeforeground 1 -background 1 -font 1 -foreground 1 -highlightbackground 1 -highlightcolor 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::.top35.fra37.but39 {
        array set save {-activebackground 1 -activeforeground 1 -background 1 -font 1 -foreground 1 -highlightbackground 1 -highlightcolor 1 -padx 1 -pady 1 -text 1}
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

    wm protocol .top35 WM_DELETE_WINDOW {exit}

    $widget(notebook) select 0
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

proc vTclWindow.top35 {base {container 0}} {
    if {$base == ""} {
        set base .top35
    }
    if {[winfo exists $base] && (!$container)} {
        wm deiconify $base; return
    }

    global widget
    set widget(rev,$base.tab36) {notebook}
    set {widget(notebook)} "$base.tab36"
    set widget($base,notebook) "$base.tab36"
    interp alias {} notebook {} .top35.tab36 $base.tab36
    interp alias {} $base.notebook {} .top35.tab36 $base.tab36

    ###################
    # CREATING WIDGETS
    ###################
    if {!$container} {
    toplevel $base -class Toplevel \
        -background #bcbcbc -highlightbackground #bcbcbc \
        -highlightcolor #000000 
    wm focusmodel $base passive
    wm geometry $base 450x368+102+166; update
    wm maxsize $base 1009 738
    wm minsize $base 1 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "New Toplevel 2"
    }
    ::iwidgets::tabnotebook $base.tab36 \
        -tabpos n 
    bindtags $base.tab36 "itk-delete-.top35.tab36 $base.tab36 Tabnotebook $base all"
    $base.tab36 add \
        -label {Page 1} 
    $base.tab36 add \
        -label {Page 2} 
    $base.tab36 add \
        -label {Page 3} 
    frame $base.tab36.canvas.notebook.cs.page1.cs.fra36
    ::iwidgets::checkbox $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 \
        -background #febcbc -labeltext Settings! 
    bindtags $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 "itk-delete-.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che37 $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 Checkbox $base all"
    $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 add chk0 \
        -background #febcbc -text {Check 1} \
        -variable ::iwidgets::Checkbox::buttonVar(::.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che37,check1) 
    $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 add chk1 \
        -background #febcbc -text {Check 2} \
        -variable ::iwidgets::Checkbox::buttonVar(::.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che37,check2) 
    $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 add chk2 \
        -background #febcbc -text {Check 3} \
        -variable ::iwidgets::Checkbox::buttonVar(::.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che37,check3) 
    ::iwidgets::checkbox $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 \
        -background #bce8bc -labeltext {Settings 2} 
    bindtags $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 "itk-delete-.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che38 $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 Checkbox $base all"
    $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 add chk0 \
        -background #bce8bc -text {Check 1} \
        -variable ::iwidgets::Checkbox::buttonVar(::.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che38,check1) 
    $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 add chk1 \
        -background #bce8bc -text {Check 2} \
        -variable ::iwidgets::Checkbox::buttonVar(::.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che38,check2) 
    $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 add chk2 \
        -background #bce8bc -text {Check 3} \
        -variable ::iwidgets::Checkbox::buttonVar(::.top35.tab36.canvas.notebook.cs.page1.cs.fra36.che38,check3) 
    frame $base.tab36.canvas.notebook.cs.page1.cs.fra34
    ::iwidgets::radiobox $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 \
        -background #bc725c -labeltext {Settings 3} 
    bindtags $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 "itk-delete-.top35.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 Radiobox $base all"
    $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 add rad0 \
        -background #bc725c -text {Radio 1} \
        -variable ::iwidgets::Radiobox::_modes(::.top35.tab36.canvas.notebook.cs.page1.cs.fra34.rad35) 
    $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 add rad1 \
        -background #bc725c -text {Radio 2} \
        -variable ::iwidgets::Radiobox::_modes(::.top35.tab36.canvas.notebook.cs.page1.cs.fra34.rad35) 
    $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 add rad2 \
        -background #bc725c -text {Radio 3} \
        -variable ::iwidgets::Radiobox::_modes(::.top35.tab36.canvas.notebook.cs.page1.cs.fra34.rad35) 
    pack $base.tab36.canvas.notebook.cs.page1.cs.fra36 \
        -in $base.tab36.canvas.notebook.cs.page1.cs -anchor center -expand 1 \
        -fill both -side top 
    pack $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 \
        -in $base.tab36.canvas.notebook.cs.page1.cs.fra36 -anchor n -expand 1 \
        -fill both -side left 
    grid columnconf $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 1 -weight 1
    grid rowconf $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 1 -weight 1
    grid rowconf $base.tab36.canvas.notebook.cs.page1.cs.fra36.che37 0 -minsize 8
    pack $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 \
        -in $base.tab36.canvas.notebook.cs.page1.cs.fra36 -anchor n -expand 1 \
        -fill both -side left 
    grid columnconf $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 1 -weight 1
    grid rowconf $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 1 -weight 1
    grid rowconf $base.tab36.canvas.notebook.cs.page1.cs.fra36.che38 0 -minsize 8
    pack $base.tab36.canvas.notebook.cs.page1.cs.fra34 \
        -in $base.tab36.canvas.notebook.cs.page1.cs -anchor center -expand 0 \
        -fill x -side top 
    pack $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 \
        -in $base.tab36.canvas.notebook.cs.page1.cs.fra34 -anchor center \
        -expand 0 -fill x -side top 
    grid columnconf $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 1 -weight 1
    grid rowconf $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 1 -weight 1
    grid rowconf $base.tab36.canvas.notebook.cs.page1.cs.fra34.rad35 0 -minsize 8
    $base.tab36 select 0
    frame $base.fra37 \
        -background #bcbcbc -borderwidth 2 -height 75 \
        -highlightbackground #bcbcbc -highlightcolor #000000 -width 125 
    button $base.fra37.but38 \
        -activebackground #bcbcbc -activeforeground #000000 \
        -background #bcbcbc \
        -font -adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1 \
        -foreground #000000 -highlightbackground #bcbcbc \
        -highlightcolor #000000 -padx 9 -pady 3 -text {Next >} 
    button $base.fra37.but39 \
        -activebackground #bcbcbc -activeforeground #000000 \
        -background #bcbcbc \
        -font -adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1 \
        -foreground #000000 -highlightbackground #bcbcbc \
        -highlightcolor #000000 -padx 9 -pady 3 -text {< Previous} 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.tab36 \
        -in $base -anchor center -expand 1 -fill both -side top 
    pack $base.fra37 \
        -in $base -anchor center -expand 0 -fill none -side right 
    pack $base.fra37.but38 \
        -in $base.fra37 -anchor center -expand 0 -fill none -side right 
    pack $base.fra37.but39 \
        -in $base.fra37 -anchor center -expand 0 -fill none -side right 
}

Window show .
Window show .top35

main $argc $argv

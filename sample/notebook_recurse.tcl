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
    namespace eval ::widgets::.top35 {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36 {
        array set save {-tabpos 1}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page1.cs {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page1.cs.but37 {
        array set save {-text 1}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page1.cs.lab38 {
        array set save {-borderwidth 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page2.cs {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page2.cs.scr39 {
        array set save {-height 1 -width 1}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page3.cs {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page3.cs.tab35 {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page3.cs.tab35.canvas.notebook.cs.page1.cs {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page3.cs.tab35.canvas.notebook.cs.page1.cs.but36 {
        array set save {-text 1}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page3.cs.tab35.canvas.notebook.cs.page2.cs {
        array set save {}
    }
    namespace eval ::widgets::.top35.tab36.canvas.notebook.cs.page3.cs.tab35.canvas.notebook.cs.page3.cs {
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
wm protocol .top35 WM_DELETE_WINDOW {exit}
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

    ###################
    # CREATING WIDGETS
    ###################
    if {!$container} {
    toplevel $base -class Toplevel
    wm focusmodel $base passive
    wm geometry $base 336x277+101+145; update
    wm maxsize $base 1284 1010
    wm minsize $base 100 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "New Toplevel 1"
    }
    ::iwidgets::tabnotebook $base.tab36 \
        -tabpos n 
    bindtags $base.tab36 "itk-delete-.top35.tab36 $base.tab36 Tabnotebook $base all"
    $base.tab36 add \
        -background #d9d9d9 -label {Page 1} 
    $base.tab36 add \
        -background #d9d9d9 -label {Page 2} 
    $base.tab36 add \
        -background #d9d9d9 -label {Page 3} 
    button $base.tab36.canvas.notebook.cs.page1.cs.but37 \
        -text button 
    label $base.tab36.canvas.notebook.cs.page1.cs.lab38 \
        -borderwidth 1 -relief raised -text label 
    place $base.tab36.canvas.notebook.cs.page1.cs.but37 \
        -x 20 -y 10 -anchor nw -bordermode ignore 
    place $base.tab36.canvas.notebook.cs.page1.cs.lab38 \
        -x 20 -y 50 -anchor nw -bordermode ignore 
    ::iwidgets::scrolledlistbox $base.tab36.canvas.notebook.cs.page2.cs.scr39 \
        -height 218 -width 300 
    bindtags $base.tab36.canvas.notebook.cs.page2.cs.scr39 "itk-delete-.top35.tab36.canvas.notebook.cs.page2.cs.scr39 $base.tab36.canvas.notebook.cs.page2.cs.scr39 Scrolledlistbox $base all"
    place $base.tab36.canvas.notebook.cs.page2.cs.scr39 \
        -x 20 -y 10 -width 300 -height 218 -anchor nw -bordermode ignore 
    grid columnconf $base.tab36.canvas.notebook.cs.page2.cs.scr39 0 -weight 1
    grid rowconf $base.tab36.canvas.notebook.cs.page2.cs.scr39 0 -weight 1
    ::iwidgets::tabnotebook $base.tab36.canvas.notebook.cs.page3.cs.tab35
    bindtags $base.tab36.canvas.notebook.cs.page3.cs.tab35 "itk-delete-.top35.tab36.canvas.notebook.cs.page3.cs.tab35 $base.tab36.canvas.notebook.cs.page3.cs.tab35 Tabnotebook $base all"
    $base.tab36.canvas.notebook.cs.page3.cs.tab35 add \
        -background #d9d9d9 -label {Page 1} 
    $base.tab36.canvas.notebook.cs.page3.cs.tab35 add \
        -background #d9d9d9 -label {Page 2} 
    $base.tab36.canvas.notebook.cs.page3.cs.tab35 add \
        -background #d9d9d9 -label {Page 3} 
    button $base.tab36.canvas.notebook.cs.page3.cs.tab35.canvas.notebook.cs.page1.cs.but36 \
        -text button 
    pack $base.tab36.canvas.notebook.cs.page3.cs.tab35.canvas.notebook.cs.page1.cs.but36 \
        \
        -in $base.tab36.canvas.notebook.cs.page3.cs.tab35.canvas.notebook.cs.page1.cs \
        -anchor center -expand 0 -fill none -side top 
    $base.tab36.canvas.notebook.cs.page3.cs.tab35 select 0
    pack $base.tab36.canvas.notebook.cs.page3.cs.tab35 \
        -in $base.tab36.canvas.notebook.cs.page3.cs -anchor center -expand 1 \
        -fill both -side top 
    $base.tab36 select 0
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.tab36 \
        -in $base -anchor center -expand 1 -fill both -side top 
}

Window show .
Window show .top35

main $argc $argv

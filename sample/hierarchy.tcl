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
    namespace eval ::widgets::.top31 {
        array set save {-background 1 -highlightbackground 1 -highlightcolor 1}
    }
    namespace eval ::widgets::.top31.hie32 {
        array set save {-querycommand 1 -sbwidth 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist {}
    }
}
}
#################################
# USER DEFINED PROCEDURES
#

proc {ls} {dir_} {
global vTcl

if {! [info exists vTcl(hierarchy,root)] } {

    # a kinda unix-centric view
    set vTcl(hierarchy,root) "/usr"
}

if {$dir_ == ""} {

    set dir $vTcl(hierarchy,root)
} else {

    set dir $dir_
}

if {! [file isdirectory $dir]} {
    return
}

cd $dir
set returnList ""
foreach file [lsort [glob -nocomplain *]] {

    lappend returnList [list [file join $dir $file] $file]
}

return $returnList
}

proc {test_func} {} {
global widget

$widget(files_browser) expand /usr
}

proc {main} {argc argv} {
wm protocol .top31 WM_DELETE_WINDOW {exit}
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

proc vTclWindow.top31 {base {container 0}} {
    if {$base == ""} {
        set base .top31
    }
    if {[winfo exists $base] && (!$container)} {
        wm deiconify $base; return
    }

    global widget
    set widget(rev,$base.hie32) {files_browser}
    set {widget(files_browser)} "$base.hie32"
    set widget($base,files_browser) "$base.hie32"
    interp alias {} files_browser {} .top31.hie32 $base.hie32
    interp alias {} $base.files_browser {} .top31.hie32 $base.hie32

    ###################
    # CREATING WIDGETS
    ###################
    if {!$container} {
    toplevel $base -class Toplevel \
        -background #bcbcbc -highlightbackground #bcbcbc \
        -highlightcolor #000000 
    wm focusmodel $base passive
    wm geometry $base 377x308+98+152; update
    wm maxsize $base 1009 738
    wm minsize $base 1 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "Hierarchy Test"
    }
    ::iwidgets::hierarchy $base.hie32 \
        -querycommand {ls %n} -sbwidth 10 
    bindtags $base.hie32 "itk-delete-.top31.hie32 $base.hie32 Hierarchy $base all"
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.hie32 \
        -in $base -anchor center -expand 1 -fill both -side top 
    grid columnconf $base.hie32 0 -weight 1
    grid rowconf $base.hie32 0 -weight 1
}

Window show .
Window show .top31

main $argc $argv

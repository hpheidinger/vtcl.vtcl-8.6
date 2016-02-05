#############################################################################
# Visual Tcl v1.07 Project
#

#################################
# GLOBAL VARIABLES
#
global w; set w {.top1.fra2.but8}
global widget; 
#################################
# USER DEFINED PROCEDURES
#
proc init {argc argv} {

}

init $argc $argv


proc main {argc argv} {

}

proc Window {args} {
global vTcl
    set cmd [lindex $args 0]
    set name [lindex $args 1]
    set rest [lrange $args 2 end]
    if {$name == "" || $cmd == ""} {return}
    set exists [winfo exists $name]
    switch $cmd {
        show {
            if {[info procs vTclWindow(pre)$name] != ""} {
                vTclWindow(pre)$name $rest
            }
            if {[info procs vTclWindow$name] != ""} {
                vTclWindow$name
            }
            if {[info procs vTclWindow(post)$name] != ""} {
                vTclWindow(post)$name $rest
            }
        }
        hide    { if $exists {wm withdraw $name; return} }
        iconify { if $exists {wm iconify $name; return} }
        destroy { if $exists {destroy $name; return} }
    }
}

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {args} {
    set base .
    ###################
    # CREATING WIDGETS
    ###################
    wm focusmodel . passive
    wm geometry . 1x1+0+0
    wm maxsize . 1137 870
    wm minsize . 1 1
    wm overrideredirect . 0
    wm resizable . 1 1
    wm withdraw .
    wm title . "vt.tcl"
    ###################
    # SETTING GEOMETRY
    ###################
}

proc vTclWindow.top1 {args} {
    set base .top1
    if {[winfo exists .top1]} {
        wm deiconify .top1; return
    }
    ###################
    # CREATING WIDGETS
    ###################
    toplevel .top1 -class Toplevel \
        -background #e3e2e3 
    wm focusmodel .top1 passive
    wm geometry .top1 226x116+103+182
    wm maxsize .top1 1137 870
    wm minsize .top1 1 1
    wm overrideredirect .top1 0
    wm resizable .top1 1 1
    wm deiconify .top1
    wm title .top1 "Grid Geometry"
    frame .top1.fra6 \
        -borderwidth 1 -height 30 -relief sunken -width 30 
    button .top1.fra6.0 \
        -background #afd9c7 \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
        -pady 3 -text one -width 5 
    button .top1.fra6.1 \
        -background #d9ab70 \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
        -pady 3 -text three -width 5 
    button .top1.fra6.2 \
        -background #d99bae \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
        -pady 3 -text two -width 5 
    button .top1.fra6.3 \
        -background #1d8fb2 \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
        -pady 3 -text five -width 5 
    button .top1.fra6.4 \
        -background #7eb5cb \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
        -pady 3 -text four -width 5 
    ###################
    # SETTING GEOMETRY
    ###################
    pack .top1.fra6 \
        -anchor center -expand 1 -fill both -padx 5 -pady 5 -side top 
    grid .top1.fra6.0 \
        -column 0 -row 0 -columnspan 2 -rowspan 1 -sticky ew 
    grid .top1.fra6.1 \
        -column 1 -row 1 -columnspan 1 -rowspan 1 
    grid .top1.fra6.2 \
        -column 0 -row 1 -columnspan 1 -rowspan 1 
    grid .top1.fra6.3 \
        -column 0 -row 2 -columnspan 3 -rowspan 1 -sticky ew 
    grid .top1.fra6.4 \
        -column 2 -row 0 -columnspan 1 -rowspan 2 -sticky ns 
}

Window show .
Window show .top1

main $argc $argv

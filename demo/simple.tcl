#############################################################################
# Visual Tcl v1.08 Project
#

#################################
# GLOBAL VARIABLES
#
global big_global; set big_global {this is a global variable}
global obj; set obj {1}
global widget; 
    set widget(rev,.top17.fra18.01) {TEXT}
    set widget(TEXT) {.top17.fra18.01}

#################################
# USER DEFINED PROCEDURES
#
proc init {argc argv} {

}

init $argc $argv


proc main {argc argv} {
global widget
$widget(TEXT) insert end "forced text"
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
    wm geometry . 212x100+0+0
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

proc vTclWindow.top17 {args} {
    set base .top17
    if {[winfo exists .top17]} {
        wm deiconify .top17; return
    }
    ###################
    # CREATING WIDGETS
    ###################
    toplevel .top17 -class Toplevel
    wm focusmodel .top17 passive
    wm geometry .top17 212x100+135+161
    wm maxsize .top17 1137 870
    wm minsize .top17 1 1
    wm overrideredirect .top17 0
    wm resizable .top17 1 1
    wm deiconify .top17
    wm title .top17 "Simple"
    frame .top17.fra18 \
        -background #81d9d9 -borderwidth 1 -height 151 -relief raised \
        -width 159 
    entry .top17.fra18.01 \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* 
    button .top17.fra18.02 \
        -command {$widget(TEXT) delete 0 end} \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
        -highlightthickness 0 -padx 9 -pady 3 -text Clear 
    ###################
    # SETTING GEOMETRY
    ###################
    grid .top17.fra18 \
        -column 0 -row 0 -columnspan 1 -rowspan 1 -ipady 5 -padx 10 -pady 10 \
        -sticky nesw 
    grid .top17.fra18.01 \
        -column 0 -row 0 -columnspan 1 -rowspan 1 -padx 20 -pady 5 
    grid .top17.fra18.02 \
        -column 0 -row 1 -columnspan 1 -rowspan 1 -pady 5 
}

Window show .
Window show .top17

main $argc $argv

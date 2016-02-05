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
frame .01 \
    -borderwidth 1 -height 30 -relief sunken -width 30 
pack .01 \
    -anchor center -expand 1 -fill both -padx 5 -pady 5 -side top 
button .01.02 \
    -background #afd9c7 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
    -pady 3 -text one -width 5 
grid .01.02 \
    -column 0 -row 0 -columnspan 2 -rowspan 1 -sticky ew 

button .01.03 \
    -background #d9ab70 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
    -pady 3 -text three -width 5 
grid .01.03 \
    -column 1 -row 1 -columnspan 1 -rowspan 1 

button .01.04 \
    -background #d99bae \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
    -pady 3 -text two -width 5 
grid .01.04 \
    -column 0 -row 1 -columnspan 1 -rowspan 1 

button .01.05 \
    -background #1d8fb2 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
    -pady 3 -text five -width 5 
grid .01.05 \
    -column 0 -row 2 -columnspan 3 -rowspan 1 -sticky ew 

button .01.06 \
    -background #7eb5cb \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -padx 9 \
    -pady 3 -text four -width 5 
grid .01.06 \
    -column 2 -row 0 -columnspan 1 -rowspan 2 -sticky ns 



main $argc $argv

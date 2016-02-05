#################################
# GLOBAL VARIABLES
#
global big_global; set big_global {this is a global variable}
global obj; set obj {1}
global widget; 
    set widget(rev,.01) {TEST}
    set widget(rev,.01.02) {TEXT}
    set widget(rev,.simple.f.e) {TEXT}
    set widget(TEST) {.01}
    set widget(rev,.simple.fra17.02) {TEXT}
    set widget(rev,.simple.fra18.ent19) {TEXT}
    set widget(TEXT) {.01.02}
    set widget(rev,.simple.fra18.02) {TEXT}
    set widget(rev,.top17.fra18.01) {TEXT}
    set widget(rev,.top17.fra18) {TEST}
    set widget(rev,.simple.fra21.01) {TEXT}
global widget; 
    set widget(rev,.01) {TEST}
    set widget(rev,.01.02) {TEXT}
    set widget(rev,.simple.f.e) {TEXT}
    set widget(TEST) {.01}
    set widget(rev,.simple.fra17.02) {TEXT}
    set widget(rev,.simple.fra18.ent19) {TEXT}
    set widget(TEXT) {.01.02}
    set widget(rev,.simple.fra18.02) {TEXT}
    set widget(rev,.top17.fra18.01) {TEXT}
    set widget(rev,.top17.fra18) {TEST}
    set widget(rev,.simple.fra21.01) {TEXT}

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
frame .01 \
    -background #81d9d9 -borderwidth 1 -height 151 -relief raised -width 159 
grid .01 \
    -column 0 -row 0 -columnspan 1 -rowspan 1 -ipady 5 -padx 10 -pady 10 \
    -sticky nesw 
entry .01.02 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* 
grid .01.02 \
    -column 0 -row 0 -columnspan 1 -rowspan 1 -padx 20 -pady 5 

button .01.03 \
    -command {$widget(TEXT) delete 0 end} \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text Clear 
grid .01.03 \
    -column 0 -row 1 -columnspan 1 -rowspan 1 -pady 5 



main $argc $argv

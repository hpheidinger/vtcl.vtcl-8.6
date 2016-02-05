#################################
# GLOBAL VARIABLES
#
global x_accel; set x_accel {}
global x_label; set x_label {}
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
    -background #a0d9d9 -borderwidth 1 -height 108 -relief sunken -width 93 
grid .01 \
    -column 0 -row 0 -columnspan 1 -rowspan 1 -padx 5 -pady 5 -sticky nesw 
button .01.02 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text We 
place .01.02 \
    -x 10 -y 10 -anchor nw -bordermode ignore 

button .01.03 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text are 
place .01.03 \
    -x 40 -y 40 -width 55 -height 24 -anchor nw -bordermode ignore 

button .01.04 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text placed 
place .01.04 \
    -x 20 -y 75 -anchor nw -bordermode ignore 


frame .05 \
    -background #d9a0d9 -borderwidth 1 -height 30 -relief sunken -width 30 
grid .05 \
    -column 1 -row 0 -columnspan 1 -rowspan 1 -padx 5 -pady 5 -sticky nesw 
button .05.06 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text We're 
pack .05.06 \
    -anchor center -expand 1 -fill both -padx 2 -pady 2 -side top 

button .05.07 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text packed 
pack .05.07 \
    -anchor center -expand 0 -fill x -padx 2 -pady 2 -side top 


frame .08 \
    -background #d9d9a0 -borderwidth 1 -relief sunken -width 30 
grid .08 \
    -column 0 -row 1 -columnspan 2 -rowspan 1 -padx 5 -pady 5 -sticky nesw 
button .08.09 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text And -width 5 
grid .08.09 \
    -column 0 -row 0 -columnspan 1 -rowspan 1 -padx 2 -pady 2 

button .08.010 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text a -width 5 
grid .08.010 \
    -column 0 -row 1 -columnspan 1 -rowspan 1 -padx 2 -pady 2 

button .08.011 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text grid -width 5 
grid .08.011 \
    -column 1 -row 1 -columnspan 1 -rowspan 1 -padx 2 -pady 2 

button .08.012 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text this -width 5 
grid .08.012 \
    -column 1 -row 0 -columnspan 1 -rowspan 1 -padx 2 -pady 2 

button .08.013 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text is -width 5 
grid .08.013 \
    -column 2 -row 0 -columnspan 1 -rowspan 1 -padx 2 -pady 2 

button .08.014 \
    -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
    -highlightthickness 0 -padx 9 -pady 3 -text layout -width 5 
grid .08.014 \
    -column 2 -row 1 -columnspan 1 -rowspan 1 -padx 2 -pady 2 


grid columnconf . 0 -weight 1
grid columnconf . 1 -weight 1
grid rowconf . 1 -weight 1

main $argc $argv

#############################################################################
# Visual Tcl v1.11 Project
#

#################################
# GLOBAL VARIABLES
#
global img; 
global widget; 
    set widget(CANVAS) {.top28.fra29.can30}
    set widget(rev,.01.02) {CANVAS}
    set widget(rev,.tclet.01) {CANVAS}
    set widget(rev,.top28.fra29.can30) {CANVAS}

#################################
# USER DEFINED PROCEDURES
#
proc init {argc argv} {
global vTcl tcl_platform tcl_version tk_strictMotif img
catch {package require unsafe}
set tk_strictMotif 1

global tool; 
global x; 
global y; 
global img;
set tool free 
set img(line) {
    R0lGODdhKAAoAPUAAAAAADj4MEDsMEjkMFBQ+FDcMFjQMGDIMGjAMHB0cHC4MHikOHisMIB8
    eICAgICcOIiQOJCIOJiAOKB4OKC0yKDEyKgoGKhsOLBkOLhcOLi4uMBQOMDAwMhIOMjEwNBA
    ONg4ONh8eOAsOOC4gOgkOPAcOPC4OPgUQPiIOPj8+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAAKAAoAAAG
    f8CUcEgsGo/IpHLJbDqf0Kj0CKhOo9Us4NrUerlJrxhc1KbM5yw5vRV+2e2r2t22DtFYO31f
    jj/nd3F6XICBhmCFh2xrVH5pjEaDj5BEkpOUl4qUlplrnJ1kn4mIjpWlhKd8jJ+qoamtmJGs
    sbOYtbavtLm4sb2+v8DBwsPEv0EAOw==
}
set img(rect) {
    R0lGODdhKAAoAPUAAAAAADj4MEDsMEjkMFBQ+FDcMFjQMGDIMGjAMHB0cHC4MHikOHisMIB8
    eICAgICcOIiQOJCIOJiAOKB4OKC0yKDEyKgoGKhsOLBkOLhcOLi4uMBQOMDAwMhIOMjEwNBA
    ONg4ONh8eOAsOOC4gOgkOPAcOPC4OPgUQPiIOPj8+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAAKAAoAAAG
    XsCUcEgsGo/IpHLJbDqf0Kh0Sq1ar9isdsvtOgHgsHhMBkfLaPQZMDVD3eu4FP5lz+1Peh5f
    b/Oben1vf4J7fnKIhYOJhot3jIqAaZNha5STXpmam5ydnp+goaKjVkEAOw==
}
set img(oval) {
    R0lGODdhKAAoAPUAAAAAADj4MEDsMEjkMFBQ+FDcMFjQMGDIMGjAMHB0cHC4MHikOHisMIB8
    eICAgICcOIiQOJCIOJiAOKB4OKC0yKDEyKgoGKhsOLBkOLhcOLi4uMBQOMDAwMhIOMjEwNBA
    ONg4ONh8eOAsOOC4gOgkOPAcOPC4OPgUQPiIOPj8+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAAKAAoAAAG
    YsCUcEgsGo/IpHLJbDqf0Kh0Sq1ar9isdstVAr5gQDcFPpax32a6Koa2pW83nC23xpf3uTqb
    N/P3aIBXfX52T4SHdVOISYyNVI5GkV6Ta4OWRGdcYZpjnp+goaKjpKWmp11BADs=
}
set img(free) {
    R0lGODdhKAAoAPcAAAAAALi4uNh8eOC4gPC4OPj8+AEUAEAIAMg0E6D4ABT/AAi/ABA1Aa+y
    ABQBAAhAAMQsuKeppxQUFAgICMi04DL39gj//0C/vw4EwMAA9gEA/0AAv1DIbwEytQAIAQBA
    QDjIyKigoBDIEK+gr+AkvPivp/8UFL8ICDEb5v22pwIAFEAACDYEEKgArxQAFAgACGjInrSg
    vQwUAQgIQMFkG4r4AA3/AEC/AIwEDVoAABQAAEAAAADIGACgAAAUAAQIADBw/Nb4pxD/FAy/
    CDA1HNay9xAB/whAv+gETskAkhEAB1DInqigvRQUATgEG6gAAAgAAMjIDTKgAAgUAPyIGPj4
    AP//AL+/AJQ1BLWyqAQBFEBACAnQHACn9wAU/wAIvwgIgKf4khT/Bwi/CEwEyAIAoAAAFAAA
    CMjIgzIyAAgIAEBABRjIEPmgr8TIG7+gAAQUAIAkEKavABQUAAgbGae2AEwEEgIAAGS4KPn4
    9////7+/v701LnmymggBBwhACGwE8MKozwwUEwA4AQD4AAD/AAC/ANgENfkAJ/8AEb8ACLDI
    OA0y9xYI/8jIFTKgjQgUB0AICNTIrPmgzf8UE9gkhPmv/P8U/78Iv7AAOA0A+hYA/wgAv5TI
    v/mggf8UBaAQDayvAAcUAAAgAACpAAAIAAHIhAAy/AAI/wBAvygOhADA/AAB/yhSqAAB+QAA
    /wAAvwCkAAAQAAGvANyMAPn4ANgxAPn9AP8CAL9AAJSahPmp/Nz8JKz4rwf/FLAKGw0AthYA
    ACjsTwAAdgAAZQAAcihudwAAaQAFdAAHZQD5IAD/ZQC/eIQKafwAc/8AdL8AaQCgBABvyAC1
    oAABFABACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAAKAAoAAAIngALCBxIsKDBgwgTKlzIsKHD
    hxAjSlQIoOLEiAAEaARw8WHGjR0bVgQZkiGAABk5lqQYoKXKlQkruoQZk0DFlzQNAiDAE2fO
    gTt7/jwY1ObQgkV9Hk16lCDTpkB5GoVa4ClVq02xZpWq9KfWpVxNdvxKdOyAAVPFTgRwtitC
    tyYterwod+5YpHWRlnzJVyfMm3hvwqVKuLDhw4gTNw0IADs=
}

    foreach i {free line rect oval} {
        image create photo $i -data $img($i)
    }
}

init $argc $argv


proc {button-down} {sx sy} {
global tool x y obj widget

switch -- $tool {
    free -
    line {
        set x $sx
        set y $sy
        set obj [$widget(CANVAS) create line $x $y $x $y]
    }
    rect {
        set x $sx
        set y $sy
        set obj [$widget(CANVAS) create rectangle $x $y $x $y]
    }
    ellipse {
        set x $sx
        set y $sy
        set obj [$widget(CANVAS) create arc $x $y $x $y -start 0 -extent 359 -style arc]
    }
}
}

proc {button-motion} {nx ny} {
global tool x y obj widget

switch -- $tool {
    free {
        $widget(CANVAS) create line $x $y $nx $ny
        set x $nx
        set y $ny
    }
    line -
    rect -
    ellipse {
        $widget(CANVAS) coords $obj $x $y $nx $ny
    }
}
}

proc {button-release} {nx ny} {
global tool x y

}

proc {main} {argc argv} {

}

proc {Window} {args} {
global vTcl
    set cmd [lindex $args 0]
    set name [lindex $args 1]
    set newname [lindex $args 2]
    set rest [lrange $args 3 end]
    if {$name == "" || $cmd == ""} {return}
    if {$newname == ""} {
        set newname $name
    }
    set exists [winfo exists $newname]
    switch $cmd {
        show {
            if {$exists == "1" && $name != "."} {wm deiconify $name; return}
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
    wm focusmodel $base passive
    wm geometry $base 200x200+0+0
    wm maxsize $base 1137 870
    wm minsize $base 96 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm withdraw $base
    wm title $base "vt.tcl"
    ###################
    # SETTING GEOMETRY
    ###################
}

proc vTclWindow.top28 {base} {
    if {$base == ""} {
        set base .top28
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    ###################
    # CREATING WIDGETS
    ###################
    toplevel $base -class Toplevel
    wm focusmodel $base passive
    wm geometry $base 503x352+95+172
    wm maxsize $base 1137 870
    wm minsize $base 96 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "Drawing Tclet"
    frame $base.fra29 \
        -borderwidth 1 -height 30 -relief raised -width 30 
    canvas $base.fra29.can30 \
        -borderwidth 2 -height 246 -highlightthickness 0 -relief ridge \
        -width 351 
    bind $base.fra29.can30 <B1-Motion> {
        button-motion %x %y
    }
    bind $base.fra29.can30 <Button-1> {
        button-down %x %y
    }
    bind $base.fra29.can30 <ButtonRelease-1> {
        button-release %x %y
    }
    frame $base.fra29.fra31 \
        -borderwidth 1 -height 30 -relief sunken -width 30 
    button $base.fra29.fra31.01 \
        -command {set tool free} \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
        -highlightthickness 0 -image free -padx 11 -pady 4 -text free 
    button $base.fra29.fra31.02 \
        -command {set tool line} \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
        -highlightthickness 0 -image line -padx 11 -pady 4 -text line 
    button $base.fra29.fra31.03 \
        -command {set tool rect} \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
        -highlightthickness 0 -image rect -padx 11 -pady 4 -text rect 
    button $base.fra29.fra31.04 \
        -command {set tool ellipse} \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
        -highlightthickness 0 -image oval -padx 11 -pady 4 -text ellipse 
    frame $base.fra29.fra32 \
        -borderwidth 2 -height 45 -relief groove -width 45 
    frame $base.fra29.fra32.01 \
        -background #ffffff -borderwidth 1 -height 30 -relief raised \
        -width 30 
    frame $base.fra29.fra32.02 \
        -background #000000 -borderwidth 1 -height 30 -relief raised \
        -width 30 
    label $base.fra29.lab33 \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
        -text select 
    label $base.fra29.lab34 \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
        -text {a tool} 
    button $base.fra29.but35 \
        -command exit \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* \
        -highlightthickness 0 -padx 9 -pady 3 -text Quit 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.fra29 \
        -in .top28 -anchor center -expand 1 -fill both -padx 5 -pady 5 \
        -side top 
    grid columnconf $base.fra29 0 -weight 1
    grid columnconf $base.fra29 1 -minsize 45
    grid rowconf $base.fra29 5 -weight 1
    grid rowconf $base.fra29 1 -minsize 45
    grid $base.fra29.can30 \
        -in .top28.fra29 -column 0 -row 0 -columnspan 1 -rowspan 6 -padx 5 \
        -pady 5 -sticky nesw 
    grid $base.fra29.fra31 \
        -in .top28.fra29 -column 1 -row 0 -columnspan 1 -rowspan 1 -padx 5 \
        -pady 5 -sticky n 
    pack $base.fra29.fra31.01 \
        -in .top28.fra29.fra31 -anchor center -expand 1 -fill both -side top 
    pack $base.fra29.fra31.02 \
        -in .top28.fra29.fra31 -anchor center -expand 1 -fill both -side top 
    pack $base.fra29.fra31.03 \
        -in .top28.fra29.fra31 -anchor center -expand 1 -fill both -side top 
    pack $base.fra29.fra31.04 \
        -in .top28.fra29.fra31 -anchor center -expand 1 -fill both -side top 
    grid $base.fra29.fra32 \
        -in .top28.fra29 -column 1 -row 1 -columnspan 1 -rowspan 1 -padx 5 \
        -pady 5 
    place $base.fra29.fra32.01 \
        -x 15 -y 15 -width 25 -height 25 -anchor nw -bordermode ignore 
    place $base.fra29.fra32.02 \
        -x 5 -y 5 -width 25 -height 25 -anchor nw -bordermode ignore 
    grid $base.fra29.lab33 \
        -in .top28.fra29 -column 1 -row 3 -columnspan 1 -rowspan 1 
    grid $base.fra29.lab34 \
        -in .top28.fra29 -column 1 -row 4 -columnspan 1 -rowspan 1 
    grid $base.fra29.but35 \
        -in .top28.fra29 -column 1 -row 5 -columnspan 1 -rowspan 1 -padx 5 \
        -pady 5 -sticky ns 
}

Window show .
Window show .top28

main $argc $argv


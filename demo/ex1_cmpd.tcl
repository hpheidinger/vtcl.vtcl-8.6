set vTcl(cmpd,list) "drawtool"

set {vTcl(cmpd:drawtool)} {{frame {-borderwidth 1 -height 30 -relief raised -width 30} {pack {-anchor center -expand 1 -fill both -padx 5 -pady 5 -side top}} {} {} {{canvas {-borderwidth 2 -height 246 -highlightthickness 0 -relief ridge -width 351} {grid {-column 0 -row 0 -columnspan 1 -rowspan 6 -padx 5 -pady 5 -sticky nesw}} {{<Button-1> {
        drawtool:button-down %x %y
    }} {<B1-Motion> {
        drawtool:button-motion %x %y
    }} {<ButtonRelease-1> {
        drawtool:button-release %x %y
    }}} {} {} .01 CANVAS {} {} {}} {frame {-borderwidth 1 -height 30 -relief sunken -width 30} {grid {-column 1 -row 0 -columnspan 1 -rowspan 1 -padx 5 -pady 5 -sticky n}} {} {} {{button {-command {set tool free} -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -highlightthickness 0 -image free -padx 11 -pady 4 -text free} {pack {-anchor center -expand 1 -fill both -side top}} {} {} {} .02.03 {} {} {} {}} {button {-command {set tool line} -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -highlightthickness 0 -image line -padx 11 -pady 4 -text line} {pack {-anchor center -expand 1 -fill both -side top}} {} {} {} .02.04 {} {} {} {}} {button {-command {set tool rect} -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -highlightthickness 0 -image rect -padx 11 -pady 4 -text rect} {pack {-anchor center -expand 1 -fill both -side top}} {} {} {} .02.05 {} {} {} {}} {button {-command {set tool ellipse} -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -highlightthickness 0 -image oval -padx 11 -pady 4 -text ellipse} {pack {-anchor center -expand 1 -fill both -side top}} {} {} {} .02.06 {} {} {} {}} } .02 {} {} {} {}} {frame {-borderwidth 2 -height 45 -relief groove -width 45} {grid {-column 1 -row 1 -columnspan 1 -rowspan 1 -padx 5 -pady 5}} {} {} {{frame {-background #ffffff -borderwidth 1 -height 30 -relief raised -width 30} {place {-x 15 -y 15 -width 25 -height 25 -anchor nw -bordermode ignore}} {} {} {} .07.08 {} {} {} {}} {frame {-background #000000 -borderwidth 1 -height 30 -relief raised -width 30} {place {-x 5 -y 5 -width 25 -height 25 -anchor nw -bordermode ignore}} {} {} {} .07.09 {} {} {} {}} } .07 {} {} {} {}} {label {-font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -text select} {grid {-column 1 -row 3 -columnspan 1 -rowspan 1}} {} {} {} .010 {} {} {} {}} {label {-font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -text {a tool}} {grid {-column 1 -row 4 -columnspan 1 -rowspan 1}} {} {} {} .011 {} {} {} {}} {button {-command exit -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -highlightthickness 0 -padx 9 -pady 3 -text Quit} {grid {-column 1 -row 5 -columnspan 1 -rowspan 1 -padx 5 -pady 5 -sticky ns}} {} {} {} .012 {} {} {} {}} } {} {} {{columnconf 0 -weight 1} {columnconf 1 -minsize 45} {rowconf 5 -weight 1} {rowconf 1 -minsize 45}} {{drawtool:button-down {sx sy} {
global tool x y obj widget

switch $tool {
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
}} {drawtool:button-motion {nx ny} {
global tool x y obj widget

switch $tool {
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
}} {drawtool:button-release {nx ny} {
global tool x y

switch $tool {
}
}} {drawtool:init args {
global vTcl tcl_platform tcl_version tk_strictMotif img
catch {package require unsafe}
set tk_strictMotif 1

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

if {$tcl_version < 7.7} {
    if {[info exists vTcl(VTCL_DIR)]} {
        set base [file join $vTcl(VTCL_DIR) demo]
    } else {
        set base [pwd]
    }
    image create photo free -file [file join $base images free.gif]
    image create photo line -file [file join $base images line.gif]
    image create photo rect -file [file join $base images rect.gif]
    image create photo oval -file [file join $base images oval.gif]
} else {
    foreach i {free line rect oval} {
        image create photo $i -data $img($i)
    }
}
}} {drawtool:main args {

}}} drawtool} {{.top28.fra29.can30 .01} {.top28.fra29.fra31.01 .02.03} {.top28.fra29.fra31.02 .02.04} {.top28.fra29.fra31.03 .02.05} {.top28.fra29.fra31.04 .02.06} {.top28.fra29.fra31 .02} {.top28.fra29.fra32.01 .07.08} {.top28.fra29.fra32.02 .07.09} {.top28.fra29.fra32 .07} {.top28.fra29.lab33 .010} {.top28.fra29.lab34 .011} {.top28.fra29.but35 .012} {.top28.fra29 }}}


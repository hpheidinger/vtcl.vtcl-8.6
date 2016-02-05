#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {
    switch $tcl_platform(platform) {
	windows {
	}
	default {
	    option add *Scrollbar.width 10
	}
    }
    
}


############################
# vTcl Code to Load Stock Images


if {![info exist vTcl(sourcing)]} {
proc vTcl:rename {name} {
    regsub -all "\\." $name "_" ret
    regsub -all "\\-" $ret "_" ret
    regsub -all " " $ret "_" ret
    regsub -all "/" $ret "__" ret
    regsub -all "::" $ret "__" ret

    return [string tolower $ret]
}

proc vTcl:image:create_new_image {filename description type data} {
    global vTcl env

    # Does the image already exist?
    if {[info exists vTcl(images,files)]} {
        if {[lsearch -exact $vTcl(images,files) $filename] > -1} { return }
    }

    if {![info exists vTcl(sourcing)] && [string length $data] > 0} {
        set object [image create  [vTcl:image:get_creation_type $filename]  -data $data]
    } else {
        # Wait a minute... Does the file actually exist?
        if {! [file exists $filename] } {
            # Try current directory
            set script [file dirname [info script]]
            set filename [file join $script [file tail $filename] ]
        }

        if {![file exists $filename]} {
            set description "file not found!"
            set object [image create photo -data [vTcl:image:broken_image] ]
        } else {
            set object [image create  [vTcl:image:get_creation_type $filename]  -file $filename]
        }
    }

    set reference [vTcl:rename $filename]

    set vTcl(images,$reference,image)       $object
    set vTcl(images,$reference,description) $description
    set vTcl(images,$reference,type)        $type
    set vTcl(images,filename,$object)       $filename

    lappend vTcl(images,files) $filename
    lappend vTcl(images,$type) $object

    # return image name in case caller might want it
    return $object
}

proc vTcl:image:get_image {filename} {
    global vTcl
    set reference [vTcl:rename $filename]

    # Let's do some checking first
    if {![info exists vTcl(images,$reference,image)]} {
        # Well, the path may be wrong; in that case check
        # only the filename instead, without the path.

        set imageTail [file tail $filename]

        foreach oneFile $vTcl(images,files) {
            if {[file tail $oneFile] == $imageTail} {
                set reference [vTcl:rename $oneFile]
                break
            }
        }
    }
    return $vTcl(images,$reference,image)
}

proc vTcl:image:get_creation_type {filename} {
    set ext [file extension $filename]
    set ext [string tolower $ext]

    switch $ext {
        .ppm -
        .gif    {return photo}
        .xbm    {return bitmap}
        default {return photo}
    }
}

proc vTcl:image:broken_image {} {
    return {
        R0lGODdhFAAUAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwICAgP8AAAD/
        AP//AAAA//8A/wD//////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAACwAAAAAFAAUAAAIhAAPCBxIsKDBgwgPAljIUOBC
        BAkBPJg4UeBEBBAVPkCI4EHGghIHChAwsKNHgyEPCFBA0mFDkBtVjiz4AADK
        mAds0tRJMCVBBkAl8hwYMsFPBwyE3jzQwKhAoASUwmTagCjDmksbVDWIderC
        g1174gQ71CHFigfOhrXKUGfbrwnjyp0bEAA7
    }
}

foreach img {

        {{[file join / home cgavin vtcl images edit ok.gif]} {} stock {
R0lGODdhFAAUAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8AAA
AAAAKgAAVQAAfwAAqgAA1AAqAAAqKgAqVQAqfwAqqgAq1ABVAABVKgBVVQBV
fwBVqgBV1AB/AAB/KgB/VQB/fwB/qgB/1ACqAACqKgCqVQCqfwCqqgCq1ADU
AADUKgDUVQDUfwDUqgDU1CoAACoAKioAVSoAfyoAqioA1CoqACoqKioqVSoq
fyoqqioq1CpVACpVKipVVSpVfypVqipV1Cp/ACp/Kip/VSp/fyp/qip/1Cqq
ACqqKiqqVSqqfyqqqiqq1CrUACrUKirUVSrUfyrUqirU1FUAAFUAKlUAVVUA
f1UAqlUA1FUqAFUqKlUqVVUqf1UqqlUq1FVVAFVVKlVVVVVVf1VVqlVV1FV/
AFV/KlV/VVV/f1V/qlV/1FWqAFWqKlWqVVWqf1WqqlWq1FXUAFXUKlXUVVXU
f1XUqlXU1H8AAH8AKn8AVX8Af38Aqn8A1H8qAH8qKn8qVX8qf38qqn8q1H9V
AH9VKn9VVX9Vf39Vqn9V1H9/AH9/Kn9/VX9/f39/qn9/1H+qAH+qKn+qVX+q
f3+qqn+q1H/UAH/UKn/UVX/Uf3/Uqn/U1KoAAKoAKqoAVaoAf6oAqqoA1Koq
AKoqKqoqVaoqf6oqqqoq1KpVAKpVKqpVVapVf6pVqqpV1Kp/AKp/Kqp/Vap/
f6p/qqp/1KqqAKqqKqqqVaqqf6qqqqqq1KrUAKrUKqrUVarUf6rUqqrU1NQA
ANQAKtQAVdQAf9QAqtQA1NQqANQqKtQqVdQqf9QqqtQq1NRVANRVKtRVVdRV
f9RVqtRV1NR/ANR/KtR/VdR/f9R/qtR/1NSqANSqKtSqVdSqf9SqqtSq1NTU
ANTUKtTUVdTUf9TUqtTU1AAAAAwMDBkZGSYmJjMzMz8/P0xMTFlZWWZmZnJy
cn9/f4yMjJmZmaWlpbKysr+/v8zMzNjY2OXl5fLy8v/78KCgpICAgP8AAAD/
AP//AAAA//8A/wD//////ywAAAAAFAAUAAAIQwDnCRxIsKDBgwgTKlyYUIAA
hgUdPoQ40CHFihYvSrw4byPHjAgnEvR4kGRHkCFFmkw5EaVCiStfxpQpUmNN
jjgvBgQAOw==}}

            } {
    eval set _file [lindex $img 0]
    vTcl:image:create_new_image\
        $_file [lindex $img 1] [lindex $img 2] [lindex $img 3]
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
proc {vTcl:DefineAlias} {target alias widgetProc top_or_alias cmdalias} {
    global widget

    set widget($alias) $target
    set widget(rev,$target) $alias

    if {$cmdalias} {
        interp alias {} $alias {} $widgetProc $target
    }

    if {$top_or_alias != ""} {
        set widget($top_or_alias,$alias) $target

        if {$cmdalias} {
            interp alias {} $top_or_alias.$alias {} $widgetProc $target
        }
    }
}

proc {vTcl:DoCmdOption} {target cmd} {
    ## menus are considered toplevel windows
    set parent $target
    while {[winfo class $parent] == "Menu"} {
        set parent [winfo parent $parent]
    }

    regsub -all {\%widget} $cmd $target cmd
    regsub -all {\%top} $cmd [winfo toplevel $parent] cmd

    uplevel #0 [list eval $cmd]
}

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

proc {vTcl:toplevel} {args} {
    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {}
}
}

if {[info exists vTcl(sourcing)]} {
proc vTcl:project:info {} {
    namespace eval ::widgets::.top18 {
        array set save {}
    }
    namespace eval ::widgets::.top18.cpd19 {
        array set save {-borderwidth 1 -height 1 -relief 1 -takefocus 1}
    }
    namespace eval ::widgets::.top18.cpd19.upframe {
        array set save {-borderwidth 1 -height 1}
    }
    namespace eval ::widgets::.top18.cpd19.centerframe {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top18.cpd19.centerframe.leftframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top18.cpd19.centerframe.rightframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top18.cpd19.centerframe.05 {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top18.cpd19.centerframe.05.06 {
        array set save {-borderwidth 1 -image 1 -text 1}
    }
    namespace eval ::widgets::.top18.cpd19.centerframe.05.07 {
        array set save {-borderwidth 1 -text 1}
    }
    namespace eval ::widgets::.top18.cpd19.downframe {
        array set save {-borderwidth 1 -height 1 -relief 1}
    }
    namespace eval ::widgets::.top18.ent20 {
        array set save {-background 1 -textvariable 1}
    }
    namespace eval ::widgets::.top18.lab18 {
        array set save {-anchor 1 -height 1 -text 1 -width 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist {BitmapButtonTop BitmapButtonSub1 BitmapButtonSub2 BitmapButtonSub3}
    }
}
}
#################################
# USER DEFINED PROCEDURES
#
###########################################################
## Procedure:  ::bitmapbutton::get_parent

namespace eval ::bitmapbutton {

proc {::bitmapbutton::get_parent} {W {level 1}} {
global widget

set items [split $W .]
set last [expr [llength $items] - 1]

set parent_items [lrange $items 0 [expr $last - $level] ]
return [join $parent_items .]
}

}
###########################################################
## Procedure:  ::bitmapbutton::init

namespace eval ::bitmapbutton {

proc {::bitmapbutton::init} {W} {
global widget

set N [vTcl:rename $W]
namespace eval ::${N} {
    variable command
    set command ""}
}

}
###########################################################
## Procedure:  ::bitmapbutton::mouse_down

namespace eval ::bitmapbutton {

proc {::bitmapbutton::mouse_down} {W X Y} {
global widget

::bitmapbutton::show_state $W sunken

set N [vTcl:rename $W]
namespace eval ::$N {variable state}

set ::${N}::state "mouse_down"
}

}
###########################################################
## Procedure:  ::bitmapbutton::mouse_inside

namespace eval ::bitmapbutton {

proc {::bitmapbutton::mouse_inside} {W X Y} {
global widget

set button_X [winfo rootx $W]
set button_Y [winfo rooty $W]
set button_width [winfo width $W]
set button_height [winfo height $W]

set N [vTcl:rename $W]
set S "mouse_up"

catch {
   eval set S $\:\:$N\:\:state
}

if {$S == "mouse_up"} return

if {$button_X <= $X &&
    $button_X + $button_width >= $X &&
    $button_Y <= $Y &&
    $button_Y + $button_height >= $Y } {
    
   ::bitmapbutton::show_state $W sunken

} else {

   ::bitmapbutton::show_state $W raised
}
}

}
###########################################################
## Procedure:  ::bitmapbutton::mouse_up

namespace eval ::bitmapbutton {

proc {::bitmapbutton::mouse_up} {W X Y} {
set button_X [winfo rootx $W]
set button_Y [winfo rooty $W]
set button_width [winfo width $W]
set button_height [winfo height $W]

::bitmapbutton::show_state $W raised

set N [vTcl:rename $W]
set S ""
catch {
   eval set S $\:\:$N\:\:state
}

if {$S == "mouse_down" } {

    set ::${N}::state "mouse_up"

    ## command triggered ?
    if {$button_X <= $X &&
        $button_X + $button_width >= $X &&
        $button_Y <= $Y &&
        $button_Y + $button_height >= $Y } {
        
        set ::${N}::W $W
        namespace eval ::${N} {
            variable command
            variable W
            if {[info exists command] && $command != ""} {
                vTcl:DoCmdOption $W $command
            }
        }
    }
}
}

}
###########################################################
## Procedure:  ::bitmapbutton::set_command

namespace eval ::bitmapbutton {

proc {::bitmapbutton::set_command} {W cmd} {
global widget

set N [vTcl:rename $W]
namespace eval ::${N} {}
set ::${N}::command $cmd
}

}
###########################################################
## Procedure:  ::bitmapbutton::show_state

namespace eval ::bitmapbutton {

proc {::bitmapbutton::show_state} {W S} {
global widget

set upframe    $W.upframe
set downframe  $W.downframe
set leftframe  $W.centerframe.leftframe
set rightframe $W.centerframe.rightframe

switch $S {

   sunken {
     $W configure -relief sunken
     $upframe    configure -height 4
     $leftframe  configure -width 4
     $rightframe configure -width 1
     $downframe  configure -height 1
   }

   raised {
     $W configure -relief raised
     $upframe configure -height 3
     $leftframe configure -width 3
     $rightframe configure -width 2
     $downframe configure -height 2
   }
}
}

}
###########################################################
## Procedure:  init
###########################################################
## Procedure:  main

proc {main} {argc argv} {
wm protocol .top18 WM_DELETE_WINDOW {exit}
global widget

::bitmapbutton::init $widget(TestButton)

::bitmapbutton::set_command $widget(TestButton) {
   puts "Clicked button %widget in toplevel %top !"
}
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

proc vTclWindow.top18 {base {container 0}} {
    if {$base == ""} {
        set base .top18
    }
    if {[winfo exists $base] && (!$container)} {
        wm deiconify $base; return
    }

    global widget
    vTcl:DefineAlias "$base.cpd19" "TestButton" vTcl:WidgetProc "$base" 1

    ###################
    # CREATING WIDGETS
    ###################
    if {!$container} {
    vTcl:toplevel $base -class Toplevel
    wm focusmodel $base passive
    wm geometry $base 435x151+164+173; update
    wm maxsize $base 1009 738
    wm minsize $base 1 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "Bitmap Button Test"
    }
    frame $base.cpd19 \
        -borderwidth 2 -height 0 -relief raised -takefocus 1 
    bindtags $base.cpd19 "$base.cpd19 Frame $base all BitmapButtonTop"
    frame $base.cpd19.upframe \
        -borderwidth 2 -height 3 
    bindtags $base.cpd19.upframe "$base.cpd19.upframe Frame $base all BitmapButtonSub1"
    frame $base.cpd19.centerframe \
        -borderwidth 2 
    bindtags $base.cpd19.centerframe "$base.cpd19.centerframe Frame $base all BitmapButtonSub1"
    frame $base.cpd19.centerframe.leftframe \
        -borderwidth 2 -width 3 
    bindtags $base.cpd19.centerframe.leftframe "$base.cpd19.centerframe.leftframe Frame $base all BitmapButtonSub2"
    frame $base.cpd19.centerframe.rightframe \
        -borderwidth 2 -width 2 
    bindtags $base.cpd19.centerframe.rightframe "$base.cpd19.centerframe.rightframe Frame $base all BitmapButtonSub2"
    frame $base.cpd19.centerframe.05 \
        -borderwidth 1 
    bindtags $base.cpd19.centerframe.05 "$base.cpd19.centerframe.05 Frame $base all BitmapButtonSub2"
    label $base.cpd19.centerframe.05.06 \
        -borderwidth 0 \
        -image [vTcl:image:get_image [file join / home cgavin vtcl images edit ok.gif]] \
        -text label 
    bindtags $base.cpd19.centerframe.05.06 "$base.cpd19.centerframe.05.06 Label $base all BitmapButtonSub3"
    label $base.cpd19.centerframe.05.07 \
        -borderwidth 1 -text Button 
    bindtags $base.cpd19.centerframe.05.07 "$base.cpd19.centerframe.05.07 Label $base all BitmapButtonSub3"
    frame $base.cpd19.downframe \
        -borderwidth 2 -height 2 -relief groove 
    bindtags $base.cpd19.downframe "$base.cpd19.downframe Frame $base all BitmapButtonSub1"
    entry $base.ent20 \
        -background white -textvariable "$base\::ent20" 
    label $base.lab18 \
        -anchor w -height 0 \
        -text {This application illustrates the 'bitmapbutton' compound.} \
        -width 383 
    ###################
    # SETTING GEOMETRY
    ###################
    place $base.cpd19 \
        -x 30 -y 60 -anchor nw 
    pack $base.cpd19.upframe \
        -in $base.cpd19 -anchor center -expand 0 -fill none -side top 
    pack $base.cpd19.centerframe \
        -in $base.cpd19 -anchor center -expand 0 -fill none -side top 
    pack $base.cpd19.centerframe.leftframe \
        -in $base.cpd19.centerframe -anchor center -expand 0 -fill none \
        -side left 
    pack $base.cpd19.centerframe.rightframe \
        -in $base.cpd19.centerframe -anchor center -expand 0 -fill none \
        -side right 
    pack $base.cpd19.centerframe.05 \
        -in $base.cpd19.centerframe -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd19.centerframe.05.06 \
        -in $base.cpd19.centerframe.05 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd19.centerframe.05.07 \
        -in $base.cpd19.centerframe.05 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd19.downframe \
        -in $base.cpd19 -anchor center -expand 0 -fill none -side bottom 
    place $base.ent20 \
        -x 105 -y 75 -anchor nw -bordermode ignore 
    place $base.lab18 \
        -x 35 -y 30 -width 383 -height 20 -anchor nw -bordermode ignore 
}

bind "BitmapButtonTop" <Button-1> {
    ::bitmapbutton::mouse_down %W %X %Y
}
bind "BitmapButtonTop" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up %W %X %Y
}
bind "BitmapButtonTop" <FocusIn> {
    # puts "Bitmapbutton gets focus"
%W.centerframe.05 configure -relief groove
}
bind "BitmapButtonTop" <FocusOut> {
    # puts "Bitmapbutton loses focus"
%W.centerframe.05 configure -relief flat
}
bind "BitmapButtonTop" <Key-space> {
    #TODO: your <KeyPress-space> event handler here
::bitmapbutton::mouse_down %W [winfo rootx %W] [winfo rooty %W]
}
bind "BitmapButtonTop" <KeyRelease-space> {
    #TODO: your <KeyRelease-space> event handler here
::bitmapbutton::mouse_up %W [winfo rootx %W] [winfo rooty %W]
}
bind "BitmapButtonTop" <Motion> {
    ::bitmapbutton::mouse_inside %W %X %Y
}
bind "BitmapButtonSub1" <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W] %X %Y
}
bind "BitmapButtonSub1" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W] %X %Y
}
bind "BitmapButtonSub1" <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W] %X %Y
}
bind "BitmapButtonSub2" <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 2] %X %Y
}
bind "BitmapButtonSub2" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 2] %X %Y
}
bind "BitmapButtonSub2" <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 2] %X %Y
}
bind "BitmapButtonSub3" <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 3] %X %Y
}
bind "BitmapButtonSub3" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 3] %X %Y
}
bind "BitmapButtonSub3" <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 3] %X %Y
}

Window show .
Window show .top18

main $argc $argv

set vTcl(cmpd,list) "bitmapbutton"

set {vTcl(cmpd:bitmapbutton)} {{Frame {-borderwidth 2 -relief raised -takefocus 1} {place {-x 30 -y 60 -anchor nw}} {{{.top18.cpd19 Frame %top all BitmapButtonTop}} {BitmapButtonTop <Motion> {
    ::bitmapbutton::mouse_inside %W %X %Y
}} {BitmapButtonTop <KeyRelease-space> {
    #TODO: your <KeyRelease-space> event handler here
::bitmapbutton::mouse_up %W [winfo rootx %W] [winfo rooty %W]
}} {BitmapButtonTop <Key-space> {
    #TODO: your <KeyPress-space> event handler here
::bitmapbutton::mouse_down %W [winfo rootx %W] [winfo rooty %W]
}} {BitmapButtonTop <FocusOut> {
    # puts "Bitmapbutton loses focus"
%W.centerframe.05 configure -relief flat
}} {BitmapButtonTop <FocusIn> {
    # puts "Bitmapbutton gets focus"
%W.centerframe.05 configure -relief groove
}} {BitmapButtonTop <ButtonRelease-1> {
    ::bitmapbutton::mouse_up %W %X %Y
}} {BitmapButtonTop <Button-1> {
    ::bitmapbutton::mouse_down %W %X %Y
}}} {} {{Frame {-borderwidth 2 -height 3} {pack {-in .top18.cpd19 -anchor center -expand 0 -fill none -side top}} {{{.top18.cpd19.upframe Frame %top all BitmapButtonSub1}} {BitmapButtonSub1 <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W] %X %Y
}} {BitmapButtonSub1 <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W] %X %Y
}} {BitmapButtonSub1 <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W] %X %Y
}}} {} {} .upframe {} {} {} {} {}} {Frame {-borderwidth 2} {pack {-in .top18.cpd19 -anchor center -expand 0 -fill none -side top}} {{{.top18.cpd19.centerframe Frame %top all BitmapButtonSub1}} {BitmapButtonSub1 <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W] %X %Y
}} {BitmapButtonSub1 <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W] %X %Y
}} {BitmapButtonSub1 <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W] %X %Y
}}} {} {{Frame {-borderwidth 2 -width 3} {pack {-in .top18.cpd19.centerframe -anchor center -expand 0 -fill none -side left}} {{{.top18.cpd19.centerframe.leftframe Frame %top all BitmapButtonSub2}} {BitmapButtonSub2 <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 2] %X %Y
}} {BitmapButtonSub2 <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 2] %X %Y
}} {BitmapButtonSub2 <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 2] %X %Y
}}} {} {} .centerframe.leftframe {} {} {} {} {}} {Frame {-borderwidth 2 -width 2} {pack {-in .top18.cpd19.centerframe -anchor center -expand 0 -fill none -side right}} {{{.top18.cpd19.centerframe.rightframe Frame %top all BitmapButtonSub2}} {BitmapButtonSub2 <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 2] %X %Y
}} {BitmapButtonSub2 <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 2] %X %Y
}} {BitmapButtonSub2 <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 2] %X %Y
}}} {} {} .centerframe.rightframe {} {} {} {} {}} {Frame {-borderwidth 1} {pack {-in .top18.cpd19.centerframe -anchor center -expand 0 -fill none -side top}} {{{.top18.cpd19.centerframe.05 Frame %top all BitmapButtonSub2}} {BitmapButtonSub2 <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 2] %X %Y
}} {BitmapButtonSub2 <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 2] %X %Y
}} {BitmapButtonSub2 <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 2] %X %Y
}}} {} {{Label {-borderwidth 0 -image image6 -text label} {pack {-in .top18.cpd19.centerframe.05 -anchor center -expand 0 -fill none -side top}} {{{.top18.cpd19.centerframe.05.06 Label %top all BitmapButtonSub3}} {BitmapButtonSub3 <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 3] %X %Y
}} {BitmapButtonSub3 <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 3] %X %Y
}} {BitmapButtonSub3 <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 3] %X %Y
}}} {} {} .centerframe.05.06 {} {} {} {} {}} {Label {-borderwidth 1 -text Button} {pack {-in .top18.cpd19.centerframe.05 -anchor center -expand 0 -fill none -side top}} {{{.top18.cpd19.centerframe.05.07 Label %top all BitmapButtonSub3}} {BitmapButtonSub3 <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 3] %X %Y
}} {BitmapButtonSub3 <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 3] %X %Y
}} {BitmapButtonSub3 <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 3] %X %Y
}}} {} {} .centerframe.05.07 {} {} {} {} {}} } .centerframe.05 {} {} {} {} {}} } .centerframe {} {} {} {} {}} {Frame {-borderwidth 2 -height 2 -relief groove} {pack {-in .top18.cpd19 -anchor center -expand 0 -fill none -side bottom}} {{{.top18.cpd19.downframe Frame %top all BitmapButtonSub1}} {BitmapButtonSub1 <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W] %X %Y
}} {BitmapButtonSub1 <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W] %X %Y
}} {BitmapButtonSub1 <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W] %X %Y
}}} {} {} .downframe {} {} {} {} {}} } {} TestButton {} {{::bitmapbutton::get_parent {W {level 1}} {
global widget

set items [split $W .]
set last [expr [llength $items] - 1]

set parent_items [lrange $items 0 [expr $last - $level] ]
return [join $parent_items .]
}} {::bitmapbutton::init W {
global widget

set N [vTcl:rename $W]
namespace eval ::${N} {
    variable command
    set command ""}
}} {::bitmapbutton::mouse_down {W X Y} {
global widget

::bitmapbutton::show_state $W sunken

set N [vTcl:rename $W]
namespace eval ::$N {variable state}

set ::${N}::state "mouse_down"
}} {::bitmapbutton::mouse_inside {W X Y} {
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
}} {::bitmapbutton::mouse_up {W X Y} {
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
}} {::bitmapbutton::set_command {W cmd} {
global widget

set N [vTcl:rename $W]
namespace eval ::${N} {}
set ::${N}::command $cmd
}} {::bitmapbutton::show_state {W S} {
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
}}} bitmapbutton {}} {{.top18.cpd19.upframe .upframe} {.top18.cpd19.centerframe.leftframe .centerframe.leftframe} {.top18.cpd19.centerframe.rightframe .centerframe.rightframe} {.top18.cpd19.centerframe.05.06 .centerframe.05.06} {.top18.cpd19.centerframe.05.07 .centerframe.05.07} {.top18.cpd19.centerframe.05 .centerframe.05} {.top18.cpd19.centerframe .centerframe} {.top18.cpd19.downframe .downframe} {.top18.cpd19 }}}


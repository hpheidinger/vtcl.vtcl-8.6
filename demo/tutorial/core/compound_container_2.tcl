#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

    package require Tk
    switch $tcl_platform(platform) {
	windows {
            option add *Button.padY 0
	}
	default {
            option add *Scrollbar.width 10
            option add *Scrollbar.highlightThickness 0
            option add *Scrollbar.elementBorderWidth 2
            option add *Scrollbar.borderWidth 2
	}
    }
    
}

#############################################################################
# Visual Tcl v1.60 Project
#

#############################################################################
## Compound: user / bitmap button
namespace eval {vTcl::compounds::user::{bitmap button}} {

set bindtags {
    BitmapButtonSub1
    BitmapButtonSub2
    BitmapButtonSub3
    BitmapButtonTop
}

set source .top79.cpd80

set libraries {
    core
}

set images {
        {{[file join D:/ cygwin home cgavin vtcl images edit ok.gif]} {} stock {}}
}

set class Frame

set procs {
    ::bitmapbutton::get_parent
    ::bitmapbutton::init
    ::bitmapbutton::mouse_down
    ::bitmapbutton::mouse_inside
    ::bitmapbutton::mouse_up
    ::bitmapbutton::set_command
    ::bitmapbutton::show_state
}


proc vTcl:DefineAlias {target alias args} {
    if {![info exists ::vTcl(running)]} {
        return [eval ::vTcl:DefineAlias $target $alias $args]
    }
    set class [vTcl:get_class $target]
    vTcl:set_alias $target [vTcl:next_widget_name $class $target $alias] -noupdate
}


proc infoCmd {target} {
    namespace eval ::widgets::$target {
        array set save {-borderwidth 1 -height 1 -relief 1 -takefocus 1}
    }
    set site_3_0 $target
    namespace eval ::widgets::$site_3_0.upframe {
        array set save {-borderwidth 1 -height 1}
    }
    namespace eval ::widgets::$site_3_0.centerframe {
        array set save {-borderwidth 1}
    }
    set site_4_0 $site_3_0.centerframe
    namespace eval ::widgets::$site_4_0.leftframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::$site_4_0.rightframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::$site_4_0.05 {
        array set save {-borderwidth 1}
    }
    set site_5_0 $site_4_0.05
    namespace eval ::widgets::$site_5_0.06 {
        array set save {-borderwidth 1 -image 1 -text 1}
    }
    namespace eval ::widgets::$site_5_0.07 {
        array set save {-borderwidth 1 -text 1}
    }
    namespace eval ::widgets::$site_3_0.downframe {
        array set save {-borderwidth 1 -height 1 -relief 1}
    }

}


proc bindtagsCmd {} {
#############################################################################
## Binding tag:  BitmapButtonSub1

bind "BitmapButtonSub1" <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W] %X %Y
}
bind "BitmapButtonSub1" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W] %X %Y
}
bind "BitmapButtonSub1" <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W] %X %Y
}
#############################################################################
## Binding tag:  BitmapButtonSub2

bind "BitmapButtonSub2" <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 2] %X %Y
}
bind "BitmapButtonSub2" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 2] %X %Y
}
bind "BitmapButtonSub2" <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 2] %X %Y
}
#############################################################################
## Binding tag:  BitmapButtonSub3

bind "BitmapButtonSub3" <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 3] %X %Y
}
bind "BitmapButtonSub3" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 3] %X %Y
}
bind "BitmapButtonSub3" <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 3] %X %Y
}
#############################################################################
## Binding tag:  BitmapButtonTop

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
}


proc compoundCmd {target} {
    ::bitmapbutton::init $target

    imagesCmd $target
    set items [split $target .]
    set parent [join [lrange $items 0 end-1] .]
    set top [winfo toplevel $parent]
    frame $target  -borderwidth 2 -relief raised -height 0 -takefocus 1 
    vTcl:DefineAlias "$target" "TestButton1" vTcl:WidgetProc "Toplevel1" 1
    bindtags $target "$target Frame $top all BitmapButtonTop"
    set site_3_0 $target
    frame $site_3_0.upframe  -borderwidth 2 -height 3 
    bindtags $site_3_0.upframe "$site_3_0.upframe Frame $top all BitmapButtonSub1"
    frame $site_3_0.centerframe  -borderwidth 2 
    bindtags $site_3_0.centerframe "$site_3_0.centerframe Frame $top all BitmapButtonSub1"
    set site_4_0 $site_3_0.centerframe
    frame $site_4_0.leftframe  -borderwidth 2 -width 3 
    bindtags $site_4_0.leftframe "$site_4_0.leftframe Frame $top all BitmapButtonSub2"
    frame $site_4_0.rightframe  -borderwidth 2 -width 2 
    bindtags $site_4_0.rightframe "$site_4_0.rightframe Frame $top all BitmapButtonSub2"
    frame $site_4_0.05  -borderwidth 1 
    bindtags $site_4_0.05 "$site_4_0.05 Frame $top all BitmapButtonSub2"
    set site_5_0 $site_4_0.05
    label $site_5_0.06  -borderwidth 0  -image [vTcl:image:get_image [file join D:/ cygwin home cgavin vtcl images edit ok.gif]]  -text label 
    bindtags $site_5_0.06 "$site_5_0.06 Label $top all BitmapButtonSub3"
    label $site_5_0.07  -borderwidth 1 -text Button 
    bindtags $site_5_0.07 "$site_5_0.07 Label $top all BitmapButtonSub3"
    pack $site_5_0.06  -in $site_5_0 -anchor center -expand 0 -fill none -side top 
    pack $site_5_0.07  -in $site_5_0 -anchor center -expand 0 -fill none -side top 
    pack $site_4_0.leftframe  -in $site_4_0 -anchor center -expand 0 -fill none -side left 
    pack $site_4_0.rightframe  -in $site_4_0 -anchor center -expand 0 -fill none -side right 
    pack $site_4_0.05  -in $site_4_0 -anchor center -expand 0 -fill none -side top 
    frame $site_3_0.downframe  -borderwidth 2 -relief groove -height 2 
    bindtags $site_3_0.downframe "$site_3_0.downframe Frame $top all BitmapButtonSub1"
    pack $site_3_0.upframe  -in $site_3_0 -anchor center -expand 0 -fill none -side top 
    pack $site_3_0.centerframe  -in $site_3_0 -anchor center -expand 0 -fill none -side top 
    pack $site_3_0.downframe  -in $site_3_0 -anchor center -expand 0 -fill none -side bottom 

}


proc imagesCmd {target} {
    variable images
    foreach img $images {
        eval set file [lindex $img 0]
        vTcl:image:create_new_image $file [lindex $img 1] [lindex $img 2] [lindex $img 3]
}
}


proc procsCmd {} {
#############################################################################
## Procedure:  ::bitmapbutton::get_parent

namespace eval ::bitmapbutton {
proc get_parent {W {level 1}} {
global widget

set items [split $W .]
set last [expr [llength $items] - 1]

set parent_items [lrange $items 0 [expr $last - $level] ]
return [join $parent_items .]
}
}

#############################################################################
## Procedure:  ::bitmapbutton::init

namespace eval ::bitmapbutton {
proc init {W} {
global widget

set N [vTcl:rename $W]
namespace eval ::${N} {
    variable command
    set command ""}
}
}

#############################################################################
## Procedure:  ::bitmapbutton::mouse_down

namespace eval ::bitmapbutton {
proc mouse_down {W X Y} {
global widget

::bitmapbutton::show_state $W sunken

set N [vTcl:rename $W]
namespace eval ::$N {variable state}

set ::${N}::state "mouse_down"
}
}

#############################################################################
## Procedure:  ::bitmapbutton::mouse_inside

namespace eval ::bitmapbutton {
proc mouse_inside {W X Y} {
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

#############################################################################
## Procedure:  ::bitmapbutton::mouse_up

namespace eval ::bitmapbutton {
proc mouse_up {W X Y} {
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

#############################################################################
## Procedure:  ::bitmapbutton::set_command

namespace eval ::bitmapbutton {
proc set_command {W cmd} {
global widget

set N [vTcl:rename $W]
namespace eval ::${N} {}
set ::${N}::command $cmd
}
}

#############################################################################
## Procedure:  ::bitmapbutton::show_state

namespace eval ::bitmapbutton {
proc show_state {W S} {
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

}

}



#############################################################################
## vTcl Code to Load Stock Images


if {![info exist vTcl(sourcing)]} {
#############################################################################
## Procedure:  vTcl:rename

proc ::vTcl:rename {name} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    regsub -all "\\." $name "_" ret
    regsub -all "\\-" $ret "_" ret
    regsub -all " " $ret "_" ret
    regsub -all "/" $ret "__" ret
    regsub -all "::" $ret "__" ret

    return [string tolower $ret]
}

#############################################################################
## Procedure:  vTcl:image:create_new_image

proc ::vTcl:image:create_new_image {filename {description {no description}} {type {}} {data {}}} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

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

#############################################################################
## Procedure:  vTcl:image:get_image

proc ::vTcl:image:get_image {filename} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    set reference [vTcl:rename $filename]

    # Let's do some checking first
    if {![info exists ::vTcl(images,$reference,image)]} {
        # Well, the path may be wrong; in that case check
        # only the filename instead, without the path.

        set imageTail [file tail $filename]

        foreach oneFile $::vTcl(images,files) {
            if {[file tail $oneFile] == $imageTail} {
                set reference [vTcl:rename $oneFile]
                break
            }
        }
    }
    return $::vTcl(images,$reference,image)
}

#############################################################################
## Procedure:  vTcl:image:get_creation_type

proc ::vTcl:image:get_creation_type {filename} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    switch [string tolower [file extension $filename]] {
        .ppm -
        .jpg -
        .bmp -
        .gif    {return photo}
        .xbm    {return bitmap}
        default {return photo}
    }
}

#############################################################################
## Procedure:  vTcl:image:broken_image

proc ::vTcl:image:broken_image {} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

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

        {{[file join D:/ cygwin home cgavin vtcl images edit ok.gif]} {} stock {}}

            } {
    eval set _file [lindex $img 0]
    vTcl:image:create_new_image\
        $_file [lindex $img 1] [lindex $img 2] [lindex $img 3]
}

}
#################################
# VTCL LIBRARY PROCEDURES
#

if {![info exists vTcl(sourcing)]} {
#############################################################################
## Library Procedure:  Window

proc ::Window {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

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
            if {$exists} {
                wm deiconify $newname
            } elseif {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[winfo exists $newname] && [wm state $newname] == "normal"} {
                vTcl:FireEvent $newname <<Show>>
            }
        }
        hide    {
            if {$exists} {
                wm withdraw $newname
                vTcl:FireEvent $newname <<Hide>>
                return}
        }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::compoundcontainer::cgetProc

namespace eval vTcl::widgets::core::compoundcontainer {
proc cgetProc {w args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        upvar ::${w}::compoundType  compoundType
        upvar ::${w}::compoundClass compoundClass

        set option [lindex $args 0]
        switch -- $option {
            -class         {return CompoundContainer}
            -compoundType  {return $compoundType}
            -compoundClass {return $compoundClass}
            default        {error "unknown option $option"}
        }
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::compoundcontainer::configureProc

namespace eval vTcl::widgets::core::compoundcontainer {
proc configureProc {w args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        upvar ::${w}::compoundType  compoundType
        upvar ::${w}::compoundClass compoundClass

        if {[lempty $args]} {
            return [concat [configureProc $w -class]  [configureProc $w -compoundType]  [configureProc $w -compoundClass]]
        }
        if {[llength $args] == 1} {
            set option [lindex $args 0]
            switch -- $option {
                -class {
                    return [list "-class class Class Frame CompoundContainer"]
                }
                -compoundClass {
                    return [list "-compoundClass compoundClass CompoundClass {} [list $compoundClass]"]
                }
                -compoundType {
                    return [list "-compoundType compoundType CompoundType user $compoundType"]
                }
                default {
                    error "unknown option $option"
                }
            }
        }
        ## this widget is not modifiable afterward
        error "cannot configure this widget after it is created"
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::compoundcontainer::createCmd

namespace eval vTcl::widgets::core::compoundcontainer {
proc createCmd {path args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        frame $path -class CompoundContainer
        namespace eval ::$path "set compoundType {}; set compoundClass {}"
        
        ## compound class specified ?
        if {[llength $args] == 2 && [lindex $args 0] == "-compoundClass"} {
            set type user
            set compoundName [lindex $args 1]
            insertCompound $path $type [list $compoundName]
        }

        return $path
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::compoundcontainer::insertCompound

namespace eval vTcl::widgets::core::compoundcontainer {
proc insertCompound {target type compoundName} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        set type user
        set spc ${type}::$compoundName
        if {[info exists ::vTcl(running)]} {
            ::vTcl::compounds::mergeCompoundCode $type [join $compoundName]
        } else {
            ::vTcl::compounds::${spc}::procsCmd
            ::vTcl::compounds::${spc}::bindtagsCmd
        }
        ::vTcl::compounds::${spc}::compoundCmd ${target}.cmpd
        ::vTcl::compounds::${spc}::infoCmd ${target}.cmpd
        pack $target.cmpd -fill both -expand 1

        ## register some info about ourself
        namespace eval ::$target "set compoundType $type; set compoundClass $compoundName"

        ## change the widget procedure
        rename ::$target ::_$target
        proc ::$target {command args}  "eval ::vTcl::widgets::core::compoundcontainer::widgetProc $target \$command \$args"
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::compoundcontainer::widgetProc

namespace eval vTcl::widgets::core::compoundcontainer {
proc widgetProc {w args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        if {[llength $args] == 0} {
            ## If no arguments, returns the path the alias points to
            return $w
        }

        set command [lindex $args 0]
        set args [lrange $args 1 end]
        switch $command {
            configure {
                return [eval configureProc $w $args]
            }
            cget {
                return [eval cgetProc $w $args]
            }
            widget {
                ## call megawidget widgetProc
                return [eval $w.cmpd widget $args]
            }
            innerClass {
                return [winfo class $w.cmpd]
            }
            default {
                ## we have renamed the default widgetProc _<widgetpath>
                uplevel _$w $command $args
            }
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:DefineAlias

proc ::vTcl:DefineAlias {target alias widgetProc top_or_alias cmdalias} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

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
#############################################################################
## Library Procedure:  vTcl:DoCmdOption

proc ::vTcl:DoCmdOption {target cmd} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## menus are considered toplevel windows
    set parent $target
    while {[winfo class $parent] == "Menu"} {
        set parent [winfo parent $parent]
    }

    regsub -all {\%widget} $cmd $target cmd
    regsub -all {\%top} $cmd [winfo toplevel $parent] cmd

    uplevel #0 [list eval $cmd]
}
#############################################################################
## Library Procedure:  vTcl:FireEvent

proc ::vTcl:FireEvent {target event {params {}}} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## The window may have disappeared
    if {![winfo exists $target]} return
    ## Process each binding tag, looking for the event
    foreach bindtag [bindtags $target] {
        set tag_events [bind $bindtag]
        set stop_processing 0
        foreach tag_event $tag_events {
            if {$tag_event == $event} {
                set bind_code [bind $bindtag $tag_event]
                foreach rep "\{%W $target\} $params" {
                    regsub -all [lindex $rep 0] $bind_code [lindex $rep 1] bind_code
                }
                set result [catch {uplevel #0 $bind_code} errortext]
                if {$result == 3} {
                    ## break exception, stop processing
                    set stop_processing 1
                } elseif {$result != 0} {
                    bgerror $errortext
                }
                break
            }
        }
        if {$stop_processing} {break}
    }
}
#############################################################################
## Library Procedure:  vTcl:Toplevel:WidgetProc

proc ::vTcl:Toplevel:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }
    set command [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- [string tolower $command] {
        "setvar" {
            set varname [lindex $args 0]
            set value [lindex $args 1]
            if {$value == ""} {
                return [set ::${w}::${varname}]
            } else {
                return [set ::${w}::${varname} $value]
            }
        }
        "hide" - "show" {
            Window [string tolower $command] $w
        }
        "showmodal" {
            ## modal dialog ends when window is destroyed
            Window show $w; raise $w
            grab $w; tkwait window $w; grab release $w
        }
        "startmodal" {
            ## ends when endmodal called
            Window show $w; raise $w
            set ::${w}::_modal 1
            grab $w; tkwait variable ::${w}::_modal; grab release $w
        }
        "endmodal" {
            ## ends modal dialog started with startmodal, argument is var name
            set ::${w}::_modal 0
            Window hide $w
        }
        default {
            uplevel $w $command $args
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:WidgetProc

proc ::vTcl:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
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
    uplevel $w $command $args
}
#############################################################################
## Library Procedure:  vTcl:toplevel

proc ::vTcl:toplevel {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {set _modal 0}
}
}


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top72
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 0
        set runvisible 1
    }
    namespace eval ::widgets::$base.lab74 {
        array set save {-anchor 1 -justify 1 -text 1}
    }
    namespace eval ::widgets::$base.fra75 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    set site_3_0 $base.fra75
    namespace eval ::widgets::$site_3_0.com76 {
        array set save {-class 1 -compoundClass 1}
    }
    namespace eval ::widgets::$site_3_0.com77 {
        array set save {-class 1 -compoundClass 1}
    }
    namespace eval ::widgets::$site_3_0.com78 {
        array set save {-class 1 -compoundClass 1}
    }
    namespace eval ::widgets::$site_3_0.com79 {
        array set save {-class 1 -compoundClass 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
        }
        set compounds {
            {user {bitmap button}}
        }
        set projectType single
    }
}
}

#################################
# USER DEFINED PROCEDURES
#
#############################################################################
## Procedure:  main

proc ::main {argc argv} {}

#############################################################################
## Initialization Procedure:  init

proc ::init {argc argv} {}

init $argc $argv

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
    wm focusmodel $top passive
    wm geometry $top 200x200+22+25; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm withdraw $top
    wm title $top "vtcl"
    bindtags $top "$top Vtcl all"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top72 {base} {
    if {$base == ""} {
        set base .top72
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel
    wm focusmodel $top passive
    wm geometry $top +201+275; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Compound Container Tutorial (The Sequel)"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    label $top.lab74 \
        -anchor w -justify left \
        -text {This sample shows another advantage of compound containers:
multiple copies of the same compound do not use a lot more space in the project file.

Look at the row of bitmap buttons below. Then, open this sample in a text editor.

Notice how a compound is created in a single line of code.
The compound creation command is called once for each compound, to create the underlying widgets.} 
    vTcl:DefineAlias "$top.lab74" "Label1" vTcl:WidgetProc "Toplevel1" 1
    frame $top.fra75 \
        -borderwidth 2 -relief sunken -height 75 -width 125 
    vTcl:DefineAlias "$top.fra75" "Frame1" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.fra75
    vTcl::widgets::core::compoundcontainer::createCmd $site_3_0.com76 \
        -compoundClass {bitmap button} 
    vTcl:DefineAlias "$site_3_0.com76" "CompoundContainer1" vTcl::widgets::core::compoundcontainer::widgetProc "Toplevel1" 1
    vTcl::widgets::core::compoundcontainer::createCmd $site_3_0.com77 \
        -compoundClass {bitmap button} 
    vTcl:DefineAlias "$site_3_0.com77" "CompoundContainer2" vTcl::widgets::core::compoundcontainer::widgetProc "Toplevel1" 1
    vTcl::widgets::core::compoundcontainer::createCmd $site_3_0.com78 \
        -compoundClass {bitmap button} 
    vTcl:DefineAlias "$site_3_0.com78" "CompoundContainer3" vTcl::widgets::core::compoundcontainer::widgetProc "Toplevel1" 1
    vTcl::widgets::core::compoundcontainer::createCmd $site_3_0.com79 \
        -compoundClass {bitmap button} 
    vTcl:DefineAlias "$site_3_0.com79" "CompoundContainer4" vTcl::widgets::core::compoundcontainer::widgetProc "Toplevel1" 1
    pack $site_3_0.com76 \
        -in $site_3_0 -anchor center -expand 0 -fill none -padx 5 -pady 5 \
        -side left 
    pack $site_3_0.com77 \
        -in $site_3_0 -anchor center -expand 0 -fill none -padx 5 -pady 5 \
        -side left 
    pack $site_3_0.com78 \
        -in $site_3_0 -anchor center -expand 0 -fill none -padx 5 -pady 5 \
        -side left 
    pack $site_3_0.com79 \
        -in $site_3_0 -anchor center -expand 0 -fill none -padx 5 -pady 5 \
        -side left 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.lab74 \
        -in $top -anchor center -expand 0 -fill x -padx 5 -pady 5 -side top 
    pack $top.fra75 \
        -in $top -anchor center -expand 0 -fill x -padx 5 -pady 5 -side top 

    vTcl:FireEvent $base <<Ready>>
}

#############################################################################
## Binding tag:  _TopLevel

bind "_TopLevel" <<Create>> {
    if {![info exists _topcount]} {set _topcount 0}; incr _topcount
}
bind "_TopLevel" <<DeleteWindow>> {
    if {[set ::%W::_modal]} {
                vTcl:Toplevel:WidgetProc %W endmodal
            } else {
                destroy %W; if {$_topcount == 0} {exit}
            }
}
bind "_TopLevel" <Destroy> {
    if {[winfo toplevel %W] == "%W"} {incr _topcount -1}
}

Window show .
Window show .top72

main $argc $argv


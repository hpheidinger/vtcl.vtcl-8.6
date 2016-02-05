#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

    # Provoke name search
    catch {package require bogus-package-name}
    set packageNames [package names]

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
    
        # tablelist is required
        package require tablelist
    
}

#############################################################################
# Visual Tcl v1.60 Project
#

#############################################################################
## Compound: user / Image List
namespace eval {vTcl::compounds::user::{Image List}} {

set bindtags {}

set source .top72.cpd73

set libraries {
    core
    tablelist
}

set class MegaWidget

set procs {
    ::imagelist::cleanList
    ::imagelist::fillList
    ::imagelist::getThumbnail
    ::imagelist::handleList
    ::imagelist::myWidgetProc
    ::imagelist::init
    ::imagelist::configureCmd
    ::imagelist::configureAllCmd
    ::imagelist::cgetCmd
    ::imagelist::configureOptionCmd
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
        array set save {-class 1 -widgetProc 1}
    }
    set site_3_0 $target
    namespace eval ::widgets::$site_3_0.tab73 {
        array set save {-background 1 -columns 1 -selectmode 1 -yscrollcommand 1}
        namespace eval subOptions {
            array set save {-title 1}
        }
    }
    namespace eval ::widgets::$site_3_0.scr78 {
        array set save {-command 1}
    }

}


proc bindtagsCmd {} {}


proc compoundCmd {target} {
    ::imagelist::init $target

    set items [split $target .]
    set parent [join [lrange $items 0 end-1] .]
    set top [winfo toplevel $parent]
    vTcl::widgets::core::megawidget::createCmd $target  -widgetProc ::imagelist::myWidgetProc 
    vTcl:DefineAlias "$target" "MegaWidget1" vTcl::widgets::core::megawidget::widgetProc "Toplevel1" 1
    set site_3_0 $target
    ::tablelist::tablelist $site_3_0.tab73  -background #ffffff -columns {0 Image left} -selectmode extended  -yscrollcommand "$site_3_0.scr78 set" 
    vTcl:DefineAlias "$site_3_0.tab73" "Tablelist1" vTcl:WidgetProc "Toplevel1" 1
    $site_3_0.tab73 columnconfigure 0  -title Image 
    bind [$site_3_0.tab73 bodypath] <Configure> {
        tablelist::adjustSepsWhenIdle [winfo parent %W]
    }
    scrollbar $site_3_0.scr78  -command "$site_3_0.tab73 yview" 
    vTcl:DefineAlias "$site_3_0.scr78" "Scrollbar1" vTcl:WidgetProc "Toplevel1" 1
    pack $site_3_0.tab73  -in $site_3_0 -anchor center -expand 1 -fill both -side left 
    pack $site_3_0.scr78  -in $site_3_0 -anchor center -expand 0 -fill y -side right 

}


proc procsCmd {} {
#############################################################################
## Procedure:  ::imagelist::cleanList

namespace eval ::imagelist {
proc cleanList {w} {
   set size [$w index end]
   for {set i 0} {$i < $size} {incr i} {
       set image [$w cellcget $i,0 -image]
       if {$image != ""} {
           image delete $image
       }
   }

   $w delete 0 end
}
}

#############################################################################
## Procedure:  ::imagelist::fillList

namespace eval ::imagelist {
proc fillList {w directory {thumbSize 60}} {
set files [glob -nocomplain [file join $directory *.jpg] [file join $directory *.JPG]]
set files [lsort -unique $files]
handleList $w $files $thumbSize
}
}

#############################################################################
## Procedure:  ::imagelist::getThumbnail

namespace eval ::imagelist {
proc getThumbnail {filename {size 60}} {
   set source [image create photo -file $filename]
   set source_width  [image width $source]
   set source_height [image height $source]

   if {$source_width > $source_height} {
      set target_width $size
      set target_height [expr $size * $source_height / $source_width]
   } else {
      set target_height $size
      set target_width [expr $size * $source_width / $source_height]
   }

   set target [image create photo -width $size -height $size]

   set deltax [expr ($size - $target_width)  / 2]
   set deltay [expr ($size - $target_height) / 2]

   $target copy $source -from 0 0 [expr $source_width - 1] [expr $source_height - 1]  -to   $deltax $deltay [expr $target_width - 1 + $deltax ]  [expr $target_height - 1 + $deltay]  -subsample [expr $source_width  / $target_width]  [expr $source_height / $target_height]

   image delete $source
   return $target
}
}

#############################################################################
## Procedure:  ::imagelist::handleList

namespace eval ::imagelist {
proc handleList {w list thumbSize} {
   if {[llength $list] == 0} {
      return
   }

   set first [lindex $list 0]
   set thumb [getThumbnail $first $thumbSize]

   $w insert end [list [file tail $first]]
   set size [$w index end]
   $w cellconfigure [expr $size -1],0 -image $thumb

   update
   after idle "::imagelist::handleList $w [list [lrange $list 1 end]] $thumbSize"
}
}

#############################################################################
## Procedure:  ::imagelist::myWidgetProc

namespace eval ::imagelist {
proc myWidgetProc {w args} {
set command [lindex $args 0]
set args [lrange $args 1 end]

if {$command == "configure"} {
    return [eval configureCmd $w $args]
} elseif {$command == "cget"} {
    return [eval cgetCmd $w $args]
}
}
}

#############################################################################
## Procedure:  ::imagelist::init

namespace eval ::imagelist {
proc init {target} {
## this megawidget requires the Img extension for handling JPEG images
package require Img

## used to store the directory path
namespace eval ::imagelist::${target} {set _path ""}
}
}

#############################################################################
## Procedure:  ::imagelist::configureCmd

namespace eval ::imagelist {
proc configureCmd {w args} {
if {[llength $args] == 0} {
    return [configureAllCmd $w]
} elseif {[llength $args] == 1} {
    return [configureOptionCmd $w $args]
}

foreach {option value} $args {
    if {$option == "-directory"} {
        cleanList $w.tab73
        fillList $w.tab73 $value
        namespace eval ::imagelist::${w} [list set _path $value]
    } else {
        ## delegate other options to tablelist
        $w.tab73 configure $option $value
    }
}
}
}

#############################################################################
## Procedure:  ::imagelist::configureAllCmd

namespace eval ::imagelist {
proc configureAllCmd {w} {
upvar ::imagelist::${w}::_path path

set result ""
set opt [list -directory directory Directory {} $path]
lappend result $opt

set opt [$w.tab73 configure]
set result [concat $result $opt]

return $result
}
}

#############################################################################
## Procedure:  ::imagelist::cgetCmd

namespace eval ::imagelist {
proc cgetCmd {w args} {
set option $args
if {$option == "-directory"} {
    upvar ::imagelist::${w}::_path path
    return $path
} else {
    return [$w.tab73 cget $option]
}
}
}

#############################################################################
## Procedure:  ::imagelist::configureOptionCmd

namespace eval ::imagelist {
proc configureOptionCmd {w option} {
if {$option == "-directory"} {
    upvar ::imagelist::${w}::_path path

    set result [list [list -directory directory Directory {} $path]]
    return $result
} else {
    set result [$w.tab73 configure $option]
    return $result
}
}
}

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
## Library Procedure:  vTcl::widgets::core::megawidget::cgetProc

namespace eval vTcl::widgets::core::megawidget {
proc cgetProc {w args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        upvar ::${w}::widgetProc  widgetProc

        set option [lindex $args 0]
        switch -- $option {
            -class         {return MegaWidget}
            -widgetProc    {return $widgetProc}
            default        {error "unknown option $option"}
        }
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::megawidget::configureProc

namespace eval vTcl::widgets::core::megawidget {
proc configureProc {w args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        upvar ::${w}::widgetProc  widgetProc

        if {[lempty $args]} {
            return [concat [configureProc $w -class]  [configureProc $w -widgetProc]]
        }
        if {[llength $args] == 1} {
            set option [lindex $args 0]
            switch -- $option {
                -class {
                    return [list "-class class Class Frame MegaWidget"]
                }
                -widgetProc {
                    return [list "-widgetProc widgetproc WidgetProc {} [list $widgetProc]"]
                }
                default {
                    error "unknown option $option"
                }
            }
        }

        foreach {option value} $args {
            if {$option == "-widgetProc"} {
                set widgetProc $value
            }
        }
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::megawidget::createCmd

namespace eval vTcl::widgets::core::megawidget {
proc createCmd {path args} {
        ## This procedure may be used free of restrictions.
        ##    Exception added by Christian Gavin on 08/08/02.
        ## Other packages and widget toolkits have different licensing requirements.
        ##    Please read their license agreements for details.

        frame $path -class MegaWidget
        namespace eval ::$path "set widgetProc {}"

        ## change the widget procedure
        rename ::$path ::_$path
        proc ::$path {command args}  "eval ::vTcl::widgets::core::megawidget::widgetProc $path \$command \$args"

        ## widgetProc specified ? if so, store it
        if {[llength $args] == 2 && [lindex $args 0] == "-widgetProc"} {
            upvar ::${path}::widgetProc  widgetProc
            set widgetProc [lindex $args 1]
        }
        
        return $path
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::core::megawidget::widgetProc

namespace eval vTcl::widgets::core::megawidget {
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
                ## this calls the custom widgetProc
                upvar ::${w}::widgetProc  widgetProc
                return [eval $widgetProc $w $args]
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
        set set,size 1
        set runvisible 1
    }
    namespace eval ::widgets::$base.com73 {
        array set save {-class 1 -compoundClass 1}
    }
    namespace eval ::widgets::$base.fra74 {
        array set save {-borderwidth 1}
    }
    set site_3_0 $base.fra74
    namespace eval ::widgets::$site_3_0.ent75 {
        array set save {-background 1 -textvariable 1}
    }
    namespace eval ::widgets::$site_3_0.but76 {
        array set save {-command 1 -text 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
            init
            main
            view_directory
        }
        set compounds {
            {user {Image List}}
        }
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
## Procedure:  view_directory

proc ::view_directory {} {
ImageList1 widget configure -directory [Toplevel1 setvar directory]
}

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
    wm geometry $top 200x200+110+125; update
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
    wm geometry $top 330x265+136+190; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Image List Test Application"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    vTcl::widgets::core::compoundcontainer::createCmd $top.com73 \
        -compoundClass {Image List} 
    vTcl:DefineAlias "$top.com73" "ImageList1" vTcl::widgets::core::compoundcontainer::widgetProc "Toplevel1" 1
    frame $top.fra74 \
        -borderwidth 2 
    vTcl:DefineAlias "$top.fra74" "Frame1" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.fra74
    entry $site_3_0.ent75 \
        -background white -textvariable "$top\::directory" 
    vTcl:DefineAlias "$site_3_0.ent75" "Entry1" vTcl:WidgetProc "Toplevel1" 1
    button $site_3_0.but76 \
        -command view_directory -text View! 
    vTcl:DefineAlias "$site_3_0.but76" "Button1" vTcl:WidgetProc "Toplevel1" 1
    pack $site_3_0.ent75 \
        -in $site_3_0 -anchor center -expand 1 -fill x -padx 4 -pady 4 \
        -side left 
    pack $site_3_0.but76 \
        -in $site_3_0 -anchor center -expand 0 -fill none -ipadx 4 -padx 4 \
        -pady 4 -side right 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.com73 \
        -in $top -anchor center -expand 1 -fill both -padx 4 -pady 4 \
        -side top 
    pack $top.fra74 \
        -in $top -anchor center -expand 0 -fill x -side top 

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


#############################################################################
# Visual Tcl v1.60 Compound Library
#
namespace eval {vTcl::compounds::user::{Image List}} {

set bindtags {}

set libraries {
    core
    tablelist
}

set source .top72.cpd73

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


proc bindtagsCmd {} {}


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


proc vTcl:DefineAlias {target alias args} {
    if {![info exists ::vTcl(running)]} {
        return [eval ::vTcl:DefineAlias $target $alias $args]
    }
    set class [vTcl:get_class $target]
    vTcl:set_alias $target [vTcl:next_widget_name $class $target $alias] -noupdate
}


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



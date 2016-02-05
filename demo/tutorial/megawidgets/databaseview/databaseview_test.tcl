#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

    # Provoke name search
    catch {package require bogus-package-name}
    set packageNames [package names]

    package require BWidget
    switch $tcl_platform(platform) {
	windows {
	}
	default {
	    option add *ScrolledWindow.size 14
	}
    }
    
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
## Compound: user / Database View
namespace eval {vTcl::compounds::user::{Database View}} {

set bindtags {}

set libraries {
    bwidget
    core
    tablelist
}

set source .top79.meg80

set class MegaWidget

set procs {
    ::database_view::init
    ::database_view::main
    ::database_view::configureCmd
    ::database_view::myWidgetProc
    ::database_view::cgetCmd
    ::database_view::openCmd
    ::database_view::layoutTable
    ::database_view::closeCmd
    ::database_view::fillLayout
    ::database_view::fillData
    ::database_view::dataTable
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
    namespace eval ::widgets::$site_3_0.not81 {
        array set save {-height 1 -width 1}
        namespace eval subOptions {
            array set save {-text 1}
        }
    }
    set site_5_0 [$site_3_0.not81 getframe page1]
    namespace eval ::widgets::$site_5_0 {
        array set save {-borderwidth 1}
    }
    set site_5_0 $site_5_0
    namespace eval ::widgets::$site_5_0.tab82 {
        array set save {-columns 1}
    }
    set site_5_1 [$site_3_0.not81 getframe page2]
    namespace eval ::widgets::$site_5_1 {
        array set save {-borderwidth 1}
    }
    set site_5_0 $site_5_1
    namespace eval ::widgets::$site_5_0.scr79 {
        array set save {}
    }
    namespace eval ::widgets::$site_5_0.scr79.f.tab80 {
        array set save {-columns 1}
    }

}


proc bindtagsCmd {} {}


proc compoundCmd {target} {
    ::database_view::init $target

    set items [split $target .]
    set parent [join [lrange $items 0 end-1] .]
    set top [winfo toplevel $parent]
    vTcl::widgets::core::megawidget::createCmd $target  -widgetProc ::database_view::myWidgetProc 
    vTcl:DefineAlias "$target" "MegaWidget1" vTcl::widgets::core::megawidget::widgetProc "Toplevel1" 1
    bind $target <Destroy> {
        ## close the database in case it was open
%W widget close
    }
    set site_3_0 $target
    NoteBook $site_3_0.not81  -height 200 -width 300 
    vTcl:DefineAlias "$site_3_0.not81" "NoteBook1" vTcl:WidgetProc "Toplevel1" 1
    $site_3_0.not81 insert end page1  -text Layout 
    $site_3_0.not81 insert end page2  -text Records 
    set site_5_0 [$site_3_0.not81 getframe page1]
    ::tablelist::tablelist $site_5_0.tab82  -columns {0 Name left 0 Type left} 
    vTcl:DefineAlias "$site_5_0.tab82" "Tablelist1" vTcl:WidgetProc "Toplevel1" 1
    $site_5_0.tab82 columnconfigure 0  -title Name 
    $site_5_0.tab82 columnconfigure 1  -title Type 
    bind [$site_5_0.tab82 bodypath] <Configure> {
        tablelist::adjustSepsWhenIdle [winfo parent %W]
    }
    pack $site_5_0.tab82  -in $site_5_0 -anchor center -expand 1 -fill both -side top 
    set site_5_1 [$site_3_0.not81 getframe page2]
    vTcl::widgets::bwidgets::scrolledwindow::createCmd $site_5_1.scr79
    vTcl:DefineAlias "$site_5_1.scr79" "ScrolledWindow1" vTcl:WidgetProc "Toplevel1" 1
    ::tablelist::tablelist $site_5_1.scr79.f.tab80  -columns {0 first left 0 last left 0 shoesize left} 
    vTcl:DefineAlias "$site_5_1.scr79.f.tab80" "Tablelist2" vTcl:WidgetProc "Toplevel1" 1
    $site_5_1.scr79.f.tab80 columnconfigure 0  -title first 
    $site_5_1.scr79.f.tab80 columnconfigure 1  -title last 
    $site_5_1.scr79.f.tab80 columnconfigure 2  -title shoesize 
    bind [$site_5_1.scr79.f.tab80 bodypath] <Configure> {
        tablelist::adjustSepsWhenIdle [winfo parent %W]
    }
    pack $site_5_1.scr79.f.tab80 -fill both -expand 1
    $site_5_1.scr79 setwidget $site_5_1.scr79.f
    pack $site_5_1.scr79  -in $site_5_1 -anchor center -expand 1 -fill both -side top 
    $site_3_0.not81 raise page1
    pack $site_3_0.not81  -in $site_3_0 -anchor center -expand 1 -fill both -side top 

    ::database_view::main $target
}


proc procsCmd {} {
#############################################################################
## Procedure:  ::database_view::init

namespace eval ::database_view {
proc init {w} {
    ## this procedure is executed before the megawidget UI gets created
    ## you can prepare any internal data here
    package require Mk4tcl
    
    ## for data storage
    namespace eval ::database_view::${w} "variable tag; set tag {}"
    namespace eval ::database_view::${w} "variable filepath; set filepath {}"
}
}

#############################################################################
## Procedure:  ::database_view::main

namespace eval ::database_view {
proc main {w} {
    ## this procedure is called after the megawidget UI gets created
}
}

#############################################################################
## Procedure:  ::database_view::configureCmd

namespace eval ::database_view {
proc configureCmd {w args} {
    ## TODO: handle megawidget configuration here
    ##
    ## examples of args:
    ##    -background white -foreground red
    ##        configure the -background and -foreground options
    ##    {}
    ##        empty list to return all options
    ##    -background
    ##        returns the -background configuration option
}
}

#############################################################################
## Procedure:  ::database_view::myWidgetProc

namespace eval ::database_view {
proc myWidgetProc {w args} {
    ## this is the widget procedure that receives all the commands
    ## for the megawidget
    set command [lindex $args 0]
    set args [lrange $args 1 end]

    ## all commands are suffixed with "Cmd" so the call to the
    ## given command is straightforward
    return [eval ${command}Cmd $w $args]
}
}

#############################################################################
## Procedure:  ::database_view::cgetCmd

namespace eval ::database_view {
proc cgetCmd {w args} {
    set option $args
    ## TODO: return the value for the option $option
}
}

#############################################################################
## Procedure:  ::database_view::openCmd

namespace eval ::database_view {
proc openCmd {w args} {
## store the tag to allow closing the database later
upvar ::database_view::${w}::tag tag
upvar ::database_view::${w}::filepath filepath

## already opened?
if {$tag != ""} {
    error "Database already open!"
}

set filepath [lindex $args 0]
set tag [mk::file open db $filepath]

## assume we have a one view database, otherwise use the first view
set views [mk::file views $tag]
set view [lindex $views 0]

## assume flat layout (eg. no fields containing other fields)
set layout [mk::view layout $tag.$view]
fillLayout $w $layout
fillData $w $view
puts "Database $filepath opened successfully."
}
}

#############################################################################
## Procedure:  ::database_view::layoutTable

namespace eval ::database_view {
proc layoutTable {w args} {
return $w.not81.fpage1.tab82
}
}

#############################################################################
## Procedure:  ::database_view::closeCmd

namespace eval ::database_view {
proc closeCmd {w args} {
upvar ::database_view::${w}::tag tag
upvar ::database_view::${w}::filepath filepath

## already closed?
if {$tag == ""} {
    return
}

mk::file close $tag
set tag ""
puts "Database $filepath closed."
}
}

#############################################################################
## Procedure:  ::database_view::fillLayout

namespace eval ::database_view {
proc fillLayout {w layout} {
set t [layoutTable $w]
$t delete 0 end

set columns "0 Name left 0 Type left"
$t configure -columns $columns

foreach field $layout {
    set values [split $field :]
    set name [lindex $values 0]
    set type [lindex $values 1]
    $t insert end [list $name $type]
}

## prepare the data table
set dt [dataTable $w]

set columns ""
foreach field $layout {
    set values [split $field :]
    set name [lindex $values 0]
    lappend columns 0 $name left
}
$dt configure -columns $columns
}
}

#############################################################################
## Procedure:  ::database_view::fillData

namespace eval ::database_view {
proc fillData {w view} {
upvar ::database_view::${w}::tag tag

set dt [dataTable $w]
set rows [mk::select $tag.$view]

$dt delete 0 end
foreach row $rows {
    set data [mk::get $tag.$view!$row]
    set line {}
    foreach {property value} $data {
        lappend line $value
    }
    $dt insert end $line
}
}
}

#############################################################################
## Procedure:  ::database_view::dataTable

namespace eval ::database_view {
proc dataTable {w} {
return $w.not81.fpage2.scr79.f.tab80
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
    foreach {cmd name newname} [lrange $args 0 2] {}
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
## Library Procedure:  ::vTcl::widgets::bwidgets::scrollchildsite::widgetProc

namespace eval ::vTcl::widgets::bwidgets::scrollchildsite {
proc widgetProc {w args} {
        set command [lindex $args 0]
        set args [lrange $args 1 end]
        set children [winfo children $w]
        set child [lindex $children 0]

        ## we have renamed the default widgetProc _<widgetpath>
        if {$command == "configure" && $args == ""} {
            if {$children == ""} {
                return [concat [uplevel _$w configure]  [list {-xscrollcommand xScrollCommand ScrollCommand {} {}}]  [list {-yscrollcommand yScrollCommand ScrollCommand {} {}}]]
            } else {
                return [concat [uplevel _$w configure]  [list [$child configure -xscrollcommand]]  [list [$child configure -yscrollcommand]]]
            }
        } elseif {$command == "configure" && [llength $args] > 1} {
            return [uplevel $child configure $args]
        } elseif {[string match ?view $command]} {
            return [uplevel $child $command $args]
        }

        uplevel _$w $command $args
    }
}
#############################################################################
## Library Procedure:  vTcl::widgets::bwidgets::scrolledwindow::createCmd

namespace eval vTcl::widgets::bwidgets::scrolledwindow {
proc createCmd {target args} {
        eval ScrolledWindow $target $args
        ## create a frame where user can insert widget to scroll
        frame $target.f -class ScrollChildsite

        ## change the widget procedure
        rename ::$target.f ::_$target.f
        proc ::$target.f {command args}  "eval ::vTcl::widgets::bwidgets::scrollchildsite::widgetProc $target.f \$command \$args"
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
            innerWidget {
                return $w.cmpd
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
            foreach {varname value} $args {}
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

    set command [lindex $args 0]
    set args [lrange $args 1 end]
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
    set base .top79
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 1
    }
    namespace eval ::widgets::$base.com80 {
        array set save {-class 1 -compoundClass 1}
    }
    namespace eval ::widgets::$base.but81 {
        array set save {-command 1 -pady 1 -text 1}
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
            {user {Database View}}
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
    wm geometry $top 200x200+66+75; update
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

proc vTclWindow.top79 {base} {
    if {$base == ""} {
        set base .top79
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
    wm geometry $top 433x366+350+212; update
    wm maxsize $top 1284 1006
    wm minsize $top 111 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm deiconify $top
    wm title $top "Database Viewer MegaWidget Test"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    vTcl::widgets::core::compoundcontainer::createCmd $top.com80 \
        -compoundClass {Database View} 
    vTcl:DefineAlias "$top.com80" "CompoundContainer1" vTcl::widgets::core::compoundcontainer::widgetProc "Toplevel1" 1
    $top.com80.cmpd widget configure \
        
    button $top.but81 \
        \
        -command {## open a small test database provided as an example
## doesn't hurt to close if not already open
CompoundContainer1 widget close
CompoundContainer1 widget open test.mk} \
        -pady 0 -text {Test Now!} 
    vTcl:DefineAlias "$top.but81" "Button1" vTcl:WidgetProc "Toplevel1" 1
    ###################
    # SETTING GEOMETRY
    ###################
    pack $top.com80 \
        -in $top -anchor center -expand 1 -fill both -side top 
    pack $top.but81 \
        -in $top -anchor center -expand 0 -fill none -padx 5 -pady 5 \
        -side top 

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
Window show .top79

main $argc $argv

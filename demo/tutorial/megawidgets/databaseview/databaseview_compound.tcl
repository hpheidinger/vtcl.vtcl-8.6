#############################################################################
# Visual Tcl v1.60 Compound Library
#
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


proc bindtagsCmd {} {}


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


proc vTcl:DefineAlias {target alias args} {
    if {![info exists ::vTcl(running)]} {
        return [eval ::vTcl:DefineAlias $target $alias $args]
    }
    set class [vTcl:get_class $target]
    vTcl:set_alias $target [vTcl:next_widget_name $class $target $alias] -noupdate
}


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


namespace eval {vTcl::compounds::user::{My Widget}} {

set bindtags {}

set source .top82.cpd83

set class MegaWidget

set procs {
    ::myWidget::myWidgetProc
}


proc bindtagsCmd {} {}


proc infoCmd {target} {
    namespace eval ::widgets::$target {
        array set save {-class 1 -widgetProc 1}
    }
    set site_3_0 $target
    namespace eval ::widgets::$site_3_0.but84 {
        array set save {-pady 1 -text 1}
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
    set items [split $target .]
    set parent [join [lrange $items 0 end-1] .]
    set top [winfo toplevel $parent]
    vTcl::widgets::core::megawidget::createCmd $target  -widgetProc ::myWidget::myWidgetProc 
    vTcl:DefineAlias "$target" "MegaWidget1" vTcl::widgets::core::megawidget::widgetProc "Toplevel1" 1
    set site_3_0 $target
    button $site_3_0.but84  -pady 0 -text {Hello World!} 
    vTcl:DefineAlias "$site_3_0.but84" "Button1" vTcl:WidgetProc "Toplevel1" 1
    place $site_3_0.but84  -x 47 -y 25 -anchor nw -bordermode ignore 

}


proc procsCmd {} {
#############################################################################
## Procedure:  ::myWidget::myWidgetProc

namespace eval ::myWidget {
proc myWidgetProc {w args} {
set command [lindex $args 0]
set args [lrange $args 1 end]

if {$command == "configure"} {
    foreach {option value} $args {
        if {$option == "-text" ||
            $option == "-command"} {
            $w.but84 configure $option $value
        }
    }
} elseif {$command == "doSomething"} {
    tk_messageBox -message "Do Something $args!"
}
}
}

}

}



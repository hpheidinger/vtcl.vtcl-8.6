# ------------------------------------------------------------------------------
#  label.tcl
#  This file is part of Unifix BWidget Toolkit
#  $Id: label.tcl,v 1.1 2001/07/24 17:07:56 damonc Exp $
# ------------------------------------------------------------------------------
#  Index of commands:
#     - BWLabel::create
#     - BWLabel::configure
#     - BWLabel::cget
#     - BWLabel::setfocus
#     - BWLabel::_drag_cmd
#     - BWLabel::_drop_cmd
#     - BWLabel::_over_cmd
# ------------------------------------------------------------------------------

namespace eval BWLabel {
    Widget::tkinclude BWLabel label .l \
        remove {-foreground -text -textvariable -underline}

    Widget::declare BWLabel {
        {-name               String     "" 0}
        {-text               String     "" 0}
        {-textvariable       String     "" 0}
        {-underline          Int        -1 0 "%d >= -1"}
        {-focus              String     "" 0}
        {-foreground         TkResource "" 0 label}
        {-disabledforeground TkResource "" 0 button}
        {-state              Enum       normal 0  {normal disabled}}
        {-fg                 Synonym    -foreground}

    }
    DynamicHelp::include BWLabel balloon
    DragSite::include    BWLabel "" 1
    DropSite::include    BWLabel {
        TEXT    {move {}}
        IMAGE   {move {}}
        BITMAP  {move {}}
        FGCOLOR {move {}}
        BGCOLOR {move {}}
        COLOR   {move {}}
    }

    Widget::syncoptions BWLabel "" .l {-text {} -underline {}}

    proc ::Label { path args } { return [eval BWLabel::create $path $args] }
    proc use {} {}

    bind BwLabel <FocusIn> {BWLabel::setfocus %W}
}


# ------------------------------------------------------------------------------
#  Command BWLabel::create
# ------------------------------------------------------------------------------
proc BWLabel::create { path args } {
    array set maps [list BWLabel {} .l {}]
    array set maps [Widget::parseArgs BWLabel $args]
    frame $path -class BWLabel -borderwidth 0 -highlightthickness 0 -relief flat
    Widget::initFromODB BWLabel $path $maps(BWLabel)

    bind real${path} <Destroy> {Widget::destroy %W; rename %W {}}
    eval label $path.l $maps(.l)

    if { [Widget::cget $path -state] == "normal" } {
        set fg [Widget::cget $path -foreground]
    } else {
        set fg [Widget::cget $path -disabledforeground]
    }

    set var [Widget::cget $path -textvariable]
    if {  $var == "" &&
          [Widget::cget $path -image] == "" &&
          [Widget::cget $path -bitmap] == ""} {
        set desc [BWidget::getname [Widget::cget $path -name]]
        if { $desc != "" } {
            set text  [lindex $desc 0]
            set under [lindex $desc 1]
        } else {
            set text  [Widget::cget $path -text]
            set under [Widget::cget $path -underline]
        }
    } else {
        set under -1
        set text  ""
    }

    $path.l configure -text $text -textvariable $var \
	    -underline $under -foreground $fg

    set accel [string tolower [string index $text $under]]
    if { $accel != "" } {
        bind [winfo toplevel $path] <Alt-$accel> "BWLabel::setfocus $path"
    }

    bindtags $path.l [list $path.l $path Label [winfo toplevel $path] all]
    bindtags $path [list real${path} BwLabel [winfo toplevel $path] all]
    pack $path.l -expand yes -fill both

    DragSite::setdrag $path $path.l BWLabel::_init_drag_cmd [Widget::cget $path -dragendcmd] 1
    DropSite::setdrop $path $path.l BWLabel::_over_cmd BWLabel::_drop_cmd 1
    DynamicHelp::sethelp $path $path.l 1

    rename $path ::$path:cmd
    proc ::$path { cmd args } "return \[eval BWLabel::\$cmd $path \$args\]"

    return $path
}


# ------------------------------------------------------------------------------
#  Command BWLabel::configure
# ------------------------------------------------------------------------------
proc BWLabel::configure { path args } {
    set oldunder [$path.l cget -underline]
    if { $oldunder != -1 } {
        set oldaccel [string tolower [string index [$path.l cget -text] $oldunder]]
    } else {
        set oldaccel ""
    }
    set res [Widget::configure $path $args]

    set cfg  [Widget::hasChanged $path -foreground fg]
    set cdfg [Widget::hasChanged $path -disabledforeground dfg]
    set cst  [Widget::hasChanged $path -state state]

    if { $cst || $cfg || $cdfg } {
        if { $state == "normal" } {
            $path.l configure -fg $fg
        } else {
            $path.l configure -fg $dfg
        }
    }

    set cv [Widget::hasChanged $path -textvariable var]
    set cb [Widget::hasChanged $path -image img]
    set ci [Widget::hasChanged $path -bitmap bmp]
    set cn [Widget::hasChanged $path -name name]
    set ct [Widget::hasChanged $path -text text]
    set cu [Widget::hasChanged $path -underline under]

    if { $cv || $cb || $ci || $cn || $ct || $cu } {
        if {  $var == "" && $img == "" && $bmp == "" } {
            set desc [BWidget::getname $name]
            if { $desc != "" } {
                set text  [lindex $desc 0]
                set under [lindex $desc 1]
            }
        } else {
            set under -1
            set text  ""
        }
        set top [winfo toplevel $path]
        if { $oldaccel != "" } {
            bind $top <Alt-$oldaccel> {}
        }
        set accel [string tolower [string index $text $under]]
        if { $accel != "" } {
            bind $top <Alt-$accel> "BWLabel::setfocus $path"
        }
        $path.l configure -text $text -underline $under -textvariable $var
    }

    set force [Widget::hasChanged $path -dragendcmd dragend]
    DragSite::setdrag $path $path.l BWLabel::_init_drag_cmd $dragend $force
    DropSite::setdrop $path $path.l BWLabel::_over_cmd BWLabel::_drop_cmd
    DynamicHelp::sethelp $path $path

    return $res
}


# ------------------------------------------------------------------------------
#  Command BWLabel::cget
# ------------------------------------------------------------------------------
proc BWLabel::cget { path option } {
    return [Widget::cget $path $option]
}


# ------------------------------------------------------------------------------
#  Command BWLabel::setfocus
# ------------------------------------------------------------------------------
proc BWLabel::setfocus { path } {
    if { ![string compare [Widget::cget $path -state] "normal"] } {
        set w [Widget::cget $path -focus]
        if { [winfo exists $w] && [Widget::focusOK $w] } {
            focus $w
        }
    }
}


# ------------------------------------------------------------------------------
#  Command BWLabel::_init_drag_cmd
# ------------------------------------------------------------------------------
proc BWLabel::_init_drag_cmd { path X Y top } {
    set path [winfo parent $path]
    if { [set cmd [Widget::cget $path -draginitcmd]] != "" } {
        return [uplevel \#0 $cmd [list $path $X $Y $top]]
    }
    if { [set data [$path.l cget -image]] != "" } {
        set type "IMAGE"
        pack [label $top.l -image $data]
    } elseif { [set data [$path.l cget -bitmap]] != "" } {
        set type "BITMAP"
        pack [label $top.l -bitmap $data]
    } else {
        set data [$path.l cget -text]
        set type "TEXT"
    }
    set usertype [Widget::getoption $path -dragtype]
    if { $usertype != "" } {
        set type $usertype
    }
    return [list $type {copy} $data]
}


# ------------------------------------------------------------------------------
#  Command BWLabel::_drop_cmd
# ------------------------------------------------------------------------------
proc BWLabel::_drop_cmd { path source X Y op type data } {
    set path [winfo parent $path]
    if { [set cmd [Widget::cget $path -dropcmd]] != "" } {
        return [uplevel \#0 $cmd [list $path $source $X $Y $op $type $data]]
    }
    if { $type == "COLOR" || $type == "FGCOLOR" } {
        configure $path -foreground $data
    } elseif { $type == "BGCOLOR" } {
        configure $path -background $data
    } else {
        set text   ""
        set image  ""
        set bitmap ""
        switch -- $type {
            IMAGE   {set image $data}
            BITMAP  {set bitmap $data}
            default {
                set text $data
                if { [set var [$path.l cget -textvariable]] != "" } {
                    configure $path -image "" -bitmap ""
                    GlobalVar::setvar $var $data
                    return
                }
            }
        }
        configure $path -text $text -image $image -bitmap $bitmap
    }
    return 1
}


# ------------------------------------------------------------------------------
#  Command BWLabel::_over_cmd
# ------------------------------------------------------------------------------
proc BWLabel::_over_cmd { path source event X Y op type data } {
    set path [winfo parent $path]
    if { [set cmd [Widget::cget $path -dropovercmd]] != "" } {
        return [uplevel \#0 $cmd [list $path $source $event $X $Y $op $type $data]]
    }
    if { [Widget::getoption $path -state] == "normal" ||
         $type == "COLOR" || $type == "FGCOLOR" || $type == "BGCOLOR" } {
        DropSite::setcursor based_arrow_down
        return 1
    }
    DropSite::setcursor dot
    return 0
}

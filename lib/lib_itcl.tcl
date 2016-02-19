##############################################################################
#
# lib_itcl.tcl - itcl widget support library
#
# Copyright (C) 1996-1998 Stewart Allen
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
##############################################################################

# Architecture by Stewart Allen
# Implementation by James Kramer using ideas from
#   Kenneth H. Cox <kcox@senteinc.com>
#
# Maintained by Christian Gavin:
#   added support for more widgets
#   added support for new image/font managers
#   made sure children are not dumped and not viewed in the widget tree
#
# Initializes this library
#

proc vTcl:lib_itcl:init {} {
    global vTcl

    if {[catch {
        package require itcl
        package require itk
        package require iwidgets
    } errorText]} {
        vTcl:log $errorText
        lappend vTcl(libNames) \
            {(not detected) Incr Tcl/Tk MegaWidgets Support Library}
        return 0
    }
    lappend vTcl(libNames) {Incr Tcl/Tk MegaWidgets Support Library}
    return 1
}

proc vTcl:widget:lib:lib_itcl {args} {
    global vTcl

    # Setup required variables
    vTcl:lib_itcl:setup

    append vTcl(head,itcl,importheader) {
    # Needs Itcl
    package require itcl

    # Needs Itk
    package require itk

    # Needs Iwidgets
    package require iwidgets

    switch $tcl_platform(platform) {
	windows {
            option add *Pushbutton.padY         0
	}
	default {
	    option add *Scrolledhtml.sbWidth    10
	    option add *Scrolledtext.sbWidth    10
	    option add *Scrolledlistbox.sbWidth 10
	    option add *Scrolledframe.sbWidth   10
	    option add *Hierarchy.sbWidth       10
            option add *Pushbutton.padY         2
        }
    }
    }

    set order {Entryfield Spinint Spintime Combobox Scrolledlistbox Calendar
               Dateentry Scrolledhtml Toolbar Feedback Optionmenu
               Hierarchy Buttonbox Checkbox Radiobox Labeledframe
               Notebook Tabnotebook Panedwindow Scrolledtext Scrolledcanvas
               Scrolledframe}

    ## avoid conflicts with Tk 8.4
    if {[info tclversion] >= 8.4} {
        ::vTcl::lremove order Panedwindow
    }

    vTcl:lib:add_widgets_to_toolbar $order Incr  "Incr Widgets"

    lappend vTcl(proc,ignore) "::iwidgets::*"

    foreach cmd [string tolower $order] {
        lappend vTcl(proc,ignore) "$cmd"
    }

    button .tmp
    set defaultBackground [lindex [.tmp configure -background] 3]
    option add *Checkbox.background $defaultBackground
    option add *Radiobox.background $defaultBackground
    option add *Buttonbox.background $defaultBackground
    destroy .tmp
}

proc vTcl:lib_itcl:setup {} {
    global vTcl tcl_platform

    #
    # additional attributes to set on insert
    #
    set vTcl(scrolledlistbox,insert)    "-labeltext {Label:} "
    set vTcl(combobox,insert)           "-labeltext {Label:} "
    set vTcl(entryfield,insert)         "-labeltext {Label:} "
    set vTcl(spinint,insert)            "-labeltext {Label:} -range {0 10} -step 1"
    set vTcl(calendar,insert)           ""
    set vTcl(dateentry,insert)	        "-labeltext {Selected date:}"
    set vTcl(scrolledhtml,insert)       ""
    set vTcl(toolbar,insert)            ""
    set vTcl(feedback,insert)           "-labeltext {Percent complete:}"
    set vTcl(optionmenu,insert)         "-labeltext {Select option:}"
    set vTcl(hierarchy,insert)          ""
    set vTcl(panedwindow,insert)        ""
    set vTcl(scrolledtext,insert)       ""

    TranslateOption    -textfont vTcl:font:translate
    NoEncaseOption     -textfont 1

    TranslateOption    -balloonfont vTcl:font:translate
    NoEncaseOption     -balloonfont 1

    TranslateOption    -labelfont vTcl:font:translate
    NoEncaseOption     -labelfont 1

    ## under Windows, we want to use the default values
    switch $tcl_platform(platform) {
        windows {
            option add *Pushbutton.padY         0
        }
        default {
            option add *Scrolledhtml.sbWidth    10
            option add *Scrolledtext.sbWidth    10
            option add *Scrolledlistbox.sbWidth 10
	    option add *Scrolledframe.sbWidth   10
            option add *Hierarchy.sbWidth       10
            option add *Pushbutton.padY         2
        }
    }

    # hum... this is not too clean, but the hierarchy widget creates
    # icons on the fly
    #
    # in brief, the hierarchy widget does not know about the following images:
    #    openFolder
    #    closedFolder
    #    nodeFolder
    #
    # unless their respective options -openFolder,-closedFolder,-nodeFolder
    # haven't been specified while creating a hierarchy widget in which case
    # Iwidgets creates them
    #
    # this creates problems while sourcing a Iwidgets project in vTcl
}

# Utility proc.  Dump a megawidget's children, but not those that are
# part of the megawidget itself.  Differs from vTcl:dump:widgets in that
# it dumps the geometry of $subwidget, but it doesn't dump $subwidget
# itself (`vTcl:dump:widgets $subwidget' doesn't do the right thing if
# the grid geometry manager is used to manage children of $subwidget.
proc vTcl:lib_itcl:dump_subwidgets {subwidget {sitebasename {}}} {
    global vTcl basenames classes
    set output ""
    set geometry ""
    set widget_tree [vTcl:get_children $subwidget]
    set length      [string length $subwidget]
    set basenames($subwidget) $sitebasename

    foreach i $widget_tree {

        set basename [vTcl:base_name $i]

        # don't try to dump subwidget itself
        if {"$i" != "$subwidget"} {
            set basenames($i) $basename
            set class [vTcl:get_class $i]
            append output [$classes($class,dumpCmd) $i $basename]
            append geometry [vTcl:dump_widget_geom $i $basename]
            catch {unset basenames($i)}
        }
    }

    ## don't forget to dump grid geometry though
    append geometry [vTcl:dump_grid_geom $subwidget $sitebasename]

    append output $geometry

    catch {unset basenames($subwidget)}
    return $output
}

proc vTcl:lib_itcl:tagscmd {target} {
    global vTcl

    # workaround for special binding tags in IWidgets
    set tags $vTcl(bindtags,$target)
    set special [lsearch -glob $tags itk-delete-*]

    set class [winfo class $target]
    set toplevel [winfo toplevel $target]

    if {$special == -1} {
        return [list $target $class $toplevel all]
    } else {
        return [list [lindex $tags $special] $target $class $toplevel all]
    }
}

###########################################################
## Code for displaying a combo box with the list of
## radio/check boxes in the attributes editor
##
namespace eval vTcl::widgets::iwidgets::boxes {

    proc get_pages {target} {
    }

    proc update_pages {target var} {
        ## there is a trace on var to update the combobox
        ## first item in the list is the current index
        set last -1
        catch {set last [$target index end]}
        set values 0
        for {set i 0} {$i <= $last} {incr i} {
            set labelOption [$target buttonconfigure $i -text]
            lappend values [lindex $labelOption 4]
        }

        ## this will trigger the trace
        set ::$var $values
    }

    proc config_pages {target var} {
    }

    proc select_page {target index} {
    }

    proc getOptions {target opts} {
        set result {}
        set last -1
        catch {set last [$target index end]}
        for {set i 0} {$i <= $last} {incr i} {
            foreach opt $opts {
                set value [lindex [$target buttonconfigure $i $opt] 4]
                if {$value != ""} {
                    lappend result $value
                }
            }
        }
        return $result
    }

    proc getImagesCmd {target} {
        switch [vTcl:get_class $target] {
        Radiobox - Checkbox {
            set opts {-image -selectimage}
        }
        default {
            set opts -image
        }
        }
        return [getOptions $target $opts]
    }

    proc getFontsCmd {target} {
        return [getOptions $target -font]
    }

    proc setDefaultValues {target opts} {
        set last -1
        catch {set last [$target index end]}
        for {set i 0} {$i <= $last} {incr i} {
            foreach opt $opts {
                set default [lindex [$target buttonconfigure $i $opt] 3]
                $target buttonconfigure $i $opt $default
            }
        }
    }
}

###########################################################
## Editing radioboxes/checkboxes
##
namespace eval vTcl::widgets::iwidgets::boxes::edit {

    variable counter 0

    proc getTitle {target} {
        return "Edit boxes for $target"
    }

    proc getLabelOption {} {
        return -text
    }

    proc getItems {target} {
        ## first item in the list is the current index
        set last -1
        catch {set last [$target index end]}
        set values 0
        for {set i 0} {$i <= $last} {incr i} {
            set labelOption [$target buttonconfigure $i -text]
            lappend values [lindex $labelOption 4]
        }
        return $values
    }

    proc addItem {target} {
        variable counter
        incr counter
        $target add tag_$counter -text "New Box"
        if {$::vTcl(w,widget) == $target} {
            vTcl:place_handles $target
        }
        return "New Box"
    }

    proc removeItem {target index} {
        $target delete $index
        if {$::vTcl(w,widget) == $target} {
            vTcl:place_handles $target
        }
    }

    proc itemConfigure {target index args} {
        if {$args == ""} {
            set options [$target buttonconfigure $index]
            set result ""
            foreach option $options {
                ## only return valid options
                if {[llength $option] == 5} {
                    lappend result $option
                }
            }
            return $result
        } else {
            eval $target buttonconfigure $index $args
        }
    }

    proc moveUpOrDown {target index direction} {
        error "Not implemented yet!"
    }
}

###########################################################
## Code for displaying a combo box with pages in the
## attributes editor
##
proc vTcl:lib_itcl:get_pages {target} {
}

proc vTcl:lib_itcl:update_pages {target var} {
    ## there is a trace on var to update the combobox
    ## first item in the list is the current index
    set sites [$target childsite]
    set current [$target index select]
    set num_pages [llength $sites]
    set values $current
    for {set i 0} {$i < $num_pages} {incr i} {
        set label_opt [$target pageconfigure $i -label]
        lappend values [lindex $label_opt 4]
    }

    ## this will trigger the trace
    set ::$var $values
}

proc vTcl:lib_itcl:config_pages {target var} {
}

proc vTcl:lib_itcl:select_page {target index} {
    $target select $index
}

###########################################################
## Code for editing pages in tabnotebook & notebook widgets
##
namespace eval vTcl::widgets::iwidgets::notebooks::edit {

    proc saveBkgnd {w} {
        namespace eval ::widgets::${w}::options {}
        namespace eval ::widgets::${w}::save    {}
        vTcl:WidgetVar $w options
        vTcl:WidgetVar $w save
	set value [$w cget -background]
        set options(-background) $value
	set save(-background) 1
    }

    proc getTitle {target} {
        return "Edit pages for $target"
    }

    proc getLabelOption {} {
        return -label
    }

    proc getItems {target} {
        ## first item in the list is the current index
        set sites [$target childsite]
        set current [$target index select]
        if {$current == -1} {
            set current 0
        }
        set values $current
        for {set i 0} {$i < [llength $sites]} {incr i} {
            set labelOption [$target pageconfigure $i -label]
            lappend values [lindex $labelOption 4]
        }
        return $values
    }

    proc addItem {target} {
        $target add -label "New Page"
        $target select end
        vTcl:init_wtree
	set page [lindex [$target childsite] end]
        saveBkgnd $page

        return "New Page"
    }

    proc removeItem {target index} {
        $target delete $index
        vTcl:init_wtree
    }

    proc itemConfigure {target index args} {
        if {$args == ""} {
            set options [$target pageconfigure $index]
            set result ""
            foreach option $options {
                ## only return valid options
                if {[llength $option] == 5} {
                    lappend result $option
                }
            }
            return $result
        } else {
            eval $target pageconfigure $index $args
        }
    }

    proc moveUpOrDown {target index direction} {
        error "Not implemented yet!"
    }
}




##############################################################################
#
# lib_tix.tcl - tix widget support library
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
# Architecture by Stewart Allen
# Implementation by Kenneth H. Cox <kcox@senteinc.com>

proc vTcl:widget:lib:lib_tix {args} {
    global vTcl

    # Setup required variables
    vTcl:lib_tix:setup

    set order {
	TixNoteBook
	TixLabelFrame
	TixComboBox
	TixMeter
	TixFileEntry
	TixLabelEntry
	TixScrolledHList
	TixScrolledListBox
	TixSelect
	TixPanedWindow
	TixOptionMenu
    }

    vTcl:lib:add_widgets_to_toolbar $order tix "Tix Widgets"

    append vTcl(head,tix,importheader) {
    # Tix is required
    package require Tix
    }
}


##############################################################################
#
# this modified version of the "option" command ignores all
# changes to the option database except for "Tix" options

proc vTcl:lib_tix:ignore_option {cmd args} {

    if {"$cmd" != "add"} {
	return [eval _option $cmd $args]
    }

    set pattern  [lindex $args 0]

    # only add Tix options
    if [string match *Tix* $pattern] {
	# puts "option $cmd $args"
	return [eval _option $cmd $args]
    }
}

##############################################################################
#
# Now I'm _really_ going out of my way to undo the screwing up of the
# option DB that Tix does.  I rename the "option" command, and interpose
# my own vTcl:lib_tix:monitor_option which tones down the damage that Tix
# does by turning
#
# '*TixLabelFrame*Label.font'
#
# into
#
# '*TixLabelFrame.Label.font'
#
proc vTcl:lib_tix:monitor_option {cmd args} {

    #puts "lib_tix:monitor_option:$cmd $args:"
    if {"$cmd" != "add"} {
	return [eval _option $cmd $args]
    }

    #puts "option $cmd $args"

    set pattern  [lindex $args 0]
    set value    [lindex $args 1]
    set priority [lindex $args 2]

    # if this is a Tix option, change all '*'s (except the first) with
    # '.'s otherwise they screw up everything!
    #puts "pattern:$pattern:"

    if {[string match {\*Tix*} $pattern]} {
	#puts "\twas: $pattern"
	regsub {(.)\*} $pattern {\1.} pattern
	#puts "\tis:  $pattern"
    }

    if {"$priority" == ""} {
	_option add $pattern $value
    } else {
	_option add $pattern $value $priority
    }
}

#
# Initializes this library
#
proc vTcl:lib_tix:init {} {
    global vTcl

    rename option _option
    rename vTcl:lib_tix:ignore_option option

    if {[catch {package require Tix} erg]} {
	lappend vTcl(libNames) {(not detected) Tix Widget Support Library}
	puts $erg
	rename option vTcl:lib_tix:ignore_option
	rename _option option
	return 0
    }

    rename option vTcl:lib_tix:ignore_option
    rename vTcl:lib_tix:monitor_option option

    lappend vTcl(libNames) {Tix Widget Support Library}
    return 1
}

#
# move variable setup into proc so "sourcing" doesn't
# install them.
#
proc vTcl:lib_tix:setup {} {
    global vTcl

    ## Preferences
    set vTcl(tixPref,dump_colors) 0 ;# if 0, don't save -background, etc.

    ## Add to procedure, var, bind regular expressions
    if {[lempty $vTcl(bind,ignore)]} {
	append vTcl(bind,ignore) "tix"
    } else {
	append vTcl(bind,ignore) "|tix"
    }

    lappend vTcl(proc,ignore) "tix*"
    append vTcl(var,ignore)  "|tix"
}

proc vTcl:dump:TixLabelEntry {target basename} {
    global vTcl
    set output [vTcl:lib_tix:dump_widget_opt $target $basename]
    return $output
}

proc vTcl:dump:TixSelect {target basename} {
    global vTcl
    set result [vTcl:lib_tix:dump_widget_opt $target $basename]
    foreach button [$target subwidgets -class Button] {
	set conf [list \
		[$button configure -bitmap] \
		[$button configure -image]]
	set pairs [vTcl:conf_to_pairs $conf ""]
	set button_name [string range $button \
		[expr 1 + [string last . $button]] end]
	append result "$vTcl(tab)$basename add $button_name \\\n"
	append result "[vTcl:clean_pairs $pairs]\n"
    }
    # Destroy unused label subwidget, but not while running in vTcl.
    if {"[$target cget -label]" == ""} {
	append result "$vTcl(tab)# destroy unused label subwidget\n"
	append result "$vTcl(tab)global vTcl\n"
	append result "$vTcl(tab)if \{!\[info exists vTcl\]\} \{destroy \[$basename subwidget label\]\}\n"
    }
    return $result
}

# Utility proc.  Dump a megawidget's children, but not those that are
# part of the megawidget itself.  Differs from vTcl:dump:widgets in that
# it dumps the geometry of $subwidget, but it doesn't dump $subwidget
# itself (`vTcl:dump:widgets $subwidget' doesn't do the right thing if
# the grid geometry manager is used to manage children of $subwidget.
proc vTcl:lib_tix:dump_subwidgets {subwidget {sitebasename {}}} {
    global vTcl basenames classes
    set output ""
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
	    catch {unset basenames($i)}
	}
	append output [vTcl:dump_widget_geom $i $basename]
    }

    catch {unset basenames($subwidget)}
    return $output
}

# Utility proc.  Ignore color options (-background, etc.) based on
# preference.
#
# returns:
#   1 means save the option
#   0 means don't save it
proc vTcl:lib_tix:save_option {opt} {
    global vTcl tix_library
    # never save -bitmap options on tix widgets; they are always
    # hard-coded to the tix library directory
    if [string match *${tix_library}* $opt] {
	#puts "kc:save_option:ignoring $opt"
	return 0
    } elseif {$vTcl(tixPref,dump_colors) == 0 \
	    && [regexp -- {^-(.*background|.*foreground|.*color|font) } $opt]} {
	#puts "kc:save_option:ignoring $opt"
	return 0
    } else {
	return 1
    }
}

# Utility proc.  Dump a tix widget.
# Differs from vTcl:dump_widget_opt in that it tries harder to avoid
# dumping options that shouldn't really be dumped, e.g. -fg,-bg,-font.
proc vTcl:lib_tix:dump_widget_opt {target basename} {
    global vTcl
    set result ""
    set class [vTcl:get_class $target]
    set result "$vTcl(tab)[vTcl:lower_first $class] $basename"
    set opt [$target conf]
    set keep_opt ""
    foreach e $opt {
	if [vTcl:lib_tix:save_option $e] {
	    lappend keep_opt $e
	}
    }
    set p [vTcl:get_opts $keep_opt]
    if {$p != ""} {
	append result " \\\n[vTcl:clean_pairs $p]\n"
    } else {
	append result "\n"
    }
    append result [vTcl:dump_widget_bind $target $basename]
    return $result
}


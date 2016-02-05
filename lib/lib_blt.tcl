##############################################################################
#
# lib_blt.tcl - blt widget support library
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
# Implementation by James Kramer usinge ideas from
# Kenneth H. Cox <kcox@senteinc.com>

proc vTcl:lib_blt:init {} {
    global vTcl

    if {[catch {package require BLT} error]} {
        lappend vTcl(libNames) {(not detected) BLT Widgets Support Library}
	return 0
    }
    lappend vTcl(libNames) {BLT Widgets Support Library}
    return 1
}

proc vTcl:widget:lib:lib_blt {args} {
    global vTcl

    set order {
	Graph
	Hierbox
	Barchart
	Stripchart
      Tabset
    }

    vTcl:lib:add_widgets_to_toolbar $order BLT "BLT Widgets"

    append vTcl(head,blt,importheader) {
    # BLT is needed
    package require BLT
    }

    IgnoreProc "::blt::*"
}

namespace eval vTcl::widgets::blt {

    ## Utility proc.  Dump a megawidget's children, but not those that are
    ## part of the megawidget itself.  Differs from vTcl:dump:widgets in that
    ## it dumps the geometry of $subwidget, but it doesn't dump $subwidget
    ## itself (`vTcl:dump:widgets $subwidget' doesn't do the right thing if
    ## the grid geometry manager is used to manage children of $subwidget.
    proc dump_subwidgets {subwidget {sitebasename {}}} {
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
        append output $geometry

        catch {unset basenames($subwidget)}
        return $output
    }

    proc pathTranslate {value} {
        if [regexp {((\.[a-zA-Z0-9_]+)+)} $value matchAll path] {
            set path [vTcl:base_name $path]
            return "\"$path\""
        }
        return $value
    }
}

TranslateOption    -window vTcl::widgets::blt::pathTranslate
NoEncaseOption     -window 1
NoEncaseOptionWhen -window vTcl:core:noencasewhen



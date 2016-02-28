##############################################################################
# $Id: color.tcl,v 1.8 2001/11/30 04:22:49 cgavin Exp $
#
# color.tcl - color browser
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

##############################################################################
#

proc vTcl:get_color {color w} {

    # apparently Iwidgets 3.0 returns screwed up colors
    #
    # tk_chooseColor accepts the following:
    # #RGB	   (4 chars)
    # #RRGGBB	(7 chars)
    # #RRRGGGBBB     (10 chars)
    # #RRRRGGGGBBBB  (13 chars)

    if {[string length $color] == 11} {

    	set extend [string range $color 10 10]
    	set color $color$extend$extend

    	vTcl:log "Fixed color: $color"

    } else {

	if {[string length $color] == 9} {

 	   	set extend [string range $color 8 8]
  	  	set color $color$extend$extend$extend$extend

   	 	vTcl:log "Fixed color: $color"
    	}
    }

    global vTcl tk_version
    set oldcolor $color

    if {$color == ""} {
	set color white
    }
    set newcolor [SelectColor::menu [winfo toplevel $w].color [list below $w] -color $color]

    if {$newcolor != ""} {
	return $newcolor
    } else {
	return $oldcolor
    }
}

proc vTcl:show_color {widget option variable w} {
global vTcl
    set vTcl(color,widget)   $widget
    set vTcl(color,option)   $option
    set vTcl(color,variable) $variable
    set color [vTcl:at $variable]
    if {$color == ""} {
	set color "#000000"
    } elseif {[string range $color 0 0] != "#" } {
	set clist [winfo rgb . $color]
	set r [lindex $clist 0]
	set g [lindex $clist 1]
	set b [lindex $clist 2]
	set color "#[vTcl:hex $r][vTcl:hex $g][vTcl:hex $b]"
    }
    set vTcl(color) [vTcl:get_color $color $w]
    set $vTcl(color,variable) $vTcl(color)
    $vTcl(color,widget) configure -bg $vTcl(color)
    $vTcl(w,widget) configure $vTcl(color,option) $vTcl(color)
}

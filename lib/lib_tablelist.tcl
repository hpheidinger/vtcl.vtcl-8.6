##############################################################################
# $ $
#
# lib_tablelist.tcl  Tablelist package support library
#
# Copyright (C) 2002 Christian Gavin
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

proc vTcl:lib_tablelist:init {} {
    global vTcl

    if {[catch {package require tablelist} erg]} {
	lappend vTcl(libNames) {(not detected) tablelist Widget Support Library}
	return 0
    }

    lappend vTcl(libNames) {tablelist Widget Support Library}
    return 1
}

proc vTcl:widget:lib:lib_tablelist {args} {
    global vTcl

    set order { Tablelist }

    vTcl:lib:add_widgets_to_toolbar $order TableList "Tablelist widget"

    append vTcl(head,tablelist,importheader) {
	# tablelist is required
	package require tablelist
    }
}


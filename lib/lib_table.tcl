##############################################################################
# $Id: lib_table.tcl,v 1.7 2005/12/05 06:58:31 kenparkerjr Exp $
#
# lib_vtcl.tcl - vTcl tcl/tk widget support library
#
# Copyright (C) 1996-1998 Damon Courtney
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

proc vTcl:lib_table:init {} {
    global vTcl

    if {[catch {package require Tktable} erg]} {
        lappend vTcl(libNames) {(not detected) tkTable Widgets Support Library}
        return 0
    }

    lappend vTcl(libNames) {tkTable Widgets Support Library}
    return 1
}

proc vTcl:widget:lib:lib_table {args} {
    global vTcl

    set order { Table }

    vTcl:lib:add_widgets_to_toolbar $order TkTable "TkTable widget"

    append vTcl(head,TkTable,importheader) {
        # Check if Tktable is available
        if {[lsearch -exact $packageNames Tktable] != -1} {
            package require Tktable
        }
    }
}


##############################################################################
# $Id: lib_vtcl.tcl,v 1.14 2005/12/05 06:58:31 kenparkerjr Exp $
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

#
# initializes this library
#
proc vTcl:lib_vtcl:init {} {
    global vTcl

    lappend vTcl(libNames) "Visual Tcl Widget Library"
    return 1
}

proc vTcl:widget:lib:lib_vtcl {args} {
    set order {
	Progressbar1
	Combobox2
	Mclistbox
    }

    vTcl:lib:add_widgets_to_toolbar $order misc  "vTcl misc widgets"

    global vTcl
    lappend vTcl(proc,ignore) "::progressbar::Trace*"
}


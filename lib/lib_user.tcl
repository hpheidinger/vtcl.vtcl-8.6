##############################################################################
# $Id: lib_user.tcl,v 1.7 2005/12/05 06:58:31 kenparkerjr Exp $
#
# lib_user.tcl - User-defined tcl/tk widget support library
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

proc vTcl:lib_user:init {} {
    return 1
}

proc vTcl:widget:lib:lib_user {args} {
    global vTcl widgets classes

    if {![info exists vTcl(lib_user,classes)]} { return }

    vTcl:lib:add_widgets_to_toolbar $vTcl(lib_user, classes) $vTcl(lib_user,classes)
}

###################################################################
# Visual Tcl (vTcl)
# Copyright (C) 1996-1998 Stewart Allen
# -----------------------------------------------------------------
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
# -----------------------------------------------------------------
# copyattr.tcl - procedures to copy attributes between widgets
#
# Courtesy Rildo Pragana, (http://ww1.pragana.net)
# -----------------------------------------------------------------

proc vTcl:copyattr:setup {} {
	global vTcl
	set w $vTcl(w,widget)
	set m $vTcl(w,manager)
	set vTcl(copyattr) {}
	set lb1 .vTcl.copyattr.f1.lb
	set lb2 .vTcl.copyattr.f2.lb
	### add attributes
	foreach k [$lb1 curselection] {
		set o [$lb1 get $k]
		set v $vTcl(w,opt,$o)
		lappend vTcl(copyattr) $o $v
	}
	### add geometry options
	foreach k [$lb2 curselection] {
		set o [$lb2 get $k]
		set v $vTcl(w,$m,$o)
		lappend vTcl(copyattr) $m,$o $v
	}
	destroy .vTcl.copyattr	
}

proc vTcl:copyattr:quit {} {
	global vTcl
	if {![info exists vTcl(copyattr)]} return
	set vTcl(copyattr) {}
}

proc vTcl:copyattr:paste {} {
	global vTcl widget
	if {$vTcl(copyattr) == {}} return
	#puts "vTcl:copyattr:paste: $vTcl(copyattr)"
	foreach {op val} $vTcl(copyattr) {
		if {[llength [split $op ,]] > 1} {
			### geometry option
			lassign [split $op ,] m gop
			if {$vTcl(w,manager) != "$m"} continue
			set vTcl(w,$op) $val
			vTcl:prop:geom_config_mgr $vTcl(w,widget) \
				$gop vTcl(w,$op) {} $m
		} else {
			### widget attribute
			vTcl:prop:config_cmd $vTcl(w,widget) $op \
				vTcl(w,opt,$op) $val
		}	
	}
}

proc vTcl:copyattr {} {
	#error "copyattr not yet implemented!"
	global vTcl widget
	set w $vTcl(w,widget)
	if {$w == ""} return
	
	### this variable flags we haven't yet installed our binding
	if {![info exists vTcl(copyattr)]} {
		set vTcl(copyattr) {}
		bind vTcl(b) <ButtonRelease-1> {+ vTcl:copyattr:paste }
	}
	catch {destroy .vTcl.copyattr}
	set top [toplevel .vTcl.copyattr]
	wm title .vTcl.copyattr "Copy/Paste Attributes"
	frame .vTcl.copyattr.bts
	button .vTcl.copyattr.ok -text ok -command vTcl:copyattr:setup
	message .vTcl.copyattr.msg -aspect 1000 -text \
		"Select attribs in listboxes, click \"ok\", then click each widget to paste. When finished, choose popup menu item \"Stop Paste attributes\"."
	set f1 [frame $top.f1]
	set f2 [frame $top.f2]
	label $f1.tit -text "Attributes"
	set lb1 [listbox $f1.lb -selectmode extended -exportselection 0 \
		-yscrollcommand [list $f1.sv set]]
	scrollbar $f1.sv -command [list $f1.lb yview]
	pack $f1.tit 
	pack $f1.sv -fill y -side right
	pack $f1.lb -fill both -expand 1
	label $f2.tit -text "Geometry Mgr"
	set lb2 [listbox $f2.lb -selectmode extended -exportselection 0 \
		-yscrollcommand [list $f2.sv set]]
	scrollbar $f2.sv -command [list $f2.lb yview]
	pack $f2.tit 
	pack $f2.sv -fill y -side right
	pack $f2.lb -fill both -expand 1
	pack .vTcl.copyattr.msg -in .vTcl.copyattr.bts -side left
	pack .vTcl.copyattr.ok -in .vTcl.copyattr.bts -side right \
		-pady 3 -padx 3
	pack .vTcl.copyattr.bts -side bottom -fill x
	pack $f1 $f2 -side left -padx 5 -fill both -expand 1

	### populate listboxes
	foreach {op val} $vTcl(w,options) {
		$lb1 insert end $op
	}
	set m $vTcl(w,manager)
	foreach k [array names vTcl w,$m,*] {
		set n [lindex [split $k ,] end]
		$lb2 insert end $n
	}
}
 




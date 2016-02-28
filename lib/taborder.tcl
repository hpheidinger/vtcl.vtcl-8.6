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
# taborder.tcl - procedures to move widgets
#
# Courtesy Rildo Pragana, (http://ww1.pragana.net)
# -----------------------------------------------------------------


proc vTcl:taborder:apply {} {
	global vTcl
	foreach ww $vTcl(taborder) {
		raise [lindex $ww 1]
	}
	destroy .vTcl.taborder	
}

proc vTcl:taborder:select {} {
	global vTcl
	set ix [.vTcl.taborder.lb curselection]
	if {$ix == "" || $ix < 0} return
	vTcl:active_widget [lindex [.vTcl.taborder.lb get $ix] 1]
}

proc vTcl:taborder:up {} {
	global vTcl
	set lb .vTcl.taborder.lb
	set ix [$lb curselection]
	if {$ix == "" || $ix < 0} return
	set a $vTcl(taborder)
	set ix1 [expr $ix-1]
	set vTcl(taborder) [linsert [lreplace $a $ix $ix] $ix1 \
		[lindex $a $ix]]
	$lb selection clear 0 end
	$lb selection set $ix1
	after idle [list $lb activate $ix1]
	$lb see $ix1
}

proc vTcl:taborder:down {} {
	global vTcl
	set lb .vTcl.taborder.lb
	set ix [$lb curselection]
	if {$ix == "" || $ix < 0} return
	set a $vTcl(taborder)
	set ix1 [expr $ix+1]
	set vTcl(taborder) [linsert [lreplace $a $ix $ix] $ix1 \
		[lindex $a $ix]]
	$lb selection clear 0 end
	$lb selection set $ix1
	after idle [list $lb activate $ix1]
	$lb see $ix1
}

proc vTcl:taborder:woptions {w} {
	set r {}
	foreach op [$w configure] {
		lassign $op option
		lappend r $option
	}
	return $r
}

proc vTcl:taborder:isContainer {w} {
	return [expr ![catch {$w cget -container}]]
}

proc vTcl:taborder {} {
	global vTcl widget
	set w $vTcl(w,widget)
	if {$w == ""} return
	if {[vTcl:taborder:isContainer $w]} {
		set top $w
		set w0 [tk_focusNext $w]
	} else {
		set top [winfo parent $w]
		set w0 $w
	}
	#puts "vTcl:taborder: w0=$w0 top=$top"
	### setup list with widget paths and aliases
	set vTcl(taborder) {}
	foreach w1 [winfo children $top] {
		if {[string match vTH* [lindex [split $w1 .] end]]} continue
		if {"-takefocus" ni [vTcl:taborder:woptions $w1]} continue
		set tf [$w1 cget -takefocus]
		if {$tf == ""} { set tf 1 }
		if {$tf || [vTcl:taborder:isContainer $w1] } {
			lappend vTcl(taborder) [list $widget(rev,$w1) $w1]
		}
	}
	catch {destroy .vTcl.taborder}
	toplevel .vTcl.taborder 
	wm title .vTcl.taborder "Change <Tab> Order"
	frame .vTcl.taborder.bts
	button .vTcl.taborder.apply -text ok -command vTcl:taborder:apply
	message .vTcl.taborder.msg -aspect 300 -text "Up/Down to focus a widget\nPgUp/PgDown to change its tab order"
	set lb [listbox .vTcl.taborder.lb -listvariable vTcl(taborder) \
		-yscrollcommand [list .vTcl.taborder.sv set]]
	scrollbar .vTcl.taborder.sv -command [list $lb yview]
	pack .vTcl.taborder.msg -in .vTcl.taborder.bts -side left
	pack .vTcl.taborder.apply -in .vTcl.taborder.bts -side right \
		-pady 3 -padx 3
	pack .vTcl.taborder.bts -side bottom -fill x
	pack .vTcl.taborder.sv -fill y -side right
	pack .vTcl.taborder.lb -fill both -expand 1
	bind $lb <Prior> { vTcl:taborder:up ; break}
	bind $lb <Next> { vTcl:taborder:down ; break}
	bind $lb <<ListboxSelect>> { vTcl:taborder:select }
	focus .vTcl.taborder.lb
}
 


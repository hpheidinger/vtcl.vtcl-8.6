##############################################################################
# $Id: dragsize.tcl,v 1.17 2001/12/08 05:53:44 cgavin Exp $
#
# dragsize.tcl - procedures to handle widget sizing and movement
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

set vTcl(cursor,w) ""

proc vTcl:store_cursor {target} {
    global vTcl

    ## only store cursor once
    if {$vTcl(cursor,w) == ""} {
        #puts "Store cursor: $target $vTcl(cursor,last)"
        set vTcl(cursor,last) ""
        catch {set vTcl(cursor,last) [$target cget -cursor]}
        set vTcl(cursor,w) $target
    }
}

proc vTcl:restore_cursor {target} {
    global vTcl

    ## only restore cursor once
    if {$vTcl(cursor,w) != "" && [winfo exists $vTcl(cursor,w)]} {
        #puts "Restore cursor: $vTcl(cursor,w) $vTcl(cursor,last)"
        catch {$vTcl(cursor,w) configure -cursor $vTcl(cursor,last)}
    }

    set vTcl(cursor,w) ""
}

proc vTcl:bind_button_1 {target X Y x y} {
    global vTcl

    vTcl:set_mouse_coords $X $Y $x $y

    set parent $target

    # Megawidget ?
    if {[vTcl:WidgetVar $target parent tmp]} { set parent $tmp }

    if {[lindex [split %W .] 1] == "vTcl"} { return }

    # puts "click button 1: $target"
    set vTcl(cursor,inside_button_1) 1

    vTcl:active_widget $parent

    if {$parent != "." && [winfo class $parent] != "Toplevel"} {
	vTcl:grab $target $X $Y
        vTcl:store_cursor $target
	catch {$target configure -cursor fleur}
    } else {
        vTcl:store_cursor $target
    }

    # puts "end click button 1: $target"
    set vTcl(cursor,inside_button_1) 0
}

proc vTcl:bind_button_2 {target X Y x y} {
    global vTcl

    vTcl:set_mouse_coords $X $Y $x $y

    set parent $target

    # Megawidget ?
    if {[vTcl:WidgetVar $target parent tmp]} { set parent $tmp }

    vTcl:active_widget $parent

    if {$vTcl(w,widget) != "." && \
        [winfo class $vTcl(w,widget)] != "Toplevel" && \
        $vTcl(w,widget) != ""} {

	vTcl:grab $target $X $Y
        vTcl:store_cursor $target
	catch {$target configure -cursor fleur}
    }
}

proc vTcl:bind_motion {W x y} {
    global vTcl
    if {$vTcl(w,widget) != "." && $vTcl(w,class) != "Toplevel"} {
        vTcl:grab_motion $vTcl(w,widget) $W $x $y
    }
}

proc vTcl:bind_release {W X Y x y} {
    global vTcl

    if {[info exist vTcl(cursor,inside_button_1)] &&
        $vTcl(cursor,inside_button_1)} {

        # puts "oops: release button 1: $W"
        after 500 "vTcl:bind_release $W $X $Y $x $y"
        return
    }

    # puts "release button 1: $W"
    vTcl:set_mouse_coords $X $Y $x $y

    if {$vTcl(w,widget) == ""} {return}

    vTcl:restore_cursor $W
    vTcl:place_handles $vTcl(w,widget)
    vTcl:grab_release $W
    vTcl:update_widget_info $vTcl(w,widget)
}

proc vTcl:grab {widget absX absY} {
    global vTcl
    grab $widget
    set vTcl(w,didmove) 0
    set vTcl(w,grabbed) 1
    set vTcl(grab,startX) [vTcl:grid_snap x $absX]
    set vTcl(grab,startY) [vTcl:grid_snap y $absY]
    # puts "grab: $widget"
}

proc vTcl:grab_motion {parent widget absX absY} {
    # parent designates a megawidget, widget is the
    # child (if any) beeing dragged

    global vTcl
    set vTcl(w,didmove) 1
    # workaround for Tix
    if { $vTcl(w,grabbed) == 0 } { vTcl:grab $widget $absX $absY }
    if { $vTcl(w,manager) == "place" } {
        place $parent \
            -x [vTcl:grid_snap x \
                [expr {$absX-$vTcl(grab,startX)+$vTcl(w,x)}]] \
            -y [vTcl:grid_snap y \
                [expr {$absY-$vTcl(grab,startY)+$vTcl(w,y)}]]
    }
    vTcl:place_handles $parent
}

proc vTcl:grab_release {widget} {
    global vTcl
    grab release $widget
	set vTcl(w,grabbed) 0
    if { $vTcl(w,didmove) == 1 } {
        set vTcl(undo) [vTcl:dump_widget_quick $vTcl(w,widget)]
        vTcl:passive_push_action $vTcl(undo) $vTcl(redo)
    }
    # puts "grab_release: $widget"
}

proc vTcl:grab_resize {absX absY handle} {
    global vTcl classes
    set vTcl(w,didmove) 1
    set widget $vTcl(w,widget)
    set X [vTcl:grid_snap x $absX]
    set Y [vTcl:grid_snap y $absY]
    set deltaX [expr {$X - $vTcl(grab,startX)}]
    set deltaY [expr {$Y - $vTcl(grab,startY)}]

    ## Can we resize this widget with this handle?
    set can [vTcl:can_resize $handle]

    ## We definitely can't resize.
    if {$can == 0} { return }

    set newX $vTcl(w,x)
    set newY $vTcl(w,y)
    set newW $vTcl(w,width)
    set newH $vTcl(w,height)
    switch $vTcl(w,manager) {
        place {
            switch $handle {
                n {
                    set newX $vTcl(w,x)
                    set newY [expr {$vTcl(w,y) + $deltaY}]
                    set newW $vTcl(w,width)
                    set newH [expr {$vTcl(w,height) - $deltaY}]
                }
                e {
                    set newX $vTcl(w,x)
                    set newY $vTcl(w,y)
                    set newW [expr {$vTcl(w,width) + $deltaX}]
                    set newH $vTcl(w,height)
                }
                s {
                    set newX $vTcl(w,x)
                    set newY $vTcl(w,y)
                    set newW $vTcl(w,width)
                    set newH [expr {$vTcl(w,height) + $deltaY}]
                }
                w {
                    set newX [expr {$vTcl(w,x) + $deltaX}]
                    set newY $vTcl(w,y)
                    set newW [expr {$vTcl(w,width) - $deltaX}]
                    set newH $vTcl(w,height)
                }
                nw {
		    if {$can == 1 || $can == 2} {
			set newX [expr {$vTcl(w,x) + $deltaX}]
			set newW [expr {$vTcl(w,width) - $deltaX}]
		    }

		    if {$can == 1 || $can == 3} {
			set newY [expr {$vTcl(w,y) + $deltaY}]
			set newH [expr {$vTcl(w,height) - $deltaY}]
		    }
                }
                ne {
		    if {$can == 1 || $can == 2} {
			set newX $vTcl(w,x)
			set newW [expr {$vTcl(w,width) + $deltaX}]
		    }

		    if {$can == 1 || $can == 3} {
			set newY [expr {$vTcl(w,y) + $deltaY}]
			set newH [expr {$vTcl(w,height) - $deltaY}]
		    }
                }
                se {
		    if {$can == 1 || $can == 2} {
			set newX $vTcl(w,x)
			set newW [expr {$vTcl(w,width) + $deltaX}]
		    }

		    if {$can == 1 || $can == 3} {
			set newY $vTcl(w,y)
			set newH [expr {$vTcl(w,height) + $deltaY}]
		    }
                }
                sw {
		    if {$can == 1 || $can == 2} {
			set newX [expr {$vTcl(w,x) + $deltaX}]
			set newW [expr {$vTcl(w,width) - $deltaX}]
		    }

		    if {$can == 1 || $can == 3} {
			set newY $vTcl(w,y)
			set newH [expr {$vTcl(w,height) + $deltaY}]
		    }
                }
            }
            place $widget -x $newX -y $newY -width $newW -height $newH
        }
        grid -
        pack {
            switch $vTcl(w,class) {
                Label -
                Entry -
                Message -
                Scrollbar -
                Scale {
#                    set vTcl(w,opt,-height) ""
                }
            }
                     
            switch $handle {
                n {
                    set newW $vTcl(w,opt,-width)
                    set newH [expr {$vTcl(w,opt,-height) - $deltaY}]
                }
                e {
                    set newW [expr {$vTcl(w,opt,-width) + $deltaX}]
                    set newH $vTcl(w,opt,-height)
                }
                s {
                    set newW $vTcl(w,opt,-width)
                    set newH [expr {$vTcl(w,opt,-height) + $deltaY}]
                }
                w {
                    set newW [expr {$vTcl(w,opt,-width) - $deltaX}]
                    set newH $vTcl(w,opt,-height)
                }
                nw {
                    set newW [expr {$vTcl(w,opt,-width) - $deltaX}]
                    set newH [expr {$vTcl(w,opt,-height) - $deltaY}]
                }
                ne {
                    set newW [expr {$vTcl(w,opt,-width) + $deltaX}]
                    set newH [expr {$vTcl(w,opt,-height) - $deltaY}]
                }
                se {
                    set newW [expr {$vTcl(w,opt,-width) + $deltaX}]
                    set newH [expr {$vTcl(w,opt,-height) + $deltaY}]
                }
                sw {
                    set newW [expr {$vTcl(w,opt,-width) - $deltaX}]
                    set newH [expr {$vTcl(w,opt,-height) + $deltaY}]
                }
            }
            if { $newW < 0 } { set newW 0 }
            if { $newH < 0 } { set newH 0 }
	}
    }
            
    $classes($vTcl(w,class),resizeCmd) $widget $newW $newH
    vTcl:place_handles $widget
}

## Default routine to adjust the size of a widget after it's been resized.
## This routine can be overridden in the widget definition.
proc vTcl:adjust_widget_size {widget w h} {
    # @@change by Christian Gavin 3/19/2000
    # added catch in case some widgets don't have a -width
    # or a -height option (for example Iwidgets toolbar)

    if {![winfo exists $widget]} { return }

    set class [winfo class $widget]
    
    catch {
	switch $class {
	   Label -
	   Entry -
	   Message -
	   Scrollbar -
	   Scale {
	       $widget configure -width $w
	   }
	   default {
	       $widget configure -width $w
	       $widget configure -height $h
	   }
	}
    }

    update
    
    # @@end_change
}

## Can we resize this widget?
## 0 = no
## 1 = yes
## 2 = only horizontally
## 3 = only vertically

## classes($class,resizable)
## 0 = none
## 1 = both
## 2 = horizontal
## 3 = vertical

proc vTcl:can_resize {dir} {
    global vTcl classes

    set c [vTcl:get_class $vTcl(w,widget)]
    set resizable $classes($c,resizable)

    ## We can't resize at all.
    if {$resizable == 0} { return 0 }

    ## We can resize both.
    if {$resizable == 1} { return 1 }

    switch -- $dir {
	e  -
	w  {
	    return [expr $resizable == 2]
	}

    	n  -
	s  {
	    return [expr $resizable == 3]
	}

	ne -
	se -
	sw -
	nw {
	    if {$resizable == 2} { return 2 }
	    if {$resizable == 3} { return 3 }
	}
    }
}

##############################################################################
# $Id: prefs.tcl,v 1.47 2006/07/28 16:03:32 unixabg Exp $
#
# prefs.tcl - procedures for editing application preferences
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

proc vTcl:prefs:uninit {base} {
    catch {destroy $base.tb}
}

proc vTcl:prefs:init {base} {
    global vTcl

    # this is to store all variables
    namespace eval prefs {
       variable balloon          ""
       variable getname          ""
       variable shortname        ""
       variable winfocus         ""
       variable autoplace        ""
       variable cmdalias         ""
       variable autoalias        ""
       variable multiplace       ""
       variable autoloadcomp     ""
       variable autoloadcompfile ""
       variable font_dlg         ""
       variable font_fixed       ""
       variable manager          ""
       variable encase           ""
       variable projecttype      ""
       variable imageeditor      ""
       variable saveimagesinline ""
       variable projfile         ""
       variable saveasexecutable ""
       variable bgcolor		 ""
       variable entrybgcolor     ""
       variable entryactivecolor ""
       variable listboxbgcolor   ""
       variable treehighlight	 ""
       variable texteditor	 ""
    }

    set prefs::font_dlg [eval font create [font actual $vTcl(pr,font_dlg)]]
    set prefs::font_fixed [eval font create [font actual $vTcl(pr,font_fixed)]]

    # set the variables for the dialog
    vTcl:prefs:data_exchange 0

    ## Destroy the notebook if already existing
    vTcl:prefs:uninit $base
    set tb [NoteBook $base.tb]
    pack $tb -fill both -expand 1

    vTcl:prefs:basics  [$tb insert end "Basics" -text "Basics"]
    vTcl:prefs:project [$tb insert end "Project" -text "Project"]
    vTcl:prefs:fonts   [$tb insert end "Fonts" -text "Fonts"]
    vTcl:prefs:bgcolor [$tb insert end "Colors" -text "Colors"]
    vTcl:prefs:images  [$tb insert end "Images" -text "Images"]
    vTcl:prefs:libs    [$tb insert end "Libraries" -text "Libraries"]
    #vTcl:prefs:external [$tb insert end "External" -text "External"]

    $tb raise Basics
}

proc vTclWindow.vTcl.prefs {{base ""}} {
    global widget

    if {$base == ""} {
        set base .vTcl.prefs
    }
    if {[winfo exists $base]} {
        wm deiconify $base
        return
    }

    ###################
    # CREATING WIDGETS
    ###################
    toplevel $base -class Toplevel
    wm geometry $base +0+0
    wm withdraw $base
    ## measure text height then compute an approximate dialog height
    radiobutton $base.rb -text "Single line"
    place $base.rb -x 0 -y 0
    update
    set height [expr ([winfo height $base.rb] + 1) * 15]
    destroy $base.rb
    ## end measurement
    wm geometry   $base 400x$height
    wm focusmodel $base passive
    wm maxsize $base 1284 1010
    wm minsize $base 100 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm title $base "Visual Tcl Preferences"
    wm protocol $base WM_DELETE_WINDOW "wm withdraw $base"
    bind $base <Key-Return> {
        vTcl:prefs:data_exchange 1; wm withdraw [winfo toplevel %W]
    }
    bind $base <Key-Escape> {
        wm withdraw [winfo toplevel %W]; vTcl:prefs:data_exchange 0
    }
    bind $base <<Show>> {
        ## make sure the dialog is up-to-date
        vTcl:prefs:data_exchange 0
    }
    frame $base.fra19
    ::vTcl::OkButton $base.fra19.but20 \
     -command "vTcl:prefs:data_exchange 1; wm withdraw $base"
    ::vTcl::CancelButton $base.fra19.but21 \
     -command "vTcl:prefs:data_exchange 0; wm withdraw $base"
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.fra19 \
        -in $base -anchor e -expand 0 -fill none -pady 5 -side top
    pack $base.fra19.but20 \
        -in $base.fra19 -side left
    pack $base.fra19.but21 \
        -in $base.fra19 -side left

    ###################
    # Balloon help
    ###################
    vTcl:set_balloon $base.fra19.but20 "Apply changes and close dialog"
    vTcl:set_balloon $base.fra19.but21 "Cancel changes and close dialog"

    vTcl:prefs:init $base
    vTcl:BindHelp $base Preferences

    update
    vTcl:center $base 400 $height
    wm deiconify $base
}

proc {vTcl:prefs:data_exchange} {save_and_validate} {
    global widget vTcl

    # if save_and_validate is set to 0, values are transferred from
    # the preferences to the dialog (this is typically done when
    # initializing the dialog)

    # if save_and_validate is set to 1, values are transferred from
    # the dialog to the preferences (this is typically done when
    # the user presses the OK button

    vTcl:data_exchange_var vTcl(pr,balloon)          \
	prefs::balloon          $save_and_validate
    vTcl:data_exchange_var vTcl(pr,getname)          \
	prefs::getname          $save_and_validate
    vTcl:data_exchange_var vTcl(pr,shortname)        \
	prefs::shortname        $save_and_validate
    vTcl:data_exchange_var vTcl(pr,winfocus)         \
	prefs::winfocus         $save_and_validate
    vTcl:data_exchange_var vTcl(pr,autoplace)        \
	prefs::autoplace        $save_and_validate
    vTcl:data_exchange_var vTcl(pr,autoloadcomp)     \
	prefs::autoloadcomp     $save_and_validate
    vTcl:data_exchange_var vTcl(pr,autoloadcompfile) \
	prefs::autoloadcompfile $save_and_validate
    vTcl:data_exchange_var vTcl(pr,manager)          \
	prefs::manager          $save_and_validate
    vTcl:data_exchange_var vTcl(pr,encase)           \
	prefs::encase           $save_and_validate
    vTcl:data_exchange_var vTcl(pr,projecttype)      \
	prefs::projecttype      $save_and_validate
    vTcl:data_exchange_var vTcl(pr,imageeditor)      \
	prefs::imageeditor      $save_and_validate
    vTcl:data_exchange_var vTcl(pr,saveimagesinline) \
	prefs::saveimagesinline $save_and_validate
    vTcl:data_exchange_var vTcl(pr,cmdalias)         \
	prefs::cmdalias         $save_and_validate
    vTcl:data_exchange_var vTcl(pr,autoalias)        \
	prefs::autoalias        $save_and_validate
    vTcl:data_exchange_var vTcl(pr,multiplace)       \
	prefs::multiplace       $save_and_validate
    vTcl:data_exchange_var vTcl(pr,projfile)         \
    	prefs::projfile         $save_and_validate
    vTcl:data_exchange_var vTcl(pr,saveasexecutable) \
        prefs::saveasexecutable $save_and_validate
    vTcl:data_exchange_var vTcl(pr,bgcolor)          \
        prefs::bgcolor $save_and_validate
    vTcl:data_exchange_var vTcl(pr,entrybgcolor)     \
        prefs::entrybgcolor $save_and_validate
    vTcl:data_exchange_var vTcl(pr,entryactivecolor) \
        prefs::entryactivecolor $save_and_validate
    vTcl:data_exchange_var vTcl(pr,listboxbgcolor)   \
        prefs::listboxbgcolor $save_and_validate
    vTcl:data_exchange_var vTcl(pr,treehighlight)    \
        prefs::treehighlight $save_and_validate
    vTcl:data_exchange_var vTcl(pr,texteditor)       \
        prefs::texteditor $save_and_validate

    if {$save_and_validate} {
        set vTcl(pr,font_dlg)   [font configure $prefs::font_dlg]
        set vTcl(pr,font_fixed) [font configure $prefs::font_fixed]

        vTcl:prefs:saveLibs
    } else {
        eval font configure $prefs::font_dlg   [font actual $vTcl(pr,font_dlg)]
        eval font configure $prefs::font_fixed [font actual $vTcl(pr,font_fixed)]

        vTcl:prefs:fillLibs
    }
}

proc {vTcl:prefs:basics} {tab} {

	vTcl:formCompound:add $tab checkbutton \
		-text "Use balloon help" \
		-variable prefs::balloon
	vTcl:formCompound:add $tab checkbutton \
		-text "Ask for widget name on insert" \
		-variable prefs::getname
	vTcl:formCompound:add $tab checkbutton \
		-text "Short automatic widget names" \
		-variable prefs::shortname
	vTcl:formCompound:add $tab checkbutton \
		-text "Window focus selects window" \
		-variable prefs::winfocus
	vTcl:formCompound:add $tab checkbutton \
		-text "Auto place new widgets" \
		-variable prefs::autoplace
	vTcl:formCompound:add $tab checkbutton \
		-text "Use widget command aliasing" \
		-variable prefs::cmdalias
	vTcl:formCompound:add $tab checkbutton \
		-text "Use auto-aliasing for new widgets" \
		-variable prefs::autoalias
	vTcl:formCompound:add $tab checkbutton \
		-text "Use continuous widget placement" \
		-variable prefs::multiplace
	vTcl:formCompound:add $tab checkbutton \
		-text "Save project info in project file" \
		-variable prefs::projfile
	vTcl:formCompound:add $tab checkbutton \
		-text "Auto load compounds from file:" \
		-variable prefs::autoloadcomp

	set form_entry [vTcl:formCompound:add $tab frame]
	pack configure $form_entry -fill x

	set entry [vTcl:formCompound:add $form_entry entry \
		-textvariable prefs::autoloadcompfile]
	pack configure $entry -fill x -padx 2 -side left -expand 1

	set browse_file [vTcl:formCompound:add $form_entry ::vTcl::BrowseButton\
		-command "vTcl:prefs:browse_file prefs::autoloadcompfile"]
	pack configure $browse_file -side right
}

proc {vTcl:prefs:browse_file} {varname} {

	global widget tk_strictMotif

	eval set value $$varname
	set types {
	    {{Tcl Files} *.tcl}
	    {{All Files} * }
	}

	set tk_strictMotif 0
	set newfile [tk_getOpenFile -filetypes $types]
	set tk_strictMotif 1

	if {$newfile != ""} {
	   set $varname $newfile
	}
}

proc {vTcl:prefs:browse_font} {fontname} {
    global widget

    set value [font configure $fontname]
    set newfont [vTcl:font:prompt_user_font_2 $value]

    if {$newfont != ""} {
	eval font configure $fontname $newfont
    }
}

proc {vTcl:prefs:fonts} {tab} {

	global widget

	set last  [vTcl:formCompound:add $tab  label \
		-text "Dialog font" -background gray -relief raised]
	pack configure $last -fill x

	set font_frame [vTcl:formCompound:add $tab frame]
	pack configure $font_frame -fill x
	set last [vTcl:formCompound:add $font_frame label \
		-text "ABCDEFGHIJKLMNOPQRSTUVWXYZ\n0123456789" \
		-justify left -font $prefs::font_dlg]
	pack configure $last -side left
	set last [vTcl:formCompound:add $font_frame button \
		-text "Change..." \
		-command "vTcl:prefs:browse_font $prefs::font_dlg"]
	pack configure $last -side right

	vTcl:formCompound:add $tab  label -text ""

	set last  [vTcl:formCompound:add $tab  label \
		-text "Fixed width font" -background gray -relief raised]
	pack configure $last -fill x

	set font_frame [vTcl:formCompound:add $tab frame]
	pack configure $font_frame -fill x
	set last [vTcl:formCompound:add $font_frame label \
		-text "ABCDEFGHIJKLMNOPQRSTUVWXYZ\n0123456789" \
		-justify left -font $prefs::font_fixed]
	pack configure $last -side left
	set last [vTcl:formCompound:add $font_frame button \
		-text "Change..." \
		-command "vTcl:prefs:browse_font $prefs::font_fixed"]
	pack configure $last -side right
}

proc vTcl:prefs:bgcolor_get {w} {
    if {[string equal $::prefs::bgcolor ""]} {
        set initial "#d9d9d9"
    } else {
        set initial $::prefs::bgcolor
    }
    set color [vTcl:get_color $initial $w]
    if {![string equal $color ""]} {
        set prefs::bgcolor $color
    }
}

proc vTcl:prefs:color_pref_get {w visual variable} {
    set initial [vTcl:at $variable]
    set color [vTcl:get_color $initial $w]
    if {![string equal $color ""]} {
        set $variable $color
        $visual configure -bg $color
    }
}

proc vTcl:prefs:color_pref {w text variable} {

    set color_frame [vTcl:formCompound:add $w frame]
    pack configure $color_frame -fill x
    set last [vTcl:formCompound:add $color_frame label \
        -text $text -justify left]
    pack configure $last -side left
    set browse [vTcl:formCompound:add $color_frame ::vTcl::BrowseButton]
    pack configure $browse -side right
    set last [vTcl:formCompound:add $color_frame label \
                -text "" -bg [vTcl:at $variable] -width 8]
    pack configure $last -side right -padx 1 -pady 1
    $browse configure -command "vTcl:prefs:color_pref_get $last $last $variable"
}

proc {vTcl:prefs:bgcolor} {tab} {
    switch $prefs::bgcolor {
	""        {set prefs::bgcolortype auto}
	"#d9d9d9" {set prefs::bgcolortype default}
	default   {set prefs::bgcolortype custom}
    }

    set last  [vTcl:formCompound:add $tab  label \
	-text "Background Color" -background gray -relief raised]
    pack configure $last -fill x

    vTcl:formCompound:add $tab radiobutton \
	-text "Autodetect system colors" \
	-variable prefs::bgcolortype -value auto \
	-command "set prefs::bgcolor {}"

    vTcl:formCompound:add $tab radiobutton \
	-text "Use Visual Tcl default color" \
	-variable prefs::bgcolortype -value default \
	-command "set prefs::bgcolor #d9d9d9"

    set last [vTcl:formCompound:add $tab radiobutton \
	-text "Choose a custom color" \
	-variable prefs::bgcolortype -value custom]
    $last configure -command "vTcl:prefs:bgcolor_get $last"

    ##-----------------------------------------------------------------------

    set last  [vTcl:formCompound:add $tab  label \
	-text "Widget Tree" -background gray -relief raised]
    pack configure $last -fill x

    vTcl:prefs:color_pref $tab "Widget Tree highlight color" \
	::prefs::treehighlight

    set last  [vTcl:formCompound:add $tab  label \
	-text "Entries" -background gray -relief raised]
    pack configure $last -fill x

    vTcl:prefs:color_pref $tab "Entry background color" ::prefs::entrybgcolor
    vTcl:prefs:color_pref $tab "Entry active color" ::prefs::entryactivecolor

    ##-----------------------------------------------------------------------

    set last  [vTcl:formCompound:add $tab  label \
	-text "Listboxes" -background gray -relief raised]
    pack configure $last -fill x

    vTcl:prefs:color_pref $tab "Listbox background color" ::prefs::listboxbgcolor
}

proc {vTcl:prefs:project} {tab} {

	global widget

	set last  [vTcl:formCompound:add $tab  label \
		-text "Option encaps" -background gray -relief raised]
	pack configure $last -fill x

	vTcl:formCompound:add $tab radiobutton  \
		-text "List"   -variable prefs::encase -value list -pady 0
	vTcl:formCompound:add $tab radiobutton  \
		-text "Braces" -variable prefs::encase -value brace -pady 0
 	vTcl:formCompound:add $tab radiobutton  \
 		-text "Quotes" -variable prefs::encase -value quote -pady 0

	#======================================================================

	set last  [vTcl:formCompound:add $tab  label \
		-text "Project type" -background gray -relief raised]
	pack configure $last -fill x

	vTcl:formCompound:add $tab radiobutton -pady 0 \
		-text "Single file project" -variable prefs::projecttype -value single
	vTcl:formCompound:add $tab radiobutton -pady 0 \
		-text "Multiple file project" -variable prefs::projecttype -value multiple

	#======================================================================

	set last  [vTcl:formCompound:add $tab  label \
		-text "Default manager" -background gray -relief raised]
	pack configure $last -fill x

	vTcl:formCompound:add $tab radiobutton  \
		-text "Grid" -variable prefs::manager -value grid -pady 0
	vTcl:formCompound:add $tab radiobutton  \
		-text "Pack" -variable prefs::manager -value pack -pady 0
	vTcl:formCompound:add $tab radiobutton  \
		-text "Place" -variable prefs::manager -value place -pady 0

	#======================================================================

	set last  [vTcl:formCompound:add $tab  label \
		-text "Source file" -background gray -relief raised]
	pack configure $last -fill x

	vTcl:formCompound:add $tab checkbutton  \
		-text "Save as executable" -variable prefs::saveasexecutable
}

proc {vTcl:prefs:images} {tab} {

	global widget

	vTcl:formCompound:add $tab label \
		-text "Editor for images"

	set form_entry [vTcl:formCompound:add $tab frame]
	pack configure $form_entry -fill x

	set last [vTcl:formCompound:add $form_entry entry  \
		-textvariable prefs::imageeditor]
	pack configure $last -fill x -expand 1 -padx 2 -side left

	set last [vTcl:formCompound:add $form_entry ::vTcl::BrowseButton \
		-command "vTcl:prefs:browse_file prefs::imageeditor"]
	pack configure $last -side right

	vTcl:formCompound:add $tab checkbutton \
		-text "Save images as inline" -variable prefs::saveimagesinline
}

proc vTcl:prefs:libs {tab} {
    set last  [vTcl:formCompound:add $tab  label \
	-text "Load libs on startup" -background gray -relief raised]
    pack configure $last -fill x

    set last [vTcl:formCompound:add $tab listbox -background white -selectmode multiple]
    pack configure $last -fill both -expand 1 -pady 5

    set ::prefs::libsListbox $last
    vTcl:prefs:fillLibs
}

proc vTcl:prefs:fillLibs {} {

    ## not yet initialized?
    if {![info exists ::prefs::libsListbox]} {
        return
    }

    set libs [glob -nocomplain [file join $::vTcl(VTCL_HOME) lib lib*.tcl]]
    set i 0
    foreach load [::vTcl::project::getLibrariesToLoad] {
        lappend toload [file tail $load]
    }
    set listbox [set ::prefs::libsListbox]
    $listbox delete 0 end
    foreach lib $libs {
        set item [file tail $lib]
        $listbox insert end $item
        if {[lsearch -exact $toload $item] != -1} {
            $listbox selection set $i
        }
        incr i
    }
}

proc vTcl:prefs:saveLibs {} {
    set listbox [set ::prefs::libsListbox]
    set indices [$listbox curselection]
    if {$indices == ""} {
        ## selection cannot be empty because
        ## 1) at least one lib must be selected
        ## 2) if the listbox is not in focus it will lose the selection
        return
    }

    set libs ""
    foreach index $indices {
        lappend libs [$listbox get $index]
    }

    set before [::vTcl::project::getLibrariesToLoad]
    ::vTcl::project::setLibrariesToLoad $libs
    set after [::vTcl::project::getLibrariesToLoad]

    if {$before != $after} {
        ::vTcl::MessageBox -icon info \
        -message "Library changes will be valid the next time you start vTcl." \
            -title "Information" -type ok
    }
}

proc vTcl:prefs:external {tab} {
    global widget

    vTcl:formCompound:add $tab label -text "External Editor"
    set f [vTcl:formCompound:add $tab frame]
    pack configure $f -fill x
    set x [vTcl:formCompound:add $f entry -textvariable prefs::texteditor]
    pack configure $x -fill x -expand 1 -side left -padx 2

    set x [vTcl:formCompound:add $f ::vTcl::BrowseButton \
	-command "vTcl:prefs:browse_file prefs::texteditor"]
    pack configure $x -side left -anchor nw
}



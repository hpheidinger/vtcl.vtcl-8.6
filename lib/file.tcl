##############################################################################
# $Id: file.tcl,v 1.55 2003/05/13 04:53:25 cgavin Exp $
#
# file.tcl - procedures to open, close and save applications
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
# This file has been modified by:
#   Christian Gavin
#   Damon Courtney
#
##############################################################################

proc vTcl:new {} {
    global vTcl
    if { [vTcl:close] == -1 } { return }

    ## Run through the Project Wizard to setup the new project.
    Window show .vTcl.newProjectWizard

    tkwait variable ::NewWizard::Done

    set vTcl(mode) EDIT

    vTcl:setup_bind_tree .
    vTcl:update_top_list
    vTcl:update_proc_list

    if {[lempty $::NewWizard::ProjectFile]} {
	set vTcl(project,name) "unknown.tcl"
    } else {
    	set vTcl(project,name) \
	    [file join $::NewWizard::ProjectFolder $::NewWizard::ProjectFile]
	set vTcl(project,file) $vTcl(project,name)
    }

    wm title $vTcl(gui,main) "Visual Tcl - $vTcl(project,name)"

    set w [vTcl:auto_place_widget Toplevel]
    if {$w != ""} { wm geometry $w $vTcl(pr,geom_new) }
}

proc vTcl:file_source {} {
    global vTcl
    set file [vTcl:get_file open "Source File"]
    if {$file != ""} {
        vTcl:source $file newprocs
        vTcl:list add $newprocs vTcl(procs)
        vTcl:update_proc_list
    }
}

proc vTcl:is_vtcl_prj {file} {
    global vTcl

    set fileID [open $file r]
    set contents [read $fileID]
    close $fileID

    set found 0
    set vmajor ""
    set vminor ""
    # hph #
    set patchl ""

    #
    # Don't be too picky here .. or you mess the hole thing
    #
    foreach line [split $contents \n] {
	if [regexp {# Visual Tcl [vV](.?.?)\.(.?.?)\.(.?.?) Project} $line \
	    matchAll vmajor vminor patchl] {
	    set found 1
	}
    }

    if !$found {
	::vTcl::MessageBox -title "Error loading file" \
	              -message "This is not a vTcl project!" \
	              -icon error \
	              -type ok

	return 0
    }

    set versions [split $vTcl(version) .]
    set actual_major [lindex $versions 0]
    set actual_minor [lindex $versions 1]

    if {$vmajor != "" && $vminor != ""} {

    	if {$vmajor > $actual_major ||
    	    ($vmajor == $actual_major && $vminor > $actual_minor)} {
		::vTcl::MessageBox -title "Error loading file" \
		              -message "You are trying to load a project created using Visual Tcl v$vmajor.$vminor\n\nPlease update to vTcl $vmajor.$vminor and try again." \
	              -icon error \
	              -type ok

	        return 0
    	}
    }

    # all right, it's a vtcl project
    return 1
}

proc vTcl:source {file newprocs} {
    global vTcl
    set vTcl(sourcing) 1
    vTcl:statbar 15
    set op ""
    upvar $newprocs np

    foreach context [vTcl:namespace_tree] {
		if {$context == "::tcl::dict"} continue
		if {$context == "::itcl::builtin"} continue	#hph,2016-02-04
        set cop [namespace eval $context {info procs}]

        foreach procname $cop {
            if {$context == "::"} {
               lappend op $procname
            } else {
               lappend op ${context}::$procname
            }
        }
    }

    vTcl:statbar 20
    if [catch {uplevel #0 [list source $file]} err] {
        ::vTcl::MessageBox -icon error -message "Error Sourcing Project\n$err" \
            -title "File Error!"
	global errorInfo
    }
    vTcl:statbar 35

    # kc: ignore global procs like "tixSelect"
    set np ""
    foreach context [vTcl:namespace_tree] {
		if {$context == "::tcl::dict"} continue
		if {$context == "::itcl::builtin"} continue	#hph,2016-02-04
		
        set cop [namespace eval $context {info procs}]

        foreach procname $cop {
            if {[vTcl:ignore_procname_when_sourcing $procname] == 0 &&
                [vTcl:ignore_procname_when_sourcing ${context}::$procname] == 0} {
               if {$context == "::"} {
                   lappend np $procname
               } else {
                   lappend np ${context}::$procname
               }
            }
       }
    }

    set np [vTcl:diff_list $op $np]
    vTcl:statbar 45
    set vTcl(tops) [vTcl:find_new_tops $np];     vTcl:statbar 0
    set vTcl(sourcing) 0
}

proc vTcl:open {{file ""}} {
    global vTcl argc argv
    if { [vTcl:close] == -1 } { return }
    if {$file == ""} {
        set file [vTcl:get_file open "Open Project"]
    } else {
        if ![file exists $file] {return}
    }

    if {![info exists vTcl(rcFiles)]} { set vTcl(rcFiles) {} }

    if {[lempty $file]} { return }

    set vTcl(sourcing) 1

    # only open a Visual Tcl project and nothing else
    if ![vTcl:is_vtcl_prj $file] {return}

    vTcl:addRcFile $file

    set vTcl(file,mode) ""
    vTcl:load_lib vtclib.tcl;            vTcl:statbar 10
    set vTcl(tops) ""
    set vTcl(vars) ""
    set vTcl(procs) ""
    proc vTcl:project:info {} {}

    vTcl:status "Loading Project"
    vTcl:source $file newprocs;          vTcl:statbar 55

    # make sure the 'Window' procedure is the latest
    vTcl:load_lib vtclib.tcl;            vTcl:statbar 60

    vTcl:status "Updating top list"
    vTcl:update_top_list;                vTcl:statbar 68

    ## convert older projects
    vTcl:convert_tops

    vTcl:status "Updating aliases"
    vTcl:update_aliases;                 vTcl:statbar 75

    vTcl:status "Loading Project Info";  vTcl:statbar 80

    set vTcl(project,file) $file
    set vTcl(project,name) [file tail $file]

    ## Determine if there is a multifile project file and source it.
    set basedir [file dir $file]
    set multidir [vTcl:dump:get_multifile_project_dir $vTcl(project,name)]
    set file [file root $vTcl(project,name)].vtp

    if {[file exists [file join $basedir $file]]} {
    	source [file join $basedir $file]
    } elseif {[file exists [file join $basedir $multidir $file]]} {
    	source [file join $basedir $multidir $file]
    }

    ## If there are project settings, load them
    if {![lempty [info proc vTcl:project:info]]} { vTcl:project:info }

    ## Setup the bind tree after we have loaded project info, so
    ## that registration of children in childsites works OK
    vTcl:status "Setting up bind tree"
    vTcl:setup_bind_tree .;              vTcl:statbar 85

    vTcl:status "Registering widgets"
    vTcl:widget:register_all_widgets;	 vTcl:statbar 90

    vTcl:status "Updating proc list"
    if {$::vTcl::modules::main::procs != ""} {
        vTcl:list add $::vTcl::modules::main::procs vTcl(procs)
    } else {
        vTcl:list add "init main" vTcl(procs)
        vTcl:list add $newprocs   vTcl(procs)
    }
    vTcl:update_proc_list;               vTcl:statbar 95
    vTcl:bind_tops;                      vTcl:statbar 98

    ## The "single file" or "multiple files" option is now saved with each
    ## project, and defaults to the current preference if not saved into the
    ## project file. This is an intermediate step toward module oriented projects.
    set vTcl(pr,projecttype) $::vTcl::modules::main::projectType

    wm title .vTcl "Visual Tcl - $vTcl(project,name)"
    vTcl:status "Done Loading"
    vTcl:statbar 0
    set vTcl(newtops) [expr [llength $vTcl(tops)] + 1]

    unset vTcl(sourcing)

    ## show all toplevels for editing
    ::vTcl:::tops::handleRunvisible deiconify

    ## refresh widget tree automatically after File Open...
    ## refresh image manager and font manager
    ## refresh user compounds menu

    after idle {
	    vTcl:init_wtree
	    vTcl:image:refresh_manager
	    vTcl:font:refresh_manager
          vTcl:cmp_user_menu
    }
}

proc vTcl:close {} {
    global vTcl
    if {$vTcl(change) > 0} {
        set result [::vTcl::MessageBox -default yes -icon question -message \
            "Your application has unsaved changes. Do you wish to save?" \
            -title "Save Changes?" -type yesnocancel]
        switch $result {
            yes {
                # @@ Nelson 20030409 if project is named just save it.
		#if {[vTcl:save_as] == -1} { return -1 }
                if {[vTcl:save] == -1} { return -1 }
            }
            cancel {
                return -1
            }
        }
    }

    set tops $vTcl(tops)
    foreach i $tops {
        if {$i != ".vTcl" && $i != ".__tk_filedialog"} {
            # list widget tree without including $i (it's why the "0" parameter)
            foreach child [vTcl:widget_tree $i 0] {
                vTcl:unset_alias $child
                vTcl:setup_unbind $child
            }
            vTcl:unset_alias $i
            destroy $i

            # this is clean up for leftover widget commands
            set _cmds [info commands $i.*]
            foreach _cmd $_cmds {catch {rename $_cmd ""}}
        }

        ## Destroy the widget namespace, as well as the namespaces of
        ## all it's subwidgets
        set namespaces [vTcl:namespace_tree ::widgets]
        foreach namespace $namespaces {
            if {[string match ::widgets::$i* $namespace]} {
                catch {namespace delete $namespace} error
            }
        }
    }

    set vTcl(tops) ""
    set vTcl(newtops) 1
    vTcl:update_top_list
    foreach i $vTcl(vars) {
        # don't erase aliases, they should be erased when
        # closing the toplevels
        if {$i == "widget"} continue
        catch {global $i; unset $i}
    }
    set vTcl(vars) ""
    foreach i $vTcl(procs) {
        catch {rename $i {}}
    }
    proc exit {args} {}
    proc init {argc argv} {}
    proc main {argc argv} {}
    set vTcl(procs) "init main"
    vTcl:update_proc_list
    set vTcl(project,file) ""
    set vTcl(project,name) ""
    set vTcl(w,widget) ""
    set vTcl(w,save) ""
    wm title $vTcl(gui,main) "Visual Tcl"
    set vTcl(change) 0
    set vTcl(quit) 0

    # refresh widget tree automatically after File Close
    # delete user images (e.g. per project images)
    # delete user fonts (e.g. per project fonts)

    vTcl:image:remove_user_images
    vTcl:font:remove_user_fonts
    vTcl:prop:clear
    ::widgets_bindings::init
    ::menu_edit::close_all_editors
    ::vTcl::project::closeCompounds main
    vTcl:cmp_user_menu
    ::vTcl::project::initModule main

    ::vTcl::notify::publish closed_project

    after idle {vTcl:init_wtree}
}

proc vTcl:save {} {
    global vTcl
    set vTcl(save) all
    set vTcl(w,save) $vTcl(w,widget)
    if {$vTcl(project,file) == ""} {
        set file [vTcl:get_file save "Save Project"]
        vTcl:save2 $file
    } else {
        vTcl:save2 $vTcl(project,file)
    }
}

proc vTcl:save_as {} {
    global vTcl
    set vTcl(save) all
    set vTcl(w,save) $vTcl(w,widget)
    set file [vTcl:get_file save "Save Project"]
    vTcl:save2 $file
}

# @@change by Christian Gavin 3/27/00
# added support for freewrap to generate executables
# under Linux and Windows

proc vTcl:save_as_binary {} {
    global vTcl env tcl_platform

    set vTcl(save) all
    set vTcl(w,save) $vTcl(w,widget)
    set file [vTcl:get_file save "Save Project With Binary"]

    update

    vTcl:save2 $file

    if {[lempty $file]} { return }

    update

    vTcl:status "Creating binary..."

    # Now comes the magic.
    set filelist [file rootname $file].fwp

    set listID [open $filelist w]
    puts $listID [join [vTcl:image:get_files_list] \n]
    puts $listID [join [vTcl:dump:get_files_list \
                          [file dirname $file] \
                          [file rootname $file] ] \n]
    close $listID
    
    ##
    ## Guess the ostag and look for an appropriate freewrap binary.
    ##
    if {[string tolower $tcl_platform(platform)] == "windows"} {
	set freewrap [file join $env(VTCL_HOME) Freewrap Windows bin freewrap.exe]
    } else {
	set ostag [exec $env(VTCL_HOME)/Freewrap/config.guess]
	set freewrap [file join $env(VTCL_HOME) Freewrap $ostag bin freewrap]
    }

    ## user installation required?
    if {![file exists $freewrap]} {
        ::vTcl::MessageBox -title "Freewrap not installed" -message \
"You have not yet installed freewrap in the vTcl distribution.

Visual Tcl needs to find freewrap in the following location:

[file dirname $freewrap]

Install a copy of the freewrap binary '[file tail $freewrap]' in the
above location then try again." \
-icon error -type ok
        return
    }

    exec $freewrap $file -f $filelist

    file delete -force $filelist

    vTcl:status "Binary Done"
}

# @@end_change

proc vTcl:save2 {file} {
    global vTcl env
    global tcl_platform
    
    if {$file == ""} {
        return -1
    }
    vTcl:destroy_handles
    vTcl:setup_bind_tree .

    set vTcl(project,name) [lindex [file split $file] end]
    set vTcl(project,file) $file
    
    # @@change 20030409 Nelson bug 415090
    if {[file exists $file] && (![file exists $file.tmp]) } {
        # If we are here then the original file exists and no ${file}.tmp exists
        # We will move the original file to ${file}.tmp . 
        # If all goes well during the save process then we can move 
        # the ${file}.tmp to ${file}.bak . 
        file rename -force ${file} ${file}.tmp
    } elseif {![file exists $file]} {
        # Do nothing here since implies we were called from a save as operation!
    } else {
        # Give feedback here if things went wrong.
	  ::vTcl::MessageBox -icon error -message \
            "$file.tmp already exists! This means for some reason a prior save attempt has failed!" \
            -title "Save Error!" -type ok	  
	  ::vTcl::MessageBox -icon info -message \
            "To work around the $file.tmp error: Perform a perform a \"Save As\" operation with a different file name.\nThis will protect the data in the $file.tmp and save your current work." \
	     -title "Save Information!" -type ok	   
         	  
	  return -1
    }
   
    # Catch for errors during the saving operations.
    set output ""
    if {[catch {
        set output [open $file w]
        if {$vTcl(pr,saveasexecutable)} {
            puts $output "\#!/bin/sh"
            puts $output "\# the next line restarts using wish\\"
            puts $output {exec wish "$0" "$@" }
        }
       
        ## Gather information about the widgets.
        vTcl:dump:gather_widget_info
        
        ## Find out what libraries are being used by the compounds
        set vTcl(dump,libraries) [concat $vTcl(dump,libraries) [vTcl::project::requiredLibraries main]]
        set vTcl(dump,libraries) [lsort -unique $vTcl(dump,libraries)]
        
	  ## Header to import libraries
        ## If any of the widgets use an external library, we need to dump the
        ## importheader for each library.  If all the widgets are core or don't
        ## use an external library, don't dump anything.
        if {![lempty $vTcl(dump,libraries)]} {
    	    
            ## If we have any library other than the core libraries, invoke
    	      ## a package name search in the headers.
    	      set namesearch 0
    	      foreach lib $vTcl(dump,libraries) {
                if {[vTcl:streq $lib "core"] \
                   || [vTcl:streq $lib "vtcl"] \
                   || [vTcl:streq $lib "user"]} { continue }
	          set namesearch 1
	      }
   	      vTcl:dump:not_sourcing_header out
	    
            if {$namesearch} {
	          append out "\n$vTcl(tab)# Provoke name search\n"
	          append out "$vTcl(tab)catch {package require bogus-package-name}\n"
	          append out "$vTcl(tab)set packageNames \[package names\]\n"
            }
	    
            foreach lib $vTcl(dump,libraries) {
                if {![info exists vTcl(head,$lib,importheader)]} { continue }
                append out $vTcl(head,$lib,importheader)
	      }
	    
	      vTcl:dump:sourcing_footer out
	      puts $output $out
	    
        }
        
        ## Project header
        puts $output "[subst $vTcl(head,proj)]\n"
        
        ## Save compounds (if any)
        puts $output [vTcl::project::saveCompounds main]
        
        ## Code to load images
        vTcl:image:generate_image_stock $output
        vTcl:image:generate_image_user  $output
        
        ## Code to load fonts
        vTcl:font:generate_font_stock   $output
        vTcl:font:generate_font_user    $output
        
        # moved init proc after user procs so that the init
        # proc can call any user proc
        ::vTcl:::tops::handleRunvisible withdraw
        if {$vTcl(save) == "all"} {
            puts $output $vTcl(head,exports)
            puts $output [vTcl:export_procs]
            puts $output [vTcl:dump:project_info \
                [file dirname $file] $vTcl(project,name)]
            puts $output $vTcl(head,procs)
            puts $output [vTcl:save_procs]
            puts $output [vTcl:dump_proc init "Initialization "]
            puts $output "init \$argc \$argv\n"
            puts $output $vTcl(head,gui)
            puts $output [vTcl:save_tree . [file dirname $file] $vTcl(project,name)]
            puts $output "main \$argc \$argv"
        } else {
            puts $output [vTcl:save_tree $vTcl(w,widget)]
        }
        
        ::vTcl:::tops::handleRunvisible deiconify
        vTcl:addRcFile $file
        
        close $output
        
	  vTcl:status "Done Saving"
        
	  set vTcl(file,mode) ""
        
	  if {$vTcl(w,save) != ""} {
            if {$vTcl(w,widget) != $vTcl(w,save)} {
                vTcl:active_widget $vTcl(w,save)
            }
            vTcl:create_handles $vTcl(w,save)
        }
	
        # it really annoyed me when I had to set the file as
        # executable under Linux to be able to run it, so here
        # we go
        if {$vTcl(pr,saveasexecutable) &&
            $tcl_platform(platform) == "unix"} {
            file attributes $file -permissions [expr 0755]
        }
        # The catch ends below.	
    } errResult]} {
        # End the catch and give feedback here if things went wrong.
	  ::vTcl::MessageBox -icon error -message \
            "An error occured during the save operation:\n\n$errResult" \
            -title "Save Error!" -type ok	

	  # Move the original file back and do not mess with the .bak file.  
        # First of all, close the messed up and uncompletely saved file.
        if {$output != ""} {
            close $output
        }
	if {[file exists ${file}.tmp]} {
            file rename -force ${file}.tmp ${file}
        }
    } else {
        if {[vTcl::project::isMultipleFileProject]} {
            ## If we get here then we are testing to see that the files associated with the 
            ## multifile project all dumped to .bak files ok. If any ${file}.tmp files with
            ## the project exist then we do not want to finish the dump with the project file.
            set tops ". $vTcl(tops)"
            ## The tmpSentry will come out 0 still if all the .tmp files for the project are gone.
            set tmpSentry 0
            foreach i $tops {
                if {[file exists [file join [file dirname $file] [vTcl:dump:get_multifile_project_dir $vTcl(project,name)] f$i.tcl.tmp]]} {
                    set tmpSentry 1
                }
            }
            if {!$tmpSentry} {
                ## All well if we get here and we need to move the ${file}.tmp to ${fiel}.bak
                if {[file exists ${file}.tmp]} {
                    file rename -force ${file}.tmp ${file}.bak
                }
                set vTcl(change) 0
                wm title $vTcl(gui,main) "Visual Tcl - $vTcl(project,name)"
            } else {
                ## The backup has failed to move the original main file back.
                if {[file exists ${file}.tmp]} {
                    file rename -force ${file}.tmp ${file}
                }
                ## Let the user know that all the associated files for the project did not backup correct.
                ## Advise them to choose save as.
                ::vTcl::MessageBox -icon error -message \
                 "An error occured during the multifile backup operation:\n\nPlease choose Save As and save in a new location!" \
                 -title "Save Error!" -type ok	
            }
        } else {
            ## All well if we get here and we need to move the ${file}.tmp to ${fiel}.bak
            if {[file exists ${file}.tmp]} {
               file rename -force ${file}.tmp ${file}.bak
            }
            set vTcl(change) 0
            wm title $vTcl(gui,main) "Visual Tcl - $vTcl(project,name)"
        }
    }
    # @@end_change 20030409 Nelson bug 415090
}

proc vTcl:quit {} {
    global vTcl
    set vTcl(quit) 1

    ## If the project has changed, close it before exiting.
    if {$vTcl(change)} {
	if {[vTcl:close] == -1} { return }
    }

    if {[winfo exists .vTcl.tip]} {
       eval [wm protocol .vTcl.tip WM_DELETE_WINDOW]
    }
    vTcl:save_prefs
    vTcl:exit
}

proc vTcl:save_prefs {} {
    global vTcl

    set w $vTcl(gui,main)
    set pos [vTcl:get_win_position $w]
    set output "set vTcl(geometry,$w) $vTcl(pr,geom_vTcl)$pos\n"
    set showlist ""

    ## If the window exists but is not visible, we still want to save its
    ## geometry, just not add it to the showlist.
    foreach i $vTcl(windows) {
        if {[winfo exists $i]} {
	    append output "set vTcl(geometry,${i}) [wm geometry $i]\n"
	    if {[vTcl:streq [wm state $i] "normal"]} { lappend showlist $i }
        } else {
            catch {
                append output "set vTcl(geometry,${i}) $vTcl(geometry,${i})\n"
            }
        }
    }
    append output "set vTcl(gui,showlist) \"$showlist\"\n"
    foreach i [array names vTcl pr,*] {
        append output "set vTcl($i) [list $vTcl($i)]\n"
    }

    if {![info exists vTcl(rcFiles)]} { set vTcl(rcFiles) {} }
    append output "set vTcl(rcFiles) \[list $vTcl(rcFiles)\]\n"
    catch {
        set file [open $vTcl(CONF_FILE) w]
        puts $file $output
        close $file
    }
}

proc vTcl:find_files {base pattern} {
    global vTcl
    set dirs ""
    set match ""
    set files [lsort [glob -nocomplain [file join $base *]]]
    if {$pattern == ""} {set pattern "*"}
    foreach i $files {
        if {[file isdir $i]} {
            lappend dirs $i
        } elseif {[string match $pattern $i]} {
            lappend match $i
        }
    }
    return "$dirs $match"
}

proc vTcl:get_file {mode {title File} {ext .tcl}} {
    global vTcl tk_version tcl_platform tcl_version tk_strictMotif
    if {![info exists vTcl(pr,initialdir)]} {
        set vTcl(pr,initialdir) [pwd]
    }
    if {[string tolower $mode] == "open"} {
        set vTcl(file,mode) "Open"
    } else {
        set vTcl(file,mode) "Save"
    }
    set types { {{Tcl Files} {*.tcl}}
                {{All}       {*}} }
    set tk_strictMotif 0
    switch $mode {
        open {
            set file [tk_getOpenFile -defaultextension $ext -title $title \
                -initialdir $vTcl(pr,initialdir) -filetypes $types]
        }
        save {
            set initname [file tail $vTcl(project,file)]
            if {$initname == ""} {
                set initname "unknown.tcl"
            }
            if {$tcl_platform(platform) == "macintosh"} then {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(pr,initialdir) -initialfile $initname]
            } else {
                set file [tk_getSaveFile -defaultextension $ext -title $title \
                    -initialdir $vTcl(pr,initialdir) -filetypes $types \
                    -initialfile $initname]
            }
        }
    }
    set tk_strictMotif 1
    if {$file != ""} {
        set vTcl(pr,initialdir) [file dirname $file]
    }
    catch {cd [file dirname $file]}
    return $file
}

proc vTcl:restore {} {
    global vTcl

    set file $vTcl(project,file)

    if {[lempty $file]} { return }
    set bakFile $file.bak
    if {![file exists $bakFile]} {
        ## change by Nelson 20030227
        ## Provides the user feedback about no $file.bak existance
        ## and potential reason why one might not exist.

        ::vTcl::MessageBox -icon error -message \
         "A backup file $bakFile does not exist! Backup files are only created upon save operations beyond the original creation of the file." \
         -title "Restore Error!" -type ok
          
	return
    }
    
    if {[vTcl::project::isMultipleFileProject]} {
        ## If we get here then it is a multi file project. So lets try to restore from each backup file.
        set restoreProject $vTcl(project,name)
        set tops ". $vTcl(tops)"
        vTcl:close
        foreach i $tops {
            set multiFile [file join [file dirname $file] [vTcl:dump:get_multifile_project_dir $restoreProject] f$i.tcl]
            set bakMultiFile [file join [file dirname $file] [vTcl:dump:get_multifile_project_dir $restoreProject] $multiFile.bak]
            if {[file exists $bakMultiFile ]} {
                file copy -force -- $bakMultiFile $multiFile
            } else {
                ::vTcl::MessageBox -icon error -message \
                 "A backup file $bakMultiFile does not exist!\n $tops \n Backup files are only created upon save operations beyond the original creation of the file." \
                 -title "Restore Error!" -type ok
            }
        }
        file copy -force -- $bakFile $file
        update idletasks
        vTcl:open $file

    } else {
        ## If we are here then it is a single file backup.
        vTcl:close
        file copy -force -- $bakFile $file
        vTcl:open $file
    }    
}

namespace eval vTcl::project {

    proc isMultipleFileProject {} {
        return [expr {$::vTcl(pr,projecttype) == "multiple"}]
    }

    proc initModule {moduleName} {
        namespace eval ::vTcl::modules::${moduleName} {
            variable procs
            set procs ""
            variable compounds
            set compounds ""
            ## TODO: this will probably be discarded once we have real modules
            ##       where any object (toplevel, procedure, image, font, ...) can
            ##       be contained and saved into a particular module
            variable projectType
            set projectType $::vTcl(pr,projecttype)
        }
    }

    proc addCompound {moduleName type compoundName} {
        upvar ::vTcl::modules::${moduleName}::compounds compounds
        set compound $type
        lappend compounds [list $type $compoundName]
        set compounds [lsort -unique $compounds]
    }

    proc saveCompounds {moduleName} {
        upvar ::vTcl::modules::${moduleName}::compounds compounds

        set output ""
        foreach compound $compounds {
            set type         [lindex $compound 0]
            set compoundName [lindex $compound 1]
            append output {#############################################################################}
            append output \n
            append output {## Compound: }
            append output "$type / $compoundName\n"
            append output [vTcl:dump_namespace vTcl::compounds::${type}::[list $compoundName]]
        }

        return $output
    }

    proc getCompounds {moduleName} {
        return [vTcl:at ::vTcl::modules::${moduleName}::compounds]
    }

    proc closeCompounds {moduleName} {
        upvar ::vTcl::modules::${moduleName}::compounds compounds

        foreach compound $compounds {
            closeCompound $compound
        }
        set compounds ""
    }

    proc closeCompound {compound} {
        set type         [lindex $compound 0]
        set compoundName [lindex $compound 1]
        vTcl::compounds::deleteCompound $type $compoundName
    }

    ## returns the required libraries for the inserted compounds
    proc requiredLibraries {moduleName} {
        upvar ::vTcl::modules::${moduleName}::compounds compounds

        set result "core"
        foreach compound $compounds {
            set type         [lindex $compound 0]
            set compoundName [lindex $compound 1]
            set result [concat $result [vTcl::compounds::getLibraries $type $compoundName]]
        }

        return [lsort -unique $result]
    }

    ## returns the list of requested libraries
    proc getLibrariesToLoad {} {
    	  set ::vTcl::toload ""
        if {[info exists ::vTcl(pr,loadlibs)]} {
            foreach lib $::vTcl(pr,loadlibs) {
                lappend ::vTcl::toload [file join $::vTcl(LIB_DIR) $lib]
            }
        } else {
            set ::vTcl::toload $::vTcl(LIB_WIDG)
        }

        return $::vTcl::toload
    }

    ## sets the list of request libraries (each lib is filename without path)
    proc setLibrariesToLoad {libs} {
        set ::vTcl(pr,loadlibs) $libs
    }
}



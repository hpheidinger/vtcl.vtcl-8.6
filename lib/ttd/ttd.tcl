# Tcl/Tk text dump
#
# Copyright (c) 1999, Bryan Douglas Oakley
# All Rights Reserved.
#
# This code is provide as-is, with no warranty expressed or implied. Use 
# at your own risk.
#
#
package provide ttd 1.0

namespace eval ::ttd {

    # this is the public interface
    namespace export get insert
    
    variable code
    variable ttdVersion {}
    variable taglist
    variable safeInterpreter
}

proc ::ttd::get {args} {
    ::ttd::init;    # one time initialization
    set argc [llength $args]
    if {$argc == 0} {
	error "wrong \# args: must be ::ttd::get pathName ?index1? ?index2?"
    }
    set w [lindex $args 0]

    if {[winfo class $w] != "Text"} {
	error "\"$w\" is not a text widget"
    }

    if {$argc == 1} {
	set index1 "1.0"
	# one might think we want "end -1c" here, but if we do that
	# we end up losing some tagoff directives. We'll remove the
	# trailing space later.
	set index2 "end"
    } elseif {$argc == 2} {
	set index1 [lindex $args 1]
	set index2 "[$w index {$index1 + 1c}]"
    } else {
	set index1 [lindex $args 1]
	set index2 [lindex $args 2]
    }
    
    set tagData {}
    set imageData {}

    set header "# -*- tcl -*-\n#\n\n"
    set version [list ttd.version 1.0]
    set result [list ]

    # we use these arrays to keep track of actual images, tags
    # and windows (though, not really windows...)
    catch {unset tags}
    catch {unset images}
    catch {unset windows}

    foreach {key value index} [$w dump $index1 $index2] {
	switch -exact -- $key {
	    tagon {
		lappend result [list ttd.tagon $value]
		if {![info exists tags($value)]} {
		    # we need to steal all of the configuration data
		    set tagname $value
		    set tags($tagname) {}
		    foreach item [$w tag configure $tagname] {
			set value [lindex $item 4]
			if {[string length $value] > 0} {
			    set option [lindex $item 0]
			    lappend tags($tagname) $option $value
			}
		    }
		}
	    }
	    tagoff {
		lappend result [list ttd.tagoff $value]
	    }
	    text {
		lappend result [list ttd.text $value]
	    }
	    mark {
		# bah! marks aren't interesting, are they?
#		lappend result [list ttd.mark $value]
	    }
	    image {
		# $value is an internal identifier. We need the actual
		# image name so we can grab its data...
		set imagename [$w image cget $value -image]
		set image [list ttd.image]

		# this gets all of the options for this image
		# at this location (such as -align, etc)
		foreach item [$w image configure $value] {
		    set value [lindex $item 4]
		    if {[string length $value] != 0} {
			set option [lindex $item 0]
			lappend image $option $value
		    }
		}
		lappend result $image

		# if we don't yet have a definition for this
		# image, grab it
		if {[string length $imagename] > 0 \
			&& ![info exists images($imagename)]} {
		    # we need to steal all of the configuration data
		    set images($imagename) $imagename
		    foreach item [$imagename configure] {
			set value [lindex $item 4]
			if {[string length $imagename] > 0} {
			    set option [lindex $item 0]
			    lappend images($imagename) $option $value
			}
		    }
		}
	    }

	    window {
		set window [list ttd.window $value]
		foreach item [$w window configure $index] {
		    set value [lindex $item 4]
		    if {[string length $value] != 0} {
			set option [lindex $item 0]
			lappend window $option $value
		    }
		}
		lappend result $window
	    }
	}

    }
    
    # process tags in priority order; ignore tags that aren't used
    set tagData {}
    foreach tag [$w tag names] {
	if {[info exists tags($tag)]} {
	    lappend tagData [concat ttd.tagdef $tag $tags($tag)]
	}
    }
    set imageData {}
    foreach image [array names images] {
	lappend imageData [concat ttd.imgdef $images($image)]
    }

    # remove the trailing newline that the text widget added
    # for us
    set result [lreplace $result end end]

    set tmp $header
    append tmp "$version\n\n"
    append tmp "[join $tagData \n]\n\n"
    append tmp "[join $imageData \n]\n\n"
    append tmp "[join $result \n]\n"
    return $tmp
}

proc ::ttd::insert {w ttd} {
    ::ttd::init;    # one time initialization
    variable ttdVersion {}
    variable taglist
    variable safeInterpreter
    variable ttdCode

    # create a safe interpreter, if we haven't already done so
    catch {interp delete $safeInterpreter }
    set safeInterpreter [interp create -safe]

    # we want the widget command to be available to the
    # safe interpreter. Also, the text may include embedded
    # images, so we need the image command available as well.
    interp alias $safeInterpreter masterTextWidget {} $w
    interp alias $safeInterpreter image {} image
#    interp alias $safeInterpreter puts {} puts

    # this defines the commands we use to parse the data
    $safeInterpreter eval $ttdCode

    # this processes the data. Alert the user if there was
    # a problem.
    if {[catch {$safeInterpreter eval $ttd} error]} {
	set message "Error opening file:\n\n$error"
	tk_messageBox -icon info \
		-message $message \
		-title "Bad file" \
		-type ok 
    }

    # and clean up after ourselves
    interp delete $safeInterpreter
}

proc ::ttd::init {} {
## already initialized?
if {[info exists ::ttd::ttdCode]} {return}

variable code
variable ttdCode
variable ttdVersion {}
variable taglist
variable safeInterpreter

# this code defines the commands which are embedded in the ttd
# data. It should only executed in a safe interpreter.
set ttdCode {
    set taglist ""
    set command ""
    set ttdVersion ""

    proc ttd.version {version} {
	global ttdVersion
	set ttdVersion $version
    }

    proc ttd.window {args} {
	# not supported yet
	error "embedded windows aren't supported in this version"
    }

    proc ttd.image {args} {
	global taglist

	set index [masterTextWidget index insert]
	eval masterTextWidget image create $index $args

	# we want the current tags associated with the image...
	# (I wonder why I can't supply tags at the time I create
	# the image, like I can when I insert text?)
	foreach tag $taglist {
	    masterTextWidget tag add $tag $index
	}
    }

    proc ttd.imgdef {name args} {
	eval image create photo $name $args
    }

    proc ttd.tagdef {name args} {
	eval masterTextWidget tag configure [list $name] $args
    }

    proc ttd.text {string} {
	global taglist
	masterTextWidget insert insert $string $taglist
    }

    proc ttd.tagon {tag} {
	global taglist

	# I'm confused by this, but we need to keep track of our
	# tags in reverse order.
	set taglist [concat [list $tag] $taglist]
    }

    proc ttd.tagoff {tag} {
	global taglist

	set i [lsearch -exact $taglist $tag]
	if {$i >= 0} {
	    set taglist [lreplace $taglist $i $i]
	}
	masterTextWidget tag remove $tag insert
    }

    proc ttd.mark {name} {
	masterTextWidget mark set $name [masterTextWidget index insert]
    }
}
}
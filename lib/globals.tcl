##############################################################################
# $Id: globals.tcl,v 1.42 2003/05/14 06:10:19 cgavin Exp $
#
# globals.tcl - global variables
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

# bind record format:
# { {bindtag} {bind list record} }  ...

# bind list record format:
# { {event} {command} } ...

# option list record format:
# { {name} {value} } ...

# widget manager record format:
# {type} {option list} {manager specific list}

global vTcl
namespace eval ::vTcl::balloon {}

set vTcl(running)        1
set vTcl(action)         ""
set vTcl(action_index)   -1
set vTcl(action_limit)   -1
set ::vTcl::balloon::first  0
set ::vTcl::balloon::set    0
set ::vTcl::balloon::soon   0
set vTcl(bind,ignore)    ""
set vTcl(change)         0
set vTcl(console)        0
set vTcl(cursor,last)    ""
set vTcl(procs)          "init main"
set vTcl(state)		 "normal"
set vTcl(file,base)      [pwd]
set vTcl(file,mode)      ""
set vTcl(file,type)      "*.tcl"
set vTcl(mouse,X)	 0
set vTcl(mouse,Y)	 0
set vTcl(mouse,x)	 0
set vTcl(mouse,y)	 0
set vTcl(grid,x)         5
set vTcl(grid,y)         5
set vTcl(gui,main)       ".vTcl"
set vTcl(gui,ae)         "$vTcl(gui,main).ae"
set vTcl(gui,command)    "$vTcl(gui,main).comm"
set vTcl(gui,console)    "$vTcl(gui,main).con"
set vTcl(gui,proc)       "$vTcl(gui,main).proc"
set vTcl(gui,proclist)   "$vTcl(gui,main).proclist"
set vTcl(gui,toplist)    "$vTcl(gui,main).toplist"
set vTcl(gui,mgr)        "$vTcl(gui,main).mgr"
set vTcl(gui,prefs)      "$vTcl(gui,main).prefs"
set vTcl(gui,rc_menu)    "$vTcl(gui,main).rc"
set vTcl(gui,varlist)    "$vTcl(gui,main).varlist"
set vTcl(gui,statbar)    "$vTcl(gui,main).stat.f.bar"
set vTcl(gui,showlist)   ".vTcl.ae"
set vTcl(h,exist)        0
set vTcl(h,size)         3
set vTcl(hide)           ""
set vTcl(item_num)       1
set vTcl(key,x)          1
set vTcl(key,y)          1
set vTcl(key,w)          1
set vTcl(key,h)          1
set vTcl(mgrs,update)    yes
# preferences
set vTcl(pr,attr_on)     1
set vTcl(pr,balloon)     1
set vTcl(pr,encase)      list
set vTcl(pr,font_dlg)    ""
set vTcl(pr,font_fixed)  ""
set vTcl(pr,getname)     0
set vTcl(pr,geom_on)     1
set vTcl(pr,geom_comm)   "350x200"
set vTcl(pr,geom_proc)   "500x400"
set vTcl(pr,geom_vTcl)	 "565x110"
set vTcl(pr,geom_new)	 "609x422+220+159"
set vTcl(pr,info_on)     1
set vTcl(pr,manager)     place
set vTcl(pr,shortname)   1
set vTcl(pr,saveglob)    0
set vTcl(pr,show_func)   1
set vTcl(pr,show_var)    -1
set vTcl(pr,show_top)    -1
set vTcl(pr,winfocus)    0
set vTcl(pr,autoplace)	 0
set vTcl(pr,autoalias)	 1
set vTcl(pr,multiplace)  0
set vTcl(pr,cmdalias)    1
set vTcl(pr,fullcfg)     0
set vTcl(pr,autoloadcomp) 0
set vTcl(pr,autoloadcompfile) ""
set vTcl(pr,projecttype) "single"
set vTcl(pr,imageeditor) ""
set vTcl(pr,saveimagesinline) 0
set vTcl(pr,projfile)    0
set vTcl(pr,saveasexecutable) 1
set vTcl(pr,dontshowtips) 0
set vTcl(pr,dontshownews) 0
set vTcl(pr,bgcolor) ""
## this is for Linux/UNIX systems only, on Windows we use default colors
if {$tcl_platform(platform) != "windows"} {
    set vTcl(pr,bgcolor) "#d9d9d9"
}
set vTcl(pr,entrybgcolor) #ffffff
set vTcl(pr,entryactivecolor) #ffffff
set vTcl(pr,listboxbgcolor) #ffffff
set vTcl(pr,treehighlight) #0000ff
set vTcl(pr,texteditor)	 ""
set vTcl(numRcFiles)	 5
# end preferences
set vTcl(proc,name)      ""
set vTcl(proc,args)      ""
set vTcl(proc,body)      ""
set vTcl(proc,ignore)    "tcl* tk* auto_* vTcl:* bgerror .*"
set vTcl(project,name)   ""
set vTcl(project,file)   ""
set vTcl(project,dir)    "Projects"
set vTcl(project,types)  {"Visual Tcl Project"}
set vTcl(quit)           0
set vTcl(tool,list)      ""
set vTcl(tool,last)      ""
set vTcl(toolbar,width) 2
set vTcl(tops)           ""
set vTcl(undo)           ""
set vTcl(vars)           ""
set vTcl(var,name)       ""
set vTcl(var,value)      ""
set vTcl(var,ignore)     "vTcl.*|tix.*"
set vTcl(var_update)     "yes"
set vTcl(w,alias)        ""
set vTcl(w,class)        ""
set vTcl(w,def_mgr)      $vTcl(pr,manager)
set vTcl(w,grabbed)      0
set vTcl(w,info)         ""
set vTcl(w,insert)       .
set vTcl(w,libs)         ""
set vTcl(w,libsnames)    ""
set vTcl(w,manager)      ""
set vTcl(w,mgrs)         "grid pack place wm"
set vTcl(w,options)      ""
set vTcl(w,widget)       ""
set vTcl(winname)        "vTclWindow"
set vTcl(windows)        ".vTcl.toolbar .vTcl.mgr .vTcl.ae .vTcl.wstat
                          .vTcl.proclist .vTcl.toplist .vTcl.tree
                          .vTcl.tkcon .vTcl.prefs .vTcl.about .vTcl.bind .vTcl.imgManager
                          .vTcl.fontManager .vTcl.inspector .vTcl.help"
set vTcl(newtops)        1
set vTcl(mode)           "EDIT"
set vTcl(pwd)            [pwd]
set vTcl(redo)           ""
set vTcl(save)           ""
set vTcl(tab)            "    "
set vTcl(tab2)           "$vTcl(tab)$vTcl(tab)"

set vTcl(images,stock)   ""
set vTcl(images,user)    ""
set vTcl(fonts,stock)    ""
set vTcl(fonts,user)     ""

set vTcl(pr,proprelief)  "flat"

set vTcl(reliefs)        "flat groove raised ridge sunken"

set vTcl(cmpd,list)      ""
set vTcl(syscmpd,list)   ""

set vTcl(attr,tops)     "aspect command focusmodel geometry grid
                         iconbitmap iconmask iconname iconposition
                         iconwindow maxsize minsize overrideredirect
                         resizable sizefrom state title"

set vTcl(attr,winfo)    "children class geometry height ismapped
                         manager name parent rootx rooty toplevel
                         width x y"

#
# Default attributes to append on insert
#
set vTcl(grid,insert)   ""
set vTcl(pack,insert)   ""
set vTcl(place,insert)  "-x 5 -y 5 -bordermode ignore"

#
# Geometry Manager Attributes       LabelName     Balloon  Type   Choices   CfgCmd     Group
#
set vTcl(m,pack,list) "-anchor -expand -fill -side -ipadx -ipady -padx -pady -in"
set vTcl(m,pack,-anchor)           { anchor          {}       choice  {n ne e se s sw w nw center} }
set vTcl(m,pack,-expand)           { expand          {}       boolean {0 1} }
set vTcl(m,pack,-fill)             { fill            {}       choice  {none x y both} }
set vTcl(m,pack,-side)             { side            {}       choice  {top bottom left right} }
set vTcl(m,pack,-ipadx)            { {int. x pad}    {}       type    {} }
set vTcl(m,pack,-ipady)            { {int. y pad}    {}       type    {} }
set vTcl(m,pack,-padx)             { {ext. x pad}    {}       type    {} }
set vTcl(m,pack,-pady)             { {ext. y pad}    {}       type    {} }
set vTcl(m,pack,-in)               { inside          {}       type    {} }
set vTcl(m,pack,extlist) "propagate"
set vTcl(m,pack,propagate)         { propagate       {}        boolean {0 1} {vTcl:pack:conf_ext} }

set vTcl(m,place,list) "-anchor -x -y -relx -rely -width -height -relwidth -relheight -in"
set vTcl(m,place,extlist) ""
set vTcl(m,place,-anchor)          { {anchor}        {}       choice  {n ne e se s sw w nw center} }
set vTcl(m,place,-x)               { {x position}    {}       type    {} }
set vTcl(m,place,-y)               { {y position}    {}       type    {} }
set vTcl(m,place,-width)           { width           {}       type    {} }
set vTcl(m,place,-height)          { height          {}       type    {} }
set vTcl(m,place,-relx)            { {relative x}    {}       type    {} }
set vTcl(m,place,-rely)            { {relative y}    {}       type    {} }
set vTcl(m,place,-relwidth)        { {rel. width}    {}       type    {} }
set vTcl(m,place,-relheight)       { {rel. height}   {}       type    {} }
set vTcl(m,place,-in)              { inside          {}       type    {} }

set vTcl(m,grid,list) "-sticky -row -column -rowspan -columnspan -ipadx -ipady -padx -pady -in"
set vTcl(m,grid,-sticky)           { sticky          {}       type    {n s e w} }
set vTcl(m,grid,-row)              { row             {}       type    {} }
set vTcl(m,grid,-column)           { column          {}       type    {} }
set vTcl(m,grid,-rowspan)          { {row span}      {}       type    {} }
set vTcl(m,grid,-columnspan)       { {col span}      {}       type    {} }
set vTcl(m,grid,-ipadx)            { {int. x pad}    {}       type    {} }
set vTcl(m,grid,-ipady)            { {int. y pad}    {}       type    {} }
set vTcl(m,grid,-padx)             { {ext. x pad}    {}       type    {} }
set vTcl(m,grid,-pady)             { {ext. y pad}    {}       type    {} }
set vTcl(m,grid,-in)               { inside          {}       type    {} }

set vTcl(m,grid,extlist) "row,weight column,weight row,minsize  column,minsize propagate"
set vTcl(m,grid,column,weight)     { {col weight}    {}       type    {} {vTcl:grid:conf_ext} }
set vTcl(m,grid,column,minsize)    { {col minsize}   {}       type    {} {vTcl:grid:conf_ext} }
set vTcl(m,grid,row,weight)        { {row weight}    {}       type    {} {vTcl:grid:conf_ext} }
set vTcl(m,grid,row,minsize)       { {row minsize}   {}       type    {} {vTcl:grid:conf_ext} }
set vTcl(m,grid,propagate)         { propagate       {}       boolean {0 1} {vTcl:grid:conf_ext} }

set vTcl(m,wm,list) ""
set vTcl(m,wm,extlist) "set,origin geometry,x geometry,y set,size geometry,w geometry,h
                        resizable,w resizable,h minsize,x minsize,y maxsize,x maxsize,y state title runvisible"
set vTcl(m,wm,savelist) "set,origin set,size runvisible"
set vTcl(m,wm,set,origin)          { {set origin}    {}       boolean {0 1}  {vTcl:wm:conf_geom} }
set vTcl(m,wm,geometry,x)          { {x position}    {}       type    {} {vTcl:wm:conf_geom} }
set vTcl(m,wm,geometry,y)          { {y position}    {}       type    {} {vTcl:wm:conf_geom} }
set vTcl(m,wm,set,size)            { {set size}      {}       boolean {0 1}  {vTcl:wm:conf_geom} }
set vTcl(m,wm,geometry,w)          { width           {}       type    {} {vTcl:wm:conf_geom} }
set vTcl(m,wm,geometry,h)          { height          {}       type    {} {vTcl:wm:conf_geom} }
set vTcl(m,wm,resizable,w)         { {resize width}  {}       boolean {0 1} {vTcl:wm:conf_resize} }
set vTcl(m,wm,resizable,h)         { {resize height} {}       boolean {0 1} {vTcl:wm:conf_resize} }
set vTcl(m,wm,minsize,x)           { {x minsize}     {}       type    {} {vTcl:wm:conf_minmax} }
set vTcl(m,wm,minsize,y)           { {y minsize}     {}       type    {} {vTcl:wm:conf_minmax} }
set vTcl(m,wm,maxsize,x)           { {x maxsize}     {}       type    {} {vTcl:wm:conf_minmax} }
set vTcl(m,wm,maxsize,y)           { {y maxsize}     {}       type    {} {vTcl:wm:conf_minmax} }
set vTcl(m,wm,state)               { state           {}       choice  {iconify deiconify withdraw} {vTcl:wm:conf_state} }
set vTcl(m,wm,runvisible)          { {run visible}   {}       boolean {0 1} {vTcl:wm:conf_geom} }
set vTcl(m,wm,title)               { title           {}       type    {} {vTcl:wm:conf_title} }

set vTcl(m,menebar,list) ""
set vTcl(m,menubar,extlist) ""

# Provide default values for menus managed by wm
set vTcl(w,wm,geometry,w)    0
set vTcl(w,wm,geometry,h)    0
set vTcl(w,wm,geometry,x)    0
set vTcl(w,wm,geometry,y)    0
set vTcl(w,wm,minsize,x)     0
set vTcl(w,wm,minsize,y)     0
set vTcl(w,wm,maxsize,x)     0
set vTcl(w,wm,maxsize,y)     0
set vTcl(w,wm,aspect,minnum) 0
set vTcl(w,wm,aspect,minden) 1
set vTcl(w,wm,aspect,maxnum) 0
set vTcl(w,wm,aspect,maxden) 1
set vTcl(w,wm,resizable,w)   0
set vTcl(w,wm,resizable,h)   0
set vTcl(w,wm,set,origin)    0
set vTcl(w,wm,set,size)      0
set vTcl(w,wm,runvisible)    1

set vTcl(head,proj) [string trim {
#############################################################################
# Visual Tcl v$vTcl(version) Project
#
}]

set vTcl(head,projfile) [string trim {
#############################################################################
# Visual Tcl v$vTcl(version) Window, part of a multiple files project
#
}]

set vTcl(head,compounds) [string trim {
#############################################################################
# Visual Tcl v$::vTcl(version) Compound Library
#
}]


set vTcl(head,exports) [string trim {
#################################
# VTCL LIBRARY PROCEDURES
#
}]

set vTcl(head,procs) [string trim {
#################################
# USER DEFINED PROCEDURES
#
}]

set vTcl(head,gui) [string trim {
#################################
# VTCL GENERATED GUI PROCEDURES
#
}]

set vTcl(head,proc,widgets) "$vTcl(tab)###################
$vTcl(tab)# CREATING WIDGETS
$vTcl(tab)###################
"

set vTcl(head,proc,geometry) "$vTcl(tab)###################
$vTcl(tab)# SETTING GEOMETRY
$vTcl(tab)###################
"


# @@change by Christian Gavin 3/19/2000
# patterns and colors for syntax colouring
# @@end_change

set vTcl(syntax,tags) "vTcl:dollar vTcl:command vTcl:option vTcl:parenthesis vTcl:bracket vTcl:window vTcl:string vTcl:comment"

set vTcl(syntax,vTcl:parenthesis)            {\([^ ]+\)}
set vTcl(syntax,vTcl:parenthesis,configure)  {-foreground #00A000}

set vTcl(syntax,vTcl:dollar)            {\$[a-zA-Z0-9_]+}
set vTcl(syntax,vTcl:dollar,configure)  {-foreground #00A000}

set vTcl(syntax,vTcl:bracket)           {\[|\]|\{|\}|\(|\)}
set vTcl(syntax,vTcl:bracket,configure) {-foreground #FF0000}

set vTcl(syntax,vTcl:command)           {[a-zA-Z0-9_\-:]+}
set vTcl(syntax,vTcl:command,configure) {-foreground #B000B0}
set vTcl(syntax,vTcl:command,validate)  vTcl:syntax:iscommand

set vTcl(syntax,vTcl:option)            {\-[a-zA-Z0-9]+}
set vTcl(syntax,vTcl:option,configure)  {-foreground #0000FF}

set vTcl(syntax,vTcl:comment)		{# [,\. a-zA-Z0-9:=_?()@'/-<>"	]+}
set vTcl(syntax,vTcl:comment,configure) {-foreground #B0B0B0}

set vTcl(syntax,vTcl:string)		{\"[^\"]*\"}
set vTcl(syntax,vTcl:string,configure)  {-foreground #00A0A0}

set vTcl(syntax,vTcl:window)            {\.[a-zA-Z0-9_\.]+}
set vTcl(syntax,vTcl:window,configure)  {-foreground #800060}

proc vTcl:syntax:iscommand {command} {
    return [ expr { [info command $command] == $command } ]
}

# special case for -in option
set vTcl(option,noencase,-in) 1



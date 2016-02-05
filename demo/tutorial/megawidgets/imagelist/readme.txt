This sample contains the following files:

imagelist.tcl
    a reusable widget that can be imported into any vTcl project

imagelist_project.tcl
    the project that is used to edit the megawidget, its children,
    and the code for the megawidget

imagelist_test.tcl
    a test project that demonstrates the use of an image list

==============================================================

Here is how the "imagelist.tcl" file was created:

- open the imagelist_project.tcl file in Visual Tcl

- to create the megawidget, select the "MegaWidget" in the widget
  tree, create a compound, name it "Image List" and select all
  the procedures in the ::imagelist namespace

- to save the megawidget, select "Save Compounds" from the 
  Compounds menu and save as "imagelist.tcl"

Here is how to use the test project:

- open it in vTcl

- switch to TEST mode

- type in a path in the entry box; this path must contain .jpg images

- click on "View"

- now go to the command console, and try a few commands:

  ImageList1 configure
  ImageList1 cget -directory
  ImageList1 configure -background red

NOTE: you need to have the TableList package installed in order to run
      this sample. You can get TableList from www.nemethi.de


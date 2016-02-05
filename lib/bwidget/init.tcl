
if { $tcl_platform(platform) == "windows" } {
    option add *Listbox.background      SystemWindow widgetDefault
    option add *ListBox.background      SystemWindow widgetDefault
    option add *Button.padY             0 widgetDefault
    option add *ButtonBox.padY          0 widgetDefault
    option add *Dialog.padY             0 widgetDefault
    option add *Dialog.anchor           e widgetDefault
} else {
    option add *Dialog.separator        1  widgetDefault
    option add *MainFrame.relief        raised widgetDefault
    option add *MainFrame.separator     none   widgetDefault
}

option read [file join $::BWIDGET::LIBRARY "lang" "en.rc"]

bind all <Key-Tab>       {focus [Widget::focusNext %W]}
bind all <Shift-Key-Tab> {focus [Widget::focusPrev %W]}

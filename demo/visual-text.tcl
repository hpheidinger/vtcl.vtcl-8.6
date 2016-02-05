#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

    switch $tcl_platform(platform) {
	windows {
	}
	default {
	    option add *Scrollbar.width 10
	}
    }
    
}


#############################################################################
## vTcl Code to Load Stock Images


if {![info exist vTcl(sourcing)]} {
#############################################################################
## Procedure:  vTcl:rename

proc {vTcl:rename} {name} {
regsub -all "\\." $name "_" ret
    regsub -all "\\-" $ret "_" ret
    regsub -all " " $ret "_" ret
    regsub -all "/" $ret "__" ret
    regsub -all "::" $ret "__" ret

    return [string tolower $ret]
}

#############################################################################
## Procedure:  vTcl:image:create_new_image

proc {vTcl:image:create_new_image} {filename {description {no description}} {type {}} {data {}}} {
global vTcl env

    # Does the image already exist?
    if {[info exists vTcl(images,files)]} {
        if {[lsearch -exact $vTcl(images,files) $filename] > -1} { return }
    }

    if {![info exists vTcl(sourcing)] && [string length $data] > 0} {
        set object [image create  [vTcl:image:get_creation_type $filename]  -data $data]
    } else {
        # Wait a minute... Does the file actually exist?
        if {! [file exists $filename] } {
            # Try current directory
            set script [file dirname [info script]]
            set filename [file join $script [file tail $filename] ]
        }

        if {![file exists $filename]} {
            set description "file not found!"
            set object [image create photo -data [vTcl:image:broken_image] ]
        } else {
            set object [image create  [vTcl:image:get_creation_type $filename]  -file $filename]
        }
    }

    set reference [vTcl:rename $filename]

    set vTcl(images,$reference,image)       $object
    set vTcl(images,$reference,description) $description
    set vTcl(images,$reference,type)        $type
    set vTcl(images,filename,$object)       $filename

    lappend vTcl(images,files) $filename
    lappend vTcl(images,$type) $object

    # return image name in case caller might want it
    return $object
}

#############################################################################
## Procedure:  vTcl:image:get_image

proc {vTcl:image:get_image} {filename} {
global vTcl
    set reference [vTcl:rename $filename]

    # Let's do some checking first
    if {![info exists vTcl(images,$reference,image)]} {
        # Well, the path may be wrong; in that case check
        # only the filename instead, without the path.

        set imageTail [file tail $filename]

        foreach oneFile $vTcl(images,files) {
            if {[file tail $oneFile] == $imageTail} {
                set reference [vTcl:rename $oneFile]
                break
            }
        }
    }
    return $vTcl(images,$reference,image)
}

#############################################################################
## Procedure:  vTcl:image:get_creation_type

proc {vTcl:image:get_creation_type} {filename} {
set ext [file extension $filename]
    set ext [string tolower $ext]

    switch $ext {
        .ppm -
        .gif    {return photo}
        .xbm    {return bitmap}
        default {return photo}
    }
}

#############################################################################
## Procedure:  vTcl:image:broken_image

proc {vTcl:image:broken_image} {} {
return {
        R0lGODdhFAAUAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwICAgP8AAAD/
        AP//AAAA//8A/wD//////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAACwAAAAAFAAUAAAIhAAPCBxIsKDBgwgPAljIUOBC
        BAkBPJg4UeBEBBAVPkCI4EHGghIHChAwsKNHgyEPCFBA0mFDkBtVjiz4AADK
        mAds0tRJMCVBBkAl8hwYMsFPBwyE3jzQwKhAoASUwmTagCjDmksbVDWIderC
        g1174gQ71CHFigfOhrXKUGfbrwnjyp0bEAA7
    }
}

foreach img {

        {{[file join / home cgavin vtcl2-0 images edit copy.gif]} {} stock {
R0lGODlhFAAUAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8AAA
AAAAKgAAVQAAfwAAqgAA1AAqAAAqKgAqVQAqfwAqqgAq1ABVAABVKgBVVQBV
fwBVqgBV1AB/AAB/KgB/VQB/fwB/qgB/1ACqAACqKgCqVQCqfwCqqgCq1ADU
AADUKgDUVQDUfwDUqgDU1CoAACoAKioAVSoAfyoAqioA1CoqACoqKioqVSoq
fyoqqioq1CpVACpVKipVVSpVfypVqipV1Cp/ACp/Kip/VSp/fyp/qip/1Cqq
ACqqKiqqVSqqfyqqqiqq1CrUACrUKirUVSrUfyrUqirU1FUAAFUAKlUAVVUA
f1UAqlUA1FUqAFUqKlUqVVUqf1UqqlUq1FVVAFVVKlVVVVVVf1VVqlVV1FV/
AFV/KlV/VVV/f1V/qlV/1FWqAFWqKlWqVVWqf1WqqlWq1FXUAFXUKlXUVVXU
f1XUqlXU1H8AAH8AKn8AVX8Af38Aqn8A1H8qAH8qKn8qVX8qf38qqn8q1H9V
AH9VKn9VVX9Vf39Vqn9V1H9/AH9/Kn9/VX9/f39/qn9/1H+qAH+qKn+qVX+q
f3+qqn+q1H/UAH/UKn/UVX/Uf3/Uqn/U1KoAAKoAKqoAVaoAf6oAqqoA1Koq
AKoqKqoqVaoqf6oqqqoq1KpVAKpVKqpVVapVf6pVqqpV1Kp/AKp/Kqp/Vap/
f6p/qqp/1KqqAKqqKqqqVaqqf6qqqqqq1KrUAKrUKqrUVarUf6rUqqrU1NQA
ANQAKtQAVdQAf9QAqtQA1NQqANQqKtQqVdQqf9QqqtQq1NRVANRVKtRVVdRV
f9RVqtRV1NR/ANR/KtR/VdR/f9R/qtR/1NSqANSqKtSqVdSqf9SqqtSq1NTU
ANTUKtTUVdTUf9TUqtTU1AAAAAwMDBkZGSYmJjMzMz8/P0xMTFlZWWZmZnJy
cn9/f4yMjJmZmaWlpbKysr+/v8zMzNjY2OXl5fLy8v/78KCgpICAgP8AAAD/
AP//AAAA//8A/wD//////yH5BAEAAPMALAAAAAAUABQAAAhzAOcJHEiwoMGD
CA3iW7gQQMKC+P5J/AfA4UOBEScCoHhxXsSK/xg2TJhRIj5uKLlVRPix4smU
Gy1CnBhSJQCbK2dWBPAyJUqZA0vW3FlRpUKKLn3CPDrxJNGbQAU+7ekzqkKc
Ra1CVPrz4lOiHcOKHfswIAA7}}
        {{[file join / home cgavin vtcl2-0 images edit add.gif]} {} stock {
R0lGODlhFAAUAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8AAA
AAAAKgAAVQAAfwAAqgAA1AAqAAAqKgAqVQAqfwAqqgAq1ABVAABVKgBVVQBV
fwBVqgBV1AB/AAB/KgB/VQB/fwB/qgB/1ACqAACqKgCqVQCqfwCqqgCq1ADU
AADUKgDUVQDUfwDUqgDU1CoAACoAKioAVSoAfyoAqioA1CoqACoqKioqVSoq
fyoqqioq1CpVACpVKipVVSpVfypVqipV1Cp/ACp/Kip/VSp/fyp/qip/1Cqq
ACqqKiqqVSqqfyqqqiqq1CrUACrUKirUVSrUfyrUqirU1FUAAFUAKlUAVVUA
f1UAqlUA1FUqAFUqKlUqVVUqf1UqqlUq1FVVAFVVKlVVVVVVf1VVqlVV1FV/
AFV/KlV/VVV/f1V/qlV/1FWqAFWqKlWqVVWqf1WqqlWq1FXUAFXUKlXUVVXU
f1XUqlXU1H8AAH8AKn8AVX8Af38Aqn8A1H8qAH8qKn8qVX8qf38qqn8q1H9V
AH9VKn9VVX9Vf39Vqn9V1H9/AH9/Kn9/VX9/f39/qn9/1H+qAH+qKn+qVX+q
f3+qqn+q1H/UAH/UKn/UVX/Uf3/Uqn/U1KoAAKoAKqoAVaoAf6oAqqoA1Koq
AKoqKqoqVaoqf6oqqqoq1KpVAKpVKqpVVapVf6pVqqpV1Kp/AKp/Kqp/Vap/
f6p/qqp/1KqqAKqqKqqqVaqqf6qqqqqq1KrUAKrUKqrUVarUf6rUqqrU1NQA
ANQAKtQAVdQAf9QAqtQA1NQqANQqKtQqVdQqf9QqqtQq1NRVANRVKtRVVdRV
f9RVqtRV1NR/ANR/KtR/VdR/f9R/qtR/1NSqANSqKtSqVdSqf9SqqtSq1NTU
ANTUKtTUVdTUf9TUqtTU1AAAAAwMDBkZGSYmJjMzMz8/P0xMTFlZWWZmZnJy
cn9/f4yMjJmZmaWlpbKysr+/v8zMzNjY2OXl5fLy8v/78KCgpICAgP8AAAD/
AP//AAAA//8A/wD//////yH5BAEAAPMALAAAAAAUABQAAAhYAOcJHEiwoMGD
CBMqXMiwID6B+P7Nw7ev4UOKFAHM06gR4T6K//CJfCiwo0ORB/ZVbDivIr6U
JAeaJIhPI0WWNBHOJLgTp8KeJX2yBLqxKEejQpMqXbowIAA7}}
        {{[file join / home cgavin vtcl2-0 images edit remove.gif]} {} stock {
R0lGODlhFAAUAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8AAA
AAAAKgAAVQAAfwAAqgAA1AAqAAAqKgAqVQAqfwAqqgAq1ABVAABVKgBVVQBV
fwBVqgBV1AB/AAB/KgB/VQB/fwB/qgB/1ACqAACqKgCqVQCqfwCqqgCq1ADU
AADUKgDUVQDUfwDUqgDU1CoAACoAKioAVSoAfyoAqioA1CoqACoqKioqVSoq
fyoqqioq1CpVACpVKipVVSpVfypVqipV1Cp/ACp/Kip/VSp/fyp/qip/1Cqq
ACqqKiqqVSqqfyqqqiqq1CrUACrUKirUVSrUfyrUqirU1FUAAFUAKlUAVVUA
f1UAqlUA1FUqAFUqKlUqVVUqf1UqqlUq1FVVAFVVKlVVVVVVf1VVqlVV1FV/
AFV/KlV/VVV/f1V/qlV/1FWqAFWqKlWqVVWqf1WqqlWq1FXUAFXUKlXUVVXU
f1XUqlXU1H8AAH8AKn8AVX8Af38Aqn8A1H8qAH8qKn8qVX8qf38qqn8q1H9V
AH9VKn9VVX9Vf39Vqn9V1H9/AH9/Kn9/VX9/f39/qn9/1H+qAH+qKn+qVX+q
f3+qqn+q1H/UAH/UKn/UVX/Uf3/Uqn/U1KoAAKoAKqoAVaoAf6oAqqoA1Koq
AKoqKqoqVaoqf6oqqqoq1KpVAKpVKqpVVapVf6pVqqpV1Kp/AKp/Kqp/Vap/
f6p/qqp/1KqqAKqqKqqqVaqqf6qqqqqq1KrUAKrUKqrUVarUf6rUqqrU1NQA
ANQAKtQAVdQAf9QAqtQA1NQqANQqKtQqVdQqf9QqqtQq1NRVANRVKtRVVdRV
f9RVqtRV1NR/ANR/KtR/VdR/f9R/qtR/1NSqANSqKtSqVdSqf9SqqtSq1NTU
ANTUKtTUVdTUf9TUqtTU1AAAAAwMDBkZGSYmJjMzMz8/P0xMTFlZWWZmZnJy
cn9/f4yMjJmZmaWlpbKysr+/v8zMzNjY2OXl5fLy8v/78KCgpICAgP8AAAD/
AP//AAAA//8A/wD//////yH5BAEAAPMALAAAAAAUABQAAAhMAOcJHEiwoMGD
CBMqRBggwD+GDg02bPiQIEWIFwVmTDjxYcSFGid+BDmvI8mQJkGa3IixYsmR
ElmWdBkTpkaaBW0O1Hmyp8+fQH8GBAA7}}
        {{[file join / home cgavin vtcl2-0 images edit cut.gif]} {} stock {
R0lGODlhFAAUAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8AAA
AAAAKgAAVQAAfwAAqgAA1AAqAAAqKgAqVQAqfwAqqgAq1ABVAABVKgBVVQBV
fwBVqgBV1AB/AAB/KgB/VQB/fwB/qgB/1ACqAACqKgCqVQCqfwCqqgCq1ADU
AADUKgDUVQDUfwDUqgDU1CoAACoAKioAVSoAfyoAqioA1CoqACoqKioqVSoq
fyoqqioq1CpVACpVKipVVSpVfypVqipV1Cp/ACp/Kip/VSp/fyp/qip/1Cqq
ACqqKiqqVSqqfyqqqiqq1CrUACrUKirUVSrUfyrUqirU1FUAAFUAKlUAVVUA
f1UAqlUA1FUqAFUqKlUqVVUqf1UqqlUq1FVVAFVVKlVVVVVVf1VVqlVV1FV/
AFV/KlV/VVV/f1V/qlV/1FWqAFWqKlWqVVWqf1WqqlWq1FXUAFXUKlXUVVXU
f1XUqlXU1H8AAH8AKn8AVX8Af38Aqn8A1H8qAH8qKn8qVX8qf38qqn8q1H9V
AH9VKn9VVX9Vf39Vqn9V1H9/AH9/Kn9/VX9/f39/qn9/1H+qAH+qKn+qVX+q
f3+qqn+q1H/UAH/UKn/UVX/Uf3/Uqn/U1KoAAKoAKqoAVaoAf6oAqqoA1Koq
AKoqKqoqVaoqf6oqqqoq1KpVAKpVKqpVVapVf6pVqqpV1Kp/AKp/Kqp/Vap/
f6p/qqp/1KqqAKqqKqqqVaqqf6qqqqqq1KrUAKrUKqrUVarUf6rUqqrU1NQA
ANQAKtQAVdQAf9QAqtQA1NQqANQqKtQqVdQqf9QqqtQq1NRVANRVKtRVVdRV
f9RVqtRV1NR/ANR/KtR/VdR/f9R/qtR/1NSqANSqKtSqVdSqf9SqqtSq1NTU
ANTUKtTUVdTUf9TUqtTU1AAAAAwMDBkZGSYmJjMzMz8/P0xMTFlZWWZmZnJy
cn9/f4yMjJmZmaWlpbKysr+/v8zMzNjY2OXl5fLy8v/78KCgpICAgP8AAAD/
AP//AAAA//8A/wD//////yH5BAEAAPMALAAAAAAUABQAAAhdAOcJHEiwoMGD
CBPiwwdgHsOEBh8+hFiQ4USKAxdexChwYUOOBDdyLHKgyEeQJk2CnFckpUqM
/1oCKPkSYkoAMWVSvCkTQM2DN1nO/GkwKEudNgGcVHpypdOnHAMCADs=}}
        {{[file join / home cgavin vtcl2-0 images edit paste.gif]} {} stock {
R0lGODlhFAAUAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8AAA
AAAAKgAAVQAAfwAAqgAA1AAqAAAqKgAqVQAqfwAqqgAq1ABVAABVKgBVVQBV
fwBVqgBV1AB/AAB/KgB/VQB/fwB/qgB/1ACqAACqKgCqVQCqfwCqqgCq1ADU
AADUKgDUVQDUfwDUqgDU1CoAACoAKioAVSoAfyoAqioA1CoqACoqKioqVSoq
fyoqqioq1CpVACpVKipVVSpVfypVqipV1Cp/ACp/Kip/VSp/fyp/qip/1Cqq
ACqqKiqqVSqqfyqqqiqq1CrUACrUKirUVSrUfyrUqirU1FUAAFUAKlUAVVUA
f1UAqlUA1FUqAFUqKlUqVVUqf1UqqlUq1FVVAFVVKlVVVVVVf1VVqlVV1FV/
AFV/KlV/VVV/f1V/qlV/1FWqAFWqKlWqVVWqf1WqqlWq1FXUAFXUKlXUVVXU
f1XUqlXU1H8AAH8AKn8AVX8Af38Aqn8A1H8qAH8qKn8qVX8qf38qqn8q1H9V
AH9VKn9VVX9Vf39Vqn9V1H9/AH9/Kn9/VX9/f39/qn9/1H+qAH+qKn+qVX+q
f3+qqn+q1H/UAH/UKn/UVX/Uf3/Uqn/U1KoAAKoAKqoAVaoAf6oAqqoA1Koq
AKoqKqoqVaoqf6oqqqoq1KpVAKpVKqpVVapVf6pVqqpV1Kp/AKp/Kqp/Vap/
f6p/qqp/1KqqAKqqKqqqVaqqf6qqqqqq1KrUAKrUKqrUVarUf6rUqqrU1NQA
ANQAKtQAVdQAf9QAqtQA1NQqANQqKtQqVdQqf9QqqtQq1NRVANRVKtRVVdRV
f9RVqtRV1NR/ANR/KtR/VdR/f9R/qtR/1NSqANSqKtSqVdSqf9SqqtSq1NTU
ANTUKtTUVdTUf9TUqtTU1AAAAAwMDBkZGSYmJjMzMz8/P0xMTFlZWWZmZnJy
cn9/f4yMjJmZmaWlpbKysr+/v8zMzNjY2OXl5fLy8v/78KCgpICAgP8AAAD/
AP//AAAA//8A/wD//////yH5BAEAAPMALAAAAAAUABQAAAh4AOcJHEiwoMGD
CBPOA8AQgMKB+CIC+PcPQER8CfFRnMiw4kaEGif+uyjR4cGQDPFxW8mNIUiK
FFWy5HgS5siWAHC6LKgRpkyWK00S7BlTJ8OWBoneBBo0qU2VDY8KhfiUaVOe
VaPmnDow6k+gXA1qjfqwrNmzZwMCADs=}}
        {{[file join / home cgavin vtcl2-0 images edit new.gif]} {} stock {
R0lGODlhFAAUAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8AAA
AAAAKgAAVQAAfwAAqgAA1AAqAAAqKgAqVQAqfwAqqgAq1ABVAABVKgBVVQBV
fwBVqgBV1AB/AAB/KgB/VQB/fwB/qgB/1ACqAACqKgCqVQCqfwCqqgCq1ADU
AADUKgDUVQDUfwDUqgDU1CoAACoAKioAVSoAfyoAqioA1CoqACoqKioqVSoq
fyoqqioq1CpVACpVKipVVSpVfypVqipV1Cp/ACp/Kip/VSp/fyp/qip/1Cqq
ACqqKiqqVSqqfyqqqiqq1CrUACrUKirUVSrUfyrUqirU1FUAAFUAKlUAVVUA
f1UAqlUA1FUqAFUqKlUqVVUqf1UqqlUq1FVVAFVVKlVVVVVVf1VVqlVV1FV/
AFV/KlV/VVV/f1V/qlV/1FWqAFWqKlWqVVWqf1WqqlWq1FXUAFXUKlXUVVXU
f1XUqlXU1H8AAH8AKn8AVX8Af38Aqn8A1H8qAH8qKn8qVX8qf38qqn8q1H9V
AH9VKn9VVX9Vf39Vqn9V1H9/AH9/Kn9/VX9/f39/qn9/1H+qAH+qKn+qVX+q
f3+qqn+q1H/UAH/UKn/UVX/Uf3/Uqn/U1KoAAKoAKqoAVaoAf6oAqqoA1Koq
AKoqKqoqVaoqf6oqqqoq1KpVAKpVKqpVVapVf6pVqqpV1Kp/AKp/Kqp/Vap/
f6p/qqp/1KqqAKqqKqqqVaqqf6qqqqqq1KrUAKrUKqrUVarUf6rUqqrU1NQA
ANQAKtQAVdQAf9QAqtQA1NQqANQqKtQqVdQqf9QqqtQq1NRVANRVKtRVVdRV
f9RVqtRV1NR/ANR/KtR/VdR/f9R/qtR/1NSqANSqKtSqVdSqf9SqqtSq1NTU
ANTUKtTUVdTUf9TUqtTU1AAAAAwMDBkZGSYmJjMzMz8/P0xMTFlZWWZmZnJy
cn9/f4yMjJmZmaWlpbKysr+/v8zMzNjY2OXl5fLy8v/78KCgpICAgP8AAAD/
AP//AAAA//8A/wD//////yH5BAEAAPMALAAAAAAUABQAAAhRAOcJHEiwoMGD
CA0CWMiw4UKEABIKjKhQ4sSKDhsOpLjRYseOGR1e/OiR47yIIUWaNClx5cmU
DE8SZJnQJcyYLj3KBHkT5UydOyf21Ai0qMeAADs=}}
        {{[file join / home cgavin vtcl2-0 images edit save.gif]} {} stock {
R0lGODlhFAATAPcAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwMDcwKbK8AAA
AAAAKgAAVQAAfwAAqgAA1AAqAAAqKgAqVQAqfwAqqgAq1ABVAABVKgBVVQBV
fwBVqgBV1AB/AAB/KgB/VQB/fwB/qgB/1ACqAACqKgCqVQCqfwCqqgCq1ADU
AADUKgDUVQDUfwDUqgDU1CoAACoAKioAVSoAfyoAqioA1CoqACoqKioqVSoq
fyoqqioq1CpVACpVKipVVSpVfypVqipV1Cp/ACp/Kip/VSp/fyp/qip/1Cqq
ACqqKiqqVSqqfyqqqiqq1CrUACrUKirUVSrUfyrUqirU1FUAAFUAKlUAVVUA
f1UAqlUA1FUqAFUqKlUqVVUqf1UqqlUq1FVVAFVVKlVVVVVVf1VVqlVV1FV/
AFV/KlV/VVV/f1V/qlV/1FWqAFWqKlWqVVWqf1WqqlWq1FXUAFXUKlXUVVXU
f1XUqlXU1H8AAH8AKn8AVX8Af38Aqn8A1H8qAH8qKn8qVX8qf38qqn8q1H9V
AH9VKn9VVX9Vf39Vqn9V1H9/AH9/Kn9/VX9/f39/qn9/1H+qAH+qKn+qVX+q
f3+qqn+q1H/UAH/UKn/UVX/Uf3/Uqn/U1KoAAKoAKqoAVaoAf6oAqqoA1Koq
AKoqKqoqVaoqf6oqqqoq1KpVAKpVKqpVVapVf6pVqqpV1Kp/AKp/Kqp/Vap/
f6p/qqp/1KqqAKqqKqqqVaqqf6qqqqqq1KrUAKrUKqrUVarUf6rUqqrU1NQA
ANQAKtQAVdQAf9QAqtQA1NQqANQqKtQqVdQqf9QqqtQq1NRVANRVKtRVVdRV
f9RVqtRV1NR/ANR/KtR/VdR/f9R/qtR/1NSqANSqKtSqVdSqf9SqqtSq1NTU
ANTUKtTUVdTUf9TUqtTU1AAAAAwMDBkZGSYmJjMzMz8/P0xMTFlZWWZmZnJy
cn9/f4yMjJmZmaWlpbKysr+/v8zMzNjY2OXl5fLy8v/78KCgpICAgP8AAAD/
AP//AAAA//8A/wD//////yH5BAEAAPMALAAAAAAUABMAAAhuAOcJHEiwoMGD
CA/iW8iwYUOD+Ljh+0exIsWIACBKtGhxYcaCESdyvMjtI8GQI0maHIgyJUaN
Ike+BMlNosOFNVcKjFizp8+cGnveBEqzZkiGEksGTdowqc55PG02nVkQgNWr
WK8m3Mq1q1eEAQEAOw==}}

            } {
    eval set _file [lindex $img 0]
    vTcl:image:create_new_image\
        $_file [lindex $img 1] [lindex $img 2] [lindex $img 3]
}

}
#############################################################################
# Visual Tcl v1.51 Project
#

#################################
# VTCL LIBRARY PROCEDURES
#

if {![info exists vTcl(sourcing)]} {
#############################################################################
## Library Procedure:  Window

proc {Window} {args} {
global vTcl
    set cmd     [lindex $args 0]
    set name    [lindex $args 1]
    set newname [lindex $args 2]
    set rest    [lrange $args 3 end]
    if {$name == "" || $cmd == ""} { return }
    if {$newname == ""} { set newname $name }
    if {$name == "."} { wm withdraw $name; return }
    set exists [winfo exists $newname]
    switch $cmd {
        show {
            if {$exists} {
                wm deiconify $newname
            } elseif {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[wm state $newname] == "normal"} {
                vTcl:FireEvent $newname <<Show>>
            }
        }
        hide    {
            if {$exists} {
                wm withdraw $newname
                vTcl:FireEvent $newname <<Hide>>
                return}
        }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}
#############################################################################
## Library Procedure:  vTcl:DefineAlias

proc {vTcl:DefineAlias} {target alias widgetProc top_or_alias cmdalias} {
global widget

    set widget($alias) $target
    set widget(rev,$target) $alias

    if {$cmdalias} {
        interp alias {} $alias {} $widgetProc $target
    }

    if {$top_or_alias != ""} {
        set widget($top_or_alias,$alias) $target

        if {$cmdalias} {
            interp alias {} $top_or_alias.$alias {} $widgetProc $target
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:DoCmdOption

proc {vTcl:DoCmdOption} {target cmd} {
## menus are considered toplevel windows
    set parent $target
    while {[winfo class $parent] == "Menu"} {
        set parent [winfo parent $parent]
    }

    regsub -all {\%widget} $cmd $target cmd
    regsub -all {\%top} $cmd [winfo toplevel $parent] cmd

    uplevel #0 [list eval $cmd]
}
#############################################################################
## Library Procedure:  vTcl:FireEvent

proc {vTcl:FireEvent} {target event} {
foreach bindtag [bindtags $target] {
        set tag_events [bind $bindtag]
        set stop_processing 0
        foreach tag_event $tag_events {
            if {$tag_event == $event} {
                set bind_code [bind $bindtag $tag_event]
                regsub -all %W $bind_code $target bind_code
                set result [catch {uplevel #0 $bind_code} errortext]
                if {$result == 3} {
                    # break exception, stop processing
                    set stop_processing 1
                } elseif {$result != 0} {
                    bgerror $errortext
                }
                break
            }
        }
        if {$stop_processing} {break}
    }
}
#############################################################################
## Library Procedure:  vTcl:Toplevel:WidgetProc

proc {vTcl:Toplevel:WidgetProc} {w args} {
global tcl_platform

    if {[llength $args] == 0} {
        return -code error "wrong # args: should be \"$w option ?arg arg ...?\""
    }

    ## The first argument is a switch, they must be doing a configure.
    if {[string index $args 0] == "-"} {
        set command configure

        ## There's only one argument, must be a cget.
        if {[llength $args] == 1} {
            set command cget
        }
    } else {
        set command [lindex $args 0]
        set args [lrange $args 1 end]
    }

    switch -- $command {
        "hide" - "Hide" {
            Window hide $w
        }

        "show" - "Show" {
            Window show $w
        }

        "ShowModal" {
            Window show $w
            if {$tcl_platform(platform) != "unix"} {raise $w}
            grab $w
            tkwait window $w
            grab release $w
        }

        default {
            eval $w $command $args
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:WidgetProc

proc {vTcl:WidgetProc} {w args} {
if {[llength $args] == 0} {
        return -code error "wrong # args: should be \"$w option ?arg arg ...?\""
    }

    ## The first argument is a switch, they must be doing a configure.
    if {[string index $args 0] == "-"} {
        set command configure

        ## There's only one argument, must be a cget.
        if {[llength $args] == 1} {
            set command cget
        }
    } else {
        set command [lindex $args 0]
        set args [lrange $args 1 end]
    }

    eval $w $command $args
}
#############################################################################
## Library Procedure:  vTcl:toplevel

proc {vTcl:toplevel} {args} {
uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {}
}
}

if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    namespace eval ::widgets::.top18 {
        array set save {}
    }
    namespace eval ::widgets::.top18.cpd19 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top18.cpd19.01 {
        array set save {-command 1 -highlightthickness 1 -orient 1}
    }
    namespace eval ::widgets::.top18.cpd19.02 {
        array set save {-command 1 -highlightthickness 1}
    }
    namespace eval ::widgets::.top18.cpd19.03 {
        array set save {-background 1 -font 1 -height 1 -relief 1 -width 1 -wrap 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::.top18.but20 {
        array set save {-command 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top19 {
        array set save {}
    }
    namespace eval ::widgets::.top19.lab20 {
        array set save {-anchor 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::.top19.cpd22 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top19.cpd22.01 {
        array set save {-background 1 -highlightthickness 1 -relief 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::.top19.cpd22.02 {
        array set save {-command 1 -highlightthickness 1 -orient 1}
    }
    namespace eval ::widgets::.top19.cpd22.03 {
        array set save {-command 1 -highlightthickness 1}
    }
    namespace eval ::widgets::.top19.fra23 {
        array set save {}
    }
    namespace eval ::widgets::.top19.fra23.but24 {
        array set save {-command 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top19.fra23.but25 {
        array set save {-command 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top21 {
        array set save {-menu 1}
    }
    namespace eval ::widgets::.top21.fra22 {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.fra22.lab30 {
        array set save {-borderwidth 1 -padx 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::.top21.fra22.lab31 {
        array set save {-borderwidth 1 -padx 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::.top21.cpd23 {
        array set save {-background 1}
    }
    namespace eval ::widgets::.top21.cpd23.01 {
        array set save {}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18 {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd23 {
        array set save {-borderwidth 1 -relief 1 -takefocus 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd23.upframe {
        array set save {-borderwidth 1 -height 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd23.centerframe {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd23.centerframe.leftframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd23.centerframe.rightframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd23.centerframe.05 {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd23.centerframe.05.06 {
        array set save {-borderwidth 1 -height 1 -image 1 -text 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd23.centerframe.05.07 {
        array set save {-borderwidth 1 -padx 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd23.downframe {
        array set save {-borderwidth 1 -height 1 -relief 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd19 {
        array set save {-borderwidth 1 -relief 1 -takefocus 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd19.upframe {
        array set save {-borderwidth 1 -height 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd19.centerframe {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd19.centerframe.leftframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd19.centerframe.rightframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd19.centerframe.05 {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd19.centerframe.05.06 {
        array set save {-borderwidth 1 -image 1 -text 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd19.centerframe.05.07 {
        array set save {-borderwidth 1 -padx 1 -pady 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd19.downframe {
        array set save {-borderwidth 1 -height 1 -relief 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.fra24 {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd20 {
        array set save {-borderwidth 1 -relief 1 -takefocus 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd20.upframe {
        array set save {-borderwidth 1 -height 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd20.centerframe {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd20.centerframe.leftframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd20.centerframe.rightframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd20.centerframe.05 {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd20.centerframe.05.06 {
        array set save {-borderwidth 1 -image 1 -text 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd20.centerframe.05.07 {
        array set save {-borderwidth 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd20.downframe {
        array set save {-borderwidth 1 -height 1 -relief 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd21 {
        array set save {-borderwidth 1 -relief 1 -takefocus 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd21.upframe {
        array set save {-borderwidth 1 -height 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd21.centerframe {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd21.centerframe.leftframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd21.centerframe.rightframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd21.centerframe.05 {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd21.centerframe.05.06 {
        array set save {-borderwidth 1 -image 1 -text 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd21.centerframe.05.07 {
        array set save {-borderwidth 1 -padx 1 -pady 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd21.downframe {
        array set save {-borderwidth 1 -height 1 -relief 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd22 {
        array set save {-borderwidth 1 -relief 1 -takefocus 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd22.upframe {
        array set save {-borderwidth 1 -height 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd22.centerframe {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd22.centerframe.leftframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd22.centerframe.rightframe {
        array set save {-borderwidth 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd22.centerframe.05 {
        array set save {-borderwidth 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd22.centerframe.05.06 {
        array set save {-borderwidth 1 -image 1 -text 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd22.centerframe.05.07 {
        array set save {-borderwidth 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.fra18.cpd22.downframe {
        array set save {-borderwidth 1 -height 1 -relief 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.cpd24 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.cpd24.01 {
        array set save {-command 1 -highlightthickness 1 -orient 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.cpd24.02 {
        array set save {-command 1 -highlightthickness 1}
    }
    namespace eval ::widgets::.top21.cpd23.01.cpd24.03 {
        array set save {-background 1 -borderwidth 1 -wrap 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::.top21.cpd23.02 {
        array set save {}
    }
    namespace eval ::widgets::.top21.cpd23.02.fra25 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.fra25.01 {
        array set save {-command 1 -highlightthickness 1 -orient 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.fra25.02 {
        array set save {-command 1 -highlightthickness 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.fra25.03 {
        array set save {-background 1 -borderwidth 1 -height 1 -width 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.fra22 {
        array set save {-borderwidth 1 -height 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.fra22.but23 {
        array set save {-command 1 -image 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.fra22.but24 {
        array set save {-command 1 -image 1 -relief 1 -text 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.cpd22 {
        array set save {-borderwidth 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.cpd22.01 {
        array set save {-background 1 -borderwidth 1 -relief 1 -selectmode 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.cpd22.02 {
        array set save {-command 1 -highlightthickness 1 -orient 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.cpd22.03 {
        array set save {-command 1 -highlightthickness 1}
    }
    namespace eval ::widgets::.top21.cpd23.02.fra23 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top21.cpd23.03 {
        array set save {-background 1 -borderwidth 1 -relief 1}
    }
    namespace eval ::widgets::.top21.m26 {
        array set save {-borderwidth 1 -cursor 1 -relief 1 -tearoff 1}
    }
    namespace eval ::widgets::.top21.m26.men27 {
        array set save {-tearoff 1}
    }
    namespace eval ::widgets::.top21.m26.men28 {
        array set save {-tearoff 1}
    }
    namespace eval ::widgets::.top21.m26.men29 {
        array set save {-tearoff 1}
    }
    namespace eval ::widgets::.top22 {
        array set save {}
    }
    namespace eval ::widgets::.top22.lab23 {
        array set save {-anchor 1 -text 1}
    }
    namespace eval ::widgets::.top22.ent24 {
        array set save {-background 1 -textvariable 1}
    }
    namespace eval ::widgets::.top22.fra25 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top22.fra27 {
        array set save {-borderwidth 1 -height 1 -width 1}
    }
    namespace eval ::widgets::.top22.fra27.cpd28 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top22.fra27.cpd28.01 {
        array set save {-background 1 -height 1 -relief 1 -width 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::.top22.fra27.cpd28.02 {
        array set save {-command 1 -highlightthickness 1 -orient 1}
    }
    namespace eval ::widgets::.top22.fra27.cpd28.03 {
        array set save {-command 1 -highlightthickness 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29 {
        array set save {-borderwidth 1 -height 1 -width 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.fra30 {
        array set save {-borderwidth 1 -height 1 -width 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.fra30.lab34 {
        array set save {-text 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.fra30.but31 {
        array set save {-command 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.fra30.ent32 {
        array set save {-background 1 -justify 1 -state 1 -textvariable 1 -width 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.fra30.but33 {
        array set save {-command 1 -padx 1 -pady 1 -text 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.che35 {
        array set save {-anchor 1 -command 1 -pady 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.che37 {
        array set save {-anchor 1 -command 1 -pady 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.che38 {
        array set save {-anchor 1 -command 1 -pady 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.che39 {
        array set save {-anchor 1 -command 1 -pady 1 -text 1 -variable 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.lab40 {
        array set save {-anchor 1 -text 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.rad41 {
        array set save {-anchor 1 -command 1 -pady 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.rad42 {
        array set save {-anchor 1 -command 1 -pady 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.rad43 {
        array set save {-anchor 1 -command 1 -pady 1 -text 1 -value 1 -variable 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.lab22 {
        array set save {-background 1 -text 1}
    }
    namespace eval ::widgets::.top22.fra27.fra29.lab23 {
        array set save {-background 1 -text 1}
    }
    namespace eval ::widgets::.top22.fra26 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top22.cpd44 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top22.cpd44.01 {
        array set save {-command 1 -highlightthickness 1 -orient 1}
    }
    namespace eval ::widgets::.top22.cpd44.02 {
        array set save {-command 1 -highlightthickness 1}
    }
    namespace eval ::widgets::.top22.cpd44.03 {
        array set save {-background 1 -height 1 -relief 1 -width 1 -wrap 1 -xscrollcommand 1 -yscrollcommand 1}
    }
    namespace eval ::widgets::.top22.fra45 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top22.fra46 {
        array set save {-borderwidth 1 -height 1 -width 1}
    }
    namespace eval ::widgets::.top22.fra46.but47 {
        array set save {-command 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top22.fra46.but48 {
        array set save {-command 1 -text 1 -width 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist {FlatToolbarButton Accelerators BitmapButtonTop BitmapButtonSub1 BitmapButtonSub2 BitmapButtonSub3}
    }
}
}
#################################
# USER DEFINED PROCEDURES
#
#############################################################################
## Procedure:  ::about::init

namespace eval ::about {

proc {::about::init} {} {
global widget

set id [open [file join [file dirname [info script]] about.ttd] r]
set ttd [read $id]
close $id

AboutVisualText.AboutText configure -state normal
AboutVisualText.AboutText delete 1.0 end
ttd::insert $widget(AboutVisualText,AboutText) $ttd
AboutVisualText.AboutText configure -state disabled
}

}
#############################################################################
## Procedure:  ::bitmapbutton::get_parent

namespace eval ::bitmapbutton {

proc {::bitmapbutton::get_parent} {W {level 1}} {
global widget

set items [split $W .]
set last [expr [llength $items] - 1]

set parent_items [lrange $items 0 [expr $last - $level] ]
return [join $parent_items .]
}

}
#############################################################################
## Procedure:  ::bitmapbutton::init

namespace eval ::bitmapbutton {

proc {::bitmapbutton::init} {W} {
global widget

set N [vTcl:rename $W]
namespace eval ::${N} {
    variable command
    set command ""}
}

}
#############################################################################
## Procedure:  ::bitmapbutton::mouse_down

namespace eval ::bitmapbutton {

proc {::bitmapbutton::mouse_down} {W X Y} {
global widget

::bitmapbutton::show_state $W sunken

set N [vTcl:rename $W]
namespace eval ::$N {variable state}

set ::${N}::state "mouse_down"
}

}
#############################################################################
## Procedure:  ::bitmapbutton::mouse_inside

namespace eval ::bitmapbutton {

proc {::bitmapbutton::mouse_inside} {W X Y} {
global widget

set button_X [winfo rootx $W]
set button_Y [winfo rooty $W]
set button_width [winfo width $W]
set button_height [winfo height $W]

set N [vTcl:rename $W]
set S "mouse_up"

catch {
   eval set S $\:\:$N\:\:state
}

if {$S == "mouse_up"} return

if {$button_X <= $X &&
    $button_X + $button_width >= $X &&
    $button_Y <= $Y &&
    $button_Y + $button_height >= $Y } {
    
   ::bitmapbutton::show_state $W sunken

} else {

   ::bitmapbutton::show_state $W raised
}
}

}
#############################################################################
## Procedure:  ::bitmapbutton::mouse_up

namespace eval ::bitmapbutton {

proc {::bitmapbutton::mouse_up} {W X Y} {
set button_X [winfo rootx $W]
set button_Y [winfo rooty $W]
set button_width [winfo width $W]
set button_height [winfo height $W]

::bitmapbutton::show_state $W raised

set N [vTcl:rename $W]
set S ""
catch {
   eval set S $\:\:$N\:\:state
}

if {$S == "mouse_down" } {

    set ::${N}::state "mouse_up"

    ## command triggered ?
    if {$button_X <= $X &&
        $button_X + $button_width >= $X &&
        $button_Y <= $Y &&
        $button_Y + $button_height >= $Y } {
        
        set ::${N}::W $W
        namespace eval ::${N} {
            variable command
            variable W
            if {[info exists command] && $command != ""} {
                vTcl:DoCmdOption $W $command
            }
        }
    }
}
}

}
#############################################################################
## Procedure:  ::bitmapbutton::set_command

namespace eval ::bitmapbutton {

proc {::bitmapbutton::set_command} {W cmd} {
global widget

set N [vTcl:rename $W]
namespace eval ::${N} {}
set ::${N}::command $cmd
}

}
#############################################################################
## Procedure:  ::bitmapbutton::show_state

namespace eval ::bitmapbutton {

proc {::bitmapbutton::show_state} {W S} {
global widget

set upframe    $W.upframe
set downframe  $W.downframe
set leftframe  $W.centerframe.leftframe
set rightframe $W.centerframe.rightframe

switch $S {

   sunken {
     $W configure -relief sunken
     $upframe    configure -height 4
     $leftframe  configure -width 4
     $rightframe configure -width 1
     $downframe  configure -height 1
   }

   raised {
     $W configure -relief raised
     $upframe configure -height 3
     $leftframe configure -width 3
     $rightframe configure -width 2
     $downframe configure -height 2
   }
}
}

}
#############################################################################
## Procedure:  ::delete_tag::do_modal

namespace eval ::delete_tag {

proc {::delete_tag::do_modal} {mainw w} {
global widget
set wa $widget(rev,$w)

$wa.DeleteTagListbox delete 0 end
set tags [$mainw.MainText tag names]
foreach tag $tags {
    if {$tag == "sel"} {continue}
    $wa.DeleteTagListbox insert end $tag
}

set ::${w}::status ""
Window show $w
vwait ::${w}::status
Window hide $w

## did the user cancel ?
upvar #0 ::${w}::status status
if {$status == "cancel"} {return}

## get the selected tag
set index [$wa.DeleteTagListbox curselection]
if {$index == ""} {return}

## delete the tag in the main text widget
set tag [$wa.DeleteTagListbox get $index]
$mainw.MainText tag delete $tag

## refresh the whole thing
::visual_text::fill_tags $mainw
::visual_text::show_tags_at_insert $mainw
}

}
#############################################################################
## Procedure:  ::edit_tag::add_new_tag

namespace eval ::edit_tag {

proc {::edit_tag::add_new_tag} {mainw w selrange} {
global widget
upvar #0 ::${w}::tag_name tag_name

eval $mainw.MainText tag add [list $tag_name] $selrange
::edit_tag::set_existing_tag $mainw $w
}

}
#############################################################################
## Procedure:  ::edit_tag::do_modal

namespace eval ::edit_tag {

proc {::edit_tag::do_modal} {w} {
global widget

set ::${w}::edit_tag_status ""
Window show $w
vwait ::${w}::edit_tag_status
Window hide $w
}

}
#############################################################################
## Procedure:  ::edit_tag::enable_ok

namespace eval ::edit_tag {

proc {::edit_tag::enable_ok} {w} {
global widget
set wa $widget(rev,$w)
upvar #0 ::${w}::tag_name tag_name

if {$tag_name == ""} {
    $wa.EditTagOK configure -state disabled
} else {
    $wa.EditTagOK configure -state normal
}
}

}
#############################################################################
## Procedure:  ::edit_tag::get_status

namespace eval ::edit_tag {

proc {::edit_tag::get_status} {w} {
## easier access to namespace variable
global widget
upvar #0 ::${w}::edit_tag_status edit_tag_status
return $edit_tag_status
}

}
#############################################################################
## Procedure:  ::edit_tag::init_edit_tag

namespace eval ::edit_tag {

proc {::edit_tag::init_edit_tag} {w} {
global widget
set wa $widget(rev,$w)
upvar #0 ::${w}::edit_tag_status edit_tag_status
upvar #0 ::${w}::selected_font   selected_font
upvar #0 ::${w}::justify_radio   justify_radio
upvar #0 ::${w}::font_size_entry font_size_entry

$wa.FontsListbox delete 0 end
foreach family [lsort [font families]] {
    $wa.FontsListbox insert end $family
}
$wa.FontsListbox selection set 0
set selected_font [$wa.FontsListbox get 0]

set justify_radio left
set font_size_entry 10

$wa.TagSampleText delete 1.0 end
$wa.TagSampleText insert end "The Quick Brown Fox jumped over a lazy dog's back" sample

::edit_tag::update_sample $w
}

}
#############################################################################
## Procedure:  ::edit_tag::prepare_edit_tag

namespace eval ::edit_tag {

proc {::edit_tag::prepare_edit_tag} {mainw w tag_to_edit} {
global widget
set wa $widget(rev,$w) 
upvar #0 ::${w}::tag_name         tag_name
upvar #0 ::${w}::edit_tag_status  edit_tag_status 
upvar #0 ::${w}::selected_font    selected_font
upvar #0 ::${w}::bold_check       bold_check
upvar #0 ::${w}::italic_check     italic_check
upvar #0 ::${w}::justify_radio    justify_radio
upvar #0 ::${w}::font_size_entry  font_size_entry
upvar #0 ::${w}::underline_check  underline_check
upvar #0 ::${w}::overstrike_check overstrike_check

set tag_name $tag_to_edit
set font [$mainw.MainText tag cget $tag_name -font]
set font_name [string tolower [get_option $font -family]]

## try to match font case insensitive
$wa.FontsListbox selection clear 0 end
for {set i 0} {$i < [$wa.FontsListbox index end]} {incr i} {
    if {[string tolower [$wa.FontsListbox get $i]] == $font_name} {
        $wa.FontsListbox selection set $i
        $wa.FontsListbox see $i
        set selected_font [$wa.FontsListbox get $i]
        break
    }
}

set justify_radio [$mainw.MainText tag cget $tag_name -justify]

set background    [$mainw.MainText tag cget $tag_name -background]
if {$background == ""} {set background [$mainw.MainText cget -background]}
$wa.TagBackground configure -background $background

set foreground    [$mainw.MainText tag cget $tag_name -foreground]
if {$foreground == ""} {set foreground [$mainw.MainText cget -foreground]}
$wa.TagForeground configure -background $foreground

set weight [get_option $font -weight]
set slant  [get_option $font -slant]

set font_size_entry  [get_option $font -size]
if {$font_size_entry == ""} {set font_size_entry 10}
set bold_check       [expr {$weight == "bold"}]
set italic_check     [expr {$slant  == "italic"}]
set underline_check  [get_option $font -underline]
if {$underline_check == ""} {set underline_check 0}
set overstrike_check [get_option $font -overstrike]
if {$overstrike_check == ""} {set overstrike_check 0}

::edit_tag::update_sample $w
}

}
#############################################################################
## Procedure:  ::edit_tag::set_existing_tag

namespace eval ::edit_tag {

proc {::edit_tag::set_existing_tag} {mainw w} {
global widget
set wa $widget(rev,$w)
upvar #0 ::${w}::tag_name         tag_name
upvar #0 ::${w}::edit_tag_status  edit_tag_status 
upvar #0 ::${w}::selected_font    selected_font
upvar #0 ::${w}::bold_check       bold_check
upvar #0 ::${w}::italic_check     italic_check
upvar #0 ::${w}::justify_radio    justify_radio
upvar #0 ::${w}::font_size_entry  font_size_entry
upvar #0 ::${w}::underline_check  underline_check
upvar #0 ::${w}::overstrike_check overstrike_check

set family $selected_font
set weight normal
if {$bold_check} {set weight bold}
set slant roman
if {$italic_check} {set slant italic}

$mainw.MainText tag configure $tag_name -font "-family [list $family] -weight $weight -slant $slant -size $font_size_entry -underline $underline_check -overstrike $overstrike_check"
$mainw.MainText tag configure $tag_name -justify $justify_radio
$mainw.MainText tag configure $tag_name -background [$wa.TagBackground cget -background]
$mainw.MainText tag configure $tag_name -foreground [$wa.TagForeground cget -background]

::visual_text::fill_tags $mainw
::visual_text::show_tags_at_insert $mainw
}

}
#############################################################################
## Procedure:  ::edit_tag::update_sample

namespace eval ::edit_tag {

proc {::edit_tag::update_sample} {w} {
global widget
set wa $widget(rev,$w)
upvar #0 ::${w}::tag_name         tag_name
upvar #0 ::${w}::edit_tag_status  edit_tag_status 
upvar #0 ::${w}::selected_font    selected_font
upvar #0 ::${w}::bold_check       bold_check
upvar #0 ::${w}::italic_check     italic_check
upvar #0 ::${w}::justify_radio    justify_radio
upvar #0 ::${w}::font_size_entry  font_size_entry
upvar #0 ::${w}::underline_check  underline_check
upvar #0 ::${w}::overstrike_check overstrike_check

set family $selected_font
set weight normal
if {$bold_check} {set weight bold}
set slant roman
if {$italic_check} {set slant italic}

$wa.TagSampleText tag configure sample -font "-family [list $family] -weight $weight -slant $slant -size $font_size_entry -underline $underline_check -overstrike $overstrike_check"
$wa.TagSampleText tag configure sample -justify $justify_radio
$wa.TagSampleText tag configure sample -background [$wa.TagBackground cget -background]
$wa.TagSampleText tag configure sample -foreground [$wa.TagForeground cget -background]
}

}
#############################################################################
## Procedure:  ::ttd::get

namespace eval ::ttd {

proc {::ttd::get} {args} {
# Tcl/Tk text dump
#
# Copyright (c) 1999, Bryan Douglas Oakley
# All Rights Reserved.
#
# This code is provide as-is, with no warranty expressed or implied. Use
# at your own risk.
#
#
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
		if {[string length $imagename] > 0  && ![info exists images($imagename)]} {
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
	    lappend tagData [concat ttd.tagdef [list $tag] $tags($tag)]
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

}
#############################################################################
## Procedure:  ::ttd::init

namespace eval ::ttd {

proc {::ttd::init} {} {
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

}
#############################################################################
## Procedure:  ::ttd::insert

namespace eval ::ttd {

proc {::ttd::insert} {w ttd} {
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
	tk_messageBox -icon info  -message $message  -title "Bad file"  -type ok
    }

    # and clean up after ourselves
    interp delete $safeInterpreter
}

}
#############################################################################
## Procedure:  ::visual_text::apply_tag

namespace eval ::visual_text {

proc {::visual_text::apply_tag} {w x y} {
set index [$w.TagsListbox index @$x,$y]
set tag   [$w.TagsListbox get $index]

## apply or unapply the tag?
if {[$w.TagsListbox itemcget $index -background] == "white"} {
    eval $w.MainText tag add [list $tag] [$w.MainText tag ranges sel]
} else {
    eval $w.MainText tag remove [list $tag] [$w.MainText tag ranges sel]
}

::visual_text::show_tags_at_insert $w
}

}
#############################################################################
## Procedure:  ::visual_text::command-add_tag

namespace eval ::visual_text {

proc {::visual_text::command-add_tag} {mainw w} {
## if there is no selection, we cannot add a tag
set selrange [$mainw.MainText tag ranges sel]
if {$selrange == ""} {
    tk_messageBox -message "Please select a bloc of text first." -title "Visual Text"
    return
}

global widget 

## we allow the user to enter a new tag name
set ::${w}::tag_name ""
set wa $widget(rev,$w)
$wa.EditTagOK    configure -state disabled
$wa.TagNameEntry configure -state normal

## launch modal dialog box and check status ("OK" or "Cancel")
::edit_tag::do_modal $w
if {[::edit_tag::get_status $w] != "OK"} return

## add a new tag to the selection
::edit_tag::add_new_tag $mainw $w $selrange
}

}
#############################################################################
## Procedure:  ::visual_text::command-edit_tag

namespace eval ::visual_text {

proc {::visual_text::command-edit_tag} {mainw w tag_to_edit} {
if {$tag_to_edit == ""} {return}
global widget

## we don't allow the user to modify the existing tag name
set wa $widget(rev,$w)
$wa.TagNameEntry configure -state disabled
::edit_tag::prepare_edit_tag $mainw $w $tag_to_edit

## launch modal dialog and check status
::edit_tag::do_modal $w
if {[::edit_tag::get_status $w] != "OK"} return

## apply changes to the existing tag
::edit_tag::set_existing_tag $mainw $w
}

}
#############################################################################
## Procedure:  ::visual_text::command-new

namespace eval ::visual_text {

proc {::visual_text::command-new} {mainw} {
set tags [$mainw.MainText tag names]
foreach tag $tags {
    $mainw.MainText tag delete $tag
}

$mainw.MainText delete 1.0 end
::visual_text::fill_tags $mainw
}

}
#############################################################################
## Procedure:  ::visual_text::command-open

namespace eval ::visual_text {

proc {::visual_text::command-open} {mainw {file {}}} {
global filename widget tk_strictMotif

    if {$file == ""} {
        set old $tk_strictMotif
        set tk_strictMotif 0
	set file [tk_getOpenFile  -defaultextension {.ttd}   -initialdir .  -filetypes {{{Rich Tcl Text} *.ttd TEXT} {all *.* TEXT} }  -initialfile $filename  -title "Open..."]
        set tk_strictMotif $old
    }

    if {$file == ""} {return}

    ## starts new empty document, then load the file
    ::visual_text::command-new $mainw

    set filename $file
    wm title $mainw "$filename - Visual Text"
    set id [open $filename]
    set ttd [read $id]
    close $id
    if {[catch {ttd::insert $widget($mainw,MainText) $ttd} message]} {
	tk_messageBox -icon info  -message $message  -title "The file cannot be opened"  -type ok  -parent $w
    }
    $mainw.MainText mark set insert 1.0
    ::visual_text::fill_tags $mainw
}

}
#############################################################################
## Procedure:  ::visual_text::command-save

namespace eval ::visual_text {

proc {::visual_text::command-save} {mainw {interactive 0}} {
global filename tk_strictMotif widget

    if {$interactive || ($filename == "")} {
        set old $tk_strictMotif
        set tk_strictMotif 0
        set file [tk_getSaveFile  -defaultextension {.ttd}   -initialdir .  -filetypes {{{Rich Tcl Text} *.ttd TEXT} {all *.* TEXT}}  -initialfile $filename  -title "Save..."]
        set tk_strictMotif $old
    } else {
        set file $filename
    }

    if {$file != ""} {
	set filename $file
	set id [open $filename w]
	set data [::ttd::get $widget($mainw,MainText)]
	puts -nonewline $id $data
	close $id
	wm title $mainw "$file - Visual Text"
    }
}

}
#############################################################################
## Procedure:  ::visual_text::fill_tags

namespace eval ::visual_text {

proc {::visual_text::fill_tags} {mainw} {
global widget

$mainw.TagsText configure -state normal
$mainw.TagsText delete 1.0 end
$mainw.TagsListbox delete 0 end

set tags [$mainw.MainText tag names]

foreach tag $tags {

    if {$tag == "sel"} continue

    set opts [$mainw.MainText tag configure $tag]
    set optvals ""

    foreach opt $opts {
        set name [lindex $opt 0]
        set val  [lindex $opt 4]
        lappend optvals $name $val
    }

    $mainw.TagsListbox insert end $tag
    $mainw.TagsText insert end $tag\n $tag
    $mainw.TagsText insert end \n default
    eval $mainw.TagsText tag configure [list $tag] $optvals
}

$mainw.TagsText tag configure default -background white
$mainw.TagsText configure -state disabled
}

}
#############################################################################
## Procedure:  ::visual_text::insert_image

namespace eval ::visual_text {

proc {::visual_text::insert_image} {mainw} {
global widget tk_strictMotif

set types {
    {{GIF Files}          {.gif}       }
    {{Portable Pixel Map} {.ppm}       }
    {{X Windows Bitmap}   {.xbm}       }
    {{All Files}          *            }
}
 
set old $tk_strictMotif
set tk_strictMotif 0
set newImageFile [tk_getOpenFile -filetypes $types  -defaultextension .gif]
set tk_strictMotif $old

if {$newImageFile == ""} { return }

set object [image create photo -file $newImageFile]
$mainw.MainText image create insert -image $object
}

}
#############################################################################
## Procedure:  ::visual_text::main

namespace eval ::visual_text {

proc {::visual_text::main} {W} {
global widget
wm protocol $W WM_DELETE_WINDOW {exit}

## set commands for toolbar buttons
::bitmapbutton::set_command $widget($W,ToolbarButtonSave)  {
    ::visual_text::command-save %top}
::bitmapbutton::set_command $widget($W,ToolbarButtonNew)   {
    ::visual_text::command-new %top}
::bitmapbutton::set_command $widget($W,ToolbarButtonCut)   {
    tk_textCut   $widget(%top,MainText)}
::bitmapbutton::set_command $widget($W,ToolbarButtonCopy)  {
    tk_textCopy  $widget(%top,MainText)}
::bitmapbutton::set_command $widget($W,ToolbarButtonPaste) {
    tk_textPaste $widget(%top,MainText)}
}

}
#############################################################################
## Procedure:  ::visual_text::show_insert_position

namespace eval ::visual_text {

proc {::visual_text::show_insert_position} {mainw} {
set position [$mainw.MainText index insert]
regexp {([0-9]+)\.([0-9]+)} $position matchAll line col
$mainw.LineCol configure -text "Line $line Col $col"
}

}
#############################################################################
## Procedure:  ::visual_text::show_tags_at_insert

namespace eval ::visual_text {

proc {::visual_text::show_tags_at_insert} {mainw} {
## if anything is selected, we show tags related to the selection
if {[$mainw.MainText tag ranges sel] != ""} {
    ::visual_text::show_tags_at_selection $mainw
    return
}

set tags [$mainw.MainText tag names insert]

$mainw.TagsListbox selection clear 0 end
set listtags [$mainw.TagsListbox get 0 end]

for {set i 0} {$i < [llength $listtags]} {incr i} {
    set tag [lindex $listtags $i]
    if {[lsearch -exact $tags $tag] != -1} {
        $mainw.TagsListbox itemconfigure $i -background #8080FF
    } else {
        $mainw.TagsListbox itemconfigure $i -background white
    }
}

::visual_text::show_insert_position $mainw
}

}
#############################################################################
## Procedure:  ::visual_text::show_tags_at_selection

namespace eval ::visual_text {

proc {::visual_text::show_tags_at_selection} {mainw} {
$mainw.TagsListbox selection clear 0 end
set listtags [$mainw.TagsListbox get 0 end]

set selranges [$mainw.MainText tag ranges sel]
set selstart  [lindex $selranges 0]
set selend    [lindex $selranges 1]

foreach tag $listtags {
    set ranges($tag) [$mainw.MainText tag ranges $tag]
}

for {set i 0} {$i < [llength $listtags]} {incr i} {
    set tag [lindex $listtags $i]
    
    ## check if a text is inside the selection or not
    set range $ranges($tag)
    set found 0
                
    while {[llength $range] > 0} {
        set start [lindex $range 0]
        set end   [lindex $range 1]
        set range [lreplace $range 0 1]
        
        set comp1 [compare_range $start $selstart]
        set comp2 [compare_range $selend     $end] 
        if {$comp1 <= 0 && $comp2 <= 0} {
            ## the tag is applied to the whole selection
            $mainw.TagsListbox itemconfigure $i -background #8080FF
            set found 1
            break
        } elseif {$comp1 >= 0 && $comp2 >= 0} {
            ## the tag is applied somewhere inside the selection
            $mainw.TagsListbox itemconfigure $i -background gray
            set found 1
            break
        } elseif {$comp1 == -1 && $comp2 == 1 &&
                  [compare_range $end $selstart] == 1} {
            ## the tag starts before the selection, ends in the middle
            $mainw.TagsListbox itemconfigure $i -background gray
            set found 1
            break
        } elseif {$comp1 == 1 && $comp2 == -1 &&
                  [compare_range $selend $start] == 1} {
            ## the tag starts inside the selection, ends outside
            $mainw.TagsListbox itemconfigure $i -background gray
            set found 1
            break
        } 
    }

    if {!$found} {
        $mainw.TagsListbox itemconfigure $i -background white
    }
}

::visual_text::show_insert_position $mainw
}

}
#############################################################################
## Procedure:  compare_range

proc {compare_range} {range1 range2} {
set range1 [split $range1 .]
set range2 [split $range2 .]

set line1 [lindex $range1 0]
set line2 [lindex $range2 0]
set col1  [lindex $range1 1]
set col2  [lindex $range2 1]

if {$line1 < $line2} {
    return -1
}

if {$line1 == $line2} {
    if {$col1 < $col2} {
        return -1
    } elseif {$col1 == $col2} {
        return 0
    } else {
        return 1
    } 
} else {
    return 1
}
}
#############################################################################
## Procedure:  get_option

proc {get_option} {opts opt} {
set index [lsearch -exact $opts $opt]
if {$index == -1} {
    return ""
}

incr index
return [lindex $opts $index]
}
#############################################################################
## Procedure:  main

proc {main} {argc argv} {
global widget

::edit_tag::init_edit_tag $widget(EditTag)
::about::init

## if not running vTcl, we use our own bindings for the text widget
if {![winfo exists .vTcl]} {
    bind Text <Control-Key-c> {}
    bind Text <Control-Key-x> {}
    bind Text <Control-Key-v> {}
}
}

#############################################################################
## Initialization Procedure:  init

proc {init} {argc argv} {
global filename
set filename ""
}

init $argc $argv

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {base} {
    if {$base == ""} {
        set base .
    }
    ###################
    # CREATING WIDGETS
    ###################
    wm focusmodel $base passive
    wm geometry $base 1x1+0+0; update
    wm maxsize $base 1009 738
    wm minsize $base 1 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm withdraw $base
    wm title $base "vtcl.tcl"
    bindtags $base "$base Vtcl.tcl all"
    vTcl:FireEvent $base <<Create>>
    wm protocol $base WM_DELETE_WINDOW "vTcl:FireEvent $base <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top18 {base} {
    if {$base == ""} {
        set base .top18
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }

    global widget
    vTcl:DefineAlias "$base" "AboutVisualText" vTcl:Toplevel:WidgetProc "" 1
    vTcl:DefineAlias "$base.cpd19.03" "AboutText" vTcl:WidgetProc "AboutVisualText" 1

    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $base -class Toplevel
    wm withdraw $base
    wm focusmodel $base passive
    wm geometry $base 471x392+264+181; update
    wm maxsize $base 1009 738
    wm minsize $base 100 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm title $base "About Visual Text"
    vTcl:FireEvent $base <<Create>>
    wm protocol $base WM_DELETE_WINDOW "vTcl:FireEvent $base <<DeleteWindow>>"

    frame $base.cpd19 \
        -borderwidth 1 -height 30 -relief sunken -width 30 
    scrollbar $base.cpd19.01 \
        -command "$base.cpd19.03 xview" -highlightthickness 0 \
        -orient horizontal 
    scrollbar $base.cpd19.02 \
        -command "$base.cpd19.03 yview" -highlightthickness 0 
    text $base.cpd19.03 \
        -background white \
        -font -Adobe-Helvetica-Medium-R-Normal-*-*-120-*-*-*-*-*-* -height 10 \
        -relief flat -width 20 -wrap word \
        -xscrollcommand "$base.cpd19.01 set" \
        -yscrollcommand "$base.cpd19.02 set" 
    button $base.but20 \
        -command {AboutVisualText hide} -text Close -width 8 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.cpd19 \
        -in $base -anchor center -expand 1 -fill both -side top 
    grid columnconf $base.cpd19 0 -weight 1
    grid rowconf $base.cpd19 0 -weight 1
    grid $base.cpd19.01 \
        -in $base.cpd19 -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky ew 
    grid $base.cpd19.02 \
        -in $base.cpd19 -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky ns 
    grid $base.cpd19.03 \
        -in $base.cpd19 -column 0 -row 0 -columnspan 1 -rowspan 1 \
        -sticky nesw 
    pack $base.but20 \
        -in $base -anchor center -expand 0 -fill none -pady 5 -side top 

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top19 {base} {
    if {$base == ""} {
        set base .top19
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }

    global widget
    vTcl:DefineAlias "$base" "DeleteTextTag" vTcl:Toplevel:WidgetProc "" 1
    vTcl:DefineAlias "$base.cpd22.01" "DeleteTagListbox" vTcl:WidgetProc "DeleteTextTag" 1
    vTcl:DefineAlias "$base.fra23.but24" "DeleteTagOK" vTcl:WidgetProc "DeleteTextTag" 1

    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $base -class Toplevel
    wm withdraw $base
    wm focusmodel $base passive
    wm geometry $base 394x328+322+213; update
    wm maxsize $base 1009 738
    wm minsize $base 1 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm title $base "Delete Tag"
    bind $base <<Show>> {
        DeleteTextTag.DeleteTagOK configure -state disabled
    }
    bind $base <Key-Escape> {
        set [winfo toplevel %W]::status "cancel"
    }
    bind $base <Key-Return> {
        set [winfo toplevel %W]::status "delete"
    }
    vTcl:FireEvent $base <<Create>>
    wm protocol $base WM_DELETE_WINDOW "vTcl:FireEvent $base <<DeleteWindow>>"

    label $base.lab20 \
        -anchor w -padx 1 -pady 1 \
        -text {Select the tag you want to delete, then press "Delete".} 
    frame $base.cpd22 \
        -borderwidth 1 -height 30 -relief sunken -width 30 
    listbox $base.cpd22.01 \
        -background white -highlightthickness 0 -relief flat \
        -xscrollcommand "$base.cpd22.02 set" \
        -yscrollcommand "$base.cpd22.03 set" 
    bind $base.cpd22.01 <<ListboxSelect>> {
        if {[%W curselection] != ""} {
    DeleteTextTag.DeleteTagOK configure -state normal
}
    }
    scrollbar $base.cpd22.02 \
        -command "$base.cpd22.01 xview" -highlightthickness 0 \
        -orient horizontal 
    scrollbar $base.cpd22.03 \
        -command "$base.cpd22.01 yview" -highlightthickness 0 
    frame $base.fra23
    button $base.fra23.but24 \
        \
        -command [list vTcl:DoCmdOption $base.fra23.but24 {set %top::status "delete"}] \
        -text Delete -width 8 
    button $base.fra23.but25 \
        \
        -command [list vTcl:DoCmdOption $base.fra23.but25 {set %top::status "cancel"}] \
        -text Cancel -width 8 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.lab20 \
        -in $base -anchor center -expand 0 -fill x -padx 2 -pady 2 -side top 
    pack $base.cpd22 \
        -in $base -anchor center -expand 1 -fill both -padx 2 -side top 
    grid columnconf $base.cpd22 0 -weight 1
    grid rowconf $base.cpd22 0 -weight 1
    grid $base.cpd22.01 \
        -in $base.cpd22 -column 0 -row 0 -columnspan 1 -rowspan 1 \
        -sticky nesw 
    grid $base.cpd22.02 \
        -in $base.cpd22 -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky ew 
    grid $base.cpd22.03 \
        -in $base.cpd22 -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky ns 
    pack $base.fra23 \
        -in $base -anchor center -expand 0 -fill none -pady 5 -side top 
    pack $base.fra23.but24 \
        -in $base.fra23 -anchor center -expand 0 -fill none -padx 5 \
        -side left 
    pack $base.fra23.but25 \
        -in $base.fra23 -anchor center -expand 0 -fill none -padx 5 \
        -side right 

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top21 {base} {
    if {$base == ""} {
        set base .top21
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }

    global widget
    vTcl:DefineAlias "$base.cpd23.01.cpd24.03" "MainText" vTcl:WidgetProc "$base" 1
    vTcl:DefineAlias "$base.cpd23.01.fra18.cpd19" "ToolbarButtonNew" vTcl:WidgetProc "$base" 1
    vTcl:DefineAlias "$base.cpd23.01.fra18.cpd20" "ToolbarButtonCut" vTcl:WidgetProc "$base" 1
    vTcl:DefineAlias "$base.cpd23.01.fra18.cpd21" "ToolbarButtonCopy" vTcl:WidgetProc "$base" 1
    vTcl:DefineAlias "$base.cpd23.01.fra18.cpd22" "ToolbarButtonPaste" vTcl:WidgetProc "$base" 1
    vTcl:DefineAlias "$base.cpd23.01.fra18.cpd23" "ToolbarButtonSave" vTcl:WidgetProc "$base" 1
    vTcl:DefineAlias "$base.cpd23.02.cpd22.01" "TagsListbox" vTcl:WidgetProc "$base" 1
    vTcl:DefineAlias "$base.cpd23.02.fra25.03" "TagsText" vTcl:WidgetProc "$base" 1
    vTcl:DefineAlias "$base.fra22.lab30" "LineCol" vTcl:WidgetProc "$base" 1

    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $base -class Toplevel \
        -menu "$base.m26" 
    wm focusmodel $base passive
    wm geometry $base 678x575+130+89; update
    wm maxsize $base 1009 738
    wm minsize $base 100 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "Visual Text"
    bindtags $base "$base Toplevel all Accelerators"
    bind $base <<Show>> {
        ::visual_text::main %W
    }
    vTcl:FireEvent $base <<Create>>
    wm protocol $base WM_DELETE_WINDOW "vTcl:FireEvent $base <<DeleteWindow>>"

    frame $base.fra22 \
        -borderwidth 1 
    label $base.fra22.lab30 \
        -borderwidth 1 -padx 1 -relief sunken -text {Line 6 Col 0} 
    label $base.fra22.lab31 \
        -borderwidth 1 -padx 1 -relief sunken -text INS 
    frame $base.cpd23 \
        -background #000000 
    frame $base.cpd23.01
    frame $base.cpd23.01.fra18 \
        -borderwidth 2 
    frame $base.cpd23.01.fra18.cpd23 \
        -borderwidth 2 -relief raised -takefocus 1 
    bindtags $base.cpd23.01.fra18.cpd23 "$base.cpd23.01.fra18.cpd23 Frame $base all BitmapButtonTop"
    frame $base.cpd23.01.fra18.cpd23.upframe \
        -borderwidth 2 -height 3 
    bindtags $base.cpd23.01.fra18.cpd23.upframe "$base.cpd23.01.fra18.cpd23.upframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd23.centerframe \
        -borderwidth 2 
    bindtags $base.cpd23.01.fra18.cpd23.centerframe "$base.cpd23.01.fra18.cpd23.centerframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd23.centerframe.leftframe \
        -borderwidth 2 -width 3 
    bindtags $base.cpd23.01.fra18.cpd23.centerframe.leftframe "$base.cpd23.01.fra18.cpd23.centerframe.leftframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd23.centerframe.rightframe \
        -borderwidth 2 -width 2 
    bindtags $base.cpd23.01.fra18.cpd23.centerframe.rightframe "$base.cpd23.01.fra18.cpd23.centerframe.rightframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd23.centerframe.05 \
        -borderwidth 1 
    bindtags $base.cpd23.01.fra18.cpd23.centerframe.05 "$base.cpd23.01.fra18.cpd23.centerframe.05 Frame $base all BitmapButtonSub2"
    label $base.cpd23.01.fra18.cpd23.centerframe.05.06 \
        -borderwidth 0 -height 20 \
        -image [vTcl:image:get_image [file join / home cgavin vtcl2-0 images edit save.gif]] \
        -text label 
    bindtags $base.cpd23.01.fra18.cpd23.centerframe.05.06 "$base.cpd23.01.fra18.cpd23.centerframe.05.06 Label $base all BitmapButtonSub3"
    label $base.cpd23.01.fra18.cpd23.centerframe.05.07 \
        -borderwidth 1 -padx 1 -text Save -width 5 
    bindtags $base.cpd23.01.fra18.cpd23.centerframe.05.07 "$base.cpd23.01.fra18.cpd23.centerframe.05.07 Label $base all BitmapButtonSub3"
    frame $base.cpd23.01.fra18.cpd23.downframe \
        -borderwidth 2 -height 2 -relief groove 
    bindtags $base.cpd23.01.fra18.cpd23.downframe "$base.cpd23.01.fra18.cpd23.downframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd19 \
        -borderwidth 2 -relief raised -takefocus 1 
    bindtags $base.cpd23.01.fra18.cpd19 "$base.cpd23.01.fra18.cpd19 Frame $base all BitmapButtonTop"
    frame $base.cpd23.01.fra18.cpd19.upframe \
        -borderwidth 2 -height 3 
    bindtags $base.cpd23.01.fra18.cpd19.upframe "$base.cpd23.01.fra18.cpd19.upframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd19.centerframe \
        -borderwidth 2 
    bindtags $base.cpd23.01.fra18.cpd19.centerframe "$base.cpd23.01.fra18.cpd19.centerframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd19.centerframe.leftframe \
        -borderwidth 2 -width 3 
    bindtags $base.cpd23.01.fra18.cpd19.centerframe.leftframe "$base.cpd23.01.fra18.cpd19.centerframe.leftframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd19.centerframe.rightframe \
        -borderwidth 2 -width 2 
    bindtags $base.cpd23.01.fra18.cpd19.centerframe.rightframe "$base.cpd23.01.fra18.cpd19.centerframe.rightframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd19.centerframe.05 \
        -borderwidth 1 
    bindtags $base.cpd23.01.fra18.cpd19.centerframe.05 "$base.cpd23.01.fra18.cpd19.centerframe.05 Frame $base all BitmapButtonSub2"
    label $base.cpd23.01.fra18.cpd19.centerframe.05.06 \
        -borderwidth 0 \
        -image [vTcl:image:get_image [file join / home cgavin vtcl2-0 images edit new.gif]] \
        -text label 
    bindtags $base.cpd23.01.fra18.cpd19.centerframe.05.06 "$base.cpd23.01.fra18.cpd19.centerframe.05.06 Label $base all BitmapButtonSub3"
    label $base.cpd23.01.fra18.cpd19.centerframe.05.07 \
        -borderwidth 1 -padx 1 -pady 1 -text New -width 5 
    bindtags $base.cpd23.01.fra18.cpd19.centerframe.05.07 "$base.cpd23.01.fra18.cpd19.centerframe.05.07 Label $base all BitmapButtonSub3"
    frame $base.cpd23.01.fra18.cpd19.downframe \
        -borderwidth 2 -height 2 -relief groove 
    bindtags $base.cpd23.01.fra18.cpd19.downframe "$base.cpd23.01.fra18.cpd19.downframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.fra24 \
        -borderwidth 2 -width 5 
    frame $base.cpd23.01.fra18.cpd20 \
        -borderwidth 2 -relief raised -takefocus 1 
    bindtags $base.cpd23.01.fra18.cpd20 "$base.cpd23.01.fra18.cpd20 Frame $base all BitmapButtonTop"
    frame $base.cpd23.01.fra18.cpd20.upframe \
        -borderwidth 2 -height 3 
    bindtags $base.cpd23.01.fra18.cpd20.upframe "$base.cpd23.01.fra18.cpd20.upframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd20.centerframe \
        -borderwidth 2 
    bindtags $base.cpd23.01.fra18.cpd20.centerframe "$base.cpd23.01.fra18.cpd20.centerframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd20.centerframe.leftframe \
        -borderwidth 2 -width 3 
    bindtags $base.cpd23.01.fra18.cpd20.centerframe.leftframe "$base.cpd23.01.fra18.cpd20.centerframe.leftframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd20.centerframe.rightframe \
        -borderwidth 2 -width 2 
    bindtags $base.cpd23.01.fra18.cpd20.centerframe.rightframe "$base.cpd23.01.fra18.cpd20.centerframe.rightframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd20.centerframe.05 \
        -borderwidth 1 
    bindtags $base.cpd23.01.fra18.cpd20.centerframe.05 "$base.cpd23.01.fra18.cpd20.centerframe.05 Frame $base all BitmapButtonSub2"
    label $base.cpd23.01.fra18.cpd20.centerframe.05.06 \
        -borderwidth 0 \
        -image [vTcl:image:get_image [file join / home cgavin vtcl2-0 images edit cut.gif]] \
        -text label 
    bindtags $base.cpd23.01.fra18.cpd20.centerframe.05.06 "$base.cpd23.01.fra18.cpd20.centerframe.05.06 Label $base all BitmapButtonSub3"
    label $base.cpd23.01.fra18.cpd20.centerframe.05.07 \
        -borderwidth 1 -text Cut -width 5 
    bindtags $base.cpd23.01.fra18.cpd20.centerframe.05.07 "$base.cpd23.01.fra18.cpd20.centerframe.05.07 Label $base all BitmapButtonSub3"
    frame $base.cpd23.01.fra18.cpd20.downframe \
        -borderwidth 2 -height 2 -relief groove 
    bindtags $base.cpd23.01.fra18.cpd20.downframe "$base.cpd23.01.fra18.cpd20.downframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd21 \
        -borderwidth 2 -relief raised -takefocus 1 
    bindtags $base.cpd23.01.fra18.cpd21 "$base.cpd23.01.fra18.cpd21 Frame $base all BitmapButtonTop"
    frame $base.cpd23.01.fra18.cpd21.upframe \
        -borderwidth 2 -height 3 
    bindtags $base.cpd23.01.fra18.cpd21.upframe "$base.cpd23.01.fra18.cpd21.upframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd21.centerframe \
        -borderwidth 2 
    bindtags $base.cpd23.01.fra18.cpd21.centerframe "$base.cpd23.01.fra18.cpd21.centerframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd21.centerframe.leftframe \
        -borderwidth 2 -width 3 
    bindtags $base.cpd23.01.fra18.cpd21.centerframe.leftframe "$base.cpd23.01.fra18.cpd21.centerframe.leftframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd21.centerframe.rightframe \
        -borderwidth 2 -width 2 
    bindtags $base.cpd23.01.fra18.cpd21.centerframe.rightframe "$base.cpd23.01.fra18.cpd21.centerframe.rightframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd21.centerframe.05 \
        -borderwidth 1 
    bindtags $base.cpd23.01.fra18.cpd21.centerframe.05 "$base.cpd23.01.fra18.cpd21.centerframe.05 Frame $base all BitmapButtonSub2"
    label $base.cpd23.01.fra18.cpd21.centerframe.05.06 \
        -borderwidth 0 \
        -image [vTcl:image:get_image [file join / home cgavin vtcl2-0 images edit copy.gif]] \
        -text label 
    bindtags $base.cpd23.01.fra18.cpd21.centerframe.05.06 "$base.cpd23.01.fra18.cpd21.centerframe.05.06 Label $base all BitmapButtonSub3"
    label $base.cpd23.01.fra18.cpd21.centerframe.05.07 \
        -borderwidth 1 -padx 1 -pady 1 -text Copy -width 5 
    bindtags $base.cpd23.01.fra18.cpd21.centerframe.05.07 "$base.cpd23.01.fra18.cpd21.centerframe.05.07 Label $base all BitmapButtonSub3"
    frame $base.cpd23.01.fra18.cpd21.downframe \
        -borderwidth 2 -height 2 -relief groove 
    bindtags $base.cpd23.01.fra18.cpd21.downframe "$base.cpd23.01.fra18.cpd21.downframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd22 \
        -borderwidth 2 -relief raised -takefocus 1 
    bindtags $base.cpd23.01.fra18.cpd22 "$base.cpd23.01.fra18.cpd22 Frame $base all BitmapButtonTop"
    frame $base.cpd23.01.fra18.cpd22.upframe \
        -borderwidth 2 -height 3 
    bindtags $base.cpd23.01.fra18.cpd22.upframe "$base.cpd23.01.fra18.cpd22.upframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd22.centerframe \
        -borderwidth 2 
    bindtags $base.cpd23.01.fra18.cpd22.centerframe "$base.cpd23.01.fra18.cpd22.centerframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.fra18.cpd22.centerframe.leftframe \
        -borderwidth 2 -width 3 
    bindtags $base.cpd23.01.fra18.cpd22.centerframe.leftframe "$base.cpd23.01.fra18.cpd22.centerframe.leftframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd22.centerframe.rightframe \
        -borderwidth 2 -width 2 
    bindtags $base.cpd23.01.fra18.cpd22.centerframe.rightframe "$base.cpd23.01.fra18.cpd22.centerframe.rightframe Frame $base all BitmapButtonSub2"
    frame $base.cpd23.01.fra18.cpd22.centerframe.05 \
        -borderwidth 1 
    bindtags $base.cpd23.01.fra18.cpd22.centerframe.05 "$base.cpd23.01.fra18.cpd22.centerframe.05 Frame $base all BitmapButtonSub2"
    label $base.cpd23.01.fra18.cpd22.centerframe.05.06 \
        -borderwidth 0 \
        -image [vTcl:image:get_image [file join / home cgavin vtcl2-0 images edit paste.gif]] \
        -text label 
    bindtags $base.cpd23.01.fra18.cpd22.centerframe.05.06 "$base.cpd23.01.fra18.cpd22.centerframe.05.06 Label $base all BitmapButtonSub3"
    label $base.cpd23.01.fra18.cpd22.centerframe.05.07 \
        -borderwidth 1 -text Paste -width 5 
    bindtags $base.cpd23.01.fra18.cpd22.centerframe.05.07 "$base.cpd23.01.fra18.cpd22.centerframe.05.07 Label $base all BitmapButtonSub3"
    frame $base.cpd23.01.fra18.cpd22.downframe \
        -borderwidth 2 -height 2 -relief groove 
    bindtags $base.cpd23.01.fra18.cpd22.downframe "$base.cpd23.01.fra18.cpd22.downframe Frame $base all BitmapButtonSub1"
    frame $base.cpd23.01.cpd24 \
        -borderwidth 1 -height 30 -relief sunken -width 30 
    scrollbar $base.cpd23.01.cpd24.01 \
        -command "$base.cpd23.01.cpd24.03 xview" -highlightthickness 0 \
        -orient horizontal 
    scrollbar $base.cpd23.01.cpd24.02 \
        -command "$base.cpd23.01.cpd24.03 yview" -highlightthickness 0 
    text $base.cpd23.01.cpd24.03 \
        -background white -borderwidth 0 -wrap word \
        -xscrollcommand "$base.cpd23.01.cpd24.01 set" \
        -yscrollcommand "$base.cpd23.01.cpd24.02 set" 
    bindtags $base.cpd23.01.cpd24.03 "Text $base all $base.cpd23.01.cpd24.03 Accelerators"
    bind $base.cpd23.01.cpd24.03 <Button-1> {
        ::visual_text::show_tags_at_insert [winfo toplevel %W]
    }
    bind $base.cpd23.01.cpd24.03 <Key> {
        ::visual_text::show_tags_at_insert [winfo toplevel %W]
    }
    frame $base.cpd23.02
    frame $base.cpd23.02.fra25 \
        -borderwidth 1 -height 30 -relief sunken -width 30 
    scrollbar $base.cpd23.02.fra25.01 \
        -command "$base.cpd23.02.fra25.03 xview" -highlightthickness 0 \
        -orient horizontal 
    scrollbar $base.cpd23.02.fra25.02 \
        -command "$base.cpd23.02.fra25.03 yview" -highlightthickness 0 
    text $base.cpd23.02.fra25.03 \
        -background white -borderwidth 0 -height 20 -width 20 \
        -xscrollcommand "$base.cpd23.02.fra25.01 set" \
        -yscrollcommand "$base.cpd23.02.fra25.02 set" 
    bindtags $base.cpd23.02.fra25.03 "$base.cpd23.02.fra25.03 Text $base all Accelerators"
    frame $base.cpd23.02.fra22 \
        -borderwidth 2 -height 75 -width 125 
    button $base.cpd23.02.fra22.but23 \
        \
        -command [list vTcl:DoCmdOption $base.cpd23.02.fra22.but23 {::visual_text::command-add_tag %top $widget(EditTag)}] \
        -image [vTcl:image:get_image [file join / home cgavin vtcl2-0 images edit add.gif]] \
        -relief flat -text button 
    bindtags $base.cpd23.02.fra22.but23 "$base.cpd23.02.fra22.but23 Button $base all FlatToolbarButton"
    button $base.cpd23.02.fra22.but24 \
        \
        -command [list vTcl:DoCmdOption $base.cpd23.02.fra22.but24 {::delete_tag::do_modal %top $widget(DeleteTextTag)}] \
        -image [vTcl:image:get_image [file join / home cgavin vtcl2-0 images edit remove.gif]] \
        -relief flat -text button 
    bindtags $base.cpd23.02.fra22.but24 "$base.cpd23.02.fra22.but24 Button $base all FlatToolbarButton"
    frame $base.cpd23.02.cpd22 \
        -borderwidth 1 -relief sunken -width 30 
    listbox $base.cpd23.02.cpd22.01 \
        -background white -borderwidth 0 -relief flat -selectmode multiple \
        -xscrollcommand "$base.cpd23.02.cpd22.02 set" \
        -yscrollcommand "$base.cpd23.02.cpd22.03 set" 
    bindtags $base.cpd23.02.cpd22.01 "$base.cpd23.02.cpd22.01 Listbox $base all Accelerators"
    bind $base.cpd23.02.cpd22.01 <Button-1> {
        if {[MainText tag ranges sel] != ""} {
    ::visual_text::apply_tag [winfo toplevel %W] %x %y
}
break
    }
    bind $base.cpd23.02.cpd22.01 <Button-3> {
        ::visual_text::command-edit_tag [winfo toplevel %W] $widget(EditTag) [%W get @%x,%y]
    }
    scrollbar $base.cpd23.02.cpd22.02 \
        -command "$base.cpd23.02.cpd22.01 xview" -highlightthickness 0 \
        -orient horizontal 
    scrollbar $base.cpd23.02.cpd22.03 \
        -command "$base.cpd23.02.cpd22.01 yview" -highlightthickness 0 
    frame $base.cpd23.02.fra23 \
        -borderwidth 2 -height 2 -relief raised -width 125 
    frame $base.cpd23.03 \
        -background #ff0000 -borderwidth 2 -relief raised 
    bind $base.cpd23.03 <B1-Motion> {
        set root [ split %W . ]
    set nb [ llength $root ]
    incr nb -1
    set root [ lreplace $root $nb $nb ]
    set root [ join $root . ]
    set width [ winfo width $root ].0

    set val [ expr (%X - [winfo rootx $root]) /$width ]

    if { $val >= 0 && $val <= 1.0 } {

        place $root.01 -relwidth $val
        place $root.03 -relx $val
        place $root.02 -relwidth [ expr 1.0 - $val ]
    }
    }
    menu $base.m26 \
        -borderwidth 0 -cursor {} -relief flat -tearoff 0 
    $base.m26 add cascade \
        -menu "$base.m26.men27" -accelerator {} -command {} -image {} \
        -label File 
    $base.m26 add cascade \
        -menu "$base.m26.men28" -accelerator {} -command {} -image {} \
        -label Edit 
    $base.m26 add cascade \
        -menu "$base.m26.men29" -accelerator {} -command {} -image {} \
        -label Help 
    menu $base.m26.men27 \
        -tearoff 0 
    $base.m26.men27 add command \
        -accelerator {Ctrl + N} \
        -command [list vTcl:DoCmdOption $base.m26.men27 {::visual_text::command-new %top}] \
        -image {} -label New 
    $base.m26.men27 add separator
    $base.m26.men27 add command \
        -accelerator {Ctrl + O} \
        -command [list vTcl:DoCmdOption $base.m26.men27 {::visual_text::command-open %top}] \
        -image {} -label Open... 
    $base.m26.men27 add command \
        -accelerator {Ctrl + S} \
        -command [list vTcl:DoCmdOption $base.m26.men27 {::visual_text::command-save %top}] \
        -image {} -label Save 
    $base.m26.men27 add command \
        -accelerator {} \
        -command [list vTcl:DoCmdOption $base.m26.men27 {::visual_text::command-save %top 1}] \
        -image {} -label {Save As...} 
    $base.m26.men27 add separator
    $base.m26.men27 add command \
        -accelerator {Ctrl + Q} -command exit -image {} -label Quit 
    menu $base.m26.men28 \
        -tearoff 0 
    $base.m26.men28 add command \
        -accelerator {Ctrl + X} \
        -command [list vTcl:DoCmdOption $base.m26.men28 {tk_textCut   $widget(%top,MainText)}] \
        -image {} -label Cut 
    $base.m26.men28 add command \
        -accelerator {Ctrl + C} \
        -command [list vTcl:DoCmdOption $base.m26.men28 {tk_textCopy   $widget(%top,MainText)}] \
        -image {} -label Copy 
    $base.m26.men28 add command \
        -accelerator {Ctrl + V} \
        -command [list vTcl:DoCmdOption $base.m26.men28 {tk_textPaste   $widget(%top,MainText)}] \
        -image {} -label Paste 
    $base.m26.men28 add separator
    $base.m26.men28 add command \
        -accelerator {} \
        -command [list vTcl:DoCmdOption $base.m26.men28 {::visual_text::insert_image %top}] \
        -image {} -label {Insert image...} 
    menu $base.m26.men29 \
        -tearoff 0 
    $base.m26.men29 add command \
        -accelerator F1 -command {AboutVisualText show} -image {} \
        -label About... 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.fra22 \
        -in $base -anchor center -expand 0 -fill x -side bottom 
    pack $base.fra22.lab30 \
        -in $base.fra22 -anchor center -expand 0 -fill none -padx 2 \
        -side left 
    pack $base.fra22.lab31 \
        -in $base.fra22 -anchor center -expand 0 -fill none -padx 2 \
        -side left 
    pack $base.cpd23 \
        -in $base -anchor center -expand 1 -fill both -side top 
    place $base.cpd23.01 \
        -x 0 -y 0 -width -1 -relwidth 0.6906 -relheight 1 -anchor nw \
        -bordermode ignore 
    pack $base.cpd23.01.fra18 \
        -in $base.cpd23.01 -anchor center -expand 0 -fill x -side top 
    pack $base.cpd23.01.fra18.cpd23 \
        -in $base.cpd23.01.fra18 -anchor center -expand 0 -fill none -padx 5 \
        -side left 
    pack $base.cpd23.01.fra18.cpd23.upframe \
        -in $base.cpd23.01.fra18.cpd23 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd23.centerframe \
        -in $base.cpd23.01.fra18.cpd23 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd23.centerframe.leftframe \
        -in $base.cpd23.01.fra18.cpd23.centerframe -anchor center -expand 0 \
        -fill none -side left 
    pack $base.cpd23.01.fra18.cpd23.centerframe.rightframe \
        -in $base.cpd23.01.fra18.cpd23.centerframe -anchor center -expand 0 \
        -fill none -side right 
    pack $base.cpd23.01.fra18.cpd23.centerframe.05 \
        -in $base.cpd23.01.fra18.cpd23.centerframe -anchor center -expand 0 \
        -fill none -side top 
    pack $base.cpd23.01.fra18.cpd23.centerframe.05.06 \
        -in $base.cpd23.01.fra18.cpd23.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd23.centerframe.05.07 \
        -in $base.cpd23.01.fra18.cpd23.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd23.downframe \
        -in $base.cpd23.01.fra18.cpd23 -anchor center -expand 0 -fill none \
        -side bottom 
    pack $base.cpd23.01.fra18.cpd19 \
        -in $base.cpd23.01.fra18 -anchor center -expand 0 -fill none -pady 5 \
        -side left 
    pack $base.cpd23.01.fra18.cpd19.upframe \
        -in $base.cpd23.01.fra18.cpd19 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd19.centerframe \
        -in $base.cpd23.01.fra18.cpd19 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd19.centerframe.leftframe \
        -in $base.cpd23.01.fra18.cpd19.centerframe -anchor center -expand 0 \
        -fill none -side left 
    pack $base.cpd23.01.fra18.cpd19.centerframe.rightframe \
        -in $base.cpd23.01.fra18.cpd19.centerframe -anchor center -expand 0 \
        -fill none -side right 
    pack $base.cpd23.01.fra18.cpd19.centerframe.05 \
        -in $base.cpd23.01.fra18.cpd19.centerframe -anchor center -expand 0 \
        -fill none -side top 
    pack $base.cpd23.01.fra18.cpd19.centerframe.05.06 \
        -in $base.cpd23.01.fra18.cpd19.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd19.centerframe.05.07 \
        -in $base.cpd23.01.fra18.cpd19.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd19.downframe \
        -in $base.cpd23.01.fra18.cpd19 -anchor center -expand 0 -fill none \
        -side bottom 
    pack $base.cpd23.01.fra18.fra24 \
        -in $base.cpd23.01.fra18 -anchor center -expand 0 -fill none \
        -side left 
    pack $base.cpd23.01.fra18.cpd20 \
        -in $base.cpd23.01.fra18 -anchor center -expand 0 -fill none -padx 5 \
        -pady 5 -side left 
    pack $base.cpd23.01.fra18.cpd20.upframe \
        -in $base.cpd23.01.fra18.cpd20 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd20.centerframe \
        -in $base.cpd23.01.fra18.cpd20 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd20.centerframe.leftframe \
        -in $base.cpd23.01.fra18.cpd20.centerframe -anchor center -expand 0 \
        -fill none -side left 
    pack $base.cpd23.01.fra18.cpd20.centerframe.rightframe \
        -in $base.cpd23.01.fra18.cpd20.centerframe -anchor center -expand 0 \
        -fill none -side right 
    pack $base.cpd23.01.fra18.cpd20.centerframe.05 \
        -in $base.cpd23.01.fra18.cpd20.centerframe -anchor center -expand 0 \
        -fill none -side top 
    pack $base.cpd23.01.fra18.cpd20.centerframe.05.06 \
        -in $base.cpd23.01.fra18.cpd20.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd20.centerframe.05.07 \
        -in $base.cpd23.01.fra18.cpd20.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd20.downframe \
        -in $base.cpd23.01.fra18.cpd20 -anchor center -expand 0 -fill none \
        -side bottom 
    pack $base.cpd23.01.fra18.cpd21 \
        -in $base.cpd23.01.fra18 -anchor center -expand 0 -fill none -pady 5 \
        -side left 
    pack $base.cpd23.01.fra18.cpd21.upframe \
        -in $base.cpd23.01.fra18.cpd21 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd21.centerframe \
        -in $base.cpd23.01.fra18.cpd21 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd21.centerframe.leftframe \
        -in $base.cpd23.01.fra18.cpd21.centerframe -anchor center -expand 0 \
        -fill none -side left 
    pack $base.cpd23.01.fra18.cpd21.centerframe.rightframe \
        -in $base.cpd23.01.fra18.cpd21.centerframe -anchor center -expand 0 \
        -fill none -side right 
    pack $base.cpd23.01.fra18.cpd21.centerframe.05 \
        -in $base.cpd23.01.fra18.cpd21.centerframe -anchor center -expand 0 \
        -fill none -side top 
    pack $base.cpd23.01.fra18.cpd21.centerframe.05.06 \
        -in $base.cpd23.01.fra18.cpd21.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd21.centerframe.05.07 \
        -in $base.cpd23.01.fra18.cpd21.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd21.downframe \
        -in $base.cpd23.01.fra18.cpd21 -anchor center -expand 0 -fill none \
        -side bottom 
    pack $base.cpd23.01.fra18.cpd22 \
        -in $base.cpd23.01.fra18 -anchor center -expand 0 -fill none -padx 5 \
        -side left 
    pack $base.cpd23.01.fra18.cpd22.upframe \
        -in $base.cpd23.01.fra18.cpd22 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd22.centerframe \
        -in $base.cpd23.01.fra18.cpd22 -anchor center -expand 0 -fill none \
        -side top 
    pack $base.cpd23.01.fra18.cpd22.centerframe.leftframe \
        -in $base.cpd23.01.fra18.cpd22.centerframe -anchor center -expand 0 \
        -fill none -side left 
    pack $base.cpd23.01.fra18.cpd22.centerframe.rightframe \
        -in $base.cpd23.01.fra18.cpd22.centerframe -anchor center -expand 0 \
        -fill none -side right 
    pack $base.cpd23.01.fra18.cpd22.centerframe.05 \
        -in $base.cpd23.01.fra18.cpd22.centerframe -anchor center -expand 0 \
        -fill none -side top 
    pack $base.cpd23.01.fra18.cpd22.centerframe.05.06 \
        -in $base.cpd23.01.fra18.cpd22.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd22.centerframe.05.07 \
        -in $base.cpd23.01.fra18.cpd22.centerframe.05 -anchor center \
        -expand 0 -fill none -side top 
    pack $base.cpd23.01.fra18.cpd22.downframe \
        -in $base.cpd23.01.fra18.cpd22 -anchor center -expand 0 -fill none \
        -side bottom 
    pack $base.cpd23.01.cpd24 \
        -in $base.cpd23.01 -anchor center -expand 1 -fill both -padx 5 \
        -side top 
    grid columnconf $base.cpd23.01.cpd24 0 -weight 1
    grid rowconf $base.cpd23.01.cpd24 0 -weight 1
    grid $base.cpd23.01.cpd24.01 \
        -in $base.cpd23.01.cpd24 -column 0 -row 1 -columnspan 1 -rowspan 1 \
        -sticky ew 
    grid $base.cpd23.01.cpd24.02 \
        -in $base.cpd23.01.cpd24 -column 1 -row 0 -columnspan 1 -rowspan 1 \
        -sticky ns 
    grid $base.cpd23.01.cpd24.03 \
        -in $base.cpd23.01.cpd24 -column 0 -row 0 -columnspan 1 -rowspan 1 \
        -sticky nesw 
    place $base.cpd23.02 \
        -x 0 -relx 1 -y 0 -width -1 -relwidth 0.3094 -relheight 1 -anchor ne \
        -bordermode ignore 
    pack $base.cpd23.02.fra25 \
        -in $base.cpd23.02 -anchor center -expand 1 -fill both -padx 5 \
        -side bottom 
    grid columnconf $base.cpd23.02.fra25 0 -weight 1
    grid rowconf $base.cpd23.02.fra25 0 -weight 1
    grid $base.cpd23.02.fra25.01 \
        -in $base.cpd23.02.fra25 -column 0 -row 1 -columnspan 1 -rowspan 1 \
        -sticky ew 
    grid $base.cpd23.02.fra25.02 \
        -in $base.cpd23.02.fra25 -column 1 -row 0 -columnspan 1 -rowspan 1 \
        -sticky ns 
    grid $base.cpd23.02.fra25.03 \
        -in $base.cpd23.02.fra25 -column 0 -row 0 -columnspan 1 -rowspan 1 \
        -sticky nesw 
    pack $base.cpd23.02.fra22 \
        -in $base.cpd23.02 -anchor center -expand 0 -fill x -side top 
    pack $base.cpd23.02.fra22.but23 \
        -in $base.cpd23.02.fra22 -anchor center -expand 0 -fill none \
        -side left 
    pack $base.cpd23.02.fra22.but24 \
        -in $base.cpd23.02.fra22 -anchor center -expand 0 -fill none \
        -side left 
    pack $base.cpd23.02.cpd22 \
        -in $base.cpd23.02 -anchor center -expand 1 -fill both -padx 5 \
        -side top 
    grid columnconf $base.cpd23.02.cpd22 0 -weight 1
    grid rowconf $base.cpd23.02.cpd22 0 -weight 1
    grid $base.cpd23.02.cpd22.01 \
        -in $base.cpd23.02.cpd22 -column 0 -row 0 -columnspan 1 -rowspan 1 \
        -sticky nesw 
    grid $base.cpd23.02.cpd22.02 \
        -in $base.cpd23.02.cpd22 -column 0 -row 1 -columnspan 1 -rowspan 1 \
        -sticky ew 
    grid $base.cpd23.02.cpd22.03 \
        -in $base.cpd23.02.cpd22 -column 1 -row 0 -columnspan 1 -rowspan 1 \
        -sticky ns 
    pack $base.cpd23.02.fra23 \
        -in $base.cpd23.02 -anchor center -expand 0 -fill x -padx 5 -pady 10 \
        -side top 
    place $base.cpd23.03 \
        -x 0 -relx 0.6906 -y 0 -rely 0.9 -width 10 -height 10 -anchor s \
        -bordermode ignore 

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top22 {base} {
    if {$base == ""} {
        set base .top22
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }

    global widget
    vTcl:DefineAlias "$base" "EditTag" vTcl:Toplevel:WidgetProc "" 1
    vTcl:DefineAlias "$base.cpd44.03" "TagSampleText" vTcl:WidgetProc "EditTag" 1
    vTcl:DefineAlias "$base.ent24" "TagNameEntry" vTcl:WidgetProc "EditTag" 1
    vTcl:DefineAlias "$base.fra27.cpd28.01" "FontsListbox" vTcl:WidgetProc "EditTag" 1
    vTcl:DefineAlias "$base.fra27.fra29.lab22" "TagBackground" vTcl:WidgetProc "EditTag" 1
    vTcl:DefineAlias "$base.fra27.fra29.lab23" "TagForeground" vTcl:WidgetProc "EditTag" 1
    vTcl:DefineAlias "$base.fra46.but47" "EditTagOK" vTcl:WidgetProc "EditTag" 1

    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $base -class Toplevel
    wm withdraw $base
    wm focusmodel $base passive
    wm geometry $base 439x473+276+181; update
    wm maxsize $base 1009 738
    wm minsize $base 100 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm title $base "Edit Tag"
    vTcl:FireEvent $base <<Create>>
    wm protocol $base WM_DELETE_WINDOW "vTcl:FireEvent $base <<DeleteWindow>>"

    label $base.lab23 \
        -anchor w -text {Tag name:} 
    entry $base.ent24 \
        -background white -textvariable "$base\::tag_name" 
    bindtags $base.ent24 "Entry $base all $base.ent24"
    bind $base.ent24 <Key> {
        ::edit_tag::enable_ok [winfo toplevel %W]
    }
    frame $base.fra25 \
        -borderwidth 2 -height 2 -relief groove -width 125 
    frame $base.fra27 \
        -borderwidth 2 -height 75 -width 125 
    frame $base.fra27.cpd28 \
        -borderwidth 1 -height 30 -relief sunken -width 30 
    listbox $base.fra27.cpd28.01 \
        -background white -height 5 -relief flat -width 40 \
        -xscrollcommand "$base.fra27.cpd28.02 set" \
        -yscrollcommand "$base.fra27.cpd28.03 set" 
    bind $base.fra27.cpd28.01 <<ListboxSelect>> {
        set ::[winfo toplevel %W]::selected_font [%W get [%W curselection]]
::edit_tag::update_sample [winfo toplevel %W]
    }
    scrollbar $base.fra27.cpd28.02 \
        -command "$base.fra27.cpd28.01 xview" -highlightthickness 0 \
        -orient horizontal 
    scrollbar $base.fra27.cpd28.03 \
        -command "$base.fra27.cpd28.01 yview" -highlightthickness 0 
    frame $base.fra27.fra29 \
        -borderwidth 2 -height 75 -width 125 
    frame $base.fra27.fra29.fra30 \
        -borderwidth 2 -height 75 -width 125 
    label $base.fra27.fra29.fra30.lab34 \
        -text Size: 
    button $base.fra27.fra29.fra30.but31 \
        \
        -command [list vTcl:DoCmdOption $base.fra27.fra29.fra30.but31 {incr ::%top::font_size_entry -1
::edit_tag::update_sample %top}] \
        -padx 0 -pady 0 -text < 
    entry $base.fra27.fra29.fra30.ent32 \
        -background white -justify center -state disabled \
        -textvariable "$base\::font_size_entry" -width 3 
    button $base.fra27.fra29.fra30.but33 \
        \
        -command [list vTcl:DoCmdOption $base.fra27.fra29.fra30.but33 {incr ::%top::font_size_entry
::edit_tag::update_sample %top}] \
        -padx 0 -pady 0 -text > 
    checkbutton $base.fra27.fra29.che35 \
        -anchor w \
        -command [list vTcl:DoCmdOption $base.fra27.fra29.che35 {::edit_tag::update_sample %top}] \
        -pady 0 -text Bold -variable "$base\::bold_check" 
    checkbutton $base.fra27.fra29.che37 \
        -anchor w \
        -command [list vTcl:DoCmdOption $base.fra27.fra29.che37 {::edit_tag::update_sample %top}] \
        -pady 0 -text Italic -variable "$base\::italic_check" 
    checkbutton $base.fra27.fra29.che38 \
        -anchor w \
        -command [list vTcl:DoCmdOption $base.fra27.fra29.che38 {::edit_tag::update_sample %top}] \
        -pady 0 -text Underline -variable "$base\::underline_check" 
    checkbutton $base.fra27.fra29.che39 \
        -anchor w \
        -command [list vTcl:DoCmdOption $base.fra27.fra29.che39 {::edit_tag::update_sample %top}] \
        -pady 0 -text Overstrike -variable "$base\::overstrike_check" 
    label $base.fra27.fra29.lab40 \
        -anchor w -text Justify 
    radiobutton $base.fra27.fra29.rad41 \
        -anchor w \
        -command [list vTcl:DoCmdOption $base.fra27.fra29.rad41 {::edit_tag::update_sample %top}] \
        -pady 0 -text left -value left -variable "$base\::justify_radio" 
    radiobutton $base.fra27.fra29.rad42 \
        -anchor w \
        -command [list vTcl:DoCmdOption $base.fra27.fra29.rad42 {::edit_tag::update_sample %top}] \
        -pady 0 -text center -value center -variable "$base\::justify_radio" 
    radiobutton $base.fra27.fra29.rad43 \
        -anchor w \
        -command [list vTcl:DoCmdOption $base.fra27.fra29.rad43 {::edit_tag::update_sample %top}] \
        -pady 0 -text right -value right -variable "$base\::justify_radio" 
    label $base.fra27.fra29.lab22 \
        -background white -text Bkgnd 
    bind $base.fra27.fra29.lab22 <Button-1> {
        %W configure -background [tk_chooseColor -initialcolor [%W cget -background]]
::edit_tag::update_sample [winfo toplevel %W]
    }
    label $base.fra27.fra29.lab23 \
        -background #000000 -text Foregnd 
    bind $base.fra27.fra29.lab23 <Button-1> {
        %W configure -background [tk_chooseColor -initialcolor [%W cget -background]]
::edit_tag::update_sample [winfo toplevel %W]
    }
    frame $base.fra26 \
        -borderwidth 2 -height 2 -relief groove -width 125 
    frame $base.cpd44 \
        -borderwidth 1 -height 30 -relief sunken -width 30 
    scrollbar $base.cpd44.01 \
        -command "$base.cpd44.03 xview" -highlightthickness 0 \
        -orient horizontal 
    scrollbar $base.cpd44.02 \
        -command "$base.cpd44.03 yview" -highlightthickness 0 
    text $base.cpd44.03 \
        -background white -height 4 -relief flat -width 20 -wrap word \
        -xscrollcommand "$base.cpd44.01 set" \
        -yscrollcommand "$base.cpd44.02 set" 
    frame $base.fra45 \
        -borderwidth 2 -height 2 -relief groove -width 125 
    frame $base.fra46 \
        -borderwidth 2 -height 75 -width 125 
    button $base.fra46.but47 \
        \
        -command [list vTcl:DoCmdOption $base.fra46.but47 {set ::%top::edit_tag_status "OK"}] \
        -text OK -width 8 
    button $base.fra46.but48 \
        \
        -command [list vTcl:DoCmdOption $base.fra46.but48 {set ::%top::edit_tag_status "Cancel"}] \
        -text Cancel -width 8 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.lab23 \
        -in $base -anchor center -expand 0 -fill x -side top 
    pack $base.ent24 \
        -in $base -anchor center -expand 0 -fill x -side top 
    pack $base.fra25 \
        -in $base -anchor center -expand 0 -fill x -pady 5 -side top 
    pack $base.fra27 \
        -in $base -anchor center -expand 0 -fill both -side top 
    pack $base.fra27.cpd28 \
        -in $base.fra27 -anchor center -expand 1 -fill both -side left 
    grid columnconf $base.fra27.cpd28 0 -weight 1
    grid rowconf $base.fra27.cpd28 0 -weight 1
    grid $base.fra27.cpd28.01 \
        -in $base.fra27.cpd28 -column 0 -row 0 -columnspan 1 -rowspan 1 \
        -sticky nesw 
    grid $base.fra27.cpd28.02 \
        -in $base.fra27.cpd28 -column 0 -row 1 -columnspan 1 -rowspan 1 \
        -sticky ew 
    grid $base.fra27.cpd28.03 \
        -in $base.fra27.cpd28 -column 1 -row 0 -columnspan 1 -rowspan 1 \
        -sticky ns 
    pack $base.fra27.fra29 \
        -in $base.fra27 -anchor center -expand 0 -fill y -side right 
    pack $base.fra27.fra29.fra30 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill none -ipadx 2 \
        -ipady 2 -side top 
    pack $base.fra27.fra29.fra30.lab34 \
        -in $base.fra27.fra29.fra30 -anchor center -expand 0 -fill none \
        -side left 
    pack $base.fra27.fra29.fra30.but31 \
        -in $base.fra27.fra29.fra30 -anchor center -expand 0 -fill none \
        -side left 
    pack $base.fra27.fra29.fra30.ent32 \
        -in $base.fra27.fra29.fra30 -anchor center -expand 0 -fill none \
        -side left 
    pack $base.fra27.fra29.fra30.but33 \
        -in $base.fra27.fra29.fra30 -anchor center -expand 0 -fill none \
        -side left 
    pack $base.fra27.fra29.che35 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -side top 
    pack $base.fra27.fra29.che37 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -side top 
    pack $base.fra27.fra29.che38 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -side top 
    pack $base.fra27.fra29.che39 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -side top 
    pack $base.fra27.fra29.lab40 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -side top 
    pack $base.fra27.fra29.rad41 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -side top 
    pack $base.fra27.fra29.rad42 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -side top 
    pack $base.fra27.fra29.rad43 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -side top 
    pack $base.fra27.fra29.lab22 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -padx 2 \
        -pady 1 -side top 
    pack $base.fra27.fra29.lab23 \
        -in $base.fra27.fra29 -anchor center -expand 0 -fill x -padx 2 \
        -pady 1 -side top 
    pack $base.fra26 \
        -in $base -anchor center -expand 0 -fill x -pady 5 -side top 
    pack $base.cpd44 \
        -in $base -anchor center -expand 1 -fill both -padx 2 -side top 
    grid columnconf $base.cpd44 0 -weight 1
    grid rowconf $base.cpd44 0 -weight 1
    grid $base.cpd44.01 \
        -in $base.cpd44 -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky ew 
    grid $base.cpd44.02 \
        -in $base.cpd44 -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky ns 
    grid $base.cpd44.03 \
        -in $base.cpd44 -column 0 -row 0 -columnspan 1 -rowspan 1 \
        -sticky nesw 
    pack $base.fra45 \
        -in $base -anchor center -expand 0 -fill x -pady 5 -side top 
    pack $base.fra46 \
        -in $base -anchor center -expand 0 -fill none -pady 2 -side top 
    pack $base.fra46.but47 \
        -in $base.fra46 -anchor center -expand 0 -fill none -padx 5 -pady 2 \
        -side left 
    pack $base.fra46.but48 \
        -in $base.fra46 -anchor center -expand 0 -fill none -padx 5 -pady 2 \
        -side left 

    vTcl:FireEvent $base <<Ready>>
}

#############################################################################
## Binding tag:  FlatToolbarButton

bind "FlatToolbarButton" <Enter> {
    %W configure -relief raised
}
bind "FlatToolbarButton" <Leave> {
    %W configure -relief flat
}
#############################################################################
## Binding tag:  Accelerators

bind "Accelerators" <Control-Key-c> {
    ## Visual Tcl already has bindings for text widgets
if {![info exists vTcl]} {
    tk_textCopy $widget([winfo toplevel %W],MainText)
}
}
bind "Accelerators" <Control-Key-n> {
    ::visual_text::command-new [winfo toplevel %W]
}
bind "Accelerators" <Control-Key-o> {
    ::visual_text::command-open [winfo toplevel %W]
}
bind "Accelerators" <Control-Key-q> {
    exit
}
bind "Accelerators" <Control-Key-s> {
    ::visual_text::command-save [winfo toplevel %W]
}
bind "Accelerators" <Control-Key-v> {
    ## Visual Tcl already has bindings for text widgets
if {![info exists vTcl]} {
    tk_textPaste $widget([winfo toplevel %W],MainText)
}
}
bind "Accelerators" <Control-Key-x> {
    ## Visual Tcl already has bindings for text widgets
if {![info exists vTcl]} {
    tk_textCut $widget([winfo toplevel %W],MainText)
}
}
bind "Accelerators" <Key-F1> {
    AboutVisualText show
}
#############################################################################
## Binding tag:  BitmapButtonTop

bind "BitmapButtonTop" <Button-1> {
    ::bitmapbutton::mouse_down %W %X %Y
}
bind "BitmapButtonTop" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up %W %X %Y
}
bind "BitmapButtonTop" <FocusIn> {
    # puts "Bitmapbutton gets focus"
%W.centerframe.05 configure -relief groove
}
bind "BitmapButtonTop" <FocusOut> {
    # puts "Bitmapbutton loses focus"
%W.centerframe.05 configure -relief flat
}
bind "BitmapButtonTop" <Key-space> {
    #TODO: your <KeyPress-space> event handler here
::bitmapbutton::mouse_down %W [winfo rootx %W] [winfo rooty %W]
}
bind "BitmapButtonTop" <KeyRelease-space> {
    #TODO: your <KeyRelease-space> event handler here
::bitmapbutton::mouse_up %W [winfo rootx %W] [winfo rooty %W]
}
bind "BitmapButtonTop" <Motion> {
    ::bitmapbutton::mouse_inside %W %X %Y
}
#############################################################################
## Binding tag:  BitmapButtonSub1

bind "BitmapButtonSub1" <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W] %X %Y
}
bind "BitmapButtonSub1" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W] %X %Y
}
bind "BitmapButtonSub1" <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W] %X %Y
}
#############################################################################
## Binding tag:  BitmapButtonSub2

bind "BitmapButtonSub2" <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 2] %X %Y
}
bind "BitmapButtonSub2" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 2] %X %Y
}
bind "BitmapButtonSub2" <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 2] %X %Y
}
#############################################################################
## Binding tag:  BitmapButtonSub3

bind "BitmapButtonSub3" <Button-1> {
    ::bitmapbutton::mouse_down [::bitmapbutton::get_parent %W 3] %X %Y
}
bind "BitmapButtonSub3" <ButtonRelease-1> {
    ::bitmapbutton::mouse_up [::bitmapbutton::get_parent %W 3] %X %Y
}
bind "BitmapButtonSub3" <Motion> {
    ::bitmapbutton::mouse_inside [::bitmapbutton::get_parent %W 3] %X %Y
}

Window show .
Window show .top18
Window show .top19
Window show .top21
Window show .top22

main $argc $argv

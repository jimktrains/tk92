###################################################################
# This file is part of tk92, a utility program for the
# Radio Shack PRO-92 and PRO-2067 receivers.
# 
#    Copyright (C) 2001, 2002, Bob Parnass
#					AJ9S
# 
# tk92 is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 2 of the License,
# or (at your option) any later version.
# 
# tk92 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with tk92; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
# 02111-1307  USA
###################################################################


proc MakeGui { } \
{
	global Cht
	global Chvector
	global GlobalParam
	global ReadRadioFlag
	global Sid
	global TemplateSavedFlag
	global TGt
	global TGvector

	set Cht ""
	set GlobalParam(TemplateFilename) untitled.spg

	set TemplateSavedFlag no
	set ReadRadioFlag no

	# Set custom font and colors.

	SetAppearance

	set Sid -1
	
	
	###############################################################
	# Menu bar along the top edge.
	###############################################################
	set fr_menubar [MakeMenuBar .mb]
	set mf [frame .mainframe]
	set fr_line1 [frame $mf.line1]
	set fr_lim [frame $mf.lim]

	
	set fr_misc [MakeMiscFrame $fr_line1.omsg]
	set fr_display [MakeDisplayFrame $fr_line1.dis]
	set fr_rescan [MakeRescanFrame $fr_line1.res]
	set fr_title [MakeTitleFrame $fr_line1.title]
	pack $fr_title -side right -fill y
	pack $fr_misc $fr_display $fr_rescan -side left -fill y


	###############################################################
	# VFO controls window
	###############################################################
	toplevel .vfo
	set fr_vfo .vfo.srch

	set fr_vfo [MakeSearchBankFrame $fr_vfo]

	pack $fr_vfo
	
	# Prevent user from closing the VFO controls window unless
	# he elects to exit the entire program.
	wm protocol .vfo WM_DELETE_WINDOW {ExitApplication}
	wm title .vfo "tk92 Search Bank Settings"
	

	###############################################################
	# Weather Channel window
	###############################################################
	toplevel .wx
	set fr_wx .wx.ctls
	frame $fr_wx -relief groove

	set fr_wxf [MakeWxFrame $fr_wx.wx]

	pack $fr_wxf \
		-side left \
		-fill both -expand true

	pack $fr_wx
	
	# Prevent user from closing the weather chan window unless
	# he elects to exit the entire program.
	wm protocol .wx WM_DELETE_WINDOW {ExitApplication}
	wm title .wx "Weather Channels"


	###############################################################
	# Secondary controls window
	###############################################################
	toplevel .controls
	set ctls .controls.ctls
	frame $ctls -relief groove

	set fr_bank [MakeMemoryBankFrame $ctls.bank]
	# set fr_com [MakeCommFrame $ctls.com]

	pack $fr_bank -side left -fill both -expand true
	
	
	set Chvector ""
	set TGvector ""
	
	pack $fr_menubar -side top -fill x -pady 3 -padx 3
	pack $fr_line1 -side top -fill x -pady 3 -padx 3
	pack $fr_lim -side top -fill x -pady 3 -padx 3
	
	
	pack $ctls -side top -fill both -expand true -padx 3 -pady 3
	pack .mainframe -side top -fill both -expand true
	

	update idletasks
	
	###############################################################
	#  Ask the window manager to catch the delete window
	#  event.
	###############################################################
	wm protocol . WM_DELETE_WINDOW {ExitApplication}
	
	# Prevent user from shrinking or expanding main window.
	wm minsize . [winfo width .] [winfo height .]
	wm maxsize . [winfo width .] [winfo height .]
	
	wm protocol .controls WM_DELETE_WINDOW {ExitApplication}
	wm title .controls "tk92 Memory Bank Settings"
	
	
	# Prevent user from overshrinking or expanding controls window.
	# wm minsize .controls [winfo width .controls] [winfo height .controls]
	# wm maxsize .controls [winfo width .controls] [winfo height .controls]
	
	
	# Prevent user from shrinking or expanding window.
	wm minsize .vfo [winfo width .vfo] [winfo height .vfo]
	wm maxsize .vfo [winfo width .vfo] [winfo height .vfo]


	return
}


###################################################################
# Alter color and font appearance based on user preferences.
###################################################################
proc SetAppearance { } \
{
	global GlobalParam

	if {$GlobalParam(Font) != "" } \
		{
		# Designate a custom font for most widgets.
		option add *font $GlobalParam(Font)
		}

	if {$GlobalParam(BackGroundColor) != "" } \
		{
		# Designate a custom background color for most widgets.
		option add *background $GlobalParam(BackGroundColor)
		}

	if {$GlobalParam(ForeGroundColor) != "" } \
		{
		# Designate a custom foreground color for most widgets.
		option add *foreground $GlobalParam(ForeGroundColor)
		}

	if {$GlobalParam(TroughColor) != "" } \
		{
		# Designate a custom slider trough color
		# for most scale widgets.
		option add *troughColor $GlobalParam(TroughColor)
		}

	return
}



##########################################################
# Check if the configuration file exists.
# If it exits, return 1.
#
# Otherwise, prompt the user to select the
# serial port.
##########################################################

proc FirstTimeCheck { Rcfile } \
{
	global AboutMsg
	global GlobalParam
	global Libdir
	global tcl_platform

	if { [file readable $Rcfile] == 1 } \
		{
		return 0
		}

	tk_dialog .about "About tk92" \
		$AboutMsg info 0 OK

	# No readable config file found.
	# Treat this as the first time the user has run the program.

	# Create a new window with radio buttions and
	# an entry field so user can designate the proper
	# serial port.

	set msg "Please identify the serial port to which\n"
	set msg [append msg "your PRO-92 receiver is connected."]

	toplevel .serialport
	set sp .serialport

	label $sp.intro -text $msg

	frame $sp.rbframe
	set fr $sp.rbframe

	if { $tcl_platform(platform) == "windows" } \
		{
		# For Windows.
		radiobutton $fr.com1 -text COM1: -variable port \
			-value {COM1:}
		radiobutton $fr.com2 -text COM2: -variable port \
			-value {COM2:} 
		radiobutton $fr.com3 -text COM3: -variable port \
			-value {COM3:} 
		radiobutton $fr.com4 -text COM4: -variable port \
			-value {COM4:} 

		pack $fr.com1 $fr.com2 $fr.com3 $fr.com4 \
			-side top -padx 3 -pady 3 -anchor w

		} \
	else \
		{
		# For unix, mac, etc..
		radiobutton $fr.s0 -text /dev/ttyS0 -variable port \
			-value {/dev/ttyS0} 
		radiobutton $fr.s1 -text /dev/ttyS1 -variable port \
			-value {/dev/ttyS1} 
		radiobutton $fr.s2 -text /dev/ttyS2 -variable port \
			-value {/dev/ttyS2} 
		radiobutton $fr.s3 -text /dev/ttyS3 -variable port \
			-value {/dev/ttyS3} 
		radiobutton $fr.s4 -text /dev/ttyS4 -variable port \
			-value {/dev/ttyS4} 
		radiobutton $fr.s5 -text /dev/ttyS5 -variable port \
			-value {/dev/ttyS5} 

		pack \
			$fr.s0 $fr.s1 $fr.s2 \
			$fr.s3 $fr.s4 $fr.s5 \
			-side top -padx 3 -pady 3 -anchor w

		}

	radiobutton $fr.other -text "other (enter below)" \
		-variable port \
		-value other

	entry $fr.ent -width 30 -textvariable otherport

	pack $fr.other $fr.ent \
		-side top -padx 3 -pady 3 -anchor w

	button $sp.ok -text "OK" \
		-command \
			{ \
			global GlobalParam

			if {$port == "other"} \
				{
				set GlobalParam(Device) $otherport
				} \
			else \
				{
				set GlobalParam(Device) $port
				}
			# puts stderr "entered $GlobalParam(Device)"
			}

	button $sp.exit -text "Exit" \
		-command { exit }

	pack $sp.intro -side top -padx 3 -pady 3
	pack $fr -side top -padx 3 -pady 3
	pack $sp.ok $sp.exit -side left -padx 3 -pady 3 -expand true



	bind $fr.ent <Key-Return> \
		{
		global GlobalParam
		set GlobalParam(Device) $otherport
		}

	wm title $sp "Select serial port"
	wm protocol $sp WM_DELETE_WINDOW {exit}

	set errorflag true

	while { $errorflag == "true" } \
		{
		tkwait variable GlobalParam(Device)

		if { $tcl_platform(platform) != "unix" } \
			{
			set errorflag false
			break
			}

		# The following tests do not work properly
		# in Windows. That is why we won't perform
		# the serial port tests when running Windows version.

		if { ([file readable $GlobalParam(Device)] != 1) \
			|| ([file writable $GlobalParam(Device)] != 1)}\
			{
			# Device must be readable, writable

			bell
			tk_dialog .badport "Serial port problem" \
				"Serial port problem" error 0 OK
			} \
		else \
			{
			set errorflag false
			}
		}

	destroy $sp
	return 1
}

##########################################################
# ExitApplication
#
# This procedure can do any cleanup necessary before
# exiting the program.
#
# Disable computer control of the radio, then quit.
##########################################################
proc ExitApplication { } \
{
	global Lid
	global Lfilename
	global TemplateSavedFlag
	global ReadRadioFlag

	if { ($ReadRadioFlag == "yes") \
		&&  ($TemplateSavedFlag == "no") } \
		{
		set msg "You did not save the template data"
		append msg " in a file."

		set result [tk_dialog .sav "Warning" \
			$msg \
			warning 0 Cancel Exit ]

		if {$result == 0} \
			{
			return
			}
		}

	SaveSetup
	# DisableCControl

	if { [info exists Lfilename] } \
		{
		if { $Lfilename != "" } \
			{
			# Close log file.
			close $Lid
			}
		}
	exit
}


##########################################################
# NoExitApplication
#
# This procedure prevents the user from
# killing the window.
##########################################################
proc NoExitApplication { } \
{

	set response [tk_dialog .quitit "Exit?" \
		"Do not close this window." \
		warning 0 OK ]

	return
}


##########################################################
#
# Return the bank selected from the channel selector listbox
#
##########################################################

proc BankSelected { w } \
{
	set line [ ListSelected $w ]
	set line [string trimleft $line " "]
	regsub " .*" $line "" ch
	return "$ch"
}

##########################################################
#
# Return the channel selected from the channel selector listbox
#
##########################################################

proc ChSelected { w } \
{
	set line [ ListSelected $w ]
	set line [string trimleft $line " "]

	regsub {^[0-9]} $line "" line
	regsub {^[0-9]} $line "" line
	set line [string trimleft $line " "]


	regsub " .*" $line "" ch
	return "$ch"
}


##########################################################
# Contruct the top row of pulldown menus
##########################################################
proc MakeMenuBar { f } \
{
	global AboutMsg
	global Device
	global FileTypes
	global GlobalParam
	global Pgm
	global Version

	# File pull down menu
	frame $f -relief groove -borderwidth 3

	menubutton $f.file -text "File" -menu $f.file.m \
		-underline 0
	menubutton $f.view -text "View" -menu $f.view.m \
		-underline 0
	menubutton $f.data -text "Data" -menu $f.data.m \
		-underline 0
	menubutton $f.radio -text "Radio" -menu $f.radio.m \
		-underline 0
	menubutton $f.help -text "Help" -menu $f.help.m \
		-underline 0
	
	
	menu $f.view.m
	AddView $f.view.m

	menu $f.data.m
	AddData $f.data.m
	
	menu $f.help.m


	$f.help.m add command -label "Readme" \
		-underline 0 \
		-command { \
			set helpfile [format "%s/README" $Libdir ]
			set win [textdisplay_create "README"]
			textdisplay_file $win $helpfile
			}
	
	$f.help.m add command -label "Tcl info" \
		-underline 0 \
		-command { \
			tk_dialog .about "Tcl info" \
				[HelpTclInfo] info 0 OK
			}

	$f.help.m add command -label "License" \
		-underline 0 \
		-command { \
			set helpfile [format "%s/COPYING" $Libdir ]
			set win [textdisplay_create "Notice"]
			textdisplay_file $win $helpfile
			}
	
	$f.help.m add command -label "About tk92" \
		-underline 0 \
		-command { \
			tk_dialog .about "About tk92" \
				$AboutMsg info 0 OK
			}
	
	menu $f.file.m -tearoff no

	$f.file.m add command -label "Open ..." \
		-underline 0 \
		-command {OpenTemplate .mainframe}
	
	$f.file.m add command -label "Save" \
		-underline 0 \
		-command {SaveTemplate .mainframe 0}

	$f.file.m add command -label "Save As ..." \
		-underline 0 \
		-command {SaveTemplate .mainframe 1}

	$f.file.m add separator

	$f.file.m add command -label "Import memory channels ..." \
		-underline 0 \
		-command { global Cht; ImportChannels . }

	$f.file.m add command -label "Export memory channels ..." \
		-underline 0 \
		-command {ExportChannels .mainframe}

	$f.file.m add separator

	$f.file.m add command -label "Import talk groups ..." \
		-underline 0 \
		-command { ImportTG . }

	$f.file.m add command -label "Export talk groups ..." \
		-underline 0 \
		-command {ExportTG .mainframe}

	$f.file.m add separator

	$f.file.m add command -label "Exit" \
		-underline 1 \
		-command { ExitApplication}
	
	menu $f.radio.m -tearoff no
	AddRadio $f.radio.m


	pack $f.file $f.view $f.data $f.radio -side left -padx 10
	pack $f.help -side right
	
	update
	return $f
}



proc MakeScrollPane {w x y} {
   frame $w -class ScrollPane -width $x -height $y
   canvas $w.c -xscrollcommand [list $w.x set] -yscrollcommand [list $w.y set]
   scrollbar $w.x -orient horizontal -command [list $w.c xview]
   scrollbar $w.y -orient vertical   -command [list $w.c yview]
   set f [frame $w.c.content -borderwidth 0 -highlightthickness 0]
   $w.c create window 0 0 -anchor nw -window $f
   grid $w.c $w.y -sticky nsew
   grid $w.x      -sticky nsew
   grid rowconfigure    $w 0 -weight 1
   grid columnconfigure $w 0 -weight 1
   # This binding makes the scroll-region of the canvas behave correctly as
   # you place more things in the content frame.
   bind $f <Configure> [list Scrollpane_cfg $w %w %h]
   $w.c configure -borderwidth 0 -highlightthickness 0
   return $f
}
proc Scrollpane_cfg {w wide high} {
   set newSR [list 0 0 $wide $high]
	return
   if {![string equals [$w cget -scrollregion] $newSR]} {
      $w configure -scrollregion $newSR
   }
}


###################################################################
# Check to see if someone is running another
# copy of  this program.
#
# Code Snippit by DJ Eaton.
# Ben Mesander helped with Mac OS X compatibility.
#
# Warning: works in Linux and Mac OS X only, not Solaris
#
###################################################################
proc CheckForDup { } \
{
	global argv0
	global Pgm

	set filename [lindex [split $argv0 "/"] end]
	set ppid [lindex \
		[exec ps xwww \| grep -i wish \| grep $filename] 0]

	if {$ppid != [pid] } \
		{
		puts stderr "$Pgm: A copy of this program is already running.\n"
		exit 1
		}
	unset ppid filename
	return
}


##########################################################
# Add widgets to the view menu
##########################################################
proc AddView { m } \
{
	global GlobalParam



	# Change font.

	if {$GlobalParam(Font) == ""} \
		{
		set msg "Change Font"
		} \
	else \
		{
		set msg [format "Change Font (%s)" $GlobalParam(Font)]
		}

	$m add command -label $msg -command \
		{
		set ft [font_select]
		if {$ft != ""} \
			{
			set GlobalParam(Font) $ft

			set msg "The change will take effect next "
			set msg [append msg "time you start tk92."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add command -label "Restore Original Font" -command \
		{
		set GlobalParam(Font) ""
		set msg "The change will take effect next "
		set msg [append msg "time you start tk92."]

		tk_dialog .wcf "Change Appearance" $msg info 0 OK
		}

	$m add separator

	$m add command -label "Change Panel Color" -command \
		{
		set col [tk_chooseColor -initialcolor #d9d9d9]
		if {$col != ""} \
			{
			set GlobalParam(BackGroundColor) $col

			set msg "The change will take effect next "
			set msg [append msg "time you start tk92."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add command -label "Change Lettering Color" -command \
		{
		set col [tk_chooseColor -initialcolor black]
		if {$col != ""} \
			{
			set GlobalParam(ForeGroundColor) $col

			set msg "The change will take effect next "
			set msg [append msg "time you start tk92."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add command -label "Change Slider Trough Color" -command \
		{
		set col [tk_chooseColor -initialcolor #c3c3c3]
		if {$col != ""} \
			{
			set GlobalParam(TroughColor) $col

			set msg "The change will take effect next "
			set msg [append msg "time you start tk92."]

			tk_dialog .wcf "Change Appearance" \
				$msg info 0 OK
			}
		}

	$m add separator


	# Helpful tips balloons


	$m add  checkbutton \
		-label "Balloon Help Windows" \
                -variable GlobalParam(BalloonHelpWindows) \
                -onvalue on \
                -offvalue off 

	return
}


##########################################################
# Add widgets to the Data menu
##########################################################
proc AddData { m } \
{
	global GlobalParam


	set hint ""
	append hint "The Encode Image operation "
	append hint "is designed for use when "
	append hint "testing tk92."
	balloonhelp_for $m $hint

	$m add command -label "Validate data" \
		-command \
			{
			if {[ValidateData] == 0} \
				{
				tk_dialog .info "Valiate data" \
				"The data is ok." info 0 OK
				}
			}



	$m add command -label "Check for duplicate frequencies" \
		-command { CkDuplicate }

	$m add command -label "Encode Image" \
		-command { \
			if {[ValidateData] == 0} \
				{
				MakeWait
				EncodeImage
				KillWait
				}
			}

	$m add separator
	
	$m add command -label "Sort Memory Channels ..." \
		-command { MakeSortFrame }


	$m add command -label "Clear All Memory Channels ..." \
		-command { ClearAllChannels }

	$m add command -label "Clear All Talk Groups ..." \
		-command { ClearAllTG }

	return
}



##########################################################
# Add choices to the Radio menu
##########################################################
proc AddRadio { m } \
{
	global GlobalParam
	global Libdir


	$m add command -label "Read from radio ..." \
		-command { \
			if { [CheckTclVersion] == 0 } \
				{
				Radio2Template .mainframe
				update
				}
			}
	
	$m add command -label "Write to radio ..." \
		-command { \
			if { [CheckTclVersion] == 0 } \
				{
				Image2Radio .mainframe
				update
				}
			}
	
	
#	$m add separator
#
#	$m add radiobutton \
#		-label "Purple cable (US Patent 5,504,864)" \
#		-variable GlobalParam(WhichCable) -value "Purple"
#
#	$m add radiobutton \
#		-label "GRE cable" \
#		-variable GlobalParam(WhichCable) -value "GRE"
#
#	$m add radiobutton \
#		-label "RT Systems CT29A cable w/mono adapter" \
#		-variable GlobalParam(WhichCable) -value "CT29A"
#
#	$m add radiobutton \
#		-label "ICOM OPC478 cable w/mono adapter" \
#		-variable GlobalParam(WhichCable) -value "OPC478"
#
#	$m add radiobutton \
#		-label "Other cable type 1" \
#		-variable GlobalParam(WhichCable) -value "Other1"
#
#	$m add radiobutton \
#		-label "Other cable type 2" \
#		-variable GlobalParam(WhichCable) -value "Other2"


	$m add separator

	$m add command -label "Configure Serial Port ..." \
		-command { MakeConfigurePortFrame }


	$m add separator

	$m add  checkbutton \
		-label "Debug" \
                -variable GlobalParam(Debug) \
                -onvalue "1" \
                -offvalue "0"

	$m add checkbutton \
		-label "Bypass All Encoding" \
		-variable GlobalParam(BypassAllEncoding) \
		-onvalue 1 -offvalue 0

	return $m
}



##########################################################
#
# Create a progress gauge widget.
#
#
# From "Effective Tcl/Tk Programming,"
# by Mark Harrison and Michael McLennan.
# Page 125.
#
##########################################################
proc gauge_create {win {color ""}} \
{
	frame $win -class Gauge

	# set len [option get $win length Length]
	set len 300

	canvas $win.display -borderwidth 0 -background white \
		-highlightthickness 0 -width $len -height 20
	pack $win.display -expand yes -padx 10
	if {$color == ""} \
		{
		set color [option get $win color Color]
		}


	$win.display create rectangle 0 0 0 20 \
		-outline "" -fill $color -tags bar
	$win.display create text [expr {0.5 * $len}] 10 \
		-anchor c -text "0%" -tags value
	return $win
}

proc gauge_value {win val} \
{
	if {$val < 0 || $val > 100} \
		{
		error "bad value \"$val\": should be 0-100"
		}
	set msg [format "%.0f%%" $val]
	$win.display itemconfigure value -text $msg

	set w [expr {0.01 * $val * [winfo width $win.display]}]
	set h [winfo height $win.display]
	$win.display coords bar 0 0 $w $h

	update
}

proc MakeWaitWindow {f cnflag color} \
{
	global CancelXfer

	set CancelXfer 0

	frame $f
	button $f.cancel -text Cancel -command {\
		global CancelXfer; set CancelXfer 1; puts "Canceled"}

	gauge_create $f.g PaleGreen
	option add *Gauge.borderWidth 2 widgetDefault
	option add *Gauge.relief sunken widgetDefault
	option add *Gauge.length 300 widgetDefault
	option add *Gauge.color gray widgetDefault

	pack $f.g -expand yes -fill both \
		-padx 10 -pady 10

	if {$cnflag} \
		{
		pack $f.cancel -side top -padx 3 -pady 3
		}

	

	pack $f
	return $f.g
}

##########################################################
#
# Copy data from radio to template image (a lengthy string).
#
##########################################################
proc Radio2Template { f }\
{
	global Cht
	global FileTypes
	global GlobalParam
	global Home
	global MemFreq
	global MemLabel
	global MemMode
	global ReadRadioFlag
	global TGt


	set msg "Instructions:\n"
	append msg "1) Ensure the radio is connected to your computer"
	append msg " and powered on.\n"
	append msg "2) Click OK when ready.\n"


	set result [tk_dialog .info "Read from PRO-92" \
		$msg \
		info 0 OK Cancel ]

	if {$result} \
		{
		return
		}

	# Read memory image from radio.
	if {[ReadImage]} \
		{
		set ReadRadioFlag no

		set msg "Checksum error while reading from radio."
		tk_dialog .error $msg $msg error 0 OK
		return
		}
		
	set GlobalParam(Populated) 1
	DecodeImage
	# ShowTG $TGt

	set msg "Transfer Complete.\n"
	append msg "Look at the radio display "
	append msg "to view a status message."

	tk_dialog .belch "Read PRO-92" \
		$msg info 0 OK

	set ReadRadioFlag yes

	return
}


##########################################################
# Write memory image to a template file.
##########################################################
proc SaveTemplate { f asflag } \
{
	global GlobalParam
	global ImageLength
	global TemplateSavedFlag
	global ReadRadioFlag
	global Mimage

	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0)} \
		{
		set msg "You must first read template data from"
		append msg " the radio before saving it in a"
		append msg " template file."
		append msg " (Use the Radio menu for reading"
		append msg " from the radio.)"

		tk_dialog .error "No template data" \
			$msg error 0 OK
		return
		}

	set mitypes \
		{
		{"PRO-92 template files"           {.spg}     }
		}

	set filename $GlobalParam(TemplateFilename)

	if { ($GlobalParam(TemplateFilename) == "") \
		|| ($asflag) } \
		{
		set filename \
			[Mytk_getSaveFile $f \
			$GlobalParam(MemoryFileDir) \
			.spg \
			"Save PRO-92 data to template file" \
			$mitypes]
		}



	if { $filename != "" }\
		{

		if {[ValidateData]} {return}
		MakeWait
		EncodeImage

		# Truncate memory image to the proper length.
		# We want to ignore the several FF records
		# which may have been appended
		# at the end of the image.

		set n [expr {$ImageLength - 1}]
		set Mimage [string range $Mimage 0 $n]

		KillWait

		set GlobalParam(TemplateFilename) $filename
		SetWinTitle

		set GlobalParam(MemoryFileDir) \
			[ Dirname $GlobalParam(TemplateFilename) ]

		set fid [open $GlobalParam(TemplateFilename) "w"]
		fconfigure $fid -translation binary
		puts -nonewline $fid $Mimage
		close $fid
		set TemplateSavedFlag yes
		}

	return
}


##########################################################
# Read memory image from a template file.
##########################################################
proc OpenTemplate { f } \
{
	global BytesPerMessage
	global Cht
	global GlobalParam
	global ImageLength
	global Mimage
	global TGt

	set mitypes \
		{
		{"PRO-92 template files"           {.spg .SPG}     }
		}

	set GlobalParam(TemplateFilename) [Mytk_getOpenFile \
		$f $GlobalParam(MemoryFileDir) \
		"Open template file" $mitypes]


	if { $GlobalParam(TemplateFilename) != "" }\
		{
		set GlobalParam(MemoryFileDir) \
			[ Dirname $GlobalParam(TemplateFilename) ]

		set fid [open $GlobalParam(TemplateFilename) "r"]
		fconfigure $fid -translation binary

		set nbytes $ImageLength
		set Mimage [read $fid $nbytes]

		close $fid
		set GlobalParam(Populated) 1
		SetWinTitle
		DecodeImage
		# ShowTG $TGt
		}

	return
}


##########################################################
# Import memory channels from a .csv file
##########################################################
proc ImportChannels { f }\
{
	global GlobalParam
	global Mimage

	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemLockout
	global MemMode
	global MemPL
	global NBanks
	global NChanPerBank
	global RMode
	global VNChanPerBank


	if {[info exists Mimage] == 0} \
		{
		set msg "You must open a template file\n"
		append msg " or read an image from the radio\n"
		append msg " before importing channels.\n"

		tk_dialog .importinfo "tk92" \
			$msg info 0 OK
		return
		}


	set filetypes \
		{
		{"PRO-92 memory channel files"     {.csv .txt}     }
		}


	set filename [Mytk_getOpenFile $f \
		$GlobalParam(MemoryFileDir) \
		"Import channels" $filetypes]

	if {$filename == ""} then {return ""}

	if [ catch { open $filename "r"} fid] \
		{
		# error
		tk_dialog .error "tk92" \
			"Cannot open file $file" \
			error 0 OK

		return
		} 

	# Read entire .csv file at one time.
	set allchannels [read $fid]
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			ZapChannel $ch
			incr ch
			}
		}

	set line ""
	set i 0

	# For each line in the .csv file.
	foreach line [split $allchannels "\n" ] \
		{
		update

		incr i
		if { $i > 1 } then\
			{
			# Delete double quote characters.
			regsub -all "\"" $line "" bline
			set line $bline

			if {$line == ""} then {continue}
			
			set msg [ParseCsvLine $line]
			if {$msg != ""} \
				{
				set response [ErrorInFile \
					$msg $line $filename]
				if {$response == 0} then {continue} \
				else {ExitApplication}
				}
			}
		}
		
	close $fid

	return
}

proc ParseCsvLine {line} \
{
	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemLockout
	global MemMode
	global MemPL
	global MemUnused

	global Mode

	global NChanPerBank


	if {$line == ""} {return error}
	set mlist [split $line ","]

	set n [llength $mlist] 
	set m [ expr {7 - $n} ]

	# Add empty fields to the end of the line
	# if there are too few fields.

	for {set i 0} {$i < $m} {incr i} \
		{
		append line ","
		}

	set mlist [split $line ","]

#	if { [llength $mlist] < 4 } \
#		{
#		return "Missing one or more fields."
#		}

	set ch [lindex $mlist 0]
	set freq [lindex $mlist 1]
	set mode [lindex $mlist 2]
	set pl [lindex $mlist 3]
	set delay [lindex $mlist 4]
	set lockout [lindex $mlist 5]
	set label [lindex $mlist 6]



	if { ($ch < 0) || ($ch > 999) } \
		{
		return "Invalid channel $ch."
		}

	set r [expr { fmod($ch, 100) }]
	set r [expr { int($r) }]

	if {$r >= $NChanPerBank} \
		{
		return "Invalid channel $ch."
		}

	
	if { ($freq < 29.0) || ($freq > 960.0) } \
		{
		return "Invalid frequency $freq."
		}

	if {$mode == ""} {set mode FM}
	set umode [string toupper $mode]
	if {$mode == "NFM"} {set mode "FM"}

	if { [info exists Mode($umode)] == 0 } \
		{
		return "Invalid mode $mode."
		}

	set MemFreq($ch) $freq
	set MemMode($ch) $mode

	if {$pl != ""} \
		{
		# If pl code is a whole number
		if { ([string first "D" $pl] < 0) \
			&& ([string first "d" $pl] < 0) \
			&& ([string first "." $pl] < 0) } \
			{
			append pl .0
			}
		set MemPL($ch) $pl
		}
	if {$lockout != ""} { set MemLockout($ch) 1 }
	if {$delay != ""} { set MemDelay($ch) 1 }

	set s [string range $label 0 11]
	set s [string trimright $s " "]
	set MemLabel($ch) $s

	set MemUnused($ch) 0

	# puts stderr "$line ch= $ch, freq= $freq, label= $label"
	return ""
}


##########################################################
# Show memory channels in a window.
##########################################################
proc ShowChannels { f }\
{
	global Chvector
	set Chvector ""

	return
}

##########################################################
# Export memory channels to a .csv file
##########################################################
proc ExportChannels { f }\
{
	global FileTypes
	global GlobalParam
	global Home
	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemMode
	global MemLockout
	global MemPL
	global MemUnused
	global Mimage
	global NBanks
	global NChanPerBank
	global Ofilename
	global TemplateFilename


	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0) } \
		{
		set msg "You must read data from the radio"
		append msg " before exporting channels."
		append msg " (See the Radio menu.)"
		tk_dialog .info "tk92" $msg info 0 OK
		return
		}


	set Ofilename [Mytk_getSaveFile $f \
		$GlobalParam(MemoryFileDir) \
		.csv \
		"Export memory channels to .csv file" \
		$FileTypes]


	if {$Ofilename != ""} \
		{
		# puts stderr "ExportChannels: Ofilename $Ofilename"
		set GlobalParam(MemoryFileDir) \
			[ Dirname $Ofilename ]

		set fid [open $Ofilename "w"]


		# Write first line as the field names.
		puts $fid [format "Ch,MHz,Mode,PL,Delay,Lockout,Label"]

		for {set bn 0} {$bn < $NBanks} {incr bn} \
			{
			set ch [expr {$bn * 100}]
			for {set i 0} {$i < $NChanPerBank} {incr i} \
				{
				if {$MemUnused($ch)} \
					{
					incr ch
					continue
					}
	
				set lockout ""
				if {$MemLockout($ch)} \
					{
					set lockout L
					}

				set delay ""
				if {$MemDelay($ch)} \
					{
					set delay D
					}

				set s [format "%d,%s,%s,%s,%s,%s," \
					$ch $MemFreq($ch) \
					$MemMode($ch) \
					$MemPL($ch) \
					$delay \
					$lockout ]
	
				if {$MemLabel($ch) != ""} \
					{
					set l [format "\"%s\"" \
						$MemLabel($ch)]
	
					append s $l
					}
	
				puts $fid $s
				incr ch
				}
			}

		close $fid
		tk_dialog .belch "Export" \
			"Export Complete" info 0 OK

		}
	return
}


##########################################################
# Export talk group IDs to a .csv file
##########################################################
proc ExportTG { f }\
{
	global FileTypes
	global GlobalParam
	global Home
	global Mimage
	global NBanks
	global NChanPerBank
	global TalkGroup
	global TGfilename


	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0) } \
		{
		set msg "You must read data from the radio"
		append msg " before exporting talk group IDs."
		append msg " (See the Radio menu.)"
		tk_dialog .info "tk92" $msg info 0 OK
		return
		}


	set TGfilename [Mytk_getSaveFile $f \
		$GlobalParam(MemoryFileDir) \
		.csv \
		"Export talk groups to .csv file" \
		$FileTypes]


	if {$TGfilename != ""} \
		{
		set GlobalParam(MemoryFileDir) \
			[ Dirname $TGfilename ]

		set fid [open $TGfilename "w"]


		# Write first line as the field names.
		puts $fid [format "Ch,ID,Label,Lockout"]

		for {set bn 0} {$bn < $NBanks} {incr bn} \
			{
			for {set i 0} {$i < 100} {incr i} \
				{
				if {$TalkGroup($bn,$i,group) == ""} \
					{
					continue
					}
				
				set lockout ""
				if {$TalkGroup($bn,$i,lockout)} \
					{
					set lockout L
					}

				set lab ""
				if {$TalkGroup($bn,$i,label) != ""} \
					{
					set lab [format "\"%s\"" \
						$TalkGroup($bn,$i,label)]
					}
				set j [ expr { ($bn * 100) + $i } ]
				set s [format "%d,%s,%s,%s" \
					$j \
					$TalkGroup($bn,$i,group) \
					$lab \
					$lockout ]
	
	
				puts $fid $s
				}
			}
		close $fid
		tk_dialog .belch "Export" \
			"Export Complete" info 0 OK

		}
	return
}

proc FileExistsDialog { file } \
{
	set result [tk_dialog .fed "Warning" \
		"File $file already exists. Overwrite file?" \
		warning 0 Cancel Overwrite ]

	puts "result is $result"
	return $result
}


##########################################################
# Copy memory image to the radio
##########################################################
proc Image2Radio { f }\
{
	global FileTypes
	global GlobalParam
	global Mimage
	global ReadRadioFlag


	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0)} \
		{
		# No image to write.
		set msg "You must first read template data from"
		append msg " the radio or a file before"
		append msg " writing it to the radio."

		tk_dialog .error "Write to PRO-92" $msg error 0 OK
		return
		}

	if {$ReadRadioFlag == "yes"} \
		{
		# We read an image from the radio.
		# Cannot read from and write to the radio
		# during the same session or else the radio
		# complains. (Reason unknown.)
		#
		# Tell user to save the image file, exit
		# the program, restart the program, read
		# the image file, then write to the radio.

		set msg ""
		append msg "You cannot read from the radio "
		append msg "and write to the radio during the same "
		append msg "session.\n\n"
		append msg "Please:\n"
		append msg "1) Save the memory image in a file,\n"
		append msg "using File --> Save As ...\n"
		append msg "2) Exit this program.\n"
		append msg "3) Restart this program.\n"
		append msg "4) Open the image file you saved "
		append msg "previously, using File --> Open ...\n "
		append msg "5) Then, you can write the image "
		append msg "to the radio."

		tk_dialog .belch "Write blocked warning" \
			$msg warning 0 OK
		return
		}

	if {[ValidateData]} {return}
	MakeWait
	EncodeImage
	KillWait

	set msg "Instructions:\n"
	append msg "1) Ensure the radio is connected to"
	append msg " your computer and radio power is on.\n"
	append msg "2) Click OK or Cancel within a couple of seconds.\n"

	set result [tk_dialog .info "Write to PRO-92" \
		$msg \
		info 0 OK Cancel ]

	if {$result} \
		{
		# User canceled the write.
		return
		}

	if { [WriteImage] } \
		{
		set msg "Error while writing to the radio."
		tk_dialog .error "Write error" $msg error 0 OK
		KillWait
		} \
	else \
		{
		set msg "Transfer Complete.\n"
		append msg "Look at the radio display "
		append msg "to view a status message."
		tk_dialog .belch "Transfer Complete" \
			$msg info 0 OK
		}

	return
}

###################################################################
# Return 1 if frequency is in range 0 - 2000 exclusive.
###################################################################
proc FreqInRange { f units } \
{
	if {$units == "mhz" } \
		{
		if { $f > 0 && $f < 2000.0 } \
			{
			return 1
			}
		} \
	elseif {$units == "khz" } \
		{
		if { $f > 0 && $f < 2000000.0 } \
			{
			return 1
			}
		}
	return 0
}

###################################################################
# Return 1 if string 's' is a valid frequency.
# Return 0 otherwise.
#
# Units should be khz or mhz
###################################################################
proc CheckFreqValid { s units }\
{
	if {$s == ""} then {return 0}

	# Check for non-digit and non decimal point chars.
	set rc [regexp {^[0-9.]*$} $s]
	if {$rc == 0} then {return 0}


	# All digits.
	set rc [regexp {^[0-9]*$} $s]
	if {$rc == 1} \
		{
		return [FreqInRange $s $units]
		}

	if {$s == "."} then {return 0}

	# Check for Two or more decimal points
	set tmp $s
	set tmp [split $s "."]
	set n [llength $tmp]
	if { $n >= 3 } then {return 0}
	
	return [FreqInRange $s $units]
}


###################################################################
# Set default receiver parameters
###################################################################
proc SetUp { } \
{
	global env
	global GlobalParam
	global RootDir
	global tcl_platform


	if { [regexp "Darwin" $tcl_platform(os) ] } \
		{
		# For Mac OS X.
		set RootDir ":"
		} \
	else \
		{
		set RootDir "/"
		}

	set GlobalParam(Debug) 0
	# set GlobalParam(Device) /dev/ttyS1
	set GlobalParam(Ifilename) {}
	set GlobalParam(MemoryFileDir) $RootDir
	set GlobalParam(PreviousFreq) 0.0

	return
}



###################################################################
# 
# Define receiver parameters before we read the
# global parameter configuration file in case they are missing
# from the configuration file.
# This avoids a tcl error if we tried to refer to an
# undefined variable.
#
# These initial definitions will be overridden with
# definitions from the configuration file.
#
###################################################################

proc PresetGlobals { } \
{
	global GlobalParam
	global Mode
	global Rcfile
	global RootDir
	global tcl_platform

	set GlobalParam(1AOC) 00
	set GlobalParam(1AOE) 00
	set GlobalParam(1A10) 00
	set GlobalParam(1A11) 00
	set GlobalParam(BalloonHelpWindows) on

	set GlobalParam(AntAM) 0
	set GlobalParam(AntFM) 0
	set GlobalParam(Attenuator) 0
	set GlobalParam(BackGroundColor) ""
	set GlobalParam(BankScan) 0
	set GlobalParam(BatterySaver) 1
	set GlobalParam(Beep) 1
	set GlobalParam(CableEchos) 1
	set GlobalParam(Contrast) 11
	set GlobalParam(Debug) 0
	set GlobalParam(PreprogrammedMap,0) Type2
	set GlobalParam(PreprogrammedMap,1) Type2
	set GlobalParam(PreprogrammedMap,2) Type2
	set GlobalParam(PreprogrammedMap,3) Type2
	set GlobalParam(PreprogrammedMap,4) Type2
	set GlobalParam(PreprogrammedMap,5) Type2
	set GlobalParam(PreprogrammedMap,6) Type2
	set GlobalParam(PreprogrammedMap,7) Type2
	set GlobalParam(PreprogrammedMap,8) Type2
	set GlobalParam(PreprogrammedMap,9) Type2
	set GlobalParam(PriorityChannel) 800
	set GlobalParam(PriorityMemoryWx) memory
	set GlobalParam(FastTuningStep) 1MHz
	set GlobalParam(FlexStep) 1
	set GlobalParam(FCounter) 50
	set GlobalParam(Flag0Bit0) 0
	set GlobalParam(Flag0Bit1) 0
	set GlobalParam(Flag1Bit0) 0
	set GlobalParam(Flag1Bit6) 0
	set GlobalParam(Flag1Bit7) 0
	set GlobalParam(Font) ""
	set GlobalParam(ForeGroundColor) ""
	set GlobalParam(EditIDs) off
	set GlobalParam(ICDelayDefault) 100
	set GlobalParam(ICDelay) $GlobalParam(ICDelayDefault)
	set GlobalParam(Lamp) AUTO
	set GlobalParam(LampTimeout) 14
	set GlobalParam(LimitSearch) 0
	set GlobalParam(Lock) 0
	set GlobalParam(MemoryFileDir) $RootDir
	set GlobalParam(Mode) $Mode(FM)
	set GlobalParam(LowestFreq) .1000
	set GlobalParam(RescanDelayConv) 2000
	set GlobalParam(RescanDelayTrunk) 3000
	set GlobalParam(DTRline) 12
	set GlobalParam(RTSline) -12
	set GlobalParam(HighestFreq) 1300.0000
	set GlobalParam(WelcomeMsg1) "Welcome"
	set GlobalParam(WelcomeMsg2) "to"
	set GlobalParam(WelcomeMsg3) "Multitrunk"
	set GlobalParam(WelcomeMsg4) "Tracking"
	set GlobalParam(PriorityEnable) 0
	set GlobalParam(PreambleRead) ""
	set GlobalParam(Resume) 5
	set GlobalParam(SetMenuItem) 0
	set GlobalParam(SetMenuItem) 0
	set GlobalParam(SortBank) -1
	set GlobalParam(SortType) "label"
	set GlobalParam(SSContinue) 0
	set GlobalParam(TroughColor) ""
	set GlobalParam(TuningStep) 5
	set GlobalParam(VFOFreq) 162.4000
	set GlobalParam(WhichCable) "Purple"
	set GlobalParam(WhichModel) USA
	set GlobalParam(WXFreq) 162.55
	set GlobalParam(WXMode) AUTO

	return
}


###################################################################
# Set global variables after reading the global
# configuration file so these settings override
# whatever values were in the configuration file.
###################################################################

proc OverrideGlobals { } \
{
	global env
	global GlobalParam
	global RootDir
	global tcl_platform


	set GlobalParam(BypassAllEncoding) 0
	set GlobalParam(Ifilename) {}
	set GlobalParam(NmsgsRead) 0
	set GlobalParam(Populated) 0
	set GlobalParam(PostambleRead) ""
	set GlobalParam(TemplateFilename) {}
	set GlobalParam(UserPort) 0

	# Note on MacOS X:
	# The initial directory passed to the file chooser widget.
	# The problem here is that osx's tcl is utterly busted.
	# The _only_ pathname it accepts is ':' - no other ones work.
	# Now this isn't as bad as you might think because
	# the native macos file selector widget persistantly
	# remembers the last place you opened/saved a file
	# for a particular application. So the logic to
	# remember this is simply redundant on macos anyway...
	# Presumably they'll fix this someday and we can take
	# out the hack.
	# - Ben Mesander

	if { [regexp "Darwin" $tcl_platform(os) ] } \
		{
		# kluge for MacOS X.

		set GlobalParam(LogFileDir) $RootDir
		set GlobalParam(MemoryFileDir) $RootDir

		if {$GlobalParam(Ifilename) != ""} \
			{
			set GlobalParam(Ifilename) $RootDir
			}
		}

	return
}

###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeImage { } \
{
	MakeWait
	update idletasks

	DecodeMisc
	DecodePriority
	DecodeMemories
	DecodeChanBanks
	DecodeSearchBanks
	DecodeSkipFreqs		;# Must decode the search banks before.
				;# skip frequencies.
	DecodeWX
	DecodeMBankLinks	;# memory bank links
	DecodeSBankLinks	;# search bank links

	update idletasks
	KillWait
	update idletasks
	return
}

###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeMisc { } \
{
	global GlobalParam
	global ImageAddr
	global Mimage

	# Parse the welcome message.

	for {set i 1} {$i <= 4} {incr i} \
		{
		scan $ImageAddr(WelcomeMsg$i) "%x" first
		set last [expr {$first + 11}]
		set s [string range $Mimage $first $last]
		# Translate bogus characters to spaces
		regsub -all {[^A-Za-z0-9 .,#_@\+\*\&/'$%!^()?\-]} $s "?" s
		set GlobalParam(WelcomeMsg$i) $s
		}


	# Parse display contrast.
	scan $ImageAddr(Contrast) "%x" first
	set b [string index $Mimage $first]
	set c [Char2Int $b]

	if {($c >= 9) && ($c <= 14)} \
		{
		set GlobalParam(Contrast) $c
		} \
	else \
		{
		set GlobalParam(Contrast) 11
		}



	# Parse lamp timeout (in seconds).
	scan $ImageAddr(LampTimeout) "%x" first
	set b [string index $Mimage $first]
	set c [Char2Int $b]

	if {($c >= 0) && ($c <= 255)} \
		{
		set GlobalParam(LampTimeout) $c
		} \
	else \
		{
		set GlobalParam(LampTimeout) 15
		}


	# Parse minimum rescan delay (in ms., when delay is off)
	scan $ImageAddr(RescanDelayMin) "%x" first
	set b [string index $Mimage $first]
	set c [Char2Int $b]
	set GlobalParam(RescanDelayMin) [expr {$c * 100}]

	# Parse trunked rescan delay
	scan $ImageAddr(RescanDelayTrunk) "%x" first
	set b [string index $Mimage $first]
	set c [Char2Int $b]
	set GlobalParam(RescanDelayTrunk) [expr {$c * 100}]

	# Parse conventional rescan delay
	scan $ImageAddr(RescanDelayConv) "%x" first
	set b [string index $Mimage $first]
	set c [Char2Int $b]
	set GlobalParam(RescanDelayConv) [expr {$c * 100}]


	return
}

###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################

proc DecodePriority { } \
{
	global GlobalParam
	global ImageAddr
	global Mimage

	# Parse priority channel.
	scan $ImageAddr(PriorityCh) "%x" first
	set last $first
	incr last

	set b0 [string index $Mimage $first]
	set b1 [string index $Mimage $last]

	set ib1 [Char2Int $b1]

	if {$ib1 == 10} \
		{
		# The priority channel is a weather channel.
		set GlobalParam(PriorityMemoryWx) wx

		set ib0 [Char2Int $b0]
		if {($ib0 >= 0) && ($ib0 <= 9)} \
			{
			set n [expr {$ib0 + 1}]
			set GlobalParam(PriorityChannel) $n
			} \
		else \
			{
			# Bogus priority channel number.
			set GlobalParam(PriorityChannel) 1
			puts stderr "DecodeMisc: Bogus priority channel"
			}
		} \
	else \
		{
		set GlobalParam(PriorityMemoryWx) memory

		binary scan $b0 "H2" n0
		binary scan $b1 "H2" n1
		set n1 [string index $n1 1]
		set pch [format "%1s%2s" $n1 $n0]
		set rc [regexp {^[0-9][0-9][0-9]$} $pch]
		if {$rc} \
			{
			set pch [string trimleft $pch "0"]
			if {$pch == ""} {set pch 0}
			if {[expr {fmod($pch,100)}] > 49} \
				{
				# Bogus priority channel
				puts stderr "DecodeMisc: Bogus priority channel"
				set pch 0
				}
			set GlobalParam(PriorityChannel) $pch
			} \
		else \
			{
			# Bogus priority channel
			set GlobalParam(PriorityChannel) 0
			puts stderr "DecodeMisc: Bogus priority channel"
			}
		}

	# Parse priority enable flag
	scan $ImageAddr(PriorityEnable) "%x" first
	set b [string index $Mimage $first]
	set c [Char2Int $b]
	if {$c} \
		{
		set GlobalParam(PriorityEnable) 1
		} \
	else \
		{
		set GlobalParam(PriorityEnable) 0
		}

	return
}


###################################################################
#
# Encode the priority channel field from the global array
# into the memory image.
#
# The ValidatePriority procedure must be run prior to this
# procedure to ensure we don't have to process bogus values.
###################################################################

proc EncodePriority { image } \
{
	global GlobalParam
	global ImageAddr
	global Mimage

	# Parse priority channel.
	scan $ImageAddr(PriorityCh) "%x" first
	set last $first
	incr last

	set b0 [string index $image $first]
	set b1 [string index $image $last]

	set pch $GlobalParam(PriorityChannel)
	set pch [string trimleft $pch "0"]
	if {$pch == ""} {set pch 0}

	if {$GlobalParam(PriorityMemoryWx) == "wx"} \
		{
		# The priority channel is a weather channel.

		set b1 [binary format "H2" 0A]

		set n [expr {$pch - 1}]
		set hn [format "%02x" $n]
		set b0 [binary format "H2" $hn]

		set image [string replace $image $first $first $b0]
		set image [string replace $image $last $last $b1]
		} \
	elseif {$GlobalParam(PriorityMemoryWx) == "memory"} \
		{
		set ch [PadLeft0 4 $pch]
		set bn [string range $ch 0 1]
		set b1 [binary format "H2" $bn]

		set chn [string range $ch 2 3]
		set b0 [binary format "H2" $chn]
		set image [string replace $image $first $first $b0]
		set image [string replace $image $last $last $b1]
#		puts stderr "ch: $ch, bn: $bn, chn: $chn"
		}
	
	# Priority enable flag
	scan $ImageAddr(PriorityEnable) "%x" first
	set last $first
	set c [format "%02x" $GlobalParam(PriorityEnable)]
	set b [binary format "H2" $c]
	set image [string replace $image $first $last $b]

	return $image
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeMBankLinks { } \
{
	global MBankLink
	global ImageAddr
	global Mimage
	global NBanks


	# Parse linked banks
	scan $ImageAddr(MBankLinks) "%x" first


	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		set byte [string index $Mimage $first]
		binary scan $byte "H2" flag
		set MBankLink($bn) $flag
		# puts stderr "DecodeMBankLinks: bn: $bn, $MBankLink($bn)"
		incr first
		}

	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeSBankLinks { } \
{
	global SBankLink
	global ImageAddr
	global Mimage
	global NBanks


	# Parse linked banks
	scan $ImageAddr(SBankLinks) "%x" first


	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		set byte [string index $Mimage $first]
		binary scan $byte "H2" flag
		set SBankLink($bn) $flag
		incr first
		}

	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
# NOTES:
#	In each bank,
#	each memory channel is represented by 18 consecutive bytes.
#	
###################################################################
proc DecodeMemories { } \
{
	global ImageAddr
	global Mimage
	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemMode
	global MemLockout
	global MemPL
	global MemUnused
	global NBanks
	global NChanPerBank
	global NBytesPerBank
	global VNChanPerBank
	global RMode

	# Parse memory channel text labels.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryLabels) "%x" first
		incr first $offset
		set last [expr {$first + 11}]

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			set s [string range $Mimage $first $last]
			# Translate bogus characters to spaces
			regsub -all {[^A-Za-z0-9 .,#_@\+\*\&/'$%!^()?\-]} $s "?" s
			set s [string trimright $s " "]
			set MemLabel($ch) $s
#			puts stderr "$bn, $ch, $i, $MemLabel($ch)"
			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}


	# Parse memory channel mode.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryModes) "%x" first
		incr first $offset
		set last [expr {$first}]

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			set s [string range $Mimage $first $last]
			set m [GetBitField $s 4 7]
			if { [info exists RMode($m)] } \
				{
				set MemMode($ch) $RMode($m)
				} \
			else \
				{
				# Bogus mode.
				set MemMode($ch) "FM"
				}

			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}



	# Parse memory channel
	# skip, atten, delay, and unused flags.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryFlags) "%x" first
		incr first $offset
		set last [expr {$first}]

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			set s [string range $Mimage $first $last]
		
			binary scan $s "H2" ss

			set MemLockout($ch) [GetBit $s 7]
			set MemAtten($ch) [GetBit $s 6]
			set MemDelay($ch) [GetBit $s 5]
			set MemUnused($ch) [GetBit $s 4]
			# set MemUnused($ch) 0

#			puts stderr "$bn, $ch, $i, $MemFreq($ch), ss: $ss, $MemMode($ch), $MemLabel($ch), unused: $MemUnused($ch)"
			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}



	# Parse memory channel PL code.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryPL) "%x" first
		incr first $offset
		set last [expr {$first + 1}]

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			set bytes [string range $Mimage $first $last]
			set MemPL($ch) [DecodePL $bytes]

			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}



	# Parse memory channel frequencies.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryFreqs) "%x" first
		incr first $offset
		set last [expr {$first + 2}]

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			if {$MemUnused($ch) } \
				{
				set MemFreq($ch) ""
				} \
			else \
				{
				set s [string range $Mimage \
					$first $last]
				set f [Internal2Freq $s]
				set MemFreq($ch) $f


#			puts stderr "$bn, $ch, $i, f: $f, junk: $junk, junkrs: $junkrs, $MemLabel($ch)"
				}
			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}


	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
# NOTES:
#	In each bank,
#	each memory channel is represented by 18 consecutive bytes.
#	
###################################################################
proc DecodeWX { } \
{
	global ImageAddr
	global Mimage
	global Weather
	global NBanks
	global RMode

	# Parse wx channel text labels.
	scan $ImageAddr(WxLabels) "%x" first
	set last [expr {$first + 11}]

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set s [string range $Mimage $first $last]
		# Translate bogus characters to spaces
		regsub -all {[^A-Za-z0-9 .,#_@\+\*\&/'$%!^()?\-]} $s "?" s
		set s [string trimright $s " "]
		set Weather($ch,label) $s
		incr first 18
		incr last 18
		}


	# Parse wx mode.

	scan $ImageAddr(WxModes) "%x" first
	set last [expr {$first}]

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set s [string range $Mimage $first $last]
		set m [GetBitField $s 4 7]
		if { [info exists RMode($m)] } \
			{
			set Weather($ch,mode) $RMode($m)
			} \
		else \
			{
			# Bogus mode.
			set Weather($ch,mode) "FM"
			}

		incr first 18
		incr last 18
		}



	# Parse wx channel
	# skip, atten, delay, and unused flags.

	scan $ImageAddr(WxFlags) "%x" first
	set last [expr {$first}]

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set s [string range $Mimage $first $last]
		
		binary scan $s "H2" ss

		set Weather($ch,lockout) [GetBit $s 7]
		set Weather($ch,atten) [GetBit $s 6]
		set Weather($ch,delay) [GetBit $s 5]
		set Weather($ch,unused) [GetBit $s 4]

		incr first 18
		incr last 18
		}



	# Parse wx channel PL code.

	scan $ImageAddr(WxPL) "%x" first
	set last [expr {$first + 1}]

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set bytes [string range $Mimage $first $last]
		set Weather($ch,pl) [DecodePL $bytes]

		incr first 18
		incr last 18
		}



	# Parse wx channel frequencies.
	scan $ImageAddr(WxFreqs) "%x" first
	set last [expr {$first + 2}]

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		if {$Weather($ch,unused) } \
			{
			set Weather($ch,freq) 0.0000
			} \
		else \
			{
			set s [string range $Mimage $first $last]
			set f [Internal2Freq $s]
			set Weather($ch,freq) $f

			}
		incr first 18
		incr last 18
		}


	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
# NOTES:
#	
###################################################################
proc DecodeChanBanks { } \
{
	global ImageAddr
	global Mimage
	global ChanBank
	global NBanks
	global NBytesPerBank
	global RBankOffset
	global RBankType
	global TalkGroup

	# Parse channel bank text labels.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(BankLabel) "%x" first
		incr first $offset
		set last [expr {$first + 11}]

		set s [string range $Mimage $first $last]
		# Translate bogus characters to spaces
		regsub -all {[^A-Za-z0-9 .,#_@\+\*\&/'$%!^()?\-]} $s "?" s
		set s [string trimright $s " "]
		set ChanBank($bn,label) $s
		incr first 18
		incr last 18

		incr offset $NBytesPerBank
		}


	# Parse channel bank type.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(BankType) "%x" first
		incr first $offset
		set last $first

		set b [string range $Mimage $first $last]
		set s [Char2Int $b]

		if {[info exists RBankType($s)] } \
			{
			set ChanBank($bn,type) $RBankType($s)
			} \
		else \
			{
			set ChanBank($bn,type) CONVENTIONAL
			}

		incr first 18
		incr last 18

		incr offset $NBytesPerBank
		}


	# Parse channel bank open/closed and trunking offset value.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(BankOffset) "%x" first
		incr first $offset
		set last $first

		# open/closed
		set b [string range $Mimage $first $last]
		if { [GetBit $b 6] } \
			{
			set ChanBank($bn,oc) OPEN
			} \
		else \
			{
			set ChanBank($bn,oc) CLOSED
			}

		# offset
		set ofs [GetBitField $b 4 5]

		if {[info exists RBankOffset($ofs)] } \
			{
			set ChanBank($bn,troffset) $RBankOffset($ofs)
			} \
		else \
			{
			set ChanBank($bn,troffset) 0
			}

		incr first 18
		incr last 18

		incr offset $NBytesPerBank
		}



	# Parse fleet map size codes.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(FleetMap) "%x" first
		incr first $offset
		set last $first

		for {set bl 0} {$bl < 8} {incr bl} \
			{
			set s [string range $Mimage $first $last]
			set sc [Char2Int $s]

			if {$sc == 0} \
				{
				set ChanBank($bn,block$bl) "Type2"
				} \
			elseif {($sc >= 1) && ($sc <= 14)} \
				{
				set ChanBank($bn,block$bl) S$sc
				} \
			else \
				{
				# bogus size code
				set ChanBank($bn,block$bl) "Type2"
				}

			incr first
			incr last
			}

		incr offset $NBytesPerBank
		}


	# Parse 100 talk group IDs in each bank.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		# puts stderr "bn: $bn ================"
		scan $ImageAddr(TalkGroupID) "%x" first
		incr first $offset
		set last [expr {$first + 1}]

		for {set i 0} {$i < 100} {incr i} \
			{
			set s [string range $Mimage $first $last]
			set lst [Internal2TalkGroupID $s \
				$ChanBank($bn,type) $bn]

			set TalkGroup($bn,$i,group) [lindex $lst 0]
			set TalkGroup($bn,$i,lockout) [lindex $lst 1]
#			puts stderr "bn: $bn, i: $i, type: $ChanBank($bn,type), $TalkGroup($bn,$i,group)"
			incr first 14
			incr last 14
			}

		incr offset $NBytesPerBank
		}


	# Parse talk group labels.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(TalkGroupLabel) "%x" first
		incr first $offset
		set last [expr {$first + 11}]

		for {set i 0} {$i < 100} {incr i} \
			{
			set s [string range $Mimage $first $last]

			# Translate bogus characters to spaces
			regsub -all {[^A-Za-z0-9 .,#_@\+\*\&/'$%!^()?\-]} $s " " s
			set s [string trimright $s " "]
			set TalkGroup($bn,$i,label) $s

			incr first 14
			incr last 14
			}

		incr offset $NBytesPerBank
		}

	return
}

######################################################################
#					Bob Parnass
#					DATE: November 29, 2002
#
# PROGRAM NAME:
#
# USAGE:	Internal2TalkGroupID s type bn
#
# INPUTS:
#		s	-a 2-byte string containing the talk group ID
#		type	-trunk system technology type MO, LT, or ED
#		bn	-bank number 0-9
#
# RETURNS:
#	a 2-element list.
#	The first element is the talk group ID.
#	The second element is the lockout value (0 or 1).
#
#	A null string ID is returned for bogus talk group IDs.
#
# PURPOSE:	Decode a talk group id and lockout.
#
# DESCRIPTION:
#
#
###################################################################
proc Internal2TalkGroupID { s type bn } \
{
	global ChanBank
	
	set b0 [string index $s 0]
	set b1 [string index $s 1]
	set sizecode  0

	if { ( [string compare -length 1 $b0 \x00] == 0) \
		&& ( [string compare -length 1 $b1 \x00] == 0) } \
		{
		# Both bytes are null.
		set retlist [list "" 0]
		return $retlist
		}

	set lockout [GetBit $b1 0]

	if {$type == "MO"} \
		{
		# We must examine the size code for
		# this block to determine whether this is 
		# is a Type 1 or Type 2 group ID
		set block [GetBitField $b1 4 6]

		set sc $ChanBank($bn,block$block)
		if {$sc == "Type2"} \
			{
			set sizecode 0
			} \
		else \
			{
			set sizecode [string range $sc 1 end]
			}

		if {$sizecode} \
			{
			# This looks like a Motorola Type 1.
			set id [Internal2Type1  $s $block $sizecode]
			} \
		else \
			{
			# Motorola Type 2
			set id0 [GetBitField $b1 1 7]
			set id1 [Char2Int $b0]
			set id [expr { 16 * (($id0 * 256) + $id1) } ]
			}
		} \
	elseif {$type == "ED"} \
		{
		set id0 [GetBitField $b1 1 7]
		set id1 [Char2Int $b0]
		set id [expr { ($id0 * 256) + $id1 } ]
		} \
	elseif {$type == "LT"} \
		{
		set userid [Char2Int $b0]
		set userid [PadLeft0 3 $userid]

		set areacode [GetBit $b1 1]
		set rptr [GetBitField $b1 1 7]

		if {($rptr < 1) || ($rptr > 84) \
			|| (($rptr > 20) && ($rptr < 65)) } \
			{
			# Bogus talk group ID.
			# Home repeater number must be 1 - 20
			# puts stderr "bogus rptr value: $rptr"
			set id 0
			} \
		elseif {$areacode == 1} \
			{
			set rptr [expr {$rptr - 64}]
			set areacode 1
			set rptr [PadLeft0 2 $rptr]
			set id [format "%1s%2s%3s" $areacode $rptr \
				$userid]
			} \
		else \
			{
			set rptr [PadLeft0 2 $rptr]
			set id [format "%1s%2s%3s" $areacode $rptr \
				$userid]
			} 

		# Trim leading zeroes from LTR ID.
		set id [string trimleft $id "0"]
		if {$id == ""} {set id 0}

		set junk [DumpBinary $s]
		# puts stderr "Internal2TalkGroup: id: $id, userid: $userid, rptr: $rptr, lockout: $lockout, s: $junk,  ++++++++++++++"
		} \
	else \
		{
		# Not trunked
		set id 0
		}

	if {$id == 0} \
		{
		set id ""
		}
	set retlist [list $id $lockout]
	return $retlist

}


###################################################################
#
# Encode a 2-byte talk group id based on the lockout flag
# and the type of trunking, e.g., MO, ED, or LT
#
###################################################################

proc TalkGroupID2Internal { group type lockout bn} \
{

	if { $group == "" } \
		{
		if {$lockout} \
			{
			set bytes [binary format "H2H2" 00 80]
			} \
		else \
			{
			set bytes [binary format "H2H2" 00 00]
			}

		return $bytes
		}

	if {$type == "MO"} \
		{
		# Check for a dash in the talk group id.
		# A dash signifies a Motorola Type 1 talk group.

		if {[string first "-" $group] >= 0} \
			{
			# Type 1
			set bytes [Type12Internal $group $bn]
			set b0 [string index $bytes 0]
			set b1 [string index $bytes 1]
			} \
		else \
			{
			# Type 2

			set g [expr {int($group / 16)}]
	
			set b1 [binary format "H2" 00]
			set id0 [expr {int($g / 256)}]
			set b1 [SetBitField $b1 1 7 $id0]
			
			set b0 [binary format "H2" 00]
			set id1 [expr {$g - ($id0 * 256)}]
			set hid1 [format "%02x" $id1]
			set b0 [binary format "H2" $hid1]
			}
		} \
	elseif {$type == "ED"} \
		{
		# Convert a group in AFS format to decimal format.
		set ngroup [Afs2Dec $group]
		set b1 [binary format "H2" 00]
		set id0 [expr {int($ngroup / 256)}]
		set b1 [SetBitField $b1 1 7 $id0]
		
		set b0 [binary format "H2" 00]
		set id1 [expr {$ngroup - ($id0 * 256)}]
		set hid1 [format "%02x" $id1]
		set b0 [binary format "H2" $hid1]
#		puts stderr "TalkGroupID2Internal: ngroup: $ngroup"
		} \
	elseif {$type == "LT"} \
		{
		set group [PadLeft0 6 $group]
		set rc [regexp {^[01][0-9][0-9][0-9][0-9][0-9]$} $group]
		if {$rc} \
			{
			set area [string index $group 0]

			set rptr [string range $group 1 2]
			regsub {^0*} $rptr "" rptr
			if {$rptr == ""} {set rptr 0}

			set unit [string range $group 3 5]
			regsub {^0*} $unit "" unit
			if {$unit == ""} {set unit 0}

			if {($rptr < 1) || ($rptr > 84) \
				|| (($rptr > 20) && ($rptr < 65)) } \
				{
				# Bogus ID
				set b0 [binary format "H2" 00]
				set b1 [binary format "H2" 00]
				puts stderr "TalkGroupID2Internal: bogus LTR talk group repeater: $rptr"
				} \
			elseif {$area == "1"} \
				{
				set rptr [expr {$rptr + 64}]

				set hunit [format "%02x" $unit]
				set b0 [binary format "H2" $hunit]

				set hptr [format "%02x" $rptr]
				set b1 [binary format "H2" $hptr]
				} \
			else \
				{
				set hunit [format "%02x" $unit]
				set b0 [binary format "H2" $hunit]
				
				set hptr [format "%02x" $rptr]
				set b1 [binary format "H2" $hptr]
				}
			} \
		else \
			{
			# Bogus talk group ID
			puts stderr "TalkGroupID2Internal: bogus talk group: $group."
			set b0 [binary format "H2" 00]
			set b1 [binary format "H2" 00]
			}

		set s ""
		append s $b0 $b1
		set junk [DumpBinary $s]
		# puts stderr "TalkGroupID2Internal: group: $group, s: $junk"
		} \
	else \
		{
		# Not trunked
		set b0 [binary format "H2" 00]
		set b1 [binary format "H2" 00]
		}

	set b1 [AssignBit $b1 0 $lockout]

	set bytes ""
	append bytes $b0 $b1

	return $bytes

}

###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
###################################################################
proc DecodeSearchBanks { } \
{
	global ImageAddr
	global Mimage
	global LimitScan
	global NBanks
	global NBytesPerBank
	global RBandStep
	global RMode

	# Parse search bank text labels.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchLabel) "%x" first
		incr first $offset
		set last [expr {$first + 11}]

		set s [string range $Mimage $first $last]
		set s [string trimright $s " "]
		set LimitScan($bn,label) $s
		# puts stderr "DecodeSearchBanks: $bn, s: $s"

		incr offset $NBytesPerBank
		}


	# Parse lower limit search mode.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchModeFirst) "%x" first
		incr first $offset
		set last [expr {$first}]

		set s [string range $Mimage $first $last]

		set m [GetBitField $s 4 7]
		if { [info exists RMode($m)] } \
			{
			set LimitScan($bn,lmode) $RMode($m)
			} \
		else \
			{
			# Bogus mode.
			set LimitScan($bn,lmode) "FM"
			}
		incr offset $NBytesPerBank
		}



	# Parse limit search bank
	# skip, atten, delay, and unused flags.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchFlags) "%x" first
		incr first $offset
		set last [expr {$first}]

		set s [string range $Mimage $first $last]
		
		binary scan $s "H2" ss

		set LimitScan($bn,lockout) [GetBit $s 7]
		set LimitScan($bn,atten) [GetBit $s 6]
		set LimitScan($bn,delay) [GetBit $s 5]
		set LimitScan($bn,unused) [GetBit $s 4]

#		puts stderr "$bn, $ch, $i, $MemFreq($ch), ss: $ss, $MemMode($ch), $MemLabel($ch), unused: $MemUnused($ch)"

		incr offset $NBytesPerBank
		}



	# Parse limit search PL code.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchPL) "%x" first
		incr first $offset
		set last [expr {$first + 1}]

		set bytes [string range $Mimage $first $last]
		set LimitScan($bn,pl) [DecodePL $bytes]

		incr offset $NBytesPerBank
		}



	# Parse lower limit search frequencies and bands.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchFreqFirst) "%x" first
		incr first $offset
		set last [expr {$first + 2}]

		if {$LimitScan($bn,unused) } \
			{
			set LimitScan($bn,lower) 0.0000
			set LimitScan($bn,band) 0
			} \
		else \
			{
			set s [string range $Mimage \
				$first $last]
			set f [Internal2Freq $s]
			set LimitScan($bn,lower) $f

			# Band is located in the most
			# significant (left) nibble
			# of second byte
			set b [string index $s 2]
			set LimitScan($bn,band) [GetBitField $b 0 3]
#			puts stderr "$bn, $ch, $i, f: $f, junk: $junk, junkrs: $junkrs, $MemLabel($ch)"
			}


		incr offset $NBytesPerBank
		}


	# Parse upper limit search frequencies.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchFreqSecond) "%x" first
		incr first $offset
		set last [expr {$first + 2}]

		if {$LimitScan($bn,unused) } \
			{
			set LimitScan($bn,lower) 0.0000
			} \
		else \
			{
			set s [string range $Mimage \
				$first $last]

			# construct a phony 3rd byte
			set b [binary format "H2" 00]
			set b [SetBitField $b 0 3 $LimitScan($bn,band)]
			set s [string replace $s 2 2 $b]

			set f [Internal2Freq $s]
			set LimitScan($bn,upper) $f

#			puts stderr "$bn, $ch, $i, f: $f, junk: $junk, junkrs: $junkrs, $MemLabel($ch)"
			}


		incr offset $NBytesPerBank
		}


	# Parse limit search step size.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchStep) "%x" first
		incr first $offset
		set last $first

		set bytes [string range $Mimage $first $last]
		set st [Char2Int $bytes]

		# Determine band and multiplier
		if {[info exists RBandStep($LimitScan($bn,band))]} \
			{
			set step \
				[expr {$st \
				* $RBandStep($LimitScan($bn,band))}]
			} \
		else \
			{
			set step 0
			}

		set LimitScan($bn,step) $step

		incr offset $NBytesPerBank
		}

#
#	# Parse the 50 skip frequencies for each search bank.
#	set offset 0
#	for {set bn 0} {$bn < $NBanks} {incr bn} \
#		{
#		scan $ImageAddr(Lockouts) "%x" first
#		incr first $offset
#		set last [expr {$first + 1}]
#
#		for {set i 0} {$i < 50} {incr i} \
#			{
#			set bytes [string range $Mimage $first $last]
#			set b0 [string index $bytes 0]
#			set b1 [string index $bytes 1]
#
#			if { ([Char2Int $b0] == 255) \
#				&& ([Char2Int $b1] == 255) } \
#				{
#				set LimitScan($bn,lockout$i) ""
#				}  \
#			else \
#				{
#				# construct a phony 3rd byte
#				set b [binary format "H2" 00]
#				set b [SetBitField $b 0 3 $LimitScan($bn,band)]
#				set s ""
#				append s $bytes $b
#	
#				set f [Internal2Freq $s]
#				set LimitScan($bn,lockout$i) $f
#	
#	#			puts stderr "$bn, $ch, $i, f: $f, junk: $junk, junkrs: $junkrs, $MemLabel($ch)"
#				}
#			incr first
#			incr last
#			}
#
#
#		incr offset $NBytesPerBank
#		}

	return
}


###################################################################
#
# Parse data from inside the memory image and store it
# in global arrays.
#
# NOTES:
#	WARNING: We must decode the limit search banks before
#	decoding the skip frequencies.
#
#	Each Skip channel is composed of a 3-byte frequency
#	followed by a special 4th byte.
#	The 4th byte contains the splinter flags in bits
#	1 and 2, and the mode in the right nibble.
###################################################################
proc DecodeSkipFreqs { } \
{
	global ImageAddr
	global Mimage
	global LimitScan
	global NBanks
	global NBytesPerBank
	global Skip


	# Parse the 50 skip frequencies for each search bank.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(Skip) "%x" first
		incr first $offset
		set last [expr {$first + 1}]

		for {set i 0} {$i < 50} {incr i} \
			{
			set bytes [string range $Mimage $first $last]
			set b0 [string index $bytes 0]
			set b1 [string index $bytes 1]

			set junk [DumpBinary $bytes]

			if { ([Char2Int $b0] == 255) \
				&& ([Char2Int $b1] == 255) } \
				{
				set Skip($bn,$i) ""
				# puts stderr "DecodeSkipFreqs: $bn, $i, bytes: $junk, EMPTY, first: $first, last: $last"
				}  \
			else \
				{
				# construct a phony 3rd byte
				set b [binary format "H2" 00]
				set b [SetBitField $b 0 3 $LimitScan($bn,band)]
				set s ""
				append s $bytes $b
	
				set f [Internal2Freq $s]
				set Skip($bn,$i) $f
				# puts stderr "DecodeSkipFreqs: $bn, $i, bytes: $junk, SKIP FREQ, f: $f, first: $first, last: $last"
	
				}
			incr first 2
			incr last 2
			}


		incr offset $NBytesPerBank
		}

	return
}



###################################################################
# Decode a 3 byte frequency.
#
# INPUTS:	a 3 byte binary string
#
# RETURNS:	frequency in MHz
#
# NOTES:
# A memory frequency is represented by GRE as a base and
# some offset information:
#
# byte 0	- whole number of MHz to add
#
# byte 1	- the number of frequency steps to add
#		Step size is 5 kHz for the 29 and 137 MHz.
#		Step size is 12.5 kHz for the other bands.
#
# byte 2	- most significant (left) nibble is a band number
#		band 0 through 4 correspond to:
#		29, 108, 137, 380, and 806 MHz
#		(The least signficant nibble contains the mode,
#		which is not used by this procedure.)
#
###################################################################

proc Internal2Freq { s } \
{
	global GlobalParam
	global RBand
	global RBandStep
	
	set junk [DumpBinary $s]
#	puts stderr "Internal2Freq junk: $junk ++++++++++++++"

	# Band is located in the most significant (left) nibble
	set b [string index $s 2]
	set band [GetBitField $b 0 3]

	# Low frequency for this band.
	if { ([info exists RBand($band)] == 0) } \
		{
		# Bogus band
		return 0
		} \
	else \
		{
		set base $RBand($band)
		}

	# Step size for this band.
	if { ([info exists RBandStep($band)] == 0) } \
		{
		# Bogus band
		return 0
		} \
	else \
		{
		set step $RBandStep($band)
		}

	set b [string index $s 0]
	set whole [Char2Int $b]

	set b [string index $s 1]
	set nsteps [Char2Int $b]

	set f1 [expr { $whole + $base }]
	set f2 [expr { ($nsteps * $step) / 1000.0 }]
	set f [expr { $f1 + $f2 }]

	set f [ format "%.4f" $f]
	if { $f < .001 } { set f ""}
# puts stderr "Internal2Freq junk: $junk, f: $f, f1: $f1, f2: $f2, whole: $whole, base: $base, nsteps: $nsteps, step: $step"
	return $f
}



###################################################################
#
# Encode frequency into a 3-byte string.
#
# INPUTS:	frequency in MHz
#
# RETURNS:	a 3 byte binary string
#
#
# NOTES:
# A memory frequency is represented by GRE as a base and
# some offset information:
#
# byte 0	- whole number of MHz to add
#
# byte 1	- the number of frequency steps to add
#		Step size is 5 kHz for the 29 and 137 MHz.
#		Step size is 12.5 kHz for the other bands.
#
# byte 2	- most significant (left) nibble is a band number
#		band 0 through 4 correspond to:
#		29, 108, 137, 380, and 806 MHz
#		(The least signficant nibble contains the mode,
#		which is not used by this procedure.)
#
###################################################################

proc Freq2Internal { f } \
{
	global GlobalParam
	global RBand
	global RBandStep

	if {$f == ""} {set f 0.0}
	
	set band [Freq2Band $f]

	if {$band < 0} \
		{
		# Frequency out of bounds.
		set s [binary format "H2H2H2" 00 00 00]
		return $s
		}

	set base $RBand($band)
	set step $RBandStep($band)
	set offset [ expr { int($f) - $base } ]
	set nsteps [ expr { (($f - int($f)) + .00005) * 1000 / $step  } ]
	set nsteps [ expr { int($nsteps) } ]

	set hoffset [format "%02x" $offset]
	set hnsteps [format "%02x" $nsteps]

	# Band goes in most significant nibble.
	# Force least significant nibble to zero.
	set hband [format "%1x0" $band]

	set s [binary format "H2H2H2" $hoffset $hnsteps $hband]

	return $s
}


###################################################################
# Create widgets for the name of this program.
###################################################################
proc MakeTitleFrame { f }\
{
	global DisplayFontSize 
	global Version

	frame $f -relief flat -borderwidth 3

	# set s [format "tk92 v%s" $Version]
	set s [format "tk92"]

	label $f.lab -text $s \
		-background yellow \
		-foreground black \
		-relief raised \
		-borderwidth 3 \
		-font $DisplayFontSize 

	set s ""
	append s [format "Version %s\n" $Version]
	append s "Experimental Utility\n"
	append s "for Radio Shack\n"
	append s "PRO-92 & PRO-2067 Scanners\n"
	append s "Copyright 2001, 2002, Bob Parnass"

	label $f.use -text $s \
		-background black \
		-foreground white \
		-relief raised \
		-borderwidth 3

	pack $f.lab $f.use -side top -padx 0 -pady 0 \
		-fill y -fill x -expand true

	return $f
}


###################################################################
# Create frame for display parameters. 
###################################################################
proc MakeDisplayFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Display, Keypad Settings" \
		-borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3
	MakeDispWidgets  $f.b

	 pack $f.b -side top -expand true -fill both

	return $f
}

proc MakeDispWidgets {f} \
{
	global GlobalParam


        label $f.lwelcomemsg1 -text "Opening Message" -borderwidth 3
        entry $f.welcomemsg1 -width 16\
		-textvariable GlobalParam(WelcomeMsg1) -background white
        entry $f.welcomemsg2 -width 16\
		-textvariable GlobalParam(WelcomeMsg2) -background white
        entry $f.welcomemsg3 -width 16\
		-textvariable GlobalParam(WelcomeMsg3) -background white
        entry $f.welcomemsg4 -width 16\
		-textvariable GlobalParam(WelcomeMsg4) -background white

#	 set s [bind Entry]
#	puts stderr "s: $s\n\n\n"

        # label $f.lcontrast -text "Contrast" -borderwidth 3
	# tk_optionMenu $f.contrast GlobalParam(Contrast) \
		# 9 10 11 12 13 14

	
	scale $f.contrast -from 9 -to 14 \
		-label "Display Contrast" \
		-variable GlobalParam(Contrast) \
		-resolution 1 \
		-orient horizontal
	$f.contrast set $GlobalParam(Contrast)
	
	scale $f.lamptimeout -from 0 -to 255 \
		-label "Lamp Timeout (sec)" \
		-variable GlobalParam(LampTimeout) \
		-resolution 1 \
		-orient horizontal
	$f.lamptimeout set $GlobalParam(LampTimeout)
	
	set hint ""
	append hint "Lamp Timeout is adjustable for the PRO-92, "
	append hint "but not the PRO-2067.\n\n"
	append hint "A value of 0 will cause the lamp to stay "
	append hint "on until you power off the radio."
	balloonhelp_for $f.lamptimeout $hint


	grid $f.lwelcomemsg1 -row 10 -column 0 -sticky w
	grid $f.welcomemsg1 -row 10 -column 1 -sticky e
	grid $f.welcomemsg2 -row 20 -column 1 -sticky e
	grid $f.welcomemsg3 -row 30 -column 1 -sticky e
	grid $f.welcomemsg4 -row 40 -column 1 -sticky e

	# grid $f.lcontrast -row 50 -column 0 -sticky w
	# grid $f.contrast -row 50 -column 1 -sticky e
	grid $f.contrast -row 50 -column 0 -sticky ew -columnspan 2

	grid $f.lamptimeout -row 60 -column 0 -sticky ew -columnspan 2
	return

}


###################################################################
# Create a search bank. 
###################################################################
proc MakeSearchSettingsFrame { f bn }\
{
	global DisplayFontSize 
	global GlobalParam
	global SBankLink


	frame $f -relief flat -borderwidth 3

	label $f.bankn$bn -text "$bn" \
		-relief flat \
		-borderwidth 6 \
		-font $DisplayFontSize 


	label $f.llabel$bn -text "Label" -borderwidth 3
	entry $f.label$bn -width 14 \
		-textvariable LimitScan($bn,label) \
		-background white 

	label $f.llower$bn -text "Lower Frequency" -borderwidth 3
	entry $f.lower$bn -width 10 \
		-textvariable LimitScan($bn,lower) \
		-background white 

	label $f.lupper$bn -text "Upper Frequency" -borderwidth 3
	entry $f.upper$bn -width 10 \
		-textvariable LimitScan($bn,upper) \
		-background white 

	label $f.lstepmenu$bn -text "Step" -borderwidth 3
	tk_optionMenu $f.stepmenu$bn LimitScan($bn,step) \
		5 10 12.5 15 20 25 30 50 100

	label $f.llmodemenu$bn -text "Mode" -borderwidth 3
	tk_optionMenu $f.lmodemenu$bn LimitScan($bn,lmode) \
		FM PL DL AM LT MO ED


	label $f.ldelay$bn -text "Delay" -borderwidth 3
	checkbutton $f.delay$bn -text "" \
		-variable LimitScan($bn,delay) \
		-onvalue 1 -offvalue 0

	label $f.latten$bn -text "Attenuator" -borderwidth 3
	checkbutton $f.atten$bn -text "" \
		-variable LimitScan($bn,atten) \
		-onvalue 1 -offvalue 0

	set n ""
	append n 3 $bn
	label $f.llink$bn -text "Link" -borderwidth 3
	checkbutton $f.link$bn -text "" \
		-variable SBankLink($bn) \
		-onvalue $n -offvalue A5

	set hint ""
	append hint "You can search through "
	append hint "a combination of banks "
	append hint "by linking banks together.\n"
	append hint "Enabling the Link "
	append hint "means this search bank "
	append hint "will be searched for active frequencies "
	append hint "during a Limit Search operation."
	balloonhelp_for $f.llink$bn $hint
	balloonhelp_for $f.link$bn $hint

	

	grid $f.bankn$bn -row 5 -column 0 -sticky ew -columnspan 2
	grid $f.llabel$bn -row 10 -column 0 -sticky w
	grid $f.label$bn -row 10 -column 1 -sticky w
	grid $f.llower$bn -row 20 -column 0 -sticky w
	grid $f.lower$bn -row 20 -column 1 -sticky w
	grid $f.lupper$bn -row 30 -column 0 -sticky w
	grid $f.upper$bn -row 30 -column 1 -sticky w
	grid $f.lstepmenu$bn -row 40 -column 0 -sticky w
	grid $f.stepmenu$bn -row 40 -column 1 -sticky w
	grid $f.llmodemenu$bn -row 50 -column 0 -sticky w
	grid $f.lmodemenu$bn -row 50 -column 1 -sticky w
	grid $f.ldelay$bn -row 60 -column 0 -sticky w
	grid $f.delay$bn -row 60 -column 1 -sticky w
	grid $f.latten$bn -row 70 -column 0 -sticky w
	grid $f.atten$bn -row 70 -column 1 -sticky w
	grid $f.llink$bn -row 80 -column 0 -sticky w
	grid $f.link$bn -row 80 -column 1 -sticky w

#	grid $h.lab -row 10 -column 0
#	grid $h.label -row 20 -column 0
#	grid $h.lower -row 30 -column 0
#	grid $h.upper -row 40 -column 0
#	grid $h.stepmenu -row 50 -column 0 -sticky ew
#	grid $h.lmodemenu -row 60 -column 0 -sticky ew
#	grid $h.delay -row 70 -column 0
#	grid $h.atten -row 80 -column 0


	return $f
}


###################################################################
# Create 10 memory banks. 
###################################################################
proc MakeMemoryBankFrame { f }\
{
	global GlobalParam
	global MemNB

	frame $f -relief groove -borderwidth 3
	frame $f.b -relief flat -borderwidth 3

	label $f.lab -text "Memory Bank Settings" \
		-borderwidth 3

	set h $f.b

	pack $f.lab $f.b \
		-side top -fill both -expand true -padx 3 -pady 3

	set MemNB $f.banknb
	MakeMemoryBankNB $MemNB
	return $f
}




###################################################################
# Create one a set of widgets for one search bank. 
###################################################################
proc MakeSearchBank { f bn }\
{
	global LimitScan
	global GlobalParam

	set r [expr {$bn + 1}]

	label $f.lab$bn -text "$bn" -borderwidth 3

	entry $f.label$bn -width 14 \
		-textvariable LimitScan($bn,label) \
		-background white 

	entry $f.lower$bn -width 10 \
		-textvariable LimitScan($bn,lower) \
		-background white 

	entry $f.upper$bn -width 10 \
		-textvariable LimitScan($bn,upper) \
		-background white 

	tk_optionMenu $f.stepmenu$bn LimitScan($bn,step) \
		5 10 12.5 15 20 25 30 50 100

	tk_optionMenu $f.lmodemenu$bn LimitScan($bn,lmode) \
		FM PL DL AM LT MO ED


	checkbutton $f.delay$bn -text "" \
		-variable LimitScan($bn,delay) \
		-onvalue 1 -offvalue 0

	checkbutton $f.atten$bn -text "" \
		-variable LimitScan($bn,atten) \
		-onvalue 1 -offvalue 0

	grid $f.lab$bn -row $r -column 1
	grid $f.label$bn -row $r -column 5
	grid $f.lower$bn -row $r -column 10
	grid $f.upper$bn -row $r -column 15
	grid $f.stepmenu$bn -row $r -column 20 -sticky ew
	grid $f.lmodemenu$bn -row $r -column 27 -sticky ew
	grid $f.delay$bn -row $r -column 35
	grid $f.atten$bn -row $r -column 40

	return $f
}


###################################################################
# Create one a set of widgets for one memory channel bank. 
###################################################################
proc MakeChanBank { f bn }\
{
	global ChanBank
	global DisplayFontSize 
	global GlobalParam

	frame $f -relief flat -borderwidth 3

	set r [expr {$bn + 10}]

	label $f.bankn$bn -text "$bn" \
		-relief flat \
		-borderwidth 6 \
		-font $DisplayFontSize 

	label $f.llabel$bn -text "Label" -borderwidth 3

	entry $f.label$bn -width 14 \
		-textvariable ChanBank($bn,label) \
		-background white 

	label $f.ltypemenu$bn -text "Type" -borderwidth 3
	tk_optionMenu $f.typemenu$bn ChanBank($bn,type) \
		CONVENTIONAL LT MO ED

	set hint ""
	append hint "The Bank Type identifies what type of trunked "
	append hint "system, if any, is associated with this bank.\n\n"
	append hint "Motorola, EDACS, and LTR trunking systems "
	append hint "encode talk group IDs differently. "
	append hint "Therefore, it is important "
	append hint "to set the Bank Type correctly before "
	append hint "defining talk group IDs.\n\n"
	append hint "Conventional type banks cannot have "
	append hint "talk groups."
	balloonhelp_for $f.ltypemenu$bn $hint
	balloonhelp_for $f.typemenu$bn $hint

	label $f.locmenu$bn -text "Open/Closed" -borderwidth 3
	tk_optionMenu $f.ocmenu$bn ChanBank($bn,oc) \
		OPEN CLOSED	


	label $f.loffsetmenu$bn -text "Offset" -borderwidth 3
	tk_optionMenu $f.offsetmenu$bn ChanBank($bn,troffset) \
		0 12.5 25 50	


	set hint ""
	append hint "Offsets are used only for Motorola trunking "
	append hint "in the 380 - 512 MHz range."
	balloonhelp_for $f.loffsetmenu$bn $hint
	balloonhelp_for $f.offsetmenu$bn $hint


	grid $f.bankn$bn -row 5 -column 0 -sticky ew -columnspan 2
	grid $f.llabel$bn -row 10 -column 0 -sticky w
	grid $f.label$bn -row 10 -column 1 -sticky w
	grid $f.ltypemenu$bn -row 20 -column 0 -sticky w
	grid $f.typemenu$bn -row 20 -column 1 -sticky ew
	grid $f.locmenu$bn -row 30 -column 0 -sticky w
	grid $f.ocmenu$bn -row 30 -column 1 -sticky ew
	grid $f.loffsetmenu$bn -row 40 -column 0 -sticky w
	grid $f.offsetmenu$bn -row 40 -column 1 -sticky ew

	return $f
}



###################################################################
# Create Weather channel frequencies.
###################################################################
proc MakeWxFrame { f }\
{
	global GlobalParam

	frame $f -relief groove -borderwidth 3

	set msg1 "Weather Channels"
	label $f.lab -text $msg1 -borderwidth 3
	pack $f.lab -side top -padx 3 -pady 3


	set b $f.b
	frame $b -relief flat -borderwidth 3

	label $b.hlab -text "" -borderwidth 3
	label $b.hunused -text "Unused" -borderwidth 3
	label $b.hfreq -text "Frequency" -borderwidth 3
	label $b.hlabel -text "Label" -borderwidth 3
	label $b.hmode -text "Mode" -borderwidth 3
	label $b.hdelay -text "Delay" -borderwidth 3
	# label $b.hlockout -text "Lockout" -borderwidth 3
	label $b.hatten -text "Atten." -borderwidth 3
	# label $b.hpl -text "PL/DPL" -borderwidth 3

	set r 0

	grid $b.hlab -row $r -column 0 -sticky w
	grid $b.hunused -row $r -column 3 -sticky w
	grid $b.hfreq -row $r -column 5 -sticky w
	grid $b.hlabel -row $r -column 10 -sticky w
	grid $b.hmode -row $r -column 15 -sticky w
	grid $b.hdelay -row $r -column 25 -sticky w
	# grid $b.hlockout -row $r -column 35 -sticky w
	grid $b.hatten -row $r -column 45 -sticky w
	# grid $b.hpl -row $r -column 55 -sticky w

	for {set i 0} {$i < 10} {incr i} \
		{
		MakeWxChan $f.b $i
		}

	pack $f.b -side top -fill both -expand true -padx 3 -pady 3

	return $f
}



###################################################################
# Create one a set of widgets for one weather channel. 
###################################################################
proc MakeWxChan { f ch }\
{
	global GlobalParam
	global Weather


	set n [expr {$ch + 1}]
	set r [expr {$ch + 10}]


	set msg [format "WX%d" $n]
	label $f.lab$ch -text "$msg" -borderwidth 3

	checkbutton $f.unused$ch -text "" \
		-variable Weather($ch,unused) \
		-onvalue 1 -offvalue 0

	set hint ""
	append hint "Setting the Unused flag "
	append hint "will clear this weather channel frequency."
	balloonhelp_for $f.unused$ch $hint

	entry $f.freq$ch -width 10 \
		-textvariable Weather($ch,freq) \
		-background white 

	set hint ""
	append hint "You can redefine the preprogrammed Weather "
	append hint "channels to be any valid frequency, "
	append hint "but they are limited to AM or FM modes only."
	balloonhelp_for $f.freq$ch $hint

	entry $f.label$ch -width 14 \
		-textvariable Weather($ch,label) \
		-background white 

	tk_optionMenu $f.modemenu$ch Weather($ch,mode) \
		FM AM

	balloonhelp_for $f.modemenu$ch $hint

	checkbutton $f.delay$ch -text "" \
		-variable Weather($ch,delay) \
		-onvalue 1 -offvalue 0

	checkbutton $f.lockout$ch -text "" \
		-variable Weather($ch,lockout) \
		-onvalue 1 -offvalue 0

	checkbutton $f.atten$ch -text "" \
		-variable Weather($ch,atten) \
		-onvalue 1 -offvalue 0

#	entry $f.pl$ch -width 8 \
#		-textvariable Weather($ch,pl) \
#		-background white 



	grid $f.lab$ch -row $r -column 0 -sticky w
	grid $f.unused$ch -row $r -column 3 -sticky w
	grid $f.freq$ch -row $r -column 5 -sticky w
	grid $f.label$ch -row $r -column 10 -sticky w
	grid $f.modemenu$ch -row $r -column 15 -sticky w
	grid $f.delay$ch -row $r -column 25 -sticky w
	# grid $f.lockout$ch -row $r -column 35 -sticky w
	grid $f.atten$ch -row $r -column 45 -sticky w
#	grid $f.pl$ch -row $r -column 55 -sticky w

	return $f
}



###################################################################
# Create frame for misc parameters. 
###################################################################
proc MakeMiscFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Misc. Settings" \
		-borderwidth 3
	pack $f.lab -side top

	MakeMiscWidgets  $f.b
	pack $f.b -side top -expand true -fill both

	return $f
}


###################################################################
# Create frame for rescan delay parameters. 
###################################################################
proc MakeRescanFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Rescan Delay Settings (ms)" \
		-borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3
	MakeRescanWidgets  $f.b
	pack $f.b -side top -expand true -fill both

	return $f
}


###################################################################
# Create widgets for misc. parameters. 
###################################################################
proc MakeMiscWidgets { f } \
{
	global GlobalParam

	frame $f -relief flat -borderwidth 3

	MakePriorityWidgets $f.priority

	pack $f.priority -side top -expand true -fill both
	return $f
}

###################################################################
# Create widgets for misc. parameters. 
###################################################################
proc MakePriorityWidgets { f } \
{
	global GlobalParam

	frame $f -relief groove -borderwidth 3

	label $f.lab -text "Priority Channel" -borderwidth 3

	label $f.ltype -text "Channel Type" -borderwidth 3

	radiobutton $f.rbmemory -text Memory \
		-variable GlobalParam(PriorityMemoryWx) -value memory

	radiobutton $f.rbwx -text WX \
		-variable GlobalParam(PriorityMemoryWx) -value wx

	label $f.lprioritych -text "Channel" -borderwidth 3
	entry $f.prioritych -width 6 \
		-textvariable GlobalParam(PriorityChannel) \
		-background white 

	label $f.lprioritye -text "Priority Active" -borderwidth 3
	checkbutton $f.prioritye -text "" \
		-variable GlobalParam(PriorityEnable) \
		-onvalue 1 -offvalue 0

        grid $f.lab  -row 2 -column 0 -sticky ew -columnspan 3

        grid $f.ltype  -row 3 -column 0 -sticky w
        grid $f.rbmemory  -row 3 -column 1 -sticky w
        grid $f.rbwx  -row 3 -column 2 -sticky w

        grid $f.lprioritych  -row 5 -column 0 -sticky w
        grid $f.prioritych  -row 5 -column 1 -sticky w

        grid $f.lprioritye  -row 10 -column 0 -sticky w
        grid $f.prioritye  -row 10 -column 1 -sticky w


	set hint ""
	append hint "The Priority channel may be a Weather "
	append hint "channel 1 - 10\n" 
	append hint "or a Memory channel. "
	append hint "The Priority channel mode must be FM, AM, "
	append hint "PL, or DL."
	balloonhelp_for $f $hint

	return $f
}

###################################################################
# Create widgets for rescan delay. 
###################################################################
proc MakeRescanWidgets { f } \
{
	global GlobalParam
	
	scale $f.crescandelay -from 400 -to 25500 \
		-label "Conventional" \
		-variable GlobalParam(RescanDelayConv) \
		-resolution 100 \
		-orient horizontal
	$f.crescandelay set $GlobalParam(RescanDelayConv)
	
	scale $f.trescandelay -from 400 -to 10000 \
		-label "Trunk" \
		-variable GlobalParam(RescanDelayTrunk) \
		-resolution 100 \
		-orient horizontal
	$f.trescandelay set $GlobalParam(RescanDelayTrunk)
	

	scale $f.mrescandelay -from 0 -to 25500 \
		-label "Minimum" \
		-variable GlobalParam(RescanDelayMin) \
		-resolution 100 \
		-orient horizontal
	$f.mrescandelay set $GlobalParam(RescanDelayMin)

	set hint ""
	append hint "The Minimum Rescan Delay setting "
	append hint "effects only those channels for "
	append hint "which the Delay flag is off."
	balloonhelp_for $f.mrescandelay $hint

	
        grid $f.crescandelay  -row 10 -column 0 -sticky ew -columnspan 2
        grid $f.trescandelay  -row 20 -column 0 -sticky ew -columnspan 2
        grid $f.mrescandelay  -row 30 -column 0 -sticky ew -columnspan 2


	return $f
}


###################################################################
# Create frame for Communications parameters. 
###################################################################
proc MakeCommFrame { f }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Serial Communication" \
		-borderwidth 3
	pack $f.lab -side top

	frame $f.b -relief flat -borderwidth 3
	MakeCommWidgets  $f.b

	set hint ""
	append hint "Serial Communications fields "
	append hint "are useful for testing tk92. "
	balloonhelp_for $f $hint


	pack $f.b -side top -expand true -fill y

	return $f
}


###################################################################
# Create widgets for Communications params. 
###################################################################
proc MakeCommWidgets { f } \
{
	global GlobalParam

	label $f.labpre -text "Preamble" -borderwidth 3
	entry $f.pre -width 26 \
		-textvariable GlobalParam(PreambleRead) \
		-background yellow 


	label $f.labpost -text "Postamble" -borderwidth 3
	entry $f.post -width 26 \
		-textvariable GlobalParam(PostambleRead) \
		-background yellow 


	label $f.labnmsgs -text "Messages Read" -borderwidth 3
	entry $f.nmsgs -width 5 \
		-textvariable GlobalParam(NmsgsRead) \
		-background yellow 



	grid $f.labpre  -row 0 -column 0 -sticky w
	grid $f.pre	-row 0 -column 1 -sticky e
	grid $f.labpost  -row 1 -column 0 -sticky w
	grid $f.post	-row 1 -column 1 -sticky e
	grid $f.labnmsgs -row 2 -column 0 -sticky w
	grid $f.nmsgs	-row 2 -column 1 -sticky e

	return $f
}


###################################################################
# Create widgets for Linked Scan Banks. 
###################################################################
proc MakeLinkedScanFrame { f }\
{

	global GlobalParam

	frame $f -relief sunken -borderwidth 3



	label $f.lab -text "Linked\nScan\nBanks" -borderwidth 3
	pack $f.lab -side top

	for {set i 0} {$i < 10} {incr i} \
		{
		MakeMBankLink $f $i
		}

	return $f
}

proc MakeMBankLink {w bn} \
{
	global MBankLink

	set n ""
	append n 3 $bn

	checkbutton $w.link$bn -text "$bn" \
		-variable MBankLink($bn) \
		-onvalue $n \
		-offvalue a5

	pack $w.link$bn -side top -anchor w
	return
}

###################################################################
# Create widgets for Skip frequencies and modes. 
###################################################################
proc MakeSkipFrame { f bn }\
{

	frame $f -relief groove -borderwidth 3
	label $f.lab -text "Skip Frequencies" \
		-borderwidth 3

	button $f.clear -text "Clear" -command \
		{ClearSkipBank [CurrentSBank]}

	pack $f.lab $f.clear -side top -padx 3 -pady 3

	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both

	set w [ScrollFormInterior $f.b]

	for {set i 0} {$i < 50} {incr i} \
		{
		MakeSkip $w $bn $i
		}



	set hint ""
	append hint "You can designate frequencies "
	append hint "to skip over during limit searches. "
	append hint "This is useful for ignoring "
	append hint "paging, birdy, and other boring "
	append hint "frequencies. "
	balloonhelp_for $f.b $hint

	pack $f.b -side top -padx 3 -pady 3

	return $f
}

###################################################################
# Create one a set of widgets for one skip freq/mode pair. 
#
# INPUTS:
#	f	-frame
#	bn	-search bank number
#	i	-skip channel number
###################################################################
proc MakeSkip { f bn i }\
{
	global Skip
	global GlobalParam

	label $f.lab$bn$i -text "$i" -borderwidth 3

	entry $f.freq$bn$i -width 10 \
		-textvariable Skip($bn,$i) \
		-background white 

	grid $f.lab$bn$i -row $i -column 0
	grid $f.freq$bn$i -row $i -column 1

	return $f
}


###################################################################
# Encode the information from the data structures into
# the memory image string which can be written to the PRO-92.
#
# We don't understand the meaning of all the bytes in
# the memory image.  Therefore, the
# image string must already exist and we will only
# change the bytes which we understand.
#
###################################################################
proc EncodeImage { } \
{
	global GlobalParam
	global Mimage

	if {$GlobalParam(BypassAllEncoding)} \
		{
		puts stderr "EncodeImage: skip encoding"
		return 0
		}

	# puts stderr "EncodeImage: encoding"
	if { ([info exists Mimage] == 0) } \
		{
		puts stderr "EncodeImage: image does not exist"
		return error
		}

	set image $Mimage

	set image [EncodeMisc $image]
	if { [string length $image] == 0} {return error}

	set image [EncodePriority $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeMemories $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeSearchBanks $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeChanBanks $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeMBankLinks $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeSBankLinks $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeWX $image]
	if { [string length $image] == 0} {return error}

	set image [EncodeSkipFreqs $image]
	if { [string length $image] == 0} {return error}


	set Mimage $image

	return 0
}



###################################################################
# Encode misc
# information into a memory image.
###################################################################
proc EncodeMisc { image } \
{
	global ImageAddr
	global GlobalParam
	global Mimage



	# welcome message.

	for {set i 1} {$i <= 4} {incr i} \
		{
		scan $ImageAddr(WelcomeMsg$i) "%x" first
		set last [expr {$first + 11}]
		set s [string range $GlobalParam(WelcomeMsg$i) 0 11]
		set s [format "%-12s" $s]

		# Translate bogus characters to spaces
		regsub -all {[^A-Za-z0-9 .,#_@\+\*\&/'$%!^()?\-]} $s "?" s
		set image [string replace $image $first $last $s]
		}



	# Contrast
	scan $ImageAddr(Contrast) "%x" first
	set last $first
	set c [format "%02x" $GlobalParam(Contrast)]
	set b [binary format "H2" $c]
	set image [string replace $image $first $last $b]


	# Lamp Timeout (sec)
	scan $ImageAddr(LampTimeout) "%x" first
	set last $first
	set c [format "%02x" $GlobalParam(LampTimeout)]
	set b [binary format "H2" $c]
	set image [string replace $image $first $last $b]


	# Minimum Rescan Delay (when delay is off)
	scan $ImageAddr(RescanDelayMin) "%x" first
	set last $first
	set d [expr { int($GlobalParam(RescanDelayMin) / 100) } ]
	set c [format "%02x" $d]
	set b [binary format "H2" $c]
	set image [string replace $image $first $last $b]

	# Conventional Rescan Delay
	scan $ImageAddr(RescanDelayConv) "%x" first
	set last $first
	set d [expr { int($GlobalParam(RescanDelayConv) / 100) } ]
	set c [format "%02x" $d]
	set b [binary format "H2" $c]
	set image [string replace $image $first $last $b]

	# Trunked Rescan Delay
	scan $ImageAddr(RescanDelayTrunk) "%x" first
	set last $first
	set d [expr { int($GlobalParam(RescanDelayTrunk) / 100) } ]
	set c [format "%02x" $d]
	set b [binary format "H2" $c]
	set image [string replace $image $first $last $b]


	return $image
}



###################################################################
#
# Encode the data from inside the global memory channel arrays
# and save it in the memory image in the correct locations.
#
# NOTES:
#	In each bank,
#	each memory channel is represented by 18 consecutive bytes.
#	
###################################################################
proc EncodeMemories { image } \
{
	global ImageAddr
	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemMode
	global MemLockout
	global MemPL
	global MemUnused
	global Mode
	global NBanks
	global NChanPerBank
	global NBytesPerBank
	global VNChanPerBank

	# Memory channel text labels.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryLabels) "%x" first
		incr first $offset
		set last [expr {$first + 11}]

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			set s [format "%-12s" $MemLabel($ch)]
			set image [string replace $image \
				$first $last $s]

			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}


	# Memory channel frequencies.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryFreqs) "%x" first
		incr first $offset
		set last [expr {$first + 2}]

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			if {$MemUnused($ch) } \
				{
				set MemFreq($ch) ""
				}

			set s [Freq2Internal $MemFreq($ch)]

			set image [string replace $image \
				$first $last $s]

			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}

	# Memory channel mode.
	# Note: Encoding the mode must be done after
	# encoding the frequency or else the mode nibble will
	# be overritten by the frequency conversion procedure.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryModes) "%x" first
		incr first $offset
		set last $first

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			set s [string range $image $first $last]
			set m $MemMode($ch)

			if { [info exists Mode($m)] } \
				{
				set s [SetBitField $s 4 7 $Mode($m)]
				} \
			else \
				{
				# Bogus mode.
				set s [SetBitField $s 4 7 $Mode(FM)]
				}

			set image [string replace $image \
				$first $last $s]

			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}


	# Memory channel
	# skip, atten, delay, and unused flags.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryFlags) "%x" first
		incr first $offset
		set last $first

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			set s [string range $image $first $last]
		
			set s [AssignBit $s 7 $MemLockout($ch)]
			set s [AssignBit $s 6 $MemAtten($ch)]
			set s [AssignBit $s 5 $MemDelay($ch)]
			set s [AssignBit $s 4 $MemUnused($ch)]

			set image [string replace $image \
				$first $last $s]

			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}



	# Memory channel PL code.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(MemoryPL) "%x" first
		incr first $offset
		set last [expr {$first + 1}]

		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			set bytes [string range $image $first $last]
			set s [EncodePL $MemPL($ch)]

			set image [string replace $image $first $last $s]

			incr first 18
			incr last 18
			incr ch
			}
		incr offset $NBytesPerBank
		}


	return $image
}


###################################################################
#
# Encode the data from inside the global memory channel arrays
# and save it in the memory image in the correct locations.
#
# NOTES:
#	Each weather
#	channel is represented by 18 consecutive bytes.
#	
###################################################################
proc EncodeWX { image } \
{
	global ImageAddr
	global Mode
	global Weather

	# wx channel text labels.

	scan $ImageAddr(WxLabels) "%x" first
		set last [expr {$first + 11}]

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set s [format "%-12s" $Weather($ch,label)]
		set image [string replace $image \
			$first $last $s]

		incr first 18
		incr last 18
		}


	# wx channel frequencies.
	scan $ImageAddr(WxFreqs) "%x" first
	set last [expr {$first + 2}]

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		if {$Weather($ch,unused) } \
			{
			set Weather($ch,freq) 0.0000
			}

		set s [Freq2Internal $Weather($ch,freq)]

		set image [string replace $image \
			$first $last $s]

		incr first 18
		incr last 18
		}

	# wx channel mode.
	# Note: Encoding the mode must be done after
	# encoding the frequency or else the mode nibble will
	# be overritten by the frequency conversion procedure.

	scan $ImageAddr(WxModes) "%x" first
	set last $first

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set s [string range $image $first $last]
		set m $Weather($ch,mode)

		if { [info exists Mode($m)] } \
			{
			set s [SetBitField $s 4 7 $Mode($m)]
			} \
		else \
			{
			# Bogus mode.
			set s [SetBitField $s 4 7 $Mode(FM)]
			}

		set image [string replace $image \
			$first $last $s]

		incr first 18
		incr last 18
		}


	# wx channel
	# skip, atten, delay, and unused flags.

	scan $ImageAddr(WxFlags) "%x" first
	set last $first

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set s [string range $image $first $last]
	
		set s [AssignBit $s 7 $Weather($ch,lockout)]
		set s [AssignBit $s 6 $Weather($ch,atten)]
		set s [AssignBit $s 5 $Weather($ch,delay)]
		set s [AssignBit $s 4 $Weather($ch,unused)]

		set image [string replace $image \
			$first $last $s]

		incr first 18
		incr last 18
		}



#	# wx channel PL code.
#
#	scan $ImageAddr(WxPL) "%x" first
#	set last [expr {$first + 1}]
#
#	for {set ch 0} {$ch < 10} {incr ch} \
#		{
#		set bytes [string range $image $first $last]
#		set s [EncodePL $Weather($ch,pl)]
#
#		set image [string replace $image $first $last $s]
#
#		incr first 18
#		incr last 18
#		}


	return $image
}


###################################################################
#
# Encode data from global arrays and store it inside
# the memory image
#
# NOTES:
#	
###################################################################
proc EncodeChanBanks { image } \
{
	global BankOffset
	global BankType
	global ImageAddr
	global ChanBank
	global NBanks
	global NBytesPerBank
	global TalkGroup

	# Channel bank text labels.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(BankLabel) "%x" first
		incr first $offset
		set last [expr {$first + 11}]

		set s $ChanBank($bn,label)
		# Translate bogus characters to spaces
		regsub -all {[^A-Za-z0-9 .,#_@\+\*\&/'$%!^()?\-]} $s "?" s
		set s [format "%-12s" $s]
		set s [string range $s 0 11]

		set image [string replace $image $first $last $s]

		incr first 18
		incr last 18

		incr offset $NBytesPerBank
		}


	# Channel bank type.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(BankType) "%x" first
		incr first $offset
		set last $first


		if {[info exists BankType($ChanBank($bn,type))] } \
			{
			set t $BankType($ChanBank($bn,type))
			} \
		else \
			{
			set t $BankType(CONVENTIONAL)
			}

		set s [format "%02x" $t]
		set b [binary format "H2" $s]

		set image [string replace $image $first $last $b]

		incr first 18
		incr last 18

		incr offset $NBytesPerBank
		}


	# Channel bank open/closed and trunking offset value.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(BankOffset) "%x" first
		incr first $offset
		set last $first

		# open/closed
		set b [string range $image $first $last]
		if {$ChanBank($bn,oc) == "OPEN"} \
			{
			set b [SetBit $b 6]
			} \
		else \
			{
			set b [ClearBit $b 6]
			}

		# offset

		if {[info exists BankOffset($ChanBank($bn,troffset))] } \
			{
			set ofs $BankOffset($ChanBank($bn,troffset))
			} \
		else \
			{
			set ofs $BankOffset(0)
			}

		set b [SetBitField $b 4 5 $ofs]
		set image [string replace $image $first $last $b]

		incr first 18
		incr last 18

		incr offset $NBytesPerBank
		}



	# Fleet map size codes.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(FleetMap) "%x" first
		incr first $offset
		set last $first

		for {set bl 0} {$bl < 8} {incr bl} \
			{
			set sc $ChanBank($bn,block$bl)

			# Size codes are either Type2 or
			# Sd or Sdd, where d is a digit.

			# Strip off the first character
			set digits [string range $sc 1 end]
			set n 0

			if {$sc == "Type2"} \
				{
				set n 0
				} \
			elseif {($digits >= 1) && ($digits <= 14)} \
				{
				set n $digits
				} \
			else \
				{
				# bogus size code
				set n 0
				}

			set hn [format "%02x" $n]
			set b [binary format "H2" $hn]

			set image [string replace $image \
				$first $last $b]

			incr first
			incr last
			}

		incr offset $NBytesPerBank
		}


	# Talk group IDs.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		# puts stderr "bn: $bn ======="
		scan $ImageAddr(TalkGroupID) "%x" first
		incr first $offset
		set last [expr {$first + 1}]

		for {set i 0} {$i < 100} {incr i} \
			{
			set b [TalkGroupID2Internal \
				$TalkGroup($bn,$i,group) \
				$ChanBank($bn,type) \
				$TalkGroup($bn,$i,lockout) \
				$bn ]

			set image [string replace $image \
				$first $last $b]


			incr first 14
			incr last 14
			}

		incr offset $NBytesPerBank
		}


	# Talk group labels.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(TalkGroupLabel) "%x" first
		incr first $offset
		set last [expr {$first + 11}]

		for {set i 0} {$i < 100} {incr i} \
			{
			set s $TalkGroup($bn,$i,label)

			# Translate bogus characters to spaces
			regsub -all {[^A-Za-z0-9 .,#_@\+\*\&/'$%!^()?\-]} $s " " s
			set s [format "%-12s" $s]
			set s [string range $s 0 11]

			set image [string replace $image \
				$first $last $s]

			incr first 14
			incr last 14
			}

		incr offset $NBytesPerBank
		}

	return $image
}

###################################################################
# Encode the Skip channel frequency for each search bank
# into a memory image.
###################################################################

proc EncodeSkipFreqs { image } \
{
	global ImageAddr
	global LimitScan
	global Mode
	global NBanks
	global NBytesPerBank
	global RBandStep
	global Skip

	# Encode the 50 skip frequencies for each search bank.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(Skip) "%x" first
		incr first $offset
		set last [expr {$first + 1}]

		for {set i 0} {$i < 50} {incr i} \
			{
			if {$Skip($bn,$i) == ""} \
				{
				set b0 [binary format "H2" ff]
				set b1 [binary format "H2" ff]
				} \
			else \
				{
				set f $Skip($bn,$i)
				set bytes [Freq2Internal $f]

				# Ignore the 3rd byte.
				set bytes [string range $bytes 0 1]

				set image [string replace \
					$image $first $last $bytes]
				# set junk [DumpBinary $bytes]
				# puts stderr "EncodeSkipFreqs: bn: $bn, i: $i, f: $f, bytes: $junk"

				}
			incr first 2
			incr last 2
			}


		incr offset $NBytesPerBank
		}

	return $image
}

###################################################################
# Encode the limit search bank frequencies and modes
# information into a memory image.
###################################################################

proc EncodeSearchBanks { image } \
{
	global ImageAddr
	global LimitScan
	global NBanks
	global NBytesPerBank
	global RBandStep
	global Mode

	# Search bank text labels.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchLabel) "%x" first
		incr first $offset
		set last [expr {$first + 11}]

		set s [format "%-12s" $LimitScan($bn,label)]

		# Translate bogus characters to spaces
		regsub -all {[^A-Za-z0-9 .,#_@\+\*\&/'$%!^()?\-]} $s "?" s
		set s [string replace $s 0 11 $s]
		set image [string replace $image $first $last $s]

		incr offset $NBytesPerBank
		}



	# Limit search bank
	# skip, atten, delay, and unused flags.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchFlags) "%x" first
		incr first $offset
		set last $first

		if { [info exists LimitScan($bn,lower)] \
			&& ($LimitScan($bn,lower) != "") \
			&& ($LimitScan($bn,lower) > 0) \
			&& [info exists LimitScan($bn,upper)] \
			&& ($LimitScan($bn,upper) != "") \
			&& ($LimitScan($bn,upper) > 0)  } \
			{
			set LimitScan($bn,unused) 0
			} \
		else \
			{
			set LimitScan($bn,lower) 0
			set LimitScan($bn,upper) 0
			set LimitScan($bn,unused) 1
			}

		set b [string range $image $first $last]

		set b [AssignBit $b 7 $LimitScan($bn,lockout)]
		set b [AssignBit $b 6 $LimitScan($bn,atten)]
		set b [AssignBit $b 5 $LimitScan($bn,delay)]
		set b [AssignBit $b 4 $LimitScan($bn,unused)]

		set image [string replace $image $first $last $b]
		incr offset $NBytesPerBank
		}


	# Limit search PL code.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchPL) "%x" first
		incr first $offset
		set last [expr {$first + 1}]

		set b [EncodePL $LimitScan($bn,pl)]
		set image [string replace $image $first $last $b]

		incr offset $NBytesPerBank
		}


	# Lower limit search frequencies and bands.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchFreqFirst) "%x" first
		incr first $offset
		set last [expr {$first + 2}]

		set s [Freq2Internal $LimitScan($bn,lower)]

		# Band is located in the most significant (left) nibble
		# of second byte
		set b [string index $s 2]
		set LimitScan($bn,band) [GetBitField $b 0 3]


		set image [string replace $image $first $last $s]

		incr offset $NBytesPerBank
		}



	# Lower limit search mode.
	# Note: mode must be set after frequency to avoid
	# the Freq2Internal procedure from clobbering the mode byte.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchModeFirst) "%x" first
		incr first $offset
		set last [expr {$first}]

		set b [string range $image $first $last]

		set m $LimitScan($bn,lmode)
		if { [info exists Mode($m)] } \
			{
			set b [SetBitField $b 4 7 $Mode($m)]
			} \
		else \
			{
			# Bogus mode.
			set b [SetBitField $b 4 7 $Mode(FM)]
			}
		set image [string replace $image $first $last $b]
		incr offset $NBytesPerBank
		}

	# Upper limit search frequencies.
	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchFreqSecond) "%x" first
		incr first $offset
		set last [expr {$first + 1}]

		set b [Freq2Internal $LimitScan($bn,upper)]

		# Ignore the 3rd byte.

		set b [string range $b 0 1]
		set image [string replace $image $first $last $b]

		incr offset $NBytesPerBank
		}


	# Limit search step size.

	set offset 0
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		scan $ImageAddr(SearchStep) "%x" first
		incr first $offset
		set last $first


		set st $LimitScan($bn,step)

		# Determine band and multiplier
		set step [expr {$st / $RBandStep($LimitScan($bn,band))}]
		set step [expr {int($step)}]

		set bs [format "%02x" $step]
		set b [binary format "H2" $bs]

		set image [string replace $image $first $first $b]

		incr offset $NBytesPerBank
		}


	return $image
}


###################################################################
# Encode the memory bank link
# information into a memory image.
###################################################################

proc EncodeMBankLinks { image } \
{
	global ImageAddr
	global MBankLink
	global NBanks


	# Bank links.

	scan $ImageAddr(MBankLinks) "%x" first

	# Banks 0 - 9.



	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		set n ""
		append n 3 $bn

		if {$MBankLink($bn) == $n } \
			{
			set byte [binary format "H2" $n]
			} \
		else \
			{
			set byte [binary format "H2" A5]
			}
		set image [string replace $image $first $first $byte]
		incr first
		}

	return $image
}


###################################################################
# Encode the search bank link
# information into a memory image.
###################################################################

proc EncodeSBankLinks { image } \
{
	global ImageAddr
	global SBankLink
	global NBanks


	# Bank links.

	scan $ImageAddr(SBankLinks) "%x" first

	# Banks 0 - 9.



	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		set n ""
		append n 3 $bn

		if {$SBankLink($bn) == $n } \
			{
			set byte [binary format "H2" $n]
			} \
		else \
			{
			set byte [binary format "H2" A5]
			}
		set image [string replace $image $first $first $byte]
		incr first
		}

	return $image
}


###################################################################
# Pop up a window which says "Please wait..."
###################################################################
proc MakeWait { } \
{
	global DisplayFontSize


	toplevel .wait

	set w .wait
	wm title $w "tk92 running"

	label $w.lab -font $DisplayFontSize -text "Please wait ..."

	pack $w.lab

	update idletasks
	waiter 500
	return
}

###################################################################
# Kill the window which says "Please wait..."
###################################################################
proc KillWait { } \
{
	catch {destroy .wait}
	update idletasks
}

###################################################################
# ValidateData tests the data.
# It pops up a window with error and/or warning messages.
# If there are warnings but no errors, the user can elect
# to continue or cancel the current operation.
#
# Returns:
#	0	- continue
#	1	- cancel the current operation
###################################################################
proc ValidateData { } \
{
	global Emsg
	global GlobalParam
	global MemFreq
	global MemMode
	global MemPL
	global NBanks
	global LimitScan
	global NChanPerBank
	global Priority
	global PriorityMode
	global Skip
	global TalkGroup
	global VNChanPerBank
	global Weather

	if { [info exists MemFreq(0)] == 0 } \
		{
		# No data to validate.
		return 1
		}

	set Emsg ""
	set nerror 0
	set nwarning 0

	# Memory channels.

	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{

			set m "Ch. $ch"
			set f $MemFreq($ch)
	
			set code [ValidateFreq $f $m]
			if {$code == "error"} { incr nerror } \
			elseif {$code == "warning"} { incr nwarning }
	
			set f $MemMode($ch)
			set pl $MemPL($ch)

			set code [ValidateMode $f $m]
			if {$code == "error"} \
				{
				incr nerror
				} \
			elseif {($f == "PL") || ($f == "pl")} \
				{
				set rc [regexp -nocase {^d.*$} $pl]
				if {$rc} \
					{
					# mode is PL but the code
					# is digital pl.
					append Emsg "\nError: $m"
					append Emsg "\nMode is PL "
					append Emsg "but channel has "
					append Emsg "a DPL code."
					incr nerror
					}
				
				} \
			elseif {($f == "DL") || ($f == "dl")} \
				{
				set rc [regexp -nocase {^d.*$} $pl]
				if { ($pl != "") && ($rc == 0) } \
					{
					# mode is DL but the code
					# is analog pl.
					append Emsg "\nError: $m"
					append Emsg "\nMode is DL "
					append Emsg "but channel has "
					append Emsg "an analog PL code."
					incr nerror
					}
				}
	
			set f $MemPL($ch)
			if {[EncodePL $f] == ""} \
				{
				append Emsg "\nError: $m"
				append Emsg "\nPL/DPL code ($f) is "
				append Emsg " not valid.\n"
				incr nerror
				}
	
			if { [expr {$nerror + $nwarning}] > 5} {break}
			incr ch
			}
		}

	# Weather channels.

	for {set ch 0} {$ch < 10} {incr ch} \
		{
		set n [expr {$ch + 1}]
		set m "WX$n"
		set f $Weather($ch,freq)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		set f $Weather($ch,mode)
		set code [ValidateMode $f $m]
		if {$code == "error"} { incr nerror }
	

		if { [expr {$nerror + $nwarning}] > 5} {break}
		}


	# Limit scan

	for {set i 0} {$i < $NBanks} {incr i} \
		{
		set m "Limit Scan bank $i"
		set f $LimitScan($i,lower)
		set step $LimitScan($i,step)

		if {[ValidateStep $f $step] < 0} \
			{
			incr nerror
			append Emsg "\nError: $m"
			append Emsg "\nstep size ($step) is "
			append Emsg " not valid for "
			append Emsg " frequency ($f).\n"
			}

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		set m "Limit Scan bank $i"
		set f $LimitScan($i,upper)

		set code [ValidateFreq $f $m]
		if {$code == "error"} { incr nerror } \
		elseif {$code == "warning"} { incr nwarning }

		set bl [Freq2Band $LimitScan($i,lower)]
		set bu [Freq2Band $LimitScan($i,upper)]
		if {$bl != $bu} \
			{
			incr nerror
			append Emsg "\nError: $m"
			append Emsg "\nlower frequency "
			append Emsg " and upper frequency must "
			append Emsg " be within the same band.\n"
			}


		if { [expr {$nerror + $nwarning}] > 5} {break}
		}


	# Skip frequencies
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		for {set i 0} {$i < 50} {incr i} \
			{
			set m "Skip frequency $i in Bank $bn"
			set f $Skip($bn,$i)

			set code [ValidateFreq $f $m]
			if {$code == "error"} { incr nerror } \
			elseif {$code == "warning"} { incr nwarning }

			if { [expr {$nerror + $nwarning}] > 5} {break}
			}
		}




	# Talk Group IDs 
	if { [ValidateID ] } { incr nerror } \

	# Validate priority channel
	if { [ValidatePriority ] } { incr nerror } \

	if {$nerror} \
		{
		tk_dialog .baddata1 "tk92 Invalid data" \
			$Emsg error 0 OK
		# puts stderr "ValidateData: returning 1"
		return 1
		}
	if {$nwarning} \
		{
		set response [tk_dialog .baddata2 \
			"tk92 Data warning" \
			$Emsg error 0 Cancel Continue]

		if {$response == 0} then {return 1} \
		else {return 0}
		}
	
	return 0
}


###################################################################
# Check a talk group ID for validity.
# Append the error or warning message to a global string.
#
# Returns:
#	0
#	warning
#	error
###################################################################
proc ValidateID { } \
{
	global ChanBank
	global Emsg
	global GlobalParam
	global NBanks
	global TalkGroup

	set code 0
	set msg ""

	set nerror 0

	# Talk Group IDs 
	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		set type $ChanBank($bn,type)
		set anyid 0
		for {set i 0} {$i < 100} {incr i} \
			{
			set m "Talk group ID $i in Bank $bn"

			set id $TalkGroup($bn,$i,group)

			if {$id != ""} {set anyid 1}

			# Sanity check talk group ID.
			set rc1 [regexp {^[0-9]*$} $id]
			set rc2 [regexp {^[0-9][0-9][0-9]-[0-9][0-9]$} $id]
			set rc3 [regexp {^[0-9][0-9][0-9][0-9]-[0-9]$} $id]
			set rc4 [regexp {^[0-9][0-9]-[0-9][0-9][0-9]$} $id]
			if {($rc1 == 0) && ($rc2 == 0) \
				&& ($rc3 == 0) && ($rc4 == 0)} \
				{
				append msg "\nError: $m"
				append msg "\nInvalid Talk Group "
				append msg "ID.\n\n"
				append msg "Must be a string of " 
				append msg "digits. Motorola Type " 
				append msg "1 IDs may be in one of " 
				append msg "two forms: \n\n" 
				append msg "BFFF-S or BFF-SS\n\n"
				append msg "where B, F, and S are "
				append msg "digits."
				incr nerror 
				set code -1
				}

			if {$nerror > 5} {break}
			}

		# Check if bank is a conventional bank
		# but contains a talk group ID.

		# puts stderr "bn: $bn, type: $type, anyid: $anyid"
		if {$anyid && ($type == "CONVENTIONAL") } \
			{
			# Bank is not trunked but it has at one talk
			# group ID.

			puts stderr "Error: Conventional bank $bn contains a talk group"
			set m "Bank $bn"
			append msg "\nError: $m"
			append msg "\nA Conventional type bank "
			append msg "cannot contain a talk group ID."

			set code -1
			incr nerror 
			if {$nerror > 5} {break}
			}
	
		}


	append Emsg $msg
	return $code
}

###################################################################
# Check a frequency for validity.
# Append the error or warning message to a global string.
#
# Returns:
#	0
#	warning
#	error
###################################################################
proc ValidateFreq {f m} \
{
	global Emsg
	global GlobalParam

	set code 0
	set msg ""

	if {( ($f != "") && ($f != 0.0) ) \
		&& (($f < .1000) || ($f > 1300.0))} \
		{
		append msg "\nError: $m frequency ($f) is out"
		append msg " of range.\n"
		set code error
		} \
	elseif {($f > 0) && ([Freq2Band $f] < 0)} \
		{
		append msg "\nError: $m frequency ($f) is out"
		append msg " of range.\n"
		set code error
		}


	append Emsg $msg
	return $code
}


###################################################################
# Return 1 if a string consists of 2 hex digits.
###################################################################
proc IsHex { s } \
{
	# Check for non-digit and non decimal point chars.
	set rc [regexp -nocase {^[0-9a-f][0-9a-f]$} $s]
	if {$rc} \
		{
		return 1
		} \
	else \
		{
		return 0
		}
}

###################################################################
# Check a mode for validity.
# Append the error message to a global string.
#
# Returns:
#	0
#	warning
#	error
###################################################################
proc ValidateMode {mode m} \
{
	global Emsg
	global Mode

	set code 0

	if { [info exists Mode($mode)] == 0} \
		{
		append Emsg "\nError: $m mode ($mode) is invalid.\n"
		set code error
		} 

	return $code
}

###################################################################
# Set title of the main window so it contains the
# current template file name.
###################################################################
proc SetWinTitle { } \
{
	global GlobalParam

	if { ( [info exists GlobalParam(TemplateFilename)] == 0 ) \
		|| ($GlobalParam(TemplateFilename) == "") } \
		{
		set filename untitled.spg
		} \
	else \
		{
		set filename $GlobalParam(TemplateFilename)
		}

	set s [format "%s - tk92" $filename]
	wm title . $s

	return
}


# Prevent user from shrinking or expanding window.

proc FixSize { w } \
{
	wm minsize $w [winfo width $w] [winfo height $w]
	wm maxsize $w [winfo width $w] [winfo height $w]

	return
}



######################################################################
#					Bob Parnass
#					DATE:
#
# USAGE:	SortaBank first last
#
# INPUTS:
#		first	-starting channel to sort
#		last	-ending channel to sort
#
# RETURNS:
#		0	-ok
#		-1	-error
#
#
# PURPOSE:	Sort a range of memory channels based on frequency.
#
# DESCRIPTION:
#
######################################################################
proc SortaBank { first last } \
{
	global GlobalParam

	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemLockout
	global MemMode
	global MemPL
	global MemUnused

	global Mimage


	if {[info exists Mimage] == 0} \
		{
		set msg "You must open a template file\n"
		append msg " or read an image from the radio\n"
		append msg " before sorting channels.\n"

		tk_dialog .belch "tk92" \
			$msg info 0 OK
		return -1
		}

	if {$GlobalParam(SortType) == "freq"} \
		{
		set inlist [Bank2List MemFreq $first $last]
		set vorder [SortFreqList $inlist]
		} \
	else \
		{
		set inlist [Bank2List MemLabel $first $last]
		set vorder [SortLabelList $inlist]
		}


	set inlist [Bank2List MemFreq $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemFreq($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemMode $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemMode($i) [lindex $slist $j]
		if {$MemMode($i) == ""} \
			{
			set MemMode($i) FM
			}
		}

	set inlist [Bank2List MemLabel $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemLabel($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemLockout $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemLockout($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemAtten $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemAtten($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemPL $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemPL($i) [lindex $slist $j]
		}


	set inlist [Bank2List MemDelay $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemDelay($i) [lindex $slist $j]
		}


	set inlist [Bank2List MemAtten $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemAtten($i) [lindex $slist $j]
		}

	set inlist [Bank2List MemUnused $first $last]
	set slist [ReorderList $inlist $vorder]
	for {set i $first; set j 0} {$i <= $last} {incr i; incr j} \
		{
		set MemUnused($i) [lindex $slist $j]
		}

	return 0
}


###################################################################
#
# Clear all memory channels by zeroing the proper arrays,
# but confirm this with the user first.
#
###################################################################
proc ClearAllChannels { } \
{
	global Cht
	global GlobalParam
	global Mimage


	global NBanks
	global NChanPerBank
	global VNChanPerBank

	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0)} \
		{
		# No image to write.
		set msg "You must first read template data from"
		append msg " the radio or open a file before"
		append msg " clearing memories."

		tk_dialog .error "Clear all channels" $msg error 0 OK
		return
		}


	set msg "Warning: This operation will clear all "
	append msg "memory channels."

	set result [tk_dialog .clearall "Warning" \
		$msg warning 0 Cancel "Clear Memories" ]

	if {$result == 0} {return}


	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		set ch [expr {$bn * $VNChanPerBank}]
		for {set i 0} {$i < $NChanPerBank} {incr i} \
			{
			ZapChannel $ch
			incr ch
			}
		}
	return

}


###################################################################
#
# Clear all talk groups by zeroing the proper arrays,
# but confirm this with the user first.
#
###################################################################
proc ClearAllTG { } \
{
	global GlobalParam
	global Mimage
	global NBanks
	global TalkGroup
	global TGt


	if { ([info exists Mimage] == 0) \
		|| ([string length $Mimage] <= 0)} \
		{
		# No image to write.
		set msg "You must first read template data from"
		append msg " the radio or open a file before"
		append msg " clearing talk groups."

		tk_dialog .error "Clear all talk groups" \
			$msg error 0 OK
		return
		}


	set msg "Warning: This operation will clear all "
	append msg "talk groups in all banks."

	set result [tk_dialog .clearall "Warning" \
		$msg warning 0 Cancel "Clear Talk Groups" ]

	if {$result == 0} {return}


	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		for {set i 0} {$i < 100} {incr i} \
			{
			set TalkGroup($bn,$i,group) ""
			set TalkGroup($bn,$i,lockout) 0
			set TalkGroup($bn,$i,label) ""
			}
		}
	# ShowTG $TGt
	return

}

###################################################################
# Decode a 2-byte PL or DPL code into an ascii string
###################################################################

proc DecodePL { s } \
{
	global RPLGroup

	set b [string index $s 0]
	set n [Char2Int $b]

	set b [string index $s 1]
	set group [Char2Int $b]

	set plcode ""
	if {$group == 0} \
		{
		# DPL
		if {$n > 0} \
			{
			# e.g., D054
			set plcode [format "D%03o" $n]
			}
		} \
	elseif {$group == 1} \
		{
		# DPL
		incr n 256
		# e.g., D721
		set plcode [format "D%03o" $n]
		} \
	elseif { ($group >= 2) && ($group <= 9) } \
		{
		# PL
		set plcode [ expr { ($n * .1) + $RPLGroup($group)} ]
		}

	return $plcode
}

###################################################################
# Encode a PL or DPL code into a 2 byte string
#
# INPUTS:
#	s	-PL or DPL, e.g., 141.3 or D023
#
# RETURNS:
#	2-byte string containing PL or DPL code
#		or
#	empty string upon error
###################################################################

proc EncodePL { s } \
{
	global Ctcss
	global RPLGroup

	set zilch [binary format "H2H2" 00 00]

	if { $s == "" } \
		{
		set bytes $zilch
		# puts stderr "EncodePL: no PL/DPL"
		} \
	else \
		{
		set rc [regexp {^[dD][0-7][0-7][0-7]$} $s]
		if {$rc} \
			{
			# Looks like a DPL code.
			set group 0
	
			# Strip the leading d
			set amt [string range $s 1 end]
	
			# DPL is octal, so convert it to decimal
			scan $amt "%o" damt
	
			if {$damt < 256} \
				{
				set group 0
				} \
			else \
				{
				set damt [expr {$damt - 256}]
				set group 1
				}
				
			set hamt [format "%02x" $damt]
			set hgroup [format "%02x" $group]
	
			set dpl [binary format "H2H2" $hamt $hgroup]
			set bytes $dpl
			} \
		else \
			{
			if {$s != ""} \
				{
				# If pl code is a whole number
				if { [string first "." $s] < 0 } \
					{
					append s .0
					}
				}
			if {[info exists Ctcss($s)] == 0} \
				{
				# Unknown PL string.
				set bytes ""
				puts stderr "EncodePL: unknown PL/DPL $s"
				} \
			else \
				{
		
				# Looks like a valid PL code.
				
				set group $Ctcss($s)
				set nsteps [expr {10 * ($s - $RPLGroup($group))}]
				set nsteps [expr {$nsteps + .5}]
				set nsteps [expr {int($nsteps)}]
		
				set hgroup [format "%02x" $group]
				set hnsteps [format "%02x" $nsteps]
		
				set pl [binary format "H2H2" $hnsteps $hgroup]
				set bytes $pl
				}
			}
		}
	return $bytes
}

###################################################################
# Given a frequency in MHz, return the band number.
#
# Return -1 if frequency is out of range.
#
# Note:
#	The PRO-92 will display an error message when
# you try to access a frequency even a little out of range
# of the factory set limits.  Therefore, this test must be strict.
###################################################################

proc Freq2Band { f } \
{
	if {$f == ""} {set f 0.0}
	if { ($f >= 29) && ($f <= 54) }		{ set band 0 } \
	elseif { ($f >= 108) && ($f < 137) }	{ set band 1 } \
	elseif { ($f >= 137) && ($f <= 174) }	{ set band 2 } \
	elseif { ($f >= 380) && ($f <= 512) }	{ set band 3 } \
	elseif { ($f >= 806) && ($f <= 823.9875) } { set band 4 } \
	elseif { ($f >= 849) && ($f <= 868.9875) } { set band 4 } \
	elseif { ($f >= 894) && ($f <= 960.0) } { set band 4 } \
	else \
		{
		# Frequency out of bounds.
		set band -1
		}

	return $band

}

###################################################################
# Check if the step size is consistent with frequency band.
#
# INPUTS:
#	f	-frequency in MHz
#	step	-step size in kHz (e.g., 12.5)
#
# RETURNS:
#	0	-ok
#	-1	-error
###################################################################

proc ValidateStep { f step } \
{
	set code 0

	set band [Freq2Band $f]

	if {$band < 0} \
		{
		set code -1
		} \
	elseif {($band == 0) || ($band == 2)} \
		{
		if {($step != 5) \
			&& ($step != 10) \
			&& ($step != 15) \
			&& ($step != 20) \
			&& ($step != 25) \
			&& ($step != 30) \
			&& ($step != 50) \
			&& ($step != 100)  } \
			{
			set code -1
			}
		} \
	else \
		{
		if {($step != 12.5) \
			&& ($step != 25) \
			&& ($step != 50) \
			&& ($step != 100) } \
			{
			set code -1
			}
		}

#	puts stderr "f: $f, band: $band, step: $step, code: $code"
	return $code
}



###################################################################
# Check if the priority channel is valid.
#
# INPUTS: none
#
# RETURNS:
#	0	-ok
#	-1	-error
#
# NOTES:
#	Weather channels are 1 - 10
#	Other channels are 0 - 49, 100 - 140, ..., 900 - 949
###################################################################
proc ValidatePriority { } \
{
	global Emsg
	global GlobalParam
	global ImageAddr
	global Mimage
	global MemMode
	global NChanPerBank

	set code 0
	set ch $GlobalParam(PriorityChannel)
	set ch [string trimleft $ch "0"]
	if {$ch == ""} {set ch 0}
	set GlobalParam(PriorityChannel) $ch

	set rc [regexp {^[0-9]*$} $ch]
	if { $rc == 0 } \
		{
		# Bogus priority channel number
		set code -1
		} \
	elseif {$GlobalParam(PriorityMemoryWx) == "wx"} \
		{
		# Parse priority channel.
		# The priority channel is a weather channel.
		if {($ch < 1) || ($ch > 10)} \
			{
			# Bogus priority weather channel
			set code -1
			}
		} \
	elseif {$GlobalParam(PriorityMemoryWx) == "memory"} \
		{
		if { ($ch < 0) || ($ch > 999) } \
			{
			set code -1
			} \
		else \
			{
			set r [expr { fmod($ch, 100) }]
			set r [expr { int($r) }]

			if {$r >= $NChanPerBank} \
				{
				set code -1
				} \
			else \
				{
				if {($MemMode($ch) == "MO") \
					|| ($MemMode($ch) == "ED") \
					|| ($MemMode($ch) == "LT")} \
					{
					# Memory channel cannot
					# be trunked.
					set code -1
					}
				}
			}
		} \
	else \
		{
		# error - Priority is neither wx nor memory.
		set code -1
		}

	if {$code} \
		{
		puts stderr "Bogus priority channel"


		append Emsg "\nError: Priority channel is invalid.\n"

		append Emsg "The Priority channel may be a Weather "
		append Emsg "channel 1 - 10 or a Memory channel.\n\n"
		append Emsg "The Priority channel mode must be FM, AM, "
		append Emsg "PL, or DL."

		}

	return $code
}

###################################################################
# Make a tabbed notebook to hold the settings
# for 10 memory banks.
###################################################################
proc MakeMemoryBankNB { w } \
{
	global NBanks

	tabnotebook_create $w

	for {set i 0} {$i < 10} {incr i} \
		{
		set p [tabnotebook_page $w "Bank $i"]
		set fr $p.f; MakeMBankFrame $fr $i; pack $fr
		}

	pack $w
}

###################################################################
# Make a frame to hold the settings
# for one memory bank.
###################################################################
proc MakeMBankFrame { f bn }\
{
	global EditIDsVisible
	global GlobalParam

	frame $f -relief flat -borderwidth 3

	MakeChanBank $f.b $bn

	set w $f.x
	tabnotebook_create $w

	set p [tabnotebook_page $w "Frequencies"]
	set fr $p.f; MakeChannelsFrame $fr $bn
	pack $fr -side left -fill x -fill y -padx 3 -pady 3

	set p [tabnotebook_page $w "Trunk Settings"]
	set fr $p.f; MakeTrunkInfoFrame $fr $bn
	pack $fr -side left -fill x -fill y -padx 3 -pady 3


	pack $f.b -side left -fill x -fill y -padx 3 -pady 3
	pack $w -side left -fill x -fill y -padx 3 -pady 3


	return $f
}

proc MakeChannelsFrame { f bn } \
{
	frame $f -relief flat -borderwidth 3
	
	MakeMemoryChannelFrame $f.freq $bn
	MakeFillerFrame $f.fill $bn

	pack $f.freq -side left -fill both -padx 3 -pady 3 -expand true
	pack $f.fill -side left -fill both -padx 3 -pady 3 -expand true
	return $f
}

proc MakeTrunkInfoFrame { f bn } \
{
	frame $f -relief flat -borderwidth 3

	# Talk group info
	MakeTGFrame $f.tg $bn

	# Fleet Map info
	MakeFleetMapFrame $f.fm $bn

	MakeFillerFrame $f.fill $bn

	pack $f.tg -side left -fill both -padx 3 -pady 3 -expand true
	pack $f.fm -side left -fill both -padx 3 -pady 3 -expand true
	pack $f.fill -side left -fill both -padx 3 -pady 3 -expand true


	return $f
}

#
#proc MakeOffsetFrame { f bn }\
#{
#	global ChanBank
#
#	frame $f -relief groove -borderwidth 3
#
#	label $f.lab \
#		-text "Offset\n(380 - 512 MHz\nMotorola Trunk\nSystems)" \
#		-borderwidth 3
#
#	tk_optionMenu $f.offsetmenu$bn ChanBank($bn,troffset) \
#		0 12.5 25 50	
#
#	set hint ""
#	append hint "Offets are used for Motorola trunking "
#	append hint "in the 380 - 512 MHz range."
#	balloonhelp_for $f.offsetmenu$bn $hint
#
#	pack $f.lab $f.offsetmenu$bn -side top -pady 3 -padx 3
#
#	return
#}
#

proc MakeFleetMapFrame { f bn }\
{
	global GlobalParam

	frame $f -relief sunken -borderwidth 3
	label $f.lab -text "Motorola Fleet Map" -borderwidth 3
	pack $f.lab -side top -pady 3 -padx 3

	set g $f.g
	frame $g -relief groove -borderwidth 3

	set hint ""
	append hint "For Motorola Type 1 trunked systems, you can "
	append hint "choose from one of 16 preprogrammed fleet maps "
	append hint "or you can define a custom fleet map "
	append hint "using the Block 0 - Block 7 menus below."
	balloonhelp_for $g $hint

	label $g.ldefaultmap -text "Preprogrammed Fleet Map" \
			-borderwidth 3

	tk_optionMenu $g.defaultmap$bn GlobalParam(PreprogrammedMap,$bn) \
		Type2 E1P1 E1P2 E1P3 E1P4 E1P5 E1P6 E1P7 E1P8 \
		E1P9 E1P10 E1P11 E1P12 E1P13 E1P14 E1P15 E1P16

	button $g.settype -text "Apply Preprogrammed Map" -command \
		{ApplyFleetMap [CurrentMBank]}

	grid $g.ldefaultmap -row 0 -column 0 -sticky ew -padx 3
	grid $g.defaultmap$bn -row 5 -column 0 -padx 3
	grid $g.settype -row 10 -column 0 -padx 3


	pack $g -side top -pady 5 -padx 5 -expand true -fill both

	set b $f.b
	frame $b -relief groove -borderwidth 3

	label $b.lcustommap -text "Custom Fleet Map" \
			-borderwidth 5

	grid $b.lcustommap -row 0 -column 0 -columnspan 2 -sticky ew

	for {set i 0} {$i < 8} {incr i} \
		{
		MakeSizeCode $b $bn $i
		}


	set hint ""
	append hint "You can define a custom fleet map "
	append hint "for Motorola Type 1 trunked systems "
	append hint "using the Block 0 - Block 7 menus."
	balloonhelp_for $b $hint

	pack $b -side top -fill x -pady 3 -padx 3 \
		-expand true -fill both


	return
}

proc MakeSizeCode {f bn bl} \
{
	global ChanBank

	set row [expr {$bl + 2}]

	label $f.lab$bl -text "Block $bl" -borderwidth 3

	tk_optionMenu $f.block$bn$bl ChanBank($bn,block$bl) \
		Type2 S1 S2 S3 S4 S5 S6 S7 \
		S8 S9 S10 S11 S12 S13 S14

	grid $f.lab$bl -row $row -column 0
	grid $f.block$bn$bl -row $row -sticky ew -column 1
}

###################################################################
# Create widgets for Talk Groups for a bank. 
###################################################################
proc MakeTGFrame { f bn }\
{

	frame $f -relief sunken -borderwidth 3
	label $f.lab -text "Talk Groups" -borderwidth 3


	pack $f.lab -side top -padx 3 -pady 3

	MakeTGFormatFrame $f.fmt $bn

	pack $f.fmt -side top -padx 3 -pady 3

	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both

	set w [ScrollFormInterior $f.b]

	label $w.id -text "ID" -borderwidth 3
	label $w.lab -text "Label" -borderwidth 3

	for {set i 0} {$i < 100} {incr i} \
		{
		MakeTG $w $bn $i
		update idletasks
		}

	grid $w.id -row 0 -column 20
	grid $w.lab -row 0 -column 30


	return $f
}


###################################################################
# Create one a set of widgets for one skip talk group. 
###################################################################
proc MakeTG { f bn n }\
{
	global TalkGroup
	global GlobalParam

	set row [expr {$n + 2}]

	label $f.lab$bn$n -text "$n" -borderwidth 3

	entry $f.group$bn$n -width 9 \
		-textvariable TalkGroup($bn,$n,group) \
		-background white 

	entry $f.label$bn$n -width 16 \
		-textvariable TalkGroup($bn,$n,label) \
		-background white 


	checkbutton $f.lockout$bn$n -text "L" \
		-variable TalkGroup($bn,$n,lockout) \
		-onvalue 1 \
		-offvalue 0

	grid $f.lab$bn$n -row $row -column 10
	grid $f.group$bn$n -row $row -column 20
	grid $f.label$bn$n -row $row -column 30
	grid $f.lockout$bn$n -row $row -column 40

	return
}

proc MakeSearchBankFrame { f } \
{
	global SearchNB

	frame $f -relief flat -borderwidth 3



	frame $f.b -relief flat -borderwidth 3

	label $f.lab -text "Search Bank Settings" \
		-borderwidth 3

	set h $f.b

	pack $f.lab $f.b \
		-side top -fill both -expand true -padx 3 -pady 3

	set SearchNB $f.banknb
	MakeSearchBankNB $SearchNB

#	pack $fr_search $fr_skip \
#		-side left \
#		-fill both -expand true

	return $f
}


###################################################################
# Make a tabbed notebook to hold the settings
# for 10 search banks.
###################################################################
proc MakeSearchBankNB { w } \
{
	global NBanks

	tabnotebook_create $w

	for {set i 0} {$i < 10} {incr i} \
		{
		set p [tabnotebook_page $w "Bank $i"]
		set fr $p.f; MakeSBankFrame $fr $i; pack $fr
		}

	pack $w
}

###################################################################
# Make a frame to hold the settings
# for one memory bank.
###################################################################
proc MakeSBankFrame { f bn }\
{
	frame $f -relief flat -borderwidth 3

	set fr_search [MakeSearchSettingsFrame $f.search $bn]

	# Skip frequencies
	set fr_skip [MakeSkipFrame $f.skip $bn]

	pack $f.search -side left -fill x -fill y -padx 3 -pady 3 \
		-expand yes
	pack $f.skip -side left -fill x -fill y -padx 3 -pady 3 \
		-expand yes

	return $f
}


##########################################################
# Import talk groups from a .csv file
##########################################################
proc ImportTG { f }\
{
	global GlobalParam
	global Mimage
	global NBanks
	global TalkGroup


	if {[info exists Mimage] == 0} \
		{
		set msg "You must open a template file\n"
		append msg " or read an image from the radio\n"
		append msg " before importing talk groups.\n"

		tk_dialog .importinfo "tk92" \
			$msg info 0 OK
		return
		}


	set filetypes \
		{
		{"PRO-92 talk group files"     {.csv .txt}     }
		}


	set filename [Mytk_getOpenFile $f \
		$GlobalParam(MemoryFileDir) \
		"Import talk groups" $filetypes]

	if {$filename == ""} then {return ""}

	if [ catch { open $filename "r"} fid] \
		{
		# error
		tk_dialog .error "tk92" \
			"Cannot open file $file" \
			error 0 OK

		return
		} 

	# Read entire .csv file at one time.
	set allchannels [read $fid]
#	for {set bn 0} {$bn < $NBanks} {incr bn} \
#		{
#		for {set i 0} {$i < 100} {incr i} \
#			{
#			set TalkGroup($bn,$i,group) ""
#			set TalkGroup($bn,$i,label) ""
#			set TalkGroup($bn,$i,lockout) 1
#			}
#		}

	set line ""
	set i 0

	# For each line in the .csv file.
	foreach line [split $allchannels "\n" ] \
		{
		update

		incr i
		if { $i > 1 } then\
			{
			# Delete double quote characters.
			regsub -all "\"" $line "" bline
			set line $bline

			if {$line == ""} then {continue}
			
			set msg [ParseTGLine $line]
			if {$msg != ""} \
				{
				set response [ErrorInFile \
					$msg $line $filename]
				if {$response == 0} then {continue} \
				else {ExitApplication}
				}
			}
		}
		
	close $fid

	return
}

proc ParseTGLine {line} \
{
	global TalkGroup
	global Mode


	if {$line == ""} {return error}
	set mlist [split $line ","]

	set n [llength $mlist] 
	set m [ expr {4 - $n} ]

	# Add empty fields to the end of the line
	# if there are too few fields.

	for {set i 0} {$i < $m} {incr i} \
		{
		append line ","
		}

	set mlist [split $line ","]


	set chn [lindex $mlist 0]
	set id [lindex $mlist 1]
	set label [lindex $mlist 2]
	set lockout [lindex $mlist 3]


	if { $chn == "" } \
		{
		return "Invalid channel number $chn."
		}

	set rc [regexp {^[0-9]*$} $chn]
	if {$rc == 0} \
		{
		return "Invalid channel number $chn"
		}

	if { ($chn < 0) || ($chn > 999) } \
		{
		return "Invalid talk group channel $chn."
		}

	set bn [expr {$chn / 100}]
	set bn [expr {int($bn)}]

	set ch [expr {$chn - ($bn * 100)}]

	if {$id == ""} \
		{
		return "Null talk group ID."
		}
	
	# Sanity check talk group ID.
	set rc1 [regexp {^[0-9]*$} $id]
	set rc2 [regexp {^[0-9][0-9][0-9]-[0-9][0-9]$} $id]
	set rc3 [regexp {^[0-9][0-9][0-9][0-9]-[0-9]$} $id]
	set rc4 [regexp {^[0-9][0-9]-[0-9][0-9][0-9]$} $id]
	if {($rc1 == 0) && ($rc2 == 0) && ($rc3 == 0) && ($rc4 == 0)} \
		{
		return "Invalid talk group ID $id"
		}

	if { $lockout == ""} \
		{
		set lockout 0
		} \
	else \
		{
		set lockout 1
		}


	set s [string range $label 0 11]
	set s [string trimright $s " "]
	set s [string range $label 0 11]

	set TalkGroup($bn,$ch,label) $s
	set TalkGroup($bn,$ch,group) $id
	set TalkGroup($bn,$ch,label) $label
	set TalkGroup($bn,$ch,lockout) $lockout

#	puts stderr "bn: $bn, ch: $ch, id: $id"

	return ""
}


##########################################################
# Show talk groups in a window.
##########################################################
proc ShowTG { f }\
{
	global EditIDsVisible
	global GlobalParam
	global NBanks
	global TalkGroup
	global TGb
	global TGvector

	set TGvector ""

	set prevbn -1

	for {set bn 0} {$bn < $NBanks} {incr bn} \
		{
		for {set i 0} {$i < 100} {incr i} \
			{
			if {$bn != $prevbn} \
				{
				set s [format "----- BANK %d --------" $bn]
				lappend TGvector $s
				set prevbn $bn
				}


			set lockout " "
			if {$TalkGroup($bn,$i,lockout)} {set lockout L}
	
			if { ($TalkGroup($bn,$i,group) != "") } \
				{
				set ch [expr {(100 * $bn) + $i}]
				set s [format "%3d %-6s %-1s %-s" \
					$ch \
					$TalkGroup($bn,$i,group) \
					$lockout \
					$TalkGroup($bn,$i,label) ]
				lappend TGvector $s
				}
			}
		}
		
	catch {destroy $f.ltg}
#	puts stderr "ShowTG: TGvector:\n$TGvector"
	set TGb [ List_channels $f.ltg $TGvector 30 ]

	if { [info exists EditIDsVisible] == 0 } \
		{
		# The window for editing talk groups is
		# hidden so we can show a scrolled list
		# of talk groups.
		# We don't want to show both at the same time
		# because the scrolled list cannot
		# reflect changes made within the edit window.

		wm deiconify $f
		}
	$TGb activate 1
	pack $f.ltg -side top


	return
}

###################################################################
# Determine the number of the currently displayed memory bank (0-9).
#
# RETURNS:
#	The number of the currently displayed memory bank (0-9).
#		or
#	-1 if error.
###################################################################
proc CurrentMBank { } \
{
	global MemNB
	global tnInfo

	set page $tnInfo($MemNB-current)

	set rc [regexp {^Bank [0-9]$} $page]
	if {$rc} \
		{
		set bank [string index $page 5]
		} \
	else \
		{
		set bank -1
		}
	return $bank
}


###################################################################
# Determine the number of the currently displayed search bank (0-9).
#
# RETURNS:
#	The number of the currently displayed search bank (0-9).
#		or
#	-1 if error.
###################################################################
proc CurrentSBank { } \
{
	global SearchNB
	global tnInfo

	set page $tnInfo($SearchNB-current)

	set rc [regexp {^Bank [0-9]$} $page]
	if {$rc} \
		{
		set bank [string index $page 5]
		} \
	else \
		{
		set bank -1
		}
	return $bank
}

###################################################################
# Clear the 50 skip frequencies in one search bank.
###################################################################
proc ClearSkipBank { bn } \
{
	global Skip

	if {($bn >= 0) && ($bn <= 9)} \
		{
		
		for {set i 0} {$i < 50} {incr i} \
			{
			set Skip($bn,$i) ""
			}
		}
	return
}


###################################################################
# Set the fleet map for one memory bank.
###################################################################
proc ApplyFleetMap { bn } \
{
	global ChanBank
	global GlobalParam
	global PresetMap

	# set PresetMap(E1P1) [list S11 S11 S11 S11 S11 S11 S11 S11]

	if {$GlobalParam(PreprogrammedMap,$bn) == "Type2"} \
		{
		if {($bn >= 0) && ($bn <= 9)} \
			{
		
			for {set i 0} {$i < 8} {incr i} \
				{
				set ChanBank($bn,block$i) "Type2"
				}
			}
		} \
	else \
		{
		set d $GlobalParam(PreprogrammedMap,$bn)

		for {set i 0} {$i < 8} {incr i} \
			{
			set scode [lindex $PresetMap($d) $i]
			set ChanBank($bn,block$i) $scode
			# puts stderr "bank $bn, i: $i, d: $d, scode: $scode"
			}
		}
	return
}


###################################################################
#
# Permit user to adjust serial port timing settings.
# Create a popup window.
#
###################################################################

proc MakeConfigurePortFrame { } \
{
	global GlobalParam
	global tcl_platform
	global tcl_version

	catch {destroy .timingwin}
	toplevel .timingwin
	wm title .timingwin "Configure serial port"

	set f .timingwin

	set a $f.a
	frame $a -relief flat -borderwidth 3

	label $a.lrtslevel \
		-text "Set RTS pin to +12 VDC" \
		-borderwidth 3
	checkbutton $a.rtslevel -text "" \
		-variable GlobalParam(RTSline) \
		-onvalue "12" -offvalue "-12"

	set hint ""
	append hint "Some cloning cables require +12 VDC on "
	append hint "the RTS pin, but most do not."
	balloonhelp_for $a.lrtslevel $hint
	balloonhelp_for $a.rtslevel $hint

	label $a.lcableechos \
		-text "Read back commands from serial port" \
		-borderwidth 3
	checkbutton $a.cableechos -text "" \
		-variable GlobalParam(CableEchos) \
		-onvalue 1 -offvalue 0

	set hint ""
	append hint "Read back commands if:\n\n"
	append hint "(1) You are using Microsoft Windows, or\n\n"
	append hint "(2) you are using Linux and \n"
	append hint "an RT Systems CT29A cloning cable "
	append hint "with a 3-to-2 conductor adapter.\n"
	balloonhelp_for $a.cableechos $hint
	balloonhelp_for $a.lcableechos $hint

        grid $a.lrtslevel  -row 10 -column 0 -sticky w
        grid $a.rtslevel  -row 10 -column 1 -sticky w
        grid $a.lcableechos  -row 20 -column 0 -sticky w
        grid $a.cableechos  -row 20 -column 1 -sticky w

	pack $a -side top -anchor w -padx 3 -pady 3 -expand true



	set b $f.b
	frame $b -relief groove -borderwidth 3

	pack $b -side top -anchor w -padx 3 -pady 3 -expand true
	
	scale $b.icdelay -from 10 -to 200 \
		-length 4i \
		-tickinterval 20 \
		-label "Inter-character delay" \
		-variable GlobalParam(ICDelay) \
		-resolution 1 \
		-orient horizontal
	$b.icdelay set $GlobalParam(ICDelay)
	


	set hint ""
	append hint "Adjust the Inter-character delay "
	append hint "to obtain a reliable download to your radio. "
	append hint "This value is adjustable to accomodate "
	append hint "a variety of different computers and "
	append hint "operating systems."
	append hint "\n\n"
	append hint "Larger delay values may improve the chances "
	append hint "for success, though the download will take longer."
	balloonhelp_for $b.icdelay $hint


	button $b.resetcomm -text "Reset to default value" -command \
		{
		global GlobalParam
		set GlobalParam(ICDelay) $GlobalParam(ICDelayDefault) 
		}


	pack $b.icdelay -side top -anchor w -padx 3 -pady 3 -expand true
	pack $b.resetcomm -side top -padx 3 -pady 3 -expand true



	pack $b -side top -anchor w -padx 3 -pady 3 -expand true

	button $f.ok -text "OK" -command \
		{
		catch {destroy .timingwin}
		}

	pack $f.ok -side top -padx 3 -pady 3 -expand true

	update
	return
}

###################################################################
# Encode a Motorola Type 1 talk group into 2-byte
# internal format.
#
# INPUTS:
#	sizecode	- size code 0 through 14
#	block
#	bleet
#	subfleet
#
# RETURNS: a string of 2 bytes 
#
###################################################################

proc T12I { sizecode block fleet subfleet } \
{
	global NSubfleets
	global NIds

	set zilch [binary format "H2" 00 00]

	if {($sizecode < 0) || ($sizecode > 14)} \
		{
		# Bogus size code
		puts stderr "Type12Internal: bogus sizecode: $sizecode"
		return $zilch
		}

	set ns [lindex $NSubfleets $sizecode]
	set ni [lindex $NIds $sizecode]

	set val [ expr { ($block * 512) + ($fleet * $ni * $ns) \
		+ ($subfleet * $ni) + ($ni - 1) } ]

	# Separate the ID into 2 bytes
	# The PRO-92 stores the least significant byte first.

	set valmsb [ expr {$val / 256}]
	set valmsb [ expr {int($valmsb)}]
	set vallsb [ expr {$val - ($valmsb * 256)}]


	# Convert to hex.
	set hvalmsb [format "%02x" $valmsb]
	set hvallsb [format "%02x" $vallsb]

#	puts stderr "$hvallsb $hvalmsb"
	set bytes [binary format "H2H2" $hvallsb $hvalmsb]

	return $bytes
}

######################################################################
#					Bob Parnass
#					DATE: Nov. 29, 2002
#
# USAGE:	 Internal2Type1 block s sizecode 
#
# INPUTS:
#		s		-a 2-string to decode
#		block		-block number, 0-7
#		sizecode	-integer size code (1-14)
#
# RETURNS:	string containing talk group id
#
#
# PURPOSE: Decode a 2-byte string into a Motorola Type 1 talk group id
#
# NOTES:
#	The empty string is returned for bogus byte strings
#	or size codes.
#
#	Talk group ID string returned in form BFFF-S if the
#	size code is 1, or BFF-SS otherwise.
#
#	Where B is the block, F is the fleet, and S is the subfleet. 
#
######################################################################

proc Internal2Type1 { s block sizecode } \
{
	global NIds
	global NSubfleets

	set zilch ""

	if {($sizecode < 1) || ($sizecode > 14)} \
		{
		# Bogus size code
		puts stderr "Type12Internal: bogus sizecode: $sizecode"
		return $zilch
		}

	# Convert the 2-byte string into an integer.

	set b0 [string index $s 0]
	set ib0 [Char2Int $b0]
	set b1 [string index $s 1]
	set ib1 [Char2Int $b1]
	set ival [expr {($ib1 * 256) + $ib0}]

	set ns [lindex $NSubfleets $sizecode]
	set ni [lindex $NIds $sizecode]
	set nidsinblock [expr {$ns * $ni}]

	# puts stderr "Internal2Type1: ns: $ns, ni: $ni"

	set maskb [expr {512 - $nidsinblock}]

	# Calculate fleet.

	if {$sizecode <= 11} \
		{
		set fleet [expr {$ival / $nidsinblock}]
		} \
	else \
		{
		set fleet 0
		}


	# Calculate subfleet.
	set tmp [expr { ($ival - $ni + 1 )}]
	set tmp [expr {int(fmod($tmp,$nidsinblock))}]
	
	set subfleet [expr { $tmp / $ni}]

	if {$sizecode == 12} \
		{
		set block [expr {int($ival / 1024)}]
		set block [expr {$block * 2}]
		set block [expr {int(fmod($block,8))}]
		} \
	elseif {$sizecode == 13} \
		{
		set block [expr {int($ival / 2048)}]
		set block [expr {$block * 4}]
		set block [expr {int(fmod($block,8))}]
		} \
	elseif {$sizecode == 14} \
		{
		set block 0
		}

	if {$sizecode == 1} \
		{
		set id [format "%1.1d%3.3d-%1.1d" \
			$block $fleet $subfleet]
		} \
	else \
		{
		set id [format "%1.1d%2.2d-%2.2d" \
			$block $fleet $subfleet]
		}
	# puts stderr "  Internal2Type1: id: $id, block: $block, fleet: $fleet, subfleet: $subfleet, ival= $ival, sizecode: $sizecode"

	return $id
}

###################################################################
#
#
###################################################################


######################################################################
#					Bob Parnass
#					DATE: Nov. 29, 2002
#
# USAGE:	 Type12Internal s bn
#
# INPUTS:
#		s		-talk group ID string in the
#				form BFFF-S or BFF-SS,
#				where B is the block, F is the fleet,
#				and S is the subfleet. 
#
#		bn		-bank 0-9
#
# RETURNS:	2-byte string containing internal format talk group id
#
#
# PURPOSE: Encode a Motorola Type 1 talk group id into 2 bytes.
#
# NOTES:
#	Convert a Type 1 talk group ID string into a 2-byte
#	internal format.
#
#	A string of 2 null byte is returned for bogus IDs.
#
######################################################################

proc Type12Internal { s bn } \
{
	global ChanBank

	set zilch [binary format "H2H2" 00 00]

	set dash [string first "-" $s]

	if {$dash == 4} \
		{
		set bytes $zilch
		# Talk group ID must be of the form: dddd-d,
		# which is really BFFF-S.

		set rc [regexp {^[0-9][0-9][0-9][0-9]-[0-9]$} $s]
		if {$rc} \
			{
			set block [string range $s 0 0]

			set fleet [string range $s 1 3]
			set fleet [string trimleft $fleet "0"]
			if {$fleet == ""} {set fleet 0}

			set subfleet [string range $s 5 5]
			set subfleet [string trimleft $subfleet "0"]
			if {$subfleet == ""} {set subfleet 0}

			set sizecode $ChanBank($bn,block$block)
			set sizecode [string range $sizecode 1 end]

			set bytes [T12I $sizecode $block \
				$fleet $subfleet]
			} \
		else \
			{
			# Bogus talk group ID
			set bytes $zilch
			}
		} \
	elseif {$dash == 3} \
		{
		# Talk group ID must be of the form: ddd-dd
		# which is really BFF-SS.

		set rc [regexp {^[0-9][0-9][0-9]-[0-9][0-9]$} $s]
		if {$rc} \
			{
			set block [string range $s 0 0]

			set fleet [string range $s 1 2]
			set fleet [string trimleft $fleet "0"]
			if {$fleet == ""} {set fleet 0}

			set subfleet [string range $s 4 5]
			set subfleet [string trimleft $subfleet "0"]
			if {$subfleet == ""} {set subfleet 0}

			set sizecode $ChanBank($bn,block$block)
			set sizecode [string range $sizecode 1 end]

			set bytes [T12I $sizecode $block \
				$fleet $subfleet]
			} \
		else \
			{
			# Bogus talk group ID
			set bytes $zilch
			}
		} \
	else \
		{
		# Bogus talk group ID
		# Dash appears in the wrong place, if at all.
		set bytes $zilch
		}

	if {$bytes == ""} \
		{
		# Bogus talk group ID
		puts stderr "Type12Internal: bogus talk group id: $s"
		}

	return $bytes
}



###################################################################
#
# INPUTS:
#		f	-frame to create
#		j	-index number
#
###################################################################
proc MakeFillerFrame { f j }\
{

	frame $f -relief flat -borderwidth 3


	for {set i 0} {$i < 16} {incr i} \
		{
		label $f.filler$j$i -text "-"  -relief flat \
			-borderwidth 6

		grid $f.filler$j$i -row $i -column 0 -sticky ew 
		}

	return $f
}


###################################################################
# Create widgets for memory channels for a bank. 
###################################################################
proc MakeMemoryChannelFrame { f bn }\
{
	global NBanks
	global NChanPerBank
	global VNChanPerBank

	frame $f -relief flat -borderwidth 3
	label $f.lab -text "Memory Channels" -borderwidth 3

	pack $f.lab -side top


	ScrollformCreate $f.b
	pack $f.b -expand yes -fill both

	set w [ScrollFormInterior $f.b]


	label $w.unused -text "Unused" -borderwidth 3
	label $w.freq -text "Freq" -borderwidth 3
	label $w.mode -text "Mode" -borderwidth 3
	label $w.label -text "Label" -borderwidth 3
	label $w.pl -text "PL/DPL" -borderwidth 3
	label $w.delay -text "D" -borderwidth 3
	label $w.lockout -text "L" -borderwidth 3
	label $w.atten -text "A" -borderwidth 3

	set hint "Rescan Delay"
	balloonhelp_for $w.delay $hint

	set hint "Lockout"
	balloonhelp_for $w.lockout $hint

	set hint "Attenuator"
	balloonhelp_for $w.atten $hint


	set ch [expr {$bn * $VNChanPerBank}]
	for {set i 0} {$i < $NChanPerBank} {incr i} \
		{
		MakeChannel $w $bn $i $ch
		incr ch
		update idletasks
		}

	grid $w.unused -row 0 -column 10
	grid $w.freq -row 0 -column 20
	grid $w.mode -row 0 -column 30
	grid $w.label -row 0 -column 40
	grid $w.pl -row 0 -column 50
	grid $w.delay -row 0 -column 60
	grid $w.lockout -row 0 -column 70
	grid $w.atten -row 0 -column 80

	return $f
}


###################################################################
# Create one a set of widgets for one channel. 
###################################################################
proc MakeChannel { f bn n ch }\
{
	global ChanNumberRepeat
	global GlobalParam

	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemLockout
	global MemMode
	global MemPL
	global MemUnused

	set row [expr {$n + 2}]

	if {$ChanNumberRepeat == "yes"}\
		{
		set chn $n
		} \
	else \
		{
		set chn $ch
		set chn [PadLeft0 3  $chn]
		}

	label $f.lab$bn$chn -text "$chn" -borderwidth 3

#	radiobutton $f.sel$chn -text "$chn" \
#		-variable GlobalParam(ChannelSelect) \
#		-value "$chn"

	checkbutton $f.unused$bn$chn -text "" \
		-variable MemUnused($ch) \
		-onvalue 1 -offvalue 0 \
		-command "set GlobalParam(ChannelSelect) $ch"

	entry $f.freq$bn$chn -width 12 \
		-textvariable MemFreq($ch) \
		-background white

	bind $f.freq$bn$chn <ButtonRelease-1> \
		{
		# Determine which channel.
		SetChannel %W
		}

	tk_optionMenu $f.modemenu$bn$chn MemMode($ch) \
		FM PL DL AM LT MO ED

	bind $f.modemenu$bn$chn <Select> \
		{
		# Determine which channel.
		set mlist [split %W "."]

		set n [llength $mlist] 
		set x [lindex [split %W "."] end]
		set channel [string range $x 5 end]

		set GlobalParam(ChannelSelect) $channel
		puts stderr "modemenu: %W, channel: $channel"
		}

	entry $f.label$bn$chn -width 16 \
		-textvariable MemLabel($ch) \
		-background white 



	bind $f.label$bn$chn <ButtonRelease-1> \
		{
		# Determine which channel.
		SetChannel %W
		}

	entry $f.pl$bn$chn -width 8 \
		-textvariable MemPL($ch) \
		-background white 


	bind $f.pl$bn$chn <ButtonRelease-1> \
		{
		# Determine which channel.
		SetChannel %W
		}

	checkbutton $f.delay$bn$chn -text "D" \
		-variable MemDelay($ch) \
		-onvalue 1 -offvalue 0 \
		-command "set GlobalParam(ChannelSelect) $ch"

	checkbutton $f.lockout$bn$chn -text "L" \
		-variable MemLockout($ch) \
		-onvalue 1 -offvalue 0 \
		-command "set GlobalParam(ChannelSelect) $ch"

	checkbutton $f.atten$bn$chn -text "A" \
		-variable MemAtten($ch) \
		-onvalue 1 -offvalue 0 \
		-command "set GlobalParam(ChannelSelect) $ch"



	button $f.lower$bn$ch -text "^" \
		-command "MoveChannel $ch [expr {$ch - 1}]"

	button $f.higher$bn$ch -text "v" \
		-command "MoveChannel $ch [expr { $ch + 1}]"

	button $f.insert$bn$ch -text "Insert" \
		-command "InsertChannel $ch"

	button $f.delete$bn$ch -text "Delete" \
		-command "DeleteChannel $ch"


	grid $f.lab$bn$chn -row $row -column 0
	# grid $f.sel$chn -row $row -column 0
	grid $f.unused$bn$chn -row $row -column 10
	grid $f.freq$bn$chn -row $row -column 20
	grid $f.modemenu$bn$chn -row $row -column 30 -sticky ew
	grid $f.label$bn$chn -row $row -column 40 -sticky ew
	grid $f.pl$bn$chn -row $row -column 50 -sticky ew
	grid $f.delay$bn$chn -row $row -column 60 -sticky ew
	grid $f.lockout$bn$chn -row $row -column 70 -sticky ew
	grid $f.atten$bn$chn -row $row -column 80 -sticky ew

	grid $f.lower$bn$ch -row $row -column 110
	grid $f.higher$bn$ch -row $row -column 120
	grid $f.insert$bn$ch -row $row -column 130
	grid $f.delete$bn$ch -row $row -column 140


	return
}

proc SetChannel { s } \
{
	global GlobalParam
	# Determine which channel.
	set mlist [split $s "."]

	set n [llength $mlist] 
	set x [lindex [split $s "."] end]
	set len [string length $x]
	set first [expr {$len - 3}]

	set channel [string range $x $first end]

	# Trim leading zeroes channel.
	set channel [string trimleft $channel "0"]
	if {$channel == ""} {set channel 0}

	set GlobalParam(ChannelSelect) $channel
	# puts stderr "SetChannel: $s, channel: $channel"

	return
}
###################################################################
# Insert a memory channel and move all the higher channels
# in the same bank higher by one channel.  Clear the current
# channel in the bank.
###################################################################
proc InsertChannel { ch } \
{

	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemLockout
	global MemMode
	global MemPL
	global MemUnused

	global NChanPerBank
	global VNChanPerBank

	set bn [expr {int($ch/$VNChanPerBank)}]
	set last [expr {($bn * $VNChanPerBank) + $NChanPerBank - 1}]

	if {($MemFreq($last) != "") \
		&& ($MemFreq($last) > 0) \
		&& $MemUnused($last) } \
		{
		# No room.

		set msg "Channel $last is not empty.\n\n"
		append msg "Please delete channel $last before "
		append msg "inserting a new channel $ch and "
		append msg "moving the existing channels higher."

		tk_dialog .belch "Insert new channel" \
			$msg error 0 OK

		return
		}

	set n [expr {$NChanPerBank - fmod($ch, $VNChanPerBank) - 1}]

	set to $last
	set from $last
	incr from -1

	for {set i 0} {$i < $n} {incr i} \
		{
		# puts stderr "InsertChannel: n: $n, moving channel $from to $to"
		set MemFreq($to) $MemFreq($from)
		set MemMode($to) $MemMode($from)
		set MemLabel($to) $MemLabel($from)
		set MemPL($to) $MemPL($from)
		set MemDelay($to) $MemDelay($from)
		set MemLockout($to) $MemLockout($from)
		set MemAtten($to) $MemAtten($from)
		set MemUnused($to) $MemUnused($from)

		incr from -1
		incr to	-1
		}

	ZapChannel $ch
	set MemUnused($ch) 0

}

###################################################################
# Delete a memory channel and move all the higher channels
# in the same bank to the previous channel.  Clear the last
# channel in the bank.
###################################################################

proc DeleteChannel { ch } \
{

	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemLockout
	global MemMode
	global MemPL
	global MemUnused

	global NChanPerBank
	global VNChanPerBank

	set n [expr {$NChanPerBank - fmod($ch, $VNChanPerBank) - 1}]

	set to $ch
	set from $ch
	incr from

	for {set i 0} {$i < $n} {incr i} \
		{
		# puts stderr "DeleteChannel: moving channel $from to $to"

		set MemFreq($to) $MemFreq($from)
		set MemMode($to) $MemMode($from)
		set MemLabel($to) $MemLabel($from)
		set MemPL($to) $MemPL($from)
		set MemDelay($to) $MemDelay($from)
		set MemLockout($to) $MemLockout($from)
		set MemAtten($to) $MemAtten($from)
		set MemUnused($to) $MemUnused($from)

		incr from	
		incr to	
		}

	set bn [expr {int($ch/$VNChanPerBank)}]
	set last [expr {($bn * $VNChanPerBank) + $NChanPerBank - 1}]

	ZapChannel $last

	return
}


###################################################################
# Swap channel with the next higher channel in the bank.
###################################################################
proc MoveChannel { ch1 ch2 } \
{

	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemLockout
	global MemMode
	global MemPL
	global MemUnused

	global NChanPerBank
	global VNChanPerBank

	set bn [expr {int($ch1/$VNChanPerBank)}]
	set last [expr {($bn * $VNChanPerBank) + $NChanPerBank - 1}]
	set ch1r [expr {int(fmod($ch1,$VNChanPerBank))}]
	set ch2r [expr {int(fmod($ch2,$VNChanPerBank))}]

	if {($ch1 > $last) \
		|| ($ch1 < 0) \
		|| ($ch2 > $last) \
		|| ($ch2 < 0) \
		|| ($ch1r >= $NChanPerBank) \
		|| ($ch2r >= $NChanPerBank) } \
		{

		set msg "Cannot move channel $ch1 to $ch2."

		tk_dialog .belch "Move channel" \
			$msg error 0 OK

		return
		}

	set tmp $MemFreq($ch2)
	set MemFreq($ch2) $MemFreq($ch1)
	set MemFreq($ch1) $tmp

	set tmp $MemMode($ch2)
	set MemMode($ch2) $MemMode($ch1)
	set MemMode($ch1) $tmp

	set tmp $MemLabel($ch2)
	set MemLabel($ch2) $MemLabel($ch1)
	set MemLabel($ch1) $tmp

	set tmp $MemPL($ch2)
	set MemPL($ch2) $MemPL($ch1)
	set MemPL($ch1) $tmp

	set tmp $MemDelay($ch2)
	set MemDelay($ch2) $MemDelay($ch1)
	set MemDelay($ch1) $tmp

	set tmp $MemLockout($ch2)
	set MemLockout($ch2) $MemLockout($ch1)
	set MemLockout($ch1) $tmp

	set tmp $MemAtten($ch2)
	set MemAtten($ch2) $MemAtten($ch1)
	set MemAtten($ch1) $tmp

	set tmp $MemUnused($ch2)
	set MemUnused($ch2) $MemUnused($ch1)
	set MemUnused($ch1) $tmp

	return
}


proc ZapChannel { ch } \
{

	global MemAtten
	global MemDelay
	global MemFreq
	global MemLabel
	global MemLockout
	global MemMode
	global MemPL
	global MemUnused


	set MemFreq($ch) ""
	set MemMode($ch) FM
	set MemLabel($ch) ""
	set MemPL($ch) ""
	set MemDelay($ch) 0
	set MemLockout($ch) 0
	set MemAtten($ch) 0
	set MemUnused($ch) 1

	return
}


###################################################################
# Create widgets for formatting Talk Groups.
###################################################################
proc MakeTGFormatFrame { g bn }\
{
	global GlobalParam

	frame $g -relief groove -borderwidth 3



	label $g.lab -text "EDACS ID Format" -borderwidth 3

	button $g.dec -text "Dec" -command \
		{Convert2Dec [CurrentMBank]}

	button $g.afs -text "AFS" -command \
		{Convert2Afs [CurrentMBank]}


	grid $g.lab -row 0 -column 0 -sticky ew -padx 3 -pady 3
	grid $g.dec -row 0 -column 1 -sticky ew -padx 3 -pady 3
	grid $g.afs -row 0 -column 2 -sticky ew -padx 3 -pady 3



	set hint ""
	append hint "Talk group IDs For EDACS trunked systems may be "
	append hint "represented in either of two different formats:\n"
	append hint "\nDecimal, e.g., 1338 or\n"
	append hint "AFS, e.g., 10-072\n\n"
	append hint "tk92 supports both formats."
	balloonhelp_for $g $hint

	return $g
}

###################################################################
# Convert all the talk group IDs in an EDACS bank to AFS format.
###################################################################
proc Convert2Afs { bn } \
{
	global ChanBank
	global TalkGroup

	if {$ChanBank($bn,type) != "ED"} \
		{
		# puts stderr "bank $bn type: $ChanBank($bn,type)"
		return
		}
	for {set i 0} {$i < 100} {incr i} \
		{
		set id [Dec2Afs $TalkGroup($bn,$i,group)]
		set TalkGroup($bn,$i,group) $id
		}

	return
}


###################################################################
# Convert all the talk group IDs in an EDACS bank to decimal format.
###################################################################
proc Convert2Dec { bn } \
{
	global ChanBank
	global TalkGroup

	if {$ChanBank($bn,type) != "ED"} \
		{
		# puts stderr "bank $bn type: $ChanBank($bn,type)"
		return
		}
	for {set i 0} {$i < 100} {incr i} \
		{
		set id [Afs2Dec $TalkGroup($bn,$i,group)]
		set TalkGroup($bn,$i,group) $id
		}

	return
}

###################################################################
# Convert decimal talk group ID to Agency Fleet Subfleet format.
#
# AFS format:
#	AA-FFS, where
#	agency = 4 bits (2 digits)
#	fleet  = 4 bits (2 digits)
#	subfleet  = 3 bits (1 digit)
#
###################################################################
proc Dec2Afs { id } \
{
	if {$id == ""} {return $id}
	if { [string first "-" $id] >= 0 }  {return $id}

	set agency [expr { int($id / 128) }]
	set fleet [expr { $id - (int(($id / 128)*128)) }]
	set fleet [expr { int($fleet / 8)}]
	set subfleet [expr { int(fmod($id,8)) }]

	set agency [PadLeft0 2  $agency]
	set fleet [PadLeft0 2  $fleet]

	set afs ""
	append afs $agency - $fleet $subfleet

	# puts stderr "id: $id, afs: $afs"

	return $afs
}



###################################################################
# Convert Agency Fleet Subfleet talk group ID to decimal format.
###################################################################
proc Afs2Dec { id } \
{
	if {$id == ""} {return $id}

	set rc [regexp {^[0-9][0-9]-[0-9][0-9][0-9]$} $id]
	if {$rc == 0} {return $id}

	set agency [string range $id 0 1]
	set fleet [string range $id 3 4]
	set subfleet [string range $id 5 5]

	set agency [string trimleft $agency "0"]
	if {$agency == ""} {set agency 0}

	set fleet [string trimleft $fleet "0"]
	if {$fleet == ""} {set fleet 0}
	

	set dec [expr {($agency * 128) + ($fleet * 8) + $subfleet}]

	return $dec
}

###################################################################
#
# Check version of tcl/tk user is running.
# Display a warning message in a popup window if
# he is using tcl/tk version 8.3
#
# He must be running Version 8.4 or later which supports the
# ttycontrol option in the fconfigure command.
#
###################################################################
proc CheckTclVersion { } \
{
	global tcl_version
	global Pgm

	set code 0
	if { [string first $tcl_version "8.3"] == 0 }\
		{
		puts stderr "running 8.3"
		set msg "Warning: You are using an older version "
		append msg "of the tcl/tk software which is "
		append msg "incompatible with some RS232-to-TTL "
		append msg "adapter cables, e.g., those sold by GRE "
		append msg "Blackbag Software, etc.\n\n"
		append msg "See the tk92 downloading page at "
		append msg "downloading http://parnass.com "
		append msg "for instructions about "
		append msg "downloading the latest version of tcl/tk."
		tk_dialog .belch "tcl/tk version problem" \
			$msg warning 0 OK
		set code -1
		}
	return $code

}


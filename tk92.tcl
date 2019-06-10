#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

###################################################################
# This file is part of tk92, a utility program for the
# Radio Shack PRO-92 and PRO-2067 scanning receivers.
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


######################################################################
# NOTES:
#	There are 2 levels of data structures within this
#	program:
#
#	(1) Mimage - a byte string stored in the format read
#		from and written to the PRO-92 radio. 
#
#	(2) Arrays containing memory channel and configuration
#		information.
#
#
#	The memory image Mimage string becomes populated in these
#	scenarios:
#
#		- image data is read from the radio
#		- image data is read from a .spg file
#		- array data is encoded into the image
#			prior to writing the image to the radio
#
#	Some or all of the arrays become populated in these
#	scenarios:
#
#		- by parsing the memory image string
#		- by importing memory channel info from a .csv file
#		- by a user changing widget values in the GUI
#
######################################################################

######################################################################
# Write error messages to stderr if linux/unix, stdout otherwise
######################################################################

proc Tattle { msg } \
{
	global tcl_platform

	 set platform $tcl_platform(os) 
	 switch -glob $platform \
		{
		{[Ll]inux} \
			{
			puts stderr $msg
			}
		{unix} \
			{
			puts stderr $msg
			}
		default \
			{
			puts $msg
			}
		}

	return
}
############################################################
set Version "0.7"

set AboutMsg  "tk92
version $Version

Copyright 2001, 2002, Bob Parnass
Oswego, Illinois
USA
http://parnass.com

Released under the GNU General Public License.

tk92 is a utility program for
Radio Shack PRO-92 and PRO-2067 scanner radios.
This is beta software. If you find a defect,
please report it."

############################################################

# trace variable Sid r {puts stderr "Sid trace trap"}
set Pgm [lindex [split $argv0 "/"] end]
set Lfilename ""

if { [catch {set Libdir $env(tk92)} ] } \
	{
	Tattle "$Pgm: error: Environment variable tk92 must"
	Tattle "be set to the directory containing the library"
	Tattle "files for program $Pgm."
	exit 1
	}

set ScanFlag 0


# Sanity check for the Libdir environment variable.
if {$Libdir == ""}\
	{
	Tattle "$Pgm: error: Environment variable tk92 must"
	Tattle "be set to the directory containing the library"
	Tattle "files for program $Pgm."
	exit 1
	}

source [ file join $Libdir "misclib.tcl" ]
source [ file join $Libdir "mylib.tcl" ]
source [ file join $Libdir "api92.tcl" ]
source [ file join $Libdir "gui92.tcl" ]


SetUp


SetWinTitle

set lst [ InitStuff ]
set Rcfile [ lindex $lst 0 ]
set LabelFile [ lindex $lst 1 ]

FirstTimeCheck $Rcfile

# Set most global variables from configuration file.

PresetGlobals
ReadSetup
OverrideGlobals



set CancelXfer 0

set FileTypes \
	{
	{"PRO-92 data files"           {.csv .txt}     }
	}


# Create graphical widgets.

MakeGui

update idletasks

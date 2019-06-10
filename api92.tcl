###################################################################
# This file is part of tk92, a utility program for the
# Radio Shack PRO-92 and PRO-2067 receivers.
#
#    Copyright (C) 2001, 2002, Bob Parnass
#
# tk92 is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 2 of the License,
# or (at your option) any later version.
#
# tk92 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with tk92; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
# 02111-1307  USA
###################################################################

set Nmessages		828
set BytesPerMessage	32

set NBanks		10
set NChanPerBank	50
set VNChanPerBank	100
set ChanNumberRepeat	no
set HasLabels		yes

set NBytesPerBank	2443
set ImageLength		32773	;# number of bytes in image file

###################################################################
# Starting address (in hexadecimal) for each field in
# the memory image.
###################################################################

set ImageAddr(Header)			00	;# 5 bytes
set ImageAddr(MemoryFreqs)		05	;# to ?
set ImageAddr(MemoryModes)		07	;# right nibble
set ImageAddr(MemoryFlags)		08	;# right nibble
set ImageAddr(MemoryPL)			09	;# 2 bytes long
set ImageAddr(MemoryLabels)		0B	;# 12 bytes long
set ImageAddr(SearchFreqFirst)		389
set ImageAddr(SearchModeFirst)		38b
set ImageAddr(SearchFlags)		38c
set ImageAddr(SearchPL)			38d
set ImageAddr(SearchLabel)		38f
set ImageAddr(SearchFreqSecond)		39b
set ImageAddr(SearchStep)		39d
set ImageAddr(BankLabel)		39e	;# 12 bytes long
set ImageAddr(BankOffset)		3aa	;# 1 byte long
set ImageAddr(BankType)			3ab	;# 1 byte long
set ImageAddr(FleetMap)			3ac	;# 8 bytes long
set ImageAddr(Skip)			3b4	;# 2 bytes each
set ImageAddr(TalkGroupID)		418	;# 2 bytes each
set ImageAddr(TalkGroupLabel)		41a	;# 12 bytes each

set ImageAddr(WxFreqs)			5f73	;# 10 weather chans
set ImageAddr(WxModes)			5f75	;# right nibble
set ImageAddr(WxFlags)			5f76	;# right nibble
set ImageAddr(WxPL)			5f77	;# 2 bytes long
set ImageAddr(WxLabels)			5f79	;# 12 bytes long

set ImageAddr(WelcomeMsg1)		672f
set ImageAddr(WelcomeMsg2)		673b
set ImageAddr(WelcomeMsg3)		6747
set ImageAddr(WelcomeMsg4)		6753
set ImageAddr(Unknown1)			675f
set ImageAddr(LampTimeout)		6760
set ImageAddr(RescanDelayConv)		6761	;#
set ImageAddr(RescanDelayTrunk)		6762	;#
set ImageAddr(Unknown2)			6763	;#
set ImageAddr(RescanDelayMin)		6764	;#
set ImageAddr(Contrast)			6765	;#
set ImageAddr(PriorityCh)		6766	;# 2 bytes
set ImageAddr(SearchTmp)		6768	;# 3 bytes
set ImageAddr(PriorityEnable)		676b	;# 01=on 00=off
set ImageAddr(Unknown3)			676c	;#
set ImageAddr(Unknown4)			676d	;#
set ImageAddr(NSearchBands)		676e	;# 1 byte
set ImageAddr(BeepFreq)			676f	;# 2 bytes
set ImageAddr(MBankLinks)		6771	;# 10 bytes
set ImageAddr(SBankLinks)		677b	;# 10 bytes



##########################################################
# Translation tables
##########################################################

# Fleet Map size codes

set SizeCode(Type2)	0
set SizeCode(S1)	1
set SizeCode(S2)	2
set SizeCode(S3)	3
set SizeCode(S4)	4
set SizeCode(S5)	5
set SizeCode(S6)	6
set SizeCode(S7)	7
set SizeCode(S8)	8
set SizeCode(S9)	9
set SizeCode(S10)	10
set SizeCode(S11)	11

# Preset Fleet Maps

set PresetMap(E1P1) [list S11 S11 S11 S11 S11 S11 S11 S11]
set PresetMap(E1P2) [list S4 S4 S4 S4 S4 S4 S4 S4]
set PresetMap(E1P3) [list S4 S4 S4 S4 S4 S4 S12 Type2]
set PresetMap(E1P4) [list S12 Type1 S4 S4 S4 S4 S4 S4]
set PresetMap(E1P5) [list S4 S4 S12 S4 S4 S4 S4 S4]
set PresetMap(E1P6) [list S3 S10 S4 S4 S12 Type2 S12 Type2]
set PresetMap(E1P7) [list S10 S10 S11 S4 S4 S4 S4 S4]
set PresetMap(E1P8) [list S1 S1 S2 S2 S3 S3 S4 S4]
set PresetMap(E1P9) [list S4 S4 S0 S0 S0 S0 S0 S0]
set PresetMap(E1P10) [list S0 S0 S0 S0 S0 S0 S4 S4]
set PresetMap(E1P11) [list S4 S0 S0 S0 S0 S0 S0 S0]
set PresetMap(E1P12) [list S0 S0 S0 S0 S0 S0 S0 S4]
set PresetMap(E1P13) [list S3 S3 S11 S4 S4 S0 S0 S0]
set PresetMap(E1P14) [list S4 S3 S10 S4 S4 S4 S12 Type2]
set PresetMap(E1P15) [list S4 S4 S4 S11 S11 S0 S12 Type2]
set PresetMap(E1P16) [list S3 S10 S10 S11 S0 S0 S12 Type2]


set NSubfleets [list 0 4 8 8 16 4 8 4 4 4 8 16 16 16 16 0]
set NIds [list 0 1 4 8 32 2 2 4 8 16 16 16 64 128 256 0]


# Memory Channel Bank
set BankType(CONVENTIONAL)	0
set BankType(LT)	4
set BankType(MO)	5
set BankType(ED)	6

set RBankType(0)	CONVENTIONAL
set RBankType(4)	LT
set RBankType(5)	MO
set RBankType(6)	ED

# Trunking offset for Motorola 380 - 512 MHz
set BankOffset(0)	0
set BankOffset(12.5)	1
set BankOffset(25)	2
set BankOffset(50)	3

set RBankOffset(0)	0
set RBankOffset(1)	12.5
set RBankOffset(2)	25
set RBankOffset(3)	50

# Band number
set RBand(0)	29
set RBand(1)	108
set RBand(2)	137
set RBand(3)	380
set RBand(4)	806

set RBandStep(0)	5
set RBandStep(1)	12.5
set RBandStep(2)	5
set RBandStep(3)	12.5
set RBandStep(4)	12.5

# Scan resume condition
set ScanResume(PAUSE)	0
set ScanResume(BUSY)	1
set ScanResume(HOLD)	2

set RScanResume(0)	PAUSE
set RScanResume(1)	BUSY
set RScanResume(2)	HOLD



# PL group encoding breakpoints

set RPLGroup(2) 51.2
set RPLGroup(3) 76.8
set RPLGroup(4) 102.4
set RPLGroup(5) 128.0
set RPLGroup(6) 153.6
set RPLGroup(7) 179.2
set RPLGroup(8) 204.8
set RPLGroup(9) 230.4

# PL (CTCSS) codes (there are 50 codes total)

set Ctcss(67.0)		2
set Ctcss(69.3)		2
set Ctcss(71.9)		2
set Ctcss(74.4)		2
set Ctcss(77.0)		3
set Ctcss(79.7)		3

set Ctcss(82.5)		3
set Ctcss(85.4)		3
set Ctcss(88.5)		3
set Ctcss(91.5)		3
set Ctcss(94.8)		3
set Ctcss(97.4)		3
set Ctcss(100.0)	3
set Ctcss(103.5)	4
set Ctcss(107.2)	4
set Ctcss(110.9)	4

set Ctcss(114.8)	4
set Ctcss(118.8)	4
set Ctcss(123.0)	4
set Ctcss(127.3)	4
set Ctcss(131.8)	5
set Ctcss(136.5)	5
set Ctcss(141.3)	5
set Ctcss(146.2)	5
set Ctcss(151.4)	5
set Ctcss(156.7)	6

set Ctcss(159.8)	6
set Ctcss(162.2)	6
set Ctcss(165.5)	6
set Ctcss(167.9)	6
set Ctcss(171.3)	6
set Ctcss(173.8)	6
set Ctcss(177.3)	6
set Ctcss(179.9)	7
set Ctcss(183.5)	7
set Ctcss(186.2)	7

set Ctcss(189.9)	7
set Ctcss(192.8)	7
set Ctcss(196.6)	7
set Ctcss(199.5)	7
set Ctcss(203.5)	7
set Ctcss(206.5)	8
set Ctcss(210.7)	8
set Ctcss(218.1)	8
set Ctcss(225.7)	8
set Ctcss(229.1)	8

set Ctcss(233.6)	9
set Ctcss(241.8)	9
set Ctcss(250.3)	9
set Ctcss(254.1)	9

# Lamp operation
# Note: RLamp value of 3 has same effect as 2, namely OFF
set RLamp(0)	AUTO
set RLamp(1)	ON
set RLamp(2)	OFF


# Fast Step size

set Fstep(10kHz)	0
set Fstep(100kHz)	1
set Fstep(1MHz)		2
set Fstep(10MHz)	3
set Fstep(100MHz)	4

set RFstep(0)	10kHz
set RFstep(1)	100kHz
set RFstep(2)	1MHz
set RFstep(3)	10MHz
set RFstep(4)	100MHz


set Mode(AM) "0"
set Mode(FM) "1"
set Mode(PL) "2"
set Mode(DL) "3"
set Mode(LT) "4"
set Mode(MO) "5"
set Mode(ED) "6"

set RMode(0) AM
set RMode(1) FM
set RMode(2) PL
set RMode(3) DL
set RMode(4) LT
set RMode(5) MO
set RMode(6) ED


##########################################################
# Open the serial port.
# Notes:
#	This procedure sets the global variable Sid.
#
# Returns:
#	nothing -ok
#	else -exits this program
##########################################################

proc OpenDevice {} \
{
	global Pgm
	global GlobalParam
	global Sid
	global tcl_platform

	set code 0

	 set platform $tcl_platform(platform)
	 switch -glob $platform \
		{
		{unix} \
			{
			if { [catch {open $GlobalParam(Device) "r+"} \
				Sid]} \
				{
				set code -1
				}
			# set Sid [open $GlobalParam(Device) "r+"]
			}
		{macintosh} \
			{
			if { [catch {open $GlobalParam(Device) "r+"} \
				Sid]} \
				{
				set code -1
				}
			}
		{windows} \
			{
			if { [catch {open $GlobalParam(Device) RDWR} \
				Sid]} \
				{
				set code -1
				}
			# set Sid [open $GlobalParam(Device) RDWR]
			}
		default \
			{
			set msg "$Pgm error: Platform $platform not supported."
			Tattle $msg
			tk_dialog .opnerror "tk92 error" \
				$msg error 0 OK
			exit
			}
		}

	if {$code} \
		{
		set msg "Error while trying to open serial port "
		append msg $GlobalParam(Device)
		tk_dialog .opnerror "tk92 error" \
			$msg error 0 OK
		exit
		}


	return
}

##########################################################
#
# Initialize a few global variables.
#
# Return the pathname to a configuration file in the user's
# HOME directory
#
# Returns:
#	list of 2 elements:
#		-name of configuration file
#		-name of label file
#
##########################################################
proc InitStuff { } \
{
	global argv0
	global DisplayFontSize
	global env
	global Home
	global Pgm
	global RootDir
	global tcl_platform


	set platform $tcl_platform(platform)
	switch -glob $platform \
		{
		{unix} \
			{
			set Home $env(HOME)
			set rcfile [format "%s/.tk92rc" $Home]
			set labelfile [format "%s/.tk92la" $Home]

			set DisplayFontSize "Courier 56 bold"
			}
		{macintosh} \
			{

			# Configuration file should be
			# named $HOME/.tk92rc

			# Use forward slashes within Tcl/Tk
			# instead of colons.

			set Home $env(HOME)
			regsub -all {:} $Home "/" Home
			set rcfile [format "%s/.tk92rc" $Home]
			set labelfile [format "%s/.tk92la" $Home]

			# The following font line may need changing.
			set DisplayFontSize "Courier 56 bold"
			}
		{windows} \
			{

			# Configuration file should be
			# named $tk92/tk92.ini
			# Use forward slashes within Tcl/Tk
			# instead of backslashes.

			set Home $env(tk92)
			regsub -all {\\} $Home "/" Home
			set rcfile [format "%s/tk92.ini" $Home]
			set labelfile [format "%s/tk92.lab" $Home]

			set DisplayFontSize "Courier 28 bold"
			}
		default \
			{
			puts "Operating System $platform not supported."
			exit 1
			}
		}
	set Home $env(HOME)
	# set Pgm [string last "/" $argv0]


	set lst [list $rcfile $labelfile]
	return $lst
}

###################################################################
# Disable computer control of radio.
###################################################################
proc DisableCControl { } \
{
	global Sid

	after 500

	close $Sid
	set Sid -1

	return
}


###################################################################
#
# Send "command" to radio.
# Write command to error stream if Debug flag is set.
#
###################################################################
proc SendCmd { Sid cmd } \
{
	global GlobalParam


	if { $GlobalParam(Debug) > 0 } \
		{
		binary scan $cmd "H*" s

		# Insert a space between each pair of hex digits
		# to improve readability.

		regsub -all ".." $s { \0} s
		set msg ""
		set msg [ append msg "---> " $s]
		Tattle $msg
		}

	# Write data to serial port.

	puts -nonewline $Sid $cmd
	flush $Sid

	if { $GlobalParam(Debug) > 0 } \
		{
		# puts stderr "SendCmd: wrote data to radio."
		}
	return
}



###################################################################
# Send a msg to radio in preparation for writing an image
# to the radio.	 Read back msg to clear the IO stream.
#
# Write:
#	50 bytes containing A5
#	Then write a 4 byte string containing:
#		01 98 03 52
#
#
# INPUTS: none
#
# RETURNS:
#	0	-ok
#	-1	-error
#
###################################################################
proc WritePreamble { } \
{
	global GlobalParam
	global Sid

	set code 0

	set cmd ""
	set a5 [binary format "H2" A5]

	for {set i 0} {$i < 50} {incr i} \
		{
		append cmd $a5
		}


	append cmd [binary format "H2H2H2H2" 01 98 03 52 ]


	SendCmd $Sid $cmd


	# Read back the same msg.
	ReadEcho $cmd

	return $code
}


###################################################################
# Send a msg to radio after writing an image
# to the radio.	 Read back msg to clear the IO stream.
#
# String written will be:
#
#	5A
#
#	Inputs: none
#
###################################################################
proc WritePostamble { } \
{
	global GlobalParam
	global Sid

	set code 0
	set cmd ""

	append cmd [binary format "H2" 5A]


	SendCmd $Sid $cmd


	# Read back the same msg.
	ReadEcho $cmd

	return $code
}


###################################################################
# Read a data msg from the serial port.
#
# Returns:
#		The message unless there was an error.
###################################################################
proc ReadMsg { } \
{
	global BytesPerMessage

	set buf [ReadRx $BytesPerMessage]

	return $buf
}

###################################################################
# Read 'n' bytes from the serial port.
#
# Returns:
#		The message unless there was an error.
###################################################################
proc ReadRx { n } \
{
	global GlobalParam
	global Pgm
	global Sid


	set line ""

	if { $GlobalParam(Debug) > 0 } \
		{
		# puts stderr "ReadRx: entered. Going to read $n bytes."
		}

	set msg "$Pgm: ReadRx error: "
	append msg "Error while reading serial port\n"
	append msg "$GlobalParam(Device)\n\n"
	append msg "Aborting."

	for {set i 0} {($i < $n) && (![eof $Sid])} {incr i} \
		{
		if { [catch {read $Sid 1} b]} \
			{
			Tattle $msg
			tk_dialog .readerror "tk92 error" \
				$msg error 0 OK
			DisableCControl
			exit
			}

		# puts stderr "ReadRx: got 1 char"
		set line [append line $b]
		}

	if { $GlobalParam(Debug) > 0 } \
		{
		set msg "<--- "
		binary scan $line "H*" x

		regsub -all ".." $x { \0} x

		set msg [append msg $x]
		Tattle $msg
		}

	set len [string length $line]

	if {$len != $n} \
		{
		# Did not read all the bytes we requested.

		set msg "$Pgm: ReadRx error: "
		append msg "data underrun while reading "
		append msg "serial port "
		append msg "$GlobalParam(Device)\n\n"
		append msg "Aborting. "
		Tattle $msg
		tk_dialog .readerror "tk92 error" \
			$msg error 0 OK
		DisableCControl
		exit
		}
	return $line
}


##########################################################
# Copy memory image to radio
#
# Returns:
#	0	-ok
#	1	-error
##########################################################
proc WriteImage { }\
{
	global BytesPerMessage
	global GlobalParam
	global Mimage
	global Nmessages
	global Sid

	# Create and display progress bar.
	toplevel .pbw
	wm title .pbw "Writing to radio"
	grab set .pbw
	set p [MakeWaitWindow .pbw.g 0 PaleGreen]
	set pc 0
	gauge_value $p $pc
	update

	set db 0

	OpenDevice
	waiter $GlobalParam(ICDelay)

	# Set up the serial port parameters (similar to stty)
	SetSerialP e

	if {[WritePreamble]} \
		{

		# Zap the progress bar.
		grab release .pbw
		catch {destroy .pbw}

		DisableCControl
		return -1
		}

	# Wait some extra time.
	waiter $GlobalParam(ICDelay)
	waiter $GlobalParam(ICDelay)

	# Set up the serial port parameters (similar to stty)
	SetSerialP o


	set bptr 0

	# Skip over the 5 byte header and reverse the rest
	# of the bytes in the memory image.

	set last [ expr {5 + ($Nmessages * $BytesPerMessage) - 1 } ]
	set rimage [string range $Mimage 5 $last ]
	set rimage [ReverseString $rimage]

	set nm [expr {$Nmessages}]
	set totmsgs $nm

	# For each message.
	for {set i 0} {$i < $nm} {incr i} \
		{

		# Copy the next chunk of the image.

		set last [expr {$bptr + $BytesPerMessage - 1}]
		set line [string range $rimage $bptr $last]

		SendCmd $Sid $line
		# ReadRx $BytesPerMessage

#		puts stderr "##### i: $i"
		ReadEcho $line

		incr bptr $BytesPerMessage

		# Update progress bar widget.
		set pc [ expr $i * 100 / $totmsgs ]
		if {$pc >= 100.0} \
			{
			set pc 99
			}
		gauge_value $p $pc

		# Wait a few ms.
		waiter $GlobalParam(ICDelay)
		}



	# Zap the progress bar.
	grab release .pbw
	catch {destroy .pbw}

	# Wait an extra few ms.
	waiter $GlobalParam(ICDelay)

	# Set up the serial port parameters (similar to stty)
	SetSerialP e


	if {[WritePostamble]} \
		{
		DisableCControl
		return -1
		}

	DisableCControl
	return 0
}


##########################################################
# Copy memory image from radio
##########################################################
proc ReadImage { } \
{
	global GlobalParam
	global Mimage
	global Nmessages
	global Sid



	# Create and display progress bar.
	toplevel .pbw
	wm title .pbw "Reading from the radio"
	grab set .pbw
	set p [MakeWaitWindow .pbw.g 0 PaleGreen]
	set pc 0
	gauge_value $p $pc
	update


	set Mimage ""


	OpenDevice

	# Set up the serial port parameters (similar to stty)
	SetSerialP e

	# Command the radio to send memory image.
	SendCloneOut

	set line [ReadRx 50]
	set line [ReadRx 4]

	if {$GlobalParam(CableEchos) == 0} \
		{
		set line [ReadRx 2]
		}


	# Set up the serial port parameters (similar to stty)
	SetSerialP o


	# For each message.
	for {set i 0} {$i < $Nmessages} {incr i} \
		{
		set line [ReadMsg]
		append Mimage $line

		# Update progress bar widget.
		set pc [ expr {$i * 100 / $Nmessages} ]
		if {$pc >= 100.0} \
			{
			set pc 99
			}
		gauge_value $p $pc

		if {[string length $line] == 0} \
			{
			# No more data to read.
			break
			}
		}

	set GlobalParam(NmsgsRead) $i

	# The radio sent the data bytes in reverse order
	# so reverse the string.

	set Mimage [ReverseString $Mimage]

	set s  [binary format "H2H2H2H2H2" 02 00 00 00 00]

	append s $Mimage
	set Mimage $s

	# Pad out to the end with null bytes.
	set nullb [binary format "H2" 00]

	for {set i 0} {$i < 6272} {incr i} \
		{
		append Mimage $nullb
		}

	# Note: The last several messages which don't contain
	# useful info.

	DisableCControl

	# Zap the progress bar.
	grab release .pbw
	destroy .pbw

	return 0
}



###################################################################
# this takes a string and converts the
# first character in it to an integer
#   in the range 0-255
#
# if the string is empty, returns an empty string
###################################################################

proc Char2Int { c } \
{
	set tmp ""

	set n [binary scan $c "c" tmp]

	if { ($n == 1) && ($tmp < 0) } \
		{
		# Force negative number to be positive

		set tmp [expr $tmp + 256]
		}
	return "$tmp"
}


###################################################################
# Calculate the modulo 256 checksum byte for a string by
# summing all the ascii character values, modulo 256.
###################################################################

proc CalcCheckSum { s } \
{

	set len [string length $s]
	set sum 0

	for {set i 0} {$i < $len} {incr i} \
		{
		set tmp [Char2Int [string index $s $i]]
		set sum [expr {$sum + $tmp}]
		}

	set sum [expr $sum % 256]
	return $sum
 }

###################################################################
# Create a string of "n" bytes where each byte is \xff (255 decimal).
###################################################################

proc Padff { n } \
{
	set ffrecd ""
	set byte [binary format "H2" ff]

	for {set i 0} {$i < $n} {incr i} \
		{
		append ffrecd $byte
		}
	return $ffrecd
}


proc DumpBinary { bstring } \
{
	binary scan $bstring "H*" s

	# Insert a space between each pair of hex digits
	# to improve readability.

	regsub -all ".." $s { \0} s
	return $s
}


###################################################################
# Send the radio a command to send memory data to computer.
###################################################################
proc SendCloneOut { } \
{
	global GlobalParam
	global Sid


	set cmd [ binary format "H2" CD ]

	SendCmd $Sid $cmd

	# Read the echo

	ReadEcho $cmd
	return
}


proc ReadEcho { sent } \
{
	global GlobalParam
	global Pgm
	global Sid

	if {$GlobalParam(CableEchos) == 0} {return}

	set len [string length $sent]

	# set echo [ReadRx 1]
	set line [read $Sid $len]


	if { $GlobalParam(Debug) > 0 } \
		{
		set msg "<--- "
		binary scan $line "H*" x

		regsub -all ".." $x { \0} x

		set msg [append msg $x]
		Tattle $msg
		}

	if { [string compare $sent $line] } \
		{
		# Error.
		# We did not read back what we wrote.
    Tattle $sent
    Tattle $line
		set msg "$Pgm: ReadEcho: Error while reading "
		append msg "echo from serial port.\n\n"
		append msg "Aborting."


		Tattle $msg
		tk_dialog .readerror "tk92 error" \
			$msg error 0 OK
		DisableCControl
		exit
		}
	return
}

###################################################################
# Reverse a string
###################################################################

proc ReverseString { s } \
{
	set ns ""
	set len [string length $s]
	set j [expr {$len - 1}]

	for {set i 0} {$i < $len} {incr i} \
		{
		append ns [string index $s $j]
		incr j -1
		}

	return $ns
}

###################################################################
# Set the serial port parameters.
#
# INPUTS:
#	parity	-o or e or n
#
#
#
# NOTES:
#
#	Requires tcl/tk 8.4 or later to support the ttycontrol
#	option on fconfigure.
#
#	In the event of an error, this procedure displays,
#	an error message, closes the serial port, and exits.
#
#
#
# From: Rolf.Schroedter@dlr.de Wed Dec 18 00:44:18 2002
#
# The serial stuff in Windows is indeed more complicated than in  Unix.
# You can see this from the volume of source code.
#
# In Windows the -mode "string" interpretation resets
# all TTY states to their default values.
# A simple workaround for you is to set the baud rate
# first and only then the -ttycontrol. The following should work:
#
#	fconfigure $Sid -buffering none -translation binary  \
#		-blocking 1 \
#		-mode 4800,$parity,8,2 -ttycontrol {DTR 1 RTS 0}
#
# Or even
#	fconfigure $Sid -buffering none -translation binary \
#		-blocking 1
#	fconfigure $id	-mode 4800,$parity,8,2
#	fconfigure $id -ttycontrol {DTR 1 RTS 0}
#
# I'll have a look whether there is a way to correct this for
# future Tcl versions.
# On the other hand setting -mode is an elementary thing
# which reconfigures the UART hardware and should not be
# done during communication.
#
###################################################################
proc SetSerialP { parity } \
{
	global Pgm
	global Sid
	global GlobalParam

	set code 0

	# Set up the serial port parameters (similar to stty)
	if {($GlobalParam(DTRline) < 0) \
		&& ($GlobalParam(RTSline) < 0)} \
		{
		if { [catch {fconfigure $Sid \
			-buffering none \
			-translation binary \
			-handshake none \
			-mode 4800,$parity,8,2 -blocking 1 \
			-ttycontrol {DTR 0 RTS 0} }]} \
			{
			set code -1
			}
		} \
	elseif {($GlobalParam(DTRline) < 0) \
		&& ($GlobalParam(RTSline) > 0)} \
		{
		if { [catch {fconfigure $Sid \
			-buffering none \
			-translation binary \
			-handshake none \
			-mode 4800,$parity,8,2 -blocking 1 \
			-ttycontrol {DTR 0 RTS 1} }]} \
			{
			set code -1
			}
		} \
	elseif {($GlobalParam(DTRline) > 0) \
		&& ($GlobalParam(RTSline) < 0)} \
		{
		if { [catch {fconfigure $Sid \
			-buffering none \
			-translation binary \
			-handshake none \
			-mode 4800,$parity,8,2 -blocking 1 \
			-ttycontrol {DTR 1 RTS 0} }]} \
			{
			set code -1
			}
		} \
	else \
		{
		if { [catch {fconfigure $Sid \
			-buffering none \
			-translation binary \
			-handshake none \
			-mode 4800,$parity,8,2 -blocking 1 \
			-ttycontrol {DTR 1 RTS 1} }]} \
			{
			set code -1
			}
		}

	if {$code} \
		{
		set msg "$Pgm: SetSerialP: Error: "
		append msg "while configuring serial port\n"
		append msg "$GlobalParam(Device).\n\n"
		append msg "Aborting."

		Tattle $msg
		tk_dialog .serialerror "tk92 error" \
			$msg error 0 OK
		DisableCControl
		exit
		}

	waiter $GlobalParam(ICDelay)
	waiter $GlobalParam(ICDelay)
	waiter $GlobalParam(ICDelay)
	waiter $GlobalParam(ICDelay)
	waiter $GlobalParam(ICDelay)
	return
}


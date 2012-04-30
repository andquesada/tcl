#!/usr/bin/tclsh8.4

# Since an IP Address has four dots and those characters are quantifiers, 
# an special character has to be used befoure those dot characters so that
# it can be searched within a Regular Expression
proc ipAddToRegExp { ipAddr } {
	set normalizedIp [string map { \. \\\. } $ipAddr]
	set normalizedIp [string trim $normalizedIp]
	return $normalizedIp
}

proc processShowIp {ip_addr log} {
	set normalizedIp [ipAddToRegExp $ip_addr]
	set regExp [ concat {(^DEFAULT_VLAN.*)} $normalizedIp {(.*$)} ]
	
	if {[regexp -nocase $regExp $log matchVar subMatchVar1 subMatchVar2]} {
		puts "<<$matchVar, $subMatchVar1, $subMatchVar2>>"
	} else {
		puts ":("
	}
}

proc processShowRunningConfig { ipAddr runLog } {
	set normalizedIp [ipAddToRegExp $ipAddr]
	set regExp [ concat {(^.*)} $normalizedIp {(.*$)} ]

	if {[regexp $regExp $runLog matchVar subMatchVar1 subMatchVar2]} {
		puts "<<$matchVar, $subMatchVar1, $subMatchVar2>>"
	} else {
		puts ":("
	}
}

proc processShowLog { ipAddr runLog } {
	set normalizedIp [ipAddToRegExp $ipAddr]
	set regExp [ concat {(^.*)} $normalizedIp {(.*$)} ]
	regsub -all {[ \r\t\n]+} $regExp "" regExp

	if {[regexp $regExp $runLog matchVar subMatchVar1 subMatchVar2]} {
		puts "<<$matchVar, $subMatchVar1, $subMatchVar2>>"
	} else {
		puts ":("
	}
}

proc lineOfChars { lineLength  } {
	set line ""

	for {set i 0} {$i < $lineLength} {incr i} {
		set line [ concat $line\*]
	}

	return $line
}

proc printSurroundedLine { line } {
	set lineLength [string length $line ]
	set lineLength [expr $lineLength + 4]

	set line [concat  \* $line \* ]
	set charLine [lineOfChars $lineLength ]
	puts "$charLine"
	puts $line
	puts "$charLine\n"
}

processShowIp 192.168.10.1 "DEFAULT_VLAN         | Manual     192.168.10.1    255.255.255.0    No    No"
processShowLog 192.168.10.1 "I 01/01/90 00:22:16 00025 ip: DEFAULT_VLAN: ip address 192.168.10.1/24"
processShowRunningConfig 192.168.10.1 "ip address 192.168.10.1 255.255.255.0 " 

printSurroundedLine "Esta es una línea de prueba"

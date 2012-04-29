#!/usr/bin/tclsh8.4

# Since an IP Address has four dots and those characters are quantifiers, 
# an special character has to be used befoure those dot characters so that
# it can be searched within a Regular Expression
proc ipAddToRegExp { ipAddr } {
	set normalizedIp [string map { \. \\\. } $ipAddr]
	return $normalizedIp
}

proc processShowIp {ip_addr log} {
	set normalizedIp [ipAddToRegExp $ip_addr]
	set regExp [ concat {(^DEFAULT_VLAN[ |a-z]+)} $normalizedIp {(.*$)} ]
	
	if {[regexp -nocase $regExp $log matchVar subMatchVar1 subMatchVar2]} {
		puts "<<$matchVar, $subMatchVar1, $subMatchVar2>>"
	} else {
		puts ":("
	}
}

proc procesShowLog { ip_addr log } {
	set normalizedIp [ipAddToRegExp $ip_addr ]
	#set regExp [ concat {(^[a-z0-9 /:_]+address )} ]
	#set regExp [ concat {(^.*address )} {(.*$)} ]
	set regExp [ concat $normalizedIp ]

	if {[regexp -nocase $regExp $log matchVar subMatchVar1 subMatchVar2]} {
		puts "<<$matchVar, $subMatchVar1, $subMatchVar2>>"
	} else {
		puts ":("
	}
}

proc processShowRunningConfig { ipAddr runLog } {
	set n [ipAddToRegExp $ipAddr]
	set reg [ concat {(^.*address )} $n {(.*$)} ]
	
	if {[regexp $reg $runLog m s1 s2]} {
		puts "<<$m, $s1, $s2>>"
	} else {
		puts ":("
	}
}

processShowIp 192.168.10.1 "DEFAULT_VLAN         | Manual     192.168.10.1    255.255.255.0    No    No"
#procesShowLog 192.168.10.1 "I 01/01/90 00:22:16 00025 ip: DEFAULT_VLAN: ip address 192.168.10.1/24"
#processShowRunningConfig 192.168.10.1 "ip address 192.168.10.1 255.255.255.0 " 

#  Slurp up the data file
set fp [open "alu2_tj_syn.v" r]
set file_data [read $fp]
close $fp
set data [split $file_data "\n"]
set i 0
set ip_op_i -1
set start 0
set input 0
set op "\n"
foreach line1 $data {
	set line [string trimleft $line1]
	set data2 [split $line " "]
	set input 0
	set i [expr $i + 1]
	set arr 0
	if { [lindex $data2 0] == "input"} {
		puts "one"
		set ip_op_i -1
		foreach ll $data2 {
			puts "inside 1"
			set ip_op_i [expr $ip_op_i + 1]
			if { $ip_op_i != 0 } {
				puts "inside 2"
				if { [string first ":" $ll]>-1} {
					puts "array"
					set len [string length $ll]
					set p [string range $ll 1 [expr $len - 1]]
					set data3 [split $ll ":"]
					set arr 1
				} else {
					puts "$ll"
					if { [string first "," $ll]>-1 || [string first ";" $ll]>-1} {
						set len_1 [string length $ll]
						set range_1 [string range $ll 0 [expr $len_1 - 2 ]]
						if { $arr == 1 } {
							puts "arr_name"
							append op "input "
							set arr_fin [lindex $data3 0]
							set arr_inn [lindex $data3 1]
							set arr_inn_len [string length $arr_inn]
							set arr_fin_len [string length $arr_fin]
							set range_1_len [string length $range_1]
    						append op "[string range $arr_fin 1 $arr_fin_len] "
							append op "[string trimright $arr_inn "]" ] "
							append op "$range_1 "
							append op "\n"
						} else {
							puts "simple name"
							append op "input "
							append op "$range_1 "
							append op "\n"
						}
					}
				}
			}	
		}
	}
	if { [lindex $data2 0] == "output"} {
		set ip_op_i -1
		foreach ll $data2 {
			set ip_op_i [expr $ip_op_i + 1]
			if { $ip_op_i != 0 } {	
				if { [string first ":" $ll]>-1} {
					set len [string length $ll]
					set p [string range $ll 1 [expr $len - 1]]
					set data 3 [split $line ":"]
					set arr 1
				} else {
					if { [string first "," $ll]>-1 || [string first ";" $ll]>-1} {
						set len_1 [string length $ll]
						set range_1 [string range $ll 0 [expr $len_1 - 2]]
						if { $arr == 1 } {
							append op "output "
							set arr_fin [lindex $data3 1]
							set arr_inn [lindex $data3 0]
    						append op "[string range $arr_fin 1 $arr_fin_len] "
							append op "[string trimright $arr_inn "]" ] "
							append op "$range_1 "
							append op "\n"
						} else {
							append op "output "
							append op "$range_1 "
							append op "\n"
						}
					}
				}
			}	
		}
	}
	if {$i==38} {
		set start 1
		puts "working"
	}
	if {$i==393} { 
		set start 0
		puts "working"
	}
	foreach ll $data2 {
		if {$start == 1} {
			if {[string match "**FFGEN**" $ll]==1} {
				set a [string first "F" $ll]
				set b [string first "N" $ll]
				set p [string range $ll [expr $a] [expr $b]]
				append op "$p"
				append op " "
			} elseif { [string equal "(" $ll]==1} {
				set input 1
			} elseif { [string equal ");" $ll]==1} {
				set input 0
			} elseif { [string first "." $ll]>-1} {
				set a [string first "(" $ll]
				set b [string first ")" $ll]
				set p [string range $ll [expr $a+1] [expr $b-1]]
				append op "$p"
				append op " "
			} else {
				set p $ll
				append op "$p"
				append op " "
			}
			
		}
	}
	if {$i >= 38 && $i <=393} {
		append op "\n"
	}
}
set pp [open "text1.txt" w]
puts $pp $op
close $pp


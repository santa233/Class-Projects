set design [get_attri [current_design] full_name]
set outFp [open ${design}_sizing.rpt w]
set debugFp [open ${design}_debug.rpt w]
#set opLog  [open ${design}_log.rpt w]]

set initialWNS  [ PtWorstSlack clk ]
set initialLeak [ PtLeakPower ]
puts $outFp "Initial slack:\t${initialWNS} ps"
puts $outFp "Initial leakage:\t${initialLeak} W"
puts $outFp "======================================" 

set cellList [get_cell *]
set VtswapCnt 0
set SizeswapCnt 0
set cntr 0

#initialize the map
foreach_in_collection cell $cellList {
	set cellName [get_attri $cell base_name]
	set libcell [get_lib_cells -of_objects $cellName]
	set libcellName [get_attri $libcell base_name]
	if {$libcellName == "ms00f80"} {
		continue
	}
	#if cell not downsizable then....else....
	if { [regexp {[a-z][a-z][0-9][0-9][smf]01} $libcellName] } {
		set mp0_size "skip"
		set mp1_size "skip"
		set mp2_size "skip"
		set mp3_size -1
		set size_flag 0
	} else {
		set size_flag 1
		set libcellNamedown [getNextSizeDown  $libcellName ] 
		set mp0_size $libcellName
		set mp1_size $cellName
		set mp2_size $libcellNamedown
		if { ![info exists leak($libcellName)] } {
			set leak($libcellName) [PtCellLeak $cellName]
		}
		set power_before $leak($libcellName)
		set cellslack [PtCellSlack $cellName]
		size_cell $cellName $libcellNamedown
        	
		if { ![info exists leak($libcellNamedown)] } {
			set leak($libcellNamedown) [PtCellLeak $cellName]
		}
		set power_after $leak($libcellNamedown)
		size_cell $cellName $libcellName
		set deltapow  [expr ($power_after * $power_after - $power_before * $power_before)]
		set mp3_size [expr -($deltapow * $cellslack)]
	}    
	#if cell not downscale then....else....
	if { [regexp {[a-z][a-z][0-9][0-9]s[0-9][0-9]} $libcellName] } {
		set mp0_vt "skip"
		set mp1_vt "skip"
		set mp2_vt "skip"
		set mp3_vt -1
		set vt_flag 0
	} else {
		set vt_flag 1
		set libcellNameVtdown [getNextVtDown  $libcellName ] 
		set mp0_vt $libcellName
		set mp1_vt $cellName
		set mp2_vt $libcellNameVtdown
		if { ![info exists leak($libcellName)] } {
			set leak($libcellName) [PtCellLeak $cellName]
		}
		set power_before $leak($libcellName)
		set cellslack [PtCellSlack $cellName]
		size_cell $cellName $libcellNameVtdown
		if { ![info exists leak($libcellNameVtdown)] } {
			set leak($libcellNameVtdown) [PtCellLeak $cellName]
		}

		set power_after $leak($libcellNameVtdown)
		size_cell $cellName $libcellName
		set deltapow  [expr ($power_after * $power_after - $power_before * $power_before)]
		set mp3_vt [expr -($deltapow * $cellslack)]  
	}
	if {$mp3_vt > $mp3_size} {
		lappend map $mp3_vt
		lappend map $mp2_vt
		lappend map $mp1_vt
		lappend map $mp0_vt
		lappend map 1
		lappend map vt_flag
		lappend map $cell
		set mapapp [lappend mapapp $map]
		incr cntr  
	} else {
		lappend map $mp3_size
		lappend map $mp2_size
		lappend map $mp1_size
		lappend map $mp0_size
		lappend map 0
		lappend map size_flag
		lappend map $cell
		set mapapp [lappend mapapp $map]
		incr cntr 
	}  
	unset map
}
set real_count [incr cntr -1]
set mapapp [lsort -decreasing -real -index 0 $mapapp]
#puts $opLog "done initial"
set ptrcntr1 $real_count
set countforthecellsup 0
set ggg 1
#puts $opLog "start while"
while {$ggg==1} {
	set recordforvtup [lindex $mapapp $ptrcntr1]
	set nameOforiginal_ipvt [lindex $recordforvtup 3]
	set nameOfCell_upvt [lindex $recordforvtup 2]
	set nameOfDown_upvt [lindex $recordforvtup 1]
	set typeofchange [lindex $recordforvtup 4]
	set rcell [lindex $recordforvtup 6]
	if { [regexp {[a-z][a-z][0-9][0-9][sm][0-9][0-9]} $nameOforiginal_ipvt] } { 
	incr countforthecellsup
	set libcellNameVtup [getNextVtUp  $nameOforiginal_ipvt ]
	size_cell $nameOfCell_upvt $nameOforiginal_ipvt]
	set [lindex $recordforvtup 0] $libcellNameVtup
	set [lindex $recordforvtup 1] $nameOfCell_upvt		
	set [lindex $recordforvtup 2] $nameOforiginal_ipvt
	if { ![info exists leak($libcellNameVtup)] } {
		set leak($libcellNameVtup) [PtCellLeak $nameOfCell_upvt]
	}
	set power_before $leak($libcellNameVtup)
	set cellslack [PtCellSlack $nameOfCell_upvt]
	size_cell $nameOfCell_upvt $libcellNameVtdown
	if { ![info exists leak($nameOforiginal_ipvt)] } {
		set leak($nameOforiginal_ipvt) [PtCellLeak $nameOfCell_upvt]
	}

	set power_after $leak($nameOforiginal_ipvt)

	size_cell $nameOfCell_upvt $libcellNameVtup
	set deltapow  [expr ($power_after * $power_after - $power_before * $power_before)]
	set mp3_vt [expr -($deltapow * $cellslack)]
	lappend map $mp3_vt
	lappend map $nameOforiginal_ipvt
	lappend map $nameOfCell_upvt
	lappend map $libcellNameVtup
	lappend map $typeofchange
	lappend map 1
	lappend map $cell
					
	set mapapp [lreplace $mapapp $ptrcntr1 $ptrcntr1 $map]
	unset map
	#set [lindex $mapapp $cntforupvt] $recordforvtup
	}
	incr ptrcntr1 -1
	if {$countforthecellsup > 50 && $ptrcntr1 < $real_count-300} {
		set ggg 0
	} else { 
		set ggg 1
	}
}
			#puts $oplog "end while"	
set mapapp [lsort -decreasing -real -index 0 $mapapp]
			#puts $oplog "end sort"	
set startvalue 0
set index 0
set k 0
set loop $real_count
for {set j 0} {$j <= [expr 2 * $real_count]} {incr j} {

		set record [lindex $mapapp $k]
		if {[lindex $record 5] == 0} {
			continue
		}
		#variables
		set cellName [lindex $record 2]
		set cell [lindex $record 6]
		set libcellNamedown [lindex $record 1]
		set libcellName [lindex $record 3]
		set typeOfChange [lindex $record 4]
		size_cell $cellName $libcellNamedown
		set newWNS [ PtWorstSlack clk ]
		if { $newWNS < 0.0 } {
			size_cell $cellName $libcellName
			lappend temp [lindex $record 0]
			lappend temp [lindex $record 1]
			lappend temp [lindex $record 2]
			lappend temp [lindex $record 3]
			lappend temp [lindex $record 4]
			lappend temp 0
			lappend temp [lindex $record 6]
			set mapapp [lreplace $mapapp $k $k $temp]
			unset temp
			incr loop -1
		} else {
			if {[lindex $record 4] == 1} {
				incr VtswapCnt
				puts $outFp "- cell ${cellName} is swapped to $libcellNamedown"
			} else {
				incr SizeswapCnt
				puts $outFp "- cell ${cellName} is swapped to $libcellNamedown"
			}
			set libcell [get_lib_cells -of_objects $cellName]
			set libcellName [get_attri $libcell base_name]
			if { [regexp {[a-z][a-z][0-9][0-9][smf]01} $libcellName] } {
				set mp0_size "skip"
				set mp1_size "skip"
				set mp2_size "skip"
				set mp3_size -1
				set size_flag 0
			} else {
				set size_flag 1
				set libcellNamedown [getNextSizeDown  $libcellName ] 
				set mp0_size $libcellName
				set mp1_size $cellName
				set mp2_size $libcellNamedown
				if { ![info exists leak($libcellName)] } {
					set leak($libcellName) [PtCellLeak $cellName]
				}
				set power_before $leak($libcellName)
				set cellslack [PtCellSlack $cellName]
				size_cell $cellName $libcellNamedown
				if { ![info exists leak($libcellNamedown)] } {
					set leak($libcellNamedown) [PtCellLeak $cellName]
				}
				set power_after $leak($libcellNamedown)
				size_cell $cellName $libcellName
				set deltapow  [expr ($power_after * $power_after - $power_before * $power_before)]
				set mp3_size [expr -($deltapow * $cellslack)]
			}    
			#if cell not downscale then....else....
			if { [regexp {[a-z][a-z][0-9][0-9]s[0-9][0-9]} $libcellName] } {
				set mp0_vt "skip"
				set mp1_vt "skip"
				set mp2_vt "skip"
				set mp3_vt -1
				set vt_flag 0
			} else {
				set vt_flag 1
				set libcellNameVtdown [getNextVtDown  $libcellName ] 
				set mp0_vt $libcellName
				set mp1_vt $cellName
				set mp2_vt $libcellNameVtdown
				if { ![info exists leak($libcellName)] } {
					set leak($libcellName) [PtCellLeak $cellName]
				}
				set power_before $leak($libcellName)
				set cellslack [PtCellSlack $cellName]
				size_cell $cellName $libcellNameVtdown
				if { ![info exists leak($libcellNameVtdown)] } {
					set leak($libcellNameVtdown) [PtCellLeak $cellName]
				}

				set power_after $leak($libcellNameVtdown)

				size_cell $cellName $libcellName
				set deltapow  [expr ($power_after * $power_after - $power_before * $power_before)]
				set mp3_vt [expr -($deltapow * $cellslack)]  
			}
			if {$mp3_vt > $mp3_size} {
				lappend map $mp3_vt
				lappend map $mp2_vt
				lappend map $mp1_vt
				lappend map $mp0_vt
				lappend map 1
				lappend map vt_flag
				lappend map $cell
				set mapapp [lappend mapapp $map]
			} else {
				lappend map $mp3_size
				lappend map $mp2_size
				lappend map $mp1_size
				lappend map $mp0_size
				lappend map 0
				lappend map size_flag
				lappend map $cell
				set mapapp [lappend mapapp $map]
			}
			set mapapp [lreplace $mapapp $k $k $map]
			unset map
		}
		
		incr index
		incr k
		if {$index >= [expr ( $real_count + 1 ) / 10 - 1]} {
			set k 0
			puts $debugFp  "=======================" 
			puts $debugFp  "$index" 
			puts $debugFp  "=======================" 
			set index 0
			for {set l 0} {$l <= $real_count} {incr l} {
				set record [lindex $mapapp $l]
				if {[lindex $record 5] == 0} {
					continue;
				} else {
					if {[lindex $record 2] == "skip"} {
						lappend map 0
						lappend map [lindex $record 1]
						lappend map [lindex $record 2]
						lappend map [lindex $record 3]
						lappend map [lindex $record 4]
						lappend map 0
					
						lappend map [lindex $record 6]
						set mapapp [lreplace $mapapp $l $l $map]
						unset map
						continue
					}
					set cellName [lindex $record 2]
					set cell [lindex $record 6]
					set libcellNamedown [lindex $record 1]
					set libcellName [lindex $record 3]
					set typeOfChange [lindex $record 4]
					if { ![info exists leak($libcellName)] } {
						set leak($libcellName) [PtCellLeak $cellName]
					}
					set power_before $leak($libcellName)
					if {![string is double $power_before]} {
						puts "$cellName !!!!!!!!!!!!!!!!!!!!!!"
					}
					set cellslack [PtCellSlack $cellName]
					size_cell $cellName $libcellNamedown
					if { ![info exists leak($libcellNamedown)] } {
						set leak($libcellNamedown) [PtCellLeak $cellName]
					}
					set power_after $leak($libcellNamedown)
					size_cell $cellName $libcellName
					set deltapow  [expr ($power_after * $power_after - $power_before * $power_before)]
					set mp3 [expr -($deltapow * $cellslack)]				
					lappend map $mp3
					lappend map [lindex $record 1]
					lappend map [lindex $record 2]
					lappend map [lindex $record 3]
					lappend map [lindex $record 4]
					lappend map 1
					
					lappend map [lindex $record 6]
					
					set mapapp [lreplace $mapapp $l $l $map]
					unset map
				}
				
				
			}
			set mapapp [lsort -decreasing -real -index 0 $mapapp]
			#puts $debugFp  "$mapapp" 
			
		}
		
	
}
set finalWNS  [ PtWorstSlack clk ]
set finalLeak [ PtLeakPower ]
set improvment  [format "%.3f" [expr ( $initialLeak - $finalLeak ) / $initialLeak * 100.0]]
puts $outFp "======================================" 
puts $outFp "Final slack:\t${finalWNS} ps"
puts $outFp "Final leakage:\t${finalLeak} W"
puts $outFp "#Vt cell swaps:\t${VtswapCnt}"
puts $outFp "#Cell size swaps:\t${SizeswapCnt}"
puts $outFp "Leakage improvment\t${improvment} %"

close $outFp    
close $debugFp 
#close $opLog

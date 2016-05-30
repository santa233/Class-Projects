proc PtSwapCell {cell_instance cell_master} {
    set swap_status [swap_cell $cell_instance $cell_master]
    return $swap_status
}

proc PtCellLeak { cell_name } {
    set cell [get_cell $cell_name]
    set power [get_attri $cell leakage_power]
    return $power
}

proc PtLeakPower {} {
    set power [get_attri [current_design] leakage_power]
    return $power
}

proc PtCellSlack { cell_name } {
	  set worst_slack 10000
    foreach_in_collection pin [get_pins -of $cell_name -filter "direction==out"] {
        set rise_slack [get_attribute $pin max_rise_slack] 
        set fall_slack [get_attribute $pin max_fall_slack] 
        if {$rise_slack < $worst_slack} {
            set worst_slack $rise_slack
        }
        if {$fall_slack < $worst_slack} {
            set worst_slack $fall_slack
        }
    }
    return $worst_slack
}

# An example to sort cells based on their slacks
proc sortCells { cell_collection } {
  
    foreach_in_collection cell $cell_collection {
      set_user_attribute $cell CellSlack [PtCellSlack cell]
    }
    set new_collection [sort_collection -descending $cell_collection {CellSlack}]
    return $new_collection
}

proc RecoverTiming { cell_collection } {
    
    foreach_in_collection cell $cell_collection {
      set cellName [get_attri $cell base_name]
      foreach vt {s m f} {
        foreach size {02 03 04 06 08 10 20 40 80} {
          puts "Attempting size $size and Vt $vt for cell $cellName..."
          set libcellName [get_attri $cell ref_name]
          set current_WNS [PtWorstSlack clk]
          
          set newlibcellName [string replace $libcellName 5 6 $size]
          set newlibcellName [string replace $newlibcellName 4 4 $vt]
          size_cell $cellName $newlibcellName
          set new_WNS [PtWorstSlack clk]
          
          if {$new_WNS >= 0} {
            puts "No negative slack!"
            return 1
          }
          
          if {$new_WNS <= $current_WNS} {
            size_cell $cellName $libcellName
            puts "Reverting..."
            break
          }
          
        }
      }
    }
    return 0
}

proc PtCellDelay { cell_name } {
    set pin [get_pins -of $cell_name]
    set max_worst 0 
    set out_arrival 0
    set max_delay 0
    set cell_delay 0
    foreach_in_collection each_pin $pin {
        set pinDirection [get_attri $each_pin direction]
        if {$pinDirection == "out" } {
            set rise_arrival [get_attribute $each_pin max_rise_arrival] 
            set fall_arrival [get_attribute $each_pin max_fall_arrival] 
            if {$rise_arrival > $fall_arrival} {
                set worst_arrival $rise_arrival
            } else {
                set worst_arrival $fall_arrival
            }
            if {$worst_arrival > $out_arrival} {
                set out_arrival $worst_arrival
            }
        }
    }
    #puts "out $out_arrival"
    foreach_in_collection each_pin $pin {
        set pinDirection [get_attri $each_pin direction]
        if {$pinDirection == "in" } {
            set rise_arrival [get_attribute $each_pin max_rise_arrival] 
            if {$rise_arrival == ""} {
                continue 
            }
            set fall_arrival [get_attribute $each_pin max_fall_arrival] 
            if {$fall_arrival == ""} {
                continue 
            }
            if {$rise_arrival > $fall_arrival} {
                set worst_arrival $rise_arrival
            } else {
                set worst_arrival $fall_arrival
            }
            set max_delay [expr $out_arrival - $worst_arrival] 
            if {$max_delay > $cell_delay} {
                set cell_delay $max_delay
            }
        }
    }
    return $cell_delay
}

proc PtWorstSlack { clk_name } {
    set path [get_timing_path -nworst 1 -group $clk_name]
    set path_slack [get_attribute $path slack]
    return $path_slack
}

proc PtGetLibCell { CellName } {  
    set Cell [get_cell $CellName]
    set LibCell [get_lib_cells -of_objects $Cell]
    set LibCellName [get_attri $LibCell base_name]
    return $LibCellName
}

proc PtSizeCell {Cell cell_master} {
  set size_status [size_cell $Cell $cell_master]
  return $size_status
}

proc PtWriteChange { FileName } {
  set cmd "write_changes -format ptsh -out $FileName"
  set status [eval $cmd]
  catch {exec touch $FileName}
  catch {exec echo "current_instance" >> $FileName}
  return $status
}


proc getNextSizeUp { cell } {
    if { [regexp {[a-z][a-z][0-9][0-9][smf]01} $cell]} {
        set newSize [string replace $cell 5 6 02]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]02} $cell]} {
        set newSize [string replace $cell 5 6 03]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]03} $cell]} {
        set newSize [string replace $cell 5 6 04]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]04} $cell]} {
        set newSize [string replace $cell 5 6 06]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]06} $cell]} {
        set newSize [string replace $cell 5 6 08]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]08} $cell]} {
        set newSize [string replace $cell 5 6 10]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]10} $cell]} {
        set newSize [string replace $cell 5 6 20]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]20} $cell]} {
        set newSize [string replace $cell 5 6 40]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]40} $cell]} {
        set newSize [string replace $cell 5 6 80]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]80} $cell]} {
        set newSize [string replace $cell 5 6 80]
        return $newSize
    }
}

proc getNextSizeDown { cell } {
    if { [regexp {[a-z][a-z][0-9][0-9][smf]80} $cell]} {
        set newSize [string replace $cell 5 6 40]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]40} $cell]} {
        set newSize [string replace $cell 5 6 20]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]20} $cell]} {
        set newSize [string replace $cell 5 6 10]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]10} $cell]} {
        set newSize [string replace $cell 5 6 08]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]08} $cell]} {
        set newSize [string replace $cell 5 6 06]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]06} $cell]} {
        set newSize [string replace $cell 5 6 04]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]04} $cell]} {
        set newSize [string replace $cell 5 6 03]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]03} $cell]} {
        set newSize [string replace $cell 5 6 02]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]02} $cell]} {
        set newSize [string replace $cell 5 6 01]
        return $newSize
    }

    if { [regexp {[a-z][a-z][0-9][0-9][smf]01} $cell]} {
	return "skip"
    }
}

proc getNextVtDown { libcellName } {
	if { [regexp {[a-z][a-z][0-9][0-9]f[0-9][0-9]} $libcellName] } { 
	        set newlibcellName [string replace $libcellName 4 4 m]
		return $newlibcellName
	}
	
	if { [regexp {[a-z][a-z][0-9][0-9]m[0-9][0-9]} $libcellName] } { 
        	set newlibcellName [string replace $libcellName 4 4 s]
		return $newlibcellName
	}
	
	if { [regexp {[a-z][a-z][0-9][0-9]s[0-9][0-9]} $libcellName] } { 
		return "skip"
	}

}

proc getNextVtUp { libcellName } {
	if { [regexp {[a-z][a-z][0-9][0-9]m[0-9][0-9]} $libcellName] } { 
        set newlibcellName [string replace $libcellName 4 4 f]
		return $newlibcellName
	}
	
	if { [regexp {[a-z][a-z][0-9][0-9]s[0-9][0-9]} $libcellName] } { 
        set newlibcellName [string replace $libcellName 4 4 m]
		return $newlibcellName
	}
	
	if { [regexp {[a-z][a-z][0-9][0-9]f[0-9][0-9]} $libcellName] } { 
        set newlibcellName $libcellName
		return $newlibcellName
	}

}

proc PtCellFanout { cell_name } {
    set outPin [get_pins -of $cell_name -filter "direction==out"]
    set net [all_connected $outPin]
    if {[sizeof $net] == 0} {
        return 0.0
    }
    return [expr [sizeof [all_connected $net -leaf]]-1]
}

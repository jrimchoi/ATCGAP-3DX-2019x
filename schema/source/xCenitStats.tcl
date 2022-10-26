# @PROGRAM = xCenitStats.tcl

tcl;
eval {

set sTimeStampX [clock format [clock seconds] -format "%a%Y%b%dv%H%M%S"]

proc _elapsedTime { start end } {
  # Procedure to measure the time elapsed.
  # Arguments are two points in time measured in seconds.
  # Use as follows:
  #   set start [clock seconds]
  #   set end   [clock seconds]
  #   _elapsed_time $start $end
 
  set total_seconds [expr $end - $start]
  set _hours [expr int($total_seconds/3600)]
  set _minutes [expr int(($total_seconds % 3600)/60)]
  set _seconds [expr int(($total_seconds % 60))]
  if {$_hours == 1} {set htxt hour} else {set htxt hours}
  if {$_minutes == 1} {set mtxt minute} else {set mtxt minutes}
  if {$_seconds == 1} {set stxt second} else {set stxt seconds}
  if {$_hours == 0} {
    if {$_minutes == 0} {
      return "$_seconds $stxt"
    } else {
      return "$_minutes $mtxt $_seconds $stxt"
    }
  } else {
    return "$_hours $htxt $_minutes $mtxt $_seconds $stxt"
  }
}

set sStart [clock scan "2018-09-21 18:00:00" -format "%Y-%m-%d %H:%M:%S"]
set sEnd   [clock seconds]
set sElapsedTime [_elapsedTime $sStart $sEnd]

set iCurrentCnt  [mql eval expr "count TRUE" on temp query bus "Part" * * where \"originated > 9/20/2018\"]
set iPreviousCnt [mql eval expr "count TRUE" on temp query bus "Part" * * where \"originated < 9/21/2018\"]

set iTotalCnt [expr $iCurrentCnt + $iPreviousCnt]

puts "==============================================================================="
puts "CENIT SAP MIGRATION - CURRENT STATISTICS:"
puts "\tStatistics Report Time: $sTimeStampX"
puts "\tMigration start Time: 2018-09-21 18:00:00"
puts "\tCurrent Elapsed Time: $sElapsedTime"
puts "\tTotal Part Objs current count Report Time: $iTotalCnt"
puts "\tParts imported prior to START TIME: $iPreviousCnt"
puts "\tParts imported during active runtime: $iCurrentCnt"
puts "===============================================================================\n"
}; #~endeval

exit;


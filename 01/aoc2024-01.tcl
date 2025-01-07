# aoc2024-01.tcl
# advent of code 2024 day 1| ed chester
# redone in tcl to find out how painful it is

set input [open [lindex $argv 0] "r"]
set data [read -nonewline $input]
close $input
set lines [split $data \n]

foreach l $lines {
    set cols [regexp -inline -all -- {\d+} $l]
    lappend lc [lindex $cols 0]
    lappend rc [lindex $cols 1]
}

set lc [lsort -integer $lc]
set rc [lsort -integer $rc]

# part 1
set t 0
for {set i 0} {$i < [llength $lc]} {incr i} {
    set d [expr {abs([lindex $lc $i] - [lindex $rc $i])}]
    set t [expr {$t + $d}]
}
puts "Part 1 = $t"

proc incid v {
    global rc
    set c 0
    foreach x $rc { if {$x == $v} { set c [expr {$c + 1}] } }
    return $c
}

set t 0
for {set i 0} {$i < [llength $lc]} {incr i} {
    set k [lindex $lc $i]
    set d [expr {$k * [incid $k] }]
    set t [expr {$t + $d}]
}

puts "Part 2 = $t"

#!/usr/bin/perl

use strict;
use warnings;

my @link_set;  # A two-dimensional array
my $output = ''; # Our final output string - you can print this for redirection 
                 # on the command line, or do something later in the program 
                 # to print it to a file

open FILE, 'parv.SLO.trans.pos'; # change to my filename
while(<FILE>) {
    chomp;
    my @split_line = split(/\t/);
    # If @link_set is empty (i.e. processing first line) or if the position 
    # for the current line is less than 5000 from the start of the current 
    # chunk ($link_set[0][0]), add the array on to the end of our array-of-arrays
    if ( (scalar(@link_set) == 0) or (($split_line[0] - 5000) < $link_set[-1][0])) {
        push(@link_set, [@split_line]);
    } else {
        # The current line is the first line of the next chunk
        # Add the position from the previous line to our output
        # Note I think this is the behavior we want if this happens to be the 
        # last line (i.e. it will 
        $output .= "$link_set[-1][0]\t";
        foreach my $cindex (1..$#{$link_set[0]}) {
            foreach my $rindex (0..$#link_set) {
                # For each column (starting at index 1), iterate through all 
                # the rows and add that to output
                $output .= $link_set[$rindex][$cindex]
            }
            # After iterating through the rows for each column, add a tab
            $output .= "\t";
        }
        $output .= "\n";
        # Add the current line to @link_set
        @link_set = [@split_line];
    }
}
# And add the last chunk to the $output
$output .= "$link_set[-1][0]\t";
foreach my $cindex (1..$#{$link_set[0]}) {
    foreach my $rindex (0..$#link_set) {
        # For each column (starting at index 1), iterate through all 
        # the rows and add that to output
        $output .= $link_set[$rindex][$cindex]
    }
    # After iterating through the rows for each column, add a tab
    $output .= "\t";
}

$output .= "\n";

print $output;


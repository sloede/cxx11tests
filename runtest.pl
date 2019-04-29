#!/usr/bin/env perl

my $LINEWIDTH = 80;
my $COLORIZED = 1;

# Store arguments
my $testname = shift @ARGV;
my $logfile = shift @ARGV;
my @cmds = @ARGV;

# Run test and save results
open F, '> '.$logfile or die 'open $logfile: $!';
my $cmd = join(' ', @cmds)." 2>&1 ";
print F "# Command executed: ";
print F $cmd;
print F "\n";
print F `$cmd`;
my $returncode = $?;
close F;

# Check returncode to set status
my $status, $statustext;
if ($returncode eq 0)
{
  $status = 1;
  $statustext = 'PASS';
}
else
{
  $status = 0;
  $statustext = 'FAIL';
}

# Add coloring if desired
my $use_colors = $COLORIZED;
$use_colors = $ENV{COLORIZED} eq 1 if (defined $ENV{COLORIZED});
if ($use_colors and -t STDIN)
{
  if ($status)
  {
    $statustext = "\033[32m".$statustext."\033[0m";
  }
  else {
    $statustext = "\033[31m".$statustext."\033[0m";
  }
}

# Print status
print "$testname".("."x($LINEWIDTH-length($testname)-6)).$statustext."\n";

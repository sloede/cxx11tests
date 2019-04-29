#!/usr/bin/env perl

package main;

my $root_dir = `pwd | tr -d "\n"`; 
my $src_dir = $root_dir.'/src';
my $m = new MakefileGen($root_dir, $src_dir, 'build', 'cpp', 'g++');
$m->generate();
exit 0;


package MakefileGen;

sub new()
{
  my $super = shift;
  my $root_dir = shift || '.';
  my $src_dir = shift || '.';
  my $build_dir = shift || 'build';
  my $ext = shift || 'cpp';
  my $compiler = shift || 'g++';
  
  # Save arguments and init member variables
  my $this = {
    root_dir => $root_dir,
    build_dir => $build_dir,
    source_dir => $src_dir,
    extension => $ext,
    compiler => $compiler,
    files => [],
    tests => [],
    makefile_header => [],
    makefile_targets => [],
    makefile_footer => [],
  };
  bless($this, $super);
  return $this;
}

sub generate()
{
  my $self = shift;
  $self->clean_build_directory();
  $self->scan_source_directory();
  $self->create_makefile_header();
  $self->create_makefile_targets();
  $self->create_makefile_footer();
  $self->write_makefile();
  print("Done.\n");
}

sub clean_build_directory()
{
  my $self = shift;
  if (-d $self->{build_dir})
  {
    my $cmd = 'rm -Rf '.$self->{build_dir};
    system($cmd);
    print("Existing build directory removed.\n");
  }
}

sub scan_source_directory()
{
  my $self = shift;
  my @f = glob($self->{source_dir}.'/*.'.$self->{extension});
  my $ext = $self->{extension};
  my @t = map { `basename $_ .$ext | tr -d '\n'` } @f;
  $self->{files} = \@f;
  $self->{tests} = \@t;
  print("Source directory scanned for test files.\n");
}

sub create_makefile_header()
{
  my $self = shift;
  $self->{makefile_header} = [];
  # Get configuration options
  my $CXX = $ENV{CXX} || $self->{compiler};
  my $CPPFLAGS = $ENV{CPPFLAGS} || '';
  my $CXXFLAGS = $ENV{CXXFLAGS} || '';

  # Add command that can be used to recreate the same Makefile
  push @{$self->{makefile_header}}, "# Command to regenerate this Makefile:";
  push @{$self->{makefile_header}}, "# CXX=$CXX CPPFLAGS=$CPPFLAGS CXXFLAGS=$CXXFLAGS";
  push @{$self->{makefile_header}}, "";

  # Add directories and executables
  push @{$self->{makefile_header}}, "ROOT := ".$self->{root_dir};
  push @{$self->{makefile_header}}, "SRC := ".$self->{source_dir};
  push @{$self->{makefile_header}}, "BLD := ".$self->{build_dir};
  push @{$self->{makefile_header}}, "RT := \$(ROOT)/runtest.pl";

  # Add compiler executable if specified
  push @{$self->{makefile_header}}, "CXX := $CXX";

  # Add preprocessor flags if specified
  push @{$self->{makefile_header}}, "CPPFLAGS := $CPPFLAGS";

  # Add compilers flags if specified
  push @{$self->{makefile_header}}, "CXXFLAGS := $CXXFLAGS";

  # Enable colors by default
  push @{$self->{makefile_header}}, "export COLORIZED ?= 1";

  print("Makefile header generated.\n");
}

sub create_makefile_targets()
{
  my $self = shift;

  # Add default target
  push @{$self->{makefile_targets}}, "";
  push @{$self->{makefile_targets}}, "# Default target";
  push @{$self->{makefile_targets}}, "all: tests";
  push @{$self->{makefile_targets}}, "";
  push @{$self->{makefile_targets}}, "# Create build directory";
  push @{$self->{makefile_targets}}, "\$(BLD):";
  push @{$self->{makefile_targets}}, "\t\@mkdir -p \$(BLD)";
  push @{$self->{makefile_targets}}, "";
  push @{$self->{makefile_targets}}, "# Run all tests";
  push @{$self->{makefile_targets}}, "tests: ".join(' ', @{$self->{tests}});
  push @{$self->{makefile_targets}}, "";
  push @{$self->{makefile_targets}}, "# Force rebuilding all tests";
  push @{$self->{makefile_targets}}, "force: clean all";

  # Add test targets
  for (my $i = 0; $i < scalar @{$self->{tests}}; $i++)
  {
    my $test = $self->{tests}->[$i];
    my $filename = $self->{files}->[$i];
    push @{$self->{makefile_targets}}, "";
    push @{$self->{makefile_targets}}, "# Build rules for $test";
    push @{$self->{makefile_targets}}, "\$(BLD)/$test.o: \$(SRC)/$test.cpp | \$(BLD)";
    push @{$self->{makefile_targets}}, "\t\@\$(RT) $test \$(BLD)/$test.log \\";
    push @{$self->{makefile_targets}}, "\t\t\$(CXX) -c \$(CPPFLAGS) \$(CXXFLAGS) -o \\";
    push @{$self->{makefile_targets}}, "\t\t\$(BLD)/$test.o \$(SRC)/$test.cpp";
    push @{$self->{makefile_targets}}, "";
    push @{$self->{makefile_targets}}, "$test: \$(BLD)/$test.o";
  }

  # Add additional targets
  push @{$self->{makefile_targets}}, "";
  push @{$self->{makefile_targets}}, "# Phony targets";
  push @{$self->{makefile_targets}}, ".PHONY: all clean distclean help";
  push @{$self->{makefile_targets}}, "";
  push @{$self->{makefile_targets}}, "# Clean up test files";
  push @{$self->{makefile_targets}}, "clean:";
  push @{$self->{makefile_targets}}, "\t\@rm -f \$(BLD)/*.o \$(BLD)/*.log";
  push @{$self->{makefile_targets}}, "";
  push @{$self->{makefile_targets}}, "# Clean up everything";
  push @{$self->{makefile_targets}}, "distclean: clean";
  push @{$self->{makefile_targets}}, "\t\@rm -f Makefile";
  push @{$self->{makefile_targets}}, "";
  push @{$self->{makefile_targets}}, "# Show targets that can be built";
  push @{$self->{makefile_targets}}, "help:";
  push @{$self->{makefile_targets}}, "\t\@echo 'The following targets can be built:'";
  push @{$self->{makefile_targets}}, "\t\@echo '  all (subault)'";
  push @{$self->{makefile_targets}}, "\t\@echo '  tests'";
  push @{$self->{makefile_targets}}, "\t\@echo '  force'";
  push @{$self->{makefile_targets}}, "\t\@echo '  clean'";
  push @{$self->{makefile_targets}}, "\t\@echo '  distclean'";
  push @{$self->{makefile_targets}}, "\t\@echo '  help'";

  foreach my $test (@{$self->{tests}})
  {
    push @{$self->{makefile_targets}}, "\t\@echo '  $test'";
  }
  print("Makefile targets generated.\n");
}

sub create_makefile_footer()
{
  print("Makefile footer generated.\n")
}

sub write_makefile()
{
  my $self = shift;
  
  open F, "> Makefile" or die "open Makefile: $!";
  print F join("\n", @{$self->{makefile_header}});
  print F "\n";
  print F join("\n", @{$self->{makefile_targets}});
  print F "\n";
  print F join("\n", @{$self->{makefile_footer}});
  close F;
  print("Makefile written to disk.\n")
}  

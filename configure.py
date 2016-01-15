#!/usr/bin/env python3

import os
import shlex
import shutil
import sys
import unittest


def main():
    root_dir = os.path.dirname(os.path.realpath(__file__))
    src_dir = os.path.join(root_dir, 'src')
    m = MakefileGen(root_dir, src_dir, 'build', 'cpp', 'g++')
    m.generate()
    return 0


class MakefileGen:
    def __init__(self, root_dir = '.', src_dir='src', build_dir='build',
                 ext='cpp', compiler='g++'):
        # Save arguments
        self.root_dir = root_dir
        self.build_dir = build_dir
        self.source_dir = src_dir
        self.extension = ext
        self.compiler = compiler

        # Init member variables
        self.files = []
        self.tests = []
        self.makefile_header = []
        self.makefile_targets = []
        self.makefile_footer = []

    def generate(self):
        self.clean_build_directory()
        self.scan_source_directory()
        self.create_makefile_header()
        self.create_makefile_targets()
        self.create_makefile_footer()
        self.write_makefile()
        print("Done.")

    def clean_build_directory(self):
        if os.path.isdir(self.build_dir):
            shutil.rmtree(self.build_dir)
        print("Existing build directory removed.")

    def scan_source_directory(self):
        self.files = [f for f in sorted(os.listdir(self.source_dir)) if
                          os.path.splitext(f)[1] == '.' + self.extension]
        self.tests = [x[:-(len(self.extension)+1)] for x in self.files]
        print("Source directory scanned for test files.")

    def create_makefile_header(self):
        self.makefile_header = []

        # Get configuration options
        if 'CXX' in os.environ:
            CXX = os.environ['CXX']
        else:
            CXX = self.compiler
        if 'CPPFLAGS' in os.environ:
            CPPFLAGS = os.environ['CPPFLAGS']
        else:
            CPPFLAGS = ''
        if 'CXXFLAGS' in os.environ:
            CXXFLAGS = os.environ['CXXFLAGS']
        else:
            CXXFLAGS = ''

        # Add command that can be used to recreate the same Makefile
        self.makefile_header.append("# Command to regenerate this Makefile:")
        self.makefile_header.append(
                "# CXX={CXX} CPPFLAGS={CPPFLAGS} CXXFLAGS={CXXFLAGS} ".format(
                        CXX=shlex.quote(CXX),
                        CPPFLAGS=shlex.quote(CPPFLAGS),
                        CXXFLAGS=shlex.quote(CXXFLAGS))
                + sys.argv[0])
        self.makefile_header.append("")

        # Add directories and executables
        self.makefile_header.append("ROOT := {}".format(self.root_dir))
        self.makefile_header.append("SRC := {}".format(self.source_dir))
        self.makefile_header.append("BLD := {}".format(self.build_dir))
        self.makefile_header.append("RT := $(ROOT)/runtest.py")

        # Add compiler executable if specified
        self.makefile_header.append("CXX := {}".format(CXX))

        # Add preprocessor flags if specified
        self.makefile_header.append("CPPFLAGS := {}".format(CPPFLAGS))

        # Add compiler flags if specified
        self.makefile_header.append("CXXFLAGS := {}".format(CXXFLAGS))

        # Enable colors by default
        self.makefile_header.append("export COLORIZED ?= 1")
        
        print("Makefile header generated.")

    def create_makefile_targets(self):
        # Add default target
        self.makefile_targets.append("")
        self.makefile_targets.append("# Default target")
        self.makefile_targets.append("all: tests")
        self.makefile_targets.append("")
        self.makefile_targets.append("# Create build directory")
        self.makefile_targets.append("$(BLD):")
        self.makefile_targets.append("\t@mkdir -p $(BLD)")
        self.makefile_targets.append("")
        self.makefile_targets.append("# Run all tests")
        self.makefile_targets.append("tests: {}".format(' '.join(self.tests)))
        self.makefile_targets.append("")
        self.makefile_targets.append("# Force rebuilding all tests")
        self.makefile_targets.append("force: clean all")

        # Add test targets
        for test, filename in zip(self.tests, self.files):
            self.makefile_targets.append("")
            self.makefile_targets.append("# Build rules for {}".format(test))
            self.makefile_targets.append(
                    "$(BLD)/{t}.o: $(SRC)/{t}.cpp | $(BLD)".format(t=test))
            self.makefile_targets.append(
                    "\t@$(RT) {t} $(BLD)/{t}.log \\".format(t=test))
            self.makefile_targets.append(
                    "\t\t$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) -o \\")
            self.makefile_targets.append(
                    "\t\t$(BLD)/{t}.o $(SRC)/{t}.{e}".format(
                            t=test, e=self.extension))
            self.makefile_targets.append("")
            self.makefile_targets.append("{t}: $(BLD)/{t}.o".format(t=test))

        # Add additional targets
        self.makefile_targets.append("")
        self.makefile_targets.append("# Phony targets")
        self.makefile_targets.append(
                ".PHONY: all clean distclean help")
        self.makefile_targets.append("")
        self.makefile_targets.append("# Clean up test files")
        self.makefile_targets.append("clean:")
        self.makefile_targets.append("\t@rm -f $(BLD)/*.o $(BLD)/*.log")
        self.makefile_targets.append("")
        self.makefile_targets.append("# Clean up everything")
        self.makefile_targets.append("distclean: clean")
        self.makefile_targets.append("\t@rm -f Makefile")
        self.makefile_targets.append("\t@rm -f $(SRC)/runtest.pyc")
        self.makefile_targets.append("")
        self.makefile_targets.append("# Show targets that can be built")
        self.makefile_targets.append("help:")
        self.makefile_targets.append(
                "\t@echo 'The following targets can be built:'")
        self.makefile_targets.append("\t@echo '  all (default)'")
        self.makefile_targets.append("\t@echo '  tests'")
        self.makefile_targets.append("\t@echo '  force'")
        self.makefile_targets.append("\t@echo '  clean'")
        self.makefile_targets.append("\t@echo '  distclean'")
        self.makefile_targets.append("\t@echo '  help'")
        for t in self.tests:
            self.makefile_targets.append("\t@echo '  {}'".format(t))

        print("Makefile targets generated.")

    def create_makefile_footer(self):
        print("Makefile footer generated.")

    def write_makefile(self):
        self.makefile = 'Makefile'
        with open(self.makefile, 'w') as f:
            f.write('\n'.join(self.makefile_header))
            f.write('\n')
            f.write('\n'.join(self.makefile_targets))
            f.write('\n')
            f.write('\n'.join(self.makefile_footer))
            f.write('\n')

        print("Makefile written to disk.")


if __name__ == '__main__':
    sys.exit(main())

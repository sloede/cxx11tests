#!/usr/bin/env python3

LINEWIDTH = 80
COLORIZED = True

import shlex
import subprocess
import sys

def main():
    # Store arguments
    testname = sys.argv[1]
    logfile = sys.argv[2]
    cmds = sys.argv[3:]

    # Run test and save results
    with open(logfile, 'w') as f:
        cmd = ' '.join(map(shlex.quote, cmds))
        f.write("# Command executed: ")
        f.write(cmd)
        f.write('\n')
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT,
                                universal_newlines=True, shell=True)
        out, _ = p.communicate()
        f.write(out)
        returncode = p.returncode

    # Check returncode to set status
    if returncode == 0:
        status = True
        statustext = 'PASS'
    else:
        status = False
        statustext = 'FAIL'

    # Add coloring if desired
    if COLORIZED and sys.stdout.isatty():
        if status:
            statustext = '\033[32m' + statustext + '\033[0m'
        else:
            statustext = '\033[31m' + statustext + '\033[0m'

    # Print status
    print("{t} {d} {s}".format(t=testname,
                               d=(LINEWIDTH-len(testname)-4-2)*'.',
                               s=statustext))

if __name__ == '__main__':
    sys.exit(main())

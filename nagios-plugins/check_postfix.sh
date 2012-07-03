#!/bin/bash

# check_postfix.sh v.1.0
# (c) 2012 - Martin Seener

# This little script checks several default postfix processes and default smtp port
# to run/listen and reports back if both running/not running or processes/ports running
# or not. This ways its easier to start debugging.

# This Version of this script doesn`t require arguments but they can be changed below.

# Known Issues:
#   - none, except that only one Port can be checked

# Configuration START:
# Set postfix`s processes and ports
PROCLIST="qmgr pickup postfix/master"
PORTS="25"
# Configuration END

# Definition: 0 = ALL running, 1 = one or more processes/ports NOT running/listening
PROCSTATE=0
PORTSTATE=0

# The Process-Check-Function
check_processes()
{
	# Go through all processes
	for PROC in `echo "$PROCLIST"`
	do
	   ps aux | grep $PROC | grep -v grep > /dev/null
		if [ $? -eq 0 ] && [ $PROCSTATE -eq 0 ]; then
		PROCSTATE=$PROCSTATE
	   else
		PROCSTATE=1
	   fi
	done
}

# The Ports-Check-Function (actually only one Port is allowed/checked)
check_ports()
{
	netstat -an | grep LISTEN | grep "$PORTS" > /dev/null
	if [ $? -eq 0 ]; then
		PORTSTATE=$PORTSTATE
	else
		PORTSTATE=1
	fi
}

# Execute Checks
check_processes
check_ports

# Generate Output
if [ $PROCSTATE -eq 0 ] && [ $PORTSTATE -eq 0 ]; then
	echo "OK: Checked Processes($PROCLIST) : Checked Ports($PORTS)"
	exit 0
elif [ $PROCSTATE -eq 0 ] && [ $PORTSTATE -ne 0 ]; then
	echo "PORTS CRITICAL: Checked Processes($PROCLIST) : Checked Ports($PORTS)"
	exit 2
elif [ $PROCSTATE -ne 0 ] && [ $PORTSTATE -eq 0 ]; then
	echo "PROCS CRITICAL: Checked Processes($PROCLIST) : Checked Ports($PORTS)"
  exit 2
else
  echo "PROCS and PORTS CRITICAL: Checked Processes($PROCLIST) : Checked Ports($PORTS)"
  exit 2
fi
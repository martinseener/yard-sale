#!/bin/bash

# check_seedbank.sh v.1.0
# (c) 2012 - Martin Seener
# License: OSL-3.0 (http://www.opensource.org/licenses/osl-3.0.php/)

# This little script checks seedbank`s process and default listen port.

# This Version of this script doesn`t require arguments but they can be changed below.

# Known Issues:
#   - none

# Configuration START:
# Set seedbank`s process name and listen port
PROC="seedbank"
PORT="7467"
# Configuration END

# Definition: 0 = ALL running, 1 = process/port NOT running/listening
PROCSTATE=0
PORTSTATE=0

# The Process-Check-Function
check_process()
{
	   ps aux | grep $PROC | grep -v grep > /dev/null
		if [ $? -eq 0 ] && [ $PROCSTATE -eq 0 ]; then
		PROCSTATE=$PROCSTATE
	   else
		PROCSTATE=1
	   fi
}

# The Ports-Check-Function
check_port()
{
	netstat -an | grep LISTEN | grep "$PORT" > /dev/null
	if [ $? -eq 0 ]; then
		PORTSTATE=$PORTSTATE
	else
		PORTSTATE=1
	fi
}

# Execute Checks
check_process
check_port

# Generate Output
if [ $PROCSTATE -eq 0 ] && [ $PORTSTATE -eq 0 ]; then
	echo "OK: Checked Process($PROC) : Checked Port($PORT)"
	exit 0
elif [ $PROCSTATE -eq 0 ] && [ $PORTSTATE -ne 0 ]; then
	echo "PORT CRITICAL: Checked Process($PROC) : Checked Port($PORT)"
	exit 2
elif [ $PROCSTATE -ne 0 ] && [ $PORTSTATE -eq 0 ]; then
  echo "PROC CRITICAL: Checked Process($PROC) : Checked Port($PORT)"
  exit 2
else
  echo "PROC and PORT CRITICAL: Checked Process($PROC) : Checked Port($PORT)"
  exit 2
fi

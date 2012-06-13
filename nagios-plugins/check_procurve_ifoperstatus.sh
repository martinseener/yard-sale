#!/bin/bash

# check_procurve_ifoperstatus.sh v.1.0
# (c) 2012 - Martin Seener

# This Wrapper only works with the "check_snmp" Script from Nagios
# and outputs the Operational State of every defined Switch Port
# whereas 1 is up and everything else will exit the script as CRITICAL

# This Script requires some Arguments: the Hostname/IP of the Switch and the community
# Argument 3 is a list of the Ports to be monitored (comma-separated)
# Ex.: check_procurve_ifoperstate.sh 10.10.10.2 public 1,2,4,8,23,49
# 49 is normally used for the LAG/Trunk

# Known Issues:
#  - none yet

# Locations
# Uncomment next line if its in the same path as this script, or define manually
#SCRIPTPATH=`dirname "$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"`
SCRIPTPATH="/usr/lib/nagios/plugins"
CHECKSNMP=$SCRIPTPATH"/check_snmp"

# Pre-define OID base so you only have to input the port numbers like 1,3,12
# instead of the OID. The Base must end with a dot.
# The OID below is tested with the HP ProCurve 2410G-24
OIDBASE="1.3.6.1.2.1.2.2.1.8."
# Comment out OIDBASE above if you want to use full OIDs instead of only the port numbers
#OIDBASE=""

# Tell us whats the OK State (everything else will be CRITICAL)
CRITTRESH=1

# Nothing more to do here
OVERALLSTATUS=0
PORTSDONE=""
CRITPORTS=""

# Check if all parameters are set
if [ "$1" != "" ] && [ "$2" != "" ] && [ "$3" != "" ]; then
  # We have some so lets start to read the ports into an sorted array
  OIFS=$IFS
  # Internal Field Separator backupped and is now being changed to comma
  IFS=','
  CHECKPORTS=($3)
  # we have the ports sorted in an array, now change IFS back to original
  IFS=$OIFS
  # now we´ll check each port in the array
  CHECKPORTSLENGTH=${#CHECKPORTS[@]}
  for ((i=0; i<${CHECKPORTSLENGTH}; i++))
  do
    if [ "$OIDBASE" != "" ]; then
      $CHECKSNMP -H $1 -C $2 -c $CRITTRESH -o $OIDBASE${CHECKPORTS[$i]} > /dev/null 2>&1
    else
      $CHECKSNMP -H $1 -C $2 -c $CRITTRESH -o ${CHECKPORTS[$i]} > /dev/null 2>&1
		fi
		if [ $? -ne 0 ]; then
      if [ "$OIDBASE" != "" ]; then
        # Ports Status os not "up" or "1" therefore we give out a CRITICAL Warning
        OVERALLSTATUS=2
        if [ ${CHECKPORTS[$i]} == 49 ]; then
          ACTUALPORT="LACP"
        else
          ACTUALPORT=${CHECKPORTS[$i]}
        fi
      else
        OVERALLSTATUS=2
        # Cut the OIDBASE away so we only have the Port
        ACTUALPORT=`echo ${CHECKPORTS[$i]} | rev | cut -d'.' -f1`
        if [ $ACTUALPORT == 49 ]; then
          ACTUALPORT="LACP"
        fi
      fi
      CRITPORTS=$CRITPORTS$ACTUALPORT","
    else
      if [ "$OIDBASE" != "" ]; then
        if [ ${CHECKPORTS[$i]} == 49 ]; then
          ACTUALPORT="LACP"
        else
          ACTUALPORT=${CHECKPORTS[$i]}
        fi
      else
        ACTUALPORT=`echo ${CHECKPORTS[$i]} | rev | cut -d'.' -f1`
        if [ $ACTUALPORT == 49 ]; then
          ACTUALPORT="LACP"
        fi
      fi
      PORTSDONE=$PORTSDONE$ACTUALPORT","
    fi
  done
  # remove trailing comma of PORTSDONE and CRITPORTS
  PORTSDONE=${PORTSDONE%?}
  CRITPORTS=${CRITPORTS%?}
  # we checked all ports - lets put all together - left ports out if all are OK
  case "$OVERALLSTATUS" in
    0)  echo "SNMP OK - Checked Ports("$PORTSDONE")"
        exit 0;;
    2)  echo "SNMP CRITICAL - Critical Ports("$CRITPORTS") OK-Ports("$PORTSDONE")"
        exit 2;;
  esac 
else
  # At least one parameter is missing, aborting as warning
  echo "At least one Parameter is missing! (1:Host/IP 2:Community 3:Ports(comma-sep.))"
  exit 1
fi

# End Script
echo "check_procurve_ifoperstatus exited without something being checked"
exit 1
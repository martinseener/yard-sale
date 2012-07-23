#!/bin/bash

# AutoNFS v.1.0

# Original Script by JeroenHoek at http://ubuntuforums.org/showthread.php?t=1389291
# Modified by Martin Seener - 23rd July 2012 at github.com/martinseener/yard-sale

# Modified to use rpcinfo instead of ping - guarantees that actually the nfs server daemon
# is listening. its more precise than a stupid ping. also added some useful mount options
# for a good stable nfs connection.

# Hints:
#		- "logger" is now disabled by default. uncomment the "logger" lines for debugging only

# The hostname or IP-address of the fileserver:
FILESERVER="mynfsserver"
# Mount Options (see mount man pages for info)
MOUNTOPT="-o rw,hard,intr,tcp,actimeo=3"
# Check every X seconds (60 is a good default):
INTERVAL=60
# The shares that need to be mounted:
MOUNTS=( "/media/music" )

while true; do
        /usr/bin/rpcinfo -t "$FILESERVER" nfs &>/dev/null
        if [ $? -eq 0 ]; then
                # Fileserver is up.
                #logger "Fileserver is up."
                for MOUNT in ${MOUNTS[@]}; do
                        mount | grep -E "^${FILESERVER}:${MOUNT} on .*$" &>/dev/null
                        if [ $? -ne 0 ]; then
                                # NFS mount not mounted, attempt mount
                                #logger "NFS shares not mounted; attempting to mount ${MOUNT}:"
                                mount -t nfs ${MOUNTOPT} ${FILESERVER}:${MOUNT} ${MOUNT}
                        fi
                done
        else
                # Fileserver is down.
                #logger "Fileserver is down."
                for MOUNT in ${MOUNTS[@]}; do
                        mount | grep -E "^${FILESERVER}:${MOUNT} on .*$" &>/dev/null
                        if [ $? -eq 0 ]; then
                                # NFS mount is still mounted; attempt umount
                                #logger "Cannot reach ${FILESERVER}, unmounting NFS share ${MOUNT}."
                                umount -f ${MOUNT}
                        fi
                done
        fi
        sleep $INTERVAL
done
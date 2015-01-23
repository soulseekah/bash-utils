#!/bin/bash

# By default we dump to a directory with the current time
# this can be overridden by setting the UID envvar
DUMPDIR=${DUMPDIR:-"~/.postmortems/$(date +%Y%m%d%H%M%S)"}

# Read PROCESS, SERVICE and LOGFILE envvars
# and do dump, restart and read log respectively
# These can be called separately.

# Dump process memory
if [ ! -z "$PROCESS" ]; then
        mkdir -p $DUMPDIR

        # Coredump processes and threads
        for pid in $(pidof $PROCESS); do
                for tid in $(ls /proc/$pid/task); do
                        gcore -o $DUMPDIR/$PROCESS.$tid.$(date +%Y%m%d%H%M%S).core $tid
                done;
        done;
fi;

# Dump logfiles (can be a space-delimited list of files)
if [ ! -z "$LOGFILE" ]; then
        mkdir -p $DUMPDIR

        for l in $LOGFILE; do
                cp $l $DUMPDIR/$PROCESS.$(date +%Y%m%d%H%M%S).$(basename $l)
        done;
fi;

# Restart service
if [ ! -z "$SERVICE" ]; then
        service $SERVICE restart
fi;

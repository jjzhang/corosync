#!/bin/bash


service corosync status >/dev/null
CS_STATUS=$?

if [ $CS_STATUS -eq 0 ]
then
    # corosync running
    active=$(corosync-cmapctl runtime.connections.active | cut -d= -f2)
    if [ $active -lt 2 ]
    then
        FILES=$(ls /dev/shm/qb-*)
        for f in $FILES
        do
            if [[ "$f" =~ "blackbox" ]]
            then
                true
            else
                echo $f
            fi
        done
    else
        pids=$(corosync-cmapctl runtime.connections. | grep client_pid | cut -d= -f2)

        FILES=$(ls /dev/shm/qb-*)
        for f in $FILES
        do
            found=0
            for p in $pids
            do
                if [[ "$f" =~ "$p" ]]
                then
                    found=1
                elif [[ "$f" =~ "blackbox" ]]
                    found=1
                fi
            done
            if [ $found -eq 0 ]
            then
                echo $f
            fi
        done
    fi
else
    FILES=$(ls /dev/shm/qb-*)
    for f in $FILES
    do
        echo $f
    done
fi

exit 0


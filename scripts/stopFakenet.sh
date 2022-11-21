#!/bin/bash
shopt -s nullglob

for pidfile in *.pid; do
    pid=$(cat $pidfile)
    echo "Stopping Opera with PID $pid ($pidfile)"
    kill $pid
done

sleep 1

for pidfile in *.pid; do
    pid=$(cat $pidfile)
    ps --pid "$pid" > /dev/null
    if [ "$?" -eq 0 ]; then
        echo "Killing Opera with PID $pid ($pidfile)"
        kill -9 $pid
        echo "PID $pid exists and is running."
    fi
    rm $pidfile
done

echo "Stopping all Operas done"


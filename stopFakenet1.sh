#!/bin/bash
OPERAPID=$(cat opera.pid)
echo "Stopping Opera with PID $OPERAPID..."
ls data
ps ax | grep $OPERAPID
kill $OPERAPID
echo "Stopped"


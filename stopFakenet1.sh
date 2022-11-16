#!/bin/bash
OPERAPID=$(cat opera.pid)
echo "Stopping Opera with PID $OPERAPID..."
kill $OPERAPID
echo "Stopped"


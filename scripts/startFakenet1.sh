#!/bin/bash

if ./opera version | grep "Version: 1.1.1-"; then
  echo "The opera version is 1.1.1 - skip db.preset"
  DBPRESET=''
else
  echo "The opera version is NOT 1.1.1 - db.preset will be set"
  DBPRESET='--db.preset=ldb-1'
fi

echo "Starting Opera with 1/1 fakenet..."
./opera \
        --fakenet 1/1 \
        --datadir ./data \
        --port=5060 \
        --maxpeers=5 \
        --verbosity=3 \
        --http \
        --http.addr=0.0.0.0 \
        --http.port=18545 \
        --http.corsdomain="*" \
        --http.vhosts="*" \
        --http.api=eth,web3,net,txpool,ftm \
        $DBPRESET 2>opera.log &
export OPERAPID=$!
sleep 3
echo "Opera started with PID $OPERAPID"
echo $OPERAPID >opera.pid
echo "IPC file:"
ls ./data/opera.ipc


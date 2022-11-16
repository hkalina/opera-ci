#!/bin/bash
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
        --db.preset=ldb-1 2>opera.log &
export OPERAPID=$!
echo "Opera started with PID $OPERAPID"
echo $OPERAPID >opera.pid


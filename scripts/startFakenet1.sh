#!/bin/bash
. scripts/helpers.sh

if ./opera version | grep "Version: 1.1.1-"; then
  echo "The opera version is 1.1.1 - skip db.preset"
  DBPRESET=''
else
  echo "The opera version is NOT 1.1.1 - db.preset will be set"
  DBPRESET='--db.preset=ldb-1'
fi

echo "Starting Opera with 1/1 fakenet..."
mkdir -p ./data1
PORT=$(($PORT_BASE+1))
RPCP=$(($RPCP_BASE+1))
WSP=$(($WSP_BASE+1))
./opera \
        --fakenet 1/1 \
        --datadir ./data1 \
        --port=${PORT} \
        --maxpeers=5 \
        --verbosity=3 \
        --http --http.addr="127.0.0.1" --http.port=${RPCP} --http.corsdomain="*" \
        --http.api="eth,debug,net,admin,web3,personal,txpool,ftm,dag" \
        --ws --ws.addr="127.0.0.1" --ws.port=${WSP} --ws.origins="*" \
        --ws.api="eth,debug,net,admin,web3,personal,txpool,ftm,dag" \
        $DBPRESET >> opera1.log 2>&1 &
export OPERAPID=$!
sleep 3
echo "Opera started with PID $OPERAPID"
echo $OPERAPID >opera1.pid
echo -e "IPC file: "
ls ./data1/opera.ipc


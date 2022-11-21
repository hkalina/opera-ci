#!/bin/bash
. scripts/helpers.sh

if ./opera version | grep "Version: 1.1.1-"; then
  echo "The opera version is 1.1.1 - skip db.preset"
  DBPRESET=''
else
  echo "The opera version is NOT 1.1.1 - db.preset will be set"
  DBPRESET='--db.preset=ldb-1'
fi

for ((i=0;i<=$N;i+=1))
do
    mkdir -p ./data$i
    PORT=$(($PORT_BASE+$i))
    RPCP=$(($RPCP_BASE+$i))
    WSP=$(($WSP_BASE+$i))
    (./opera \
        --datadir=./data$i \
        --fakenet=$i/$N \
        --port=${PORT} \
        --nat extip:127.0.0.1 \
        --http --http.addr="127.0.0.1" --http.port=${RPCP} --http.corsdomain="*" \
        --http.api="eth,debug,net,admin,web3,personal,txpool,ftm,dag" \
        --ws --ws.addr="127.0.0.1" --ws.port=${WSP} --ws.origins="*" \
        --ws.api="eth,debug,net,admin,web3,personal,txpool,ftm,dag" \
        --verbosity=3 $DBPRESET \
        --tracing >> opera$i.log 2>&1)&
    echo $! >opera$i.pid
    echo "Node $i started - PID $(cat opera$i.pid)"
done

sleep 1

echo "Connecting nodes to ring..."
for ((i=0;i<=$N;i+=1))
do
    for ((n=1;n<$N;n+=1))
    do
        j=$(((i+n) % (N+1)))

	enode=$(attach_and_exec $j 'admin.nodeInfo.enode')
        echo "    p2p address = ${enode}"

        echo " connecting node-$i to node-$j:"
        res=$(attach_and_exec $i "admin.addPeer(${enode})")
        echo "    result = ${res}"
    done
done

echo "Network of $N validators and one API node started..."

echo "Waiting for full initialization..."
sleep 10


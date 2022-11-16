#!/bin/bash
./build/opera \
	attach \
	--datadir ./data1 \
       	--exec "loadScript('contractCreateCall.js')"

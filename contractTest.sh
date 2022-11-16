#!/bin/bash
./opera attach --datadir ./data --exec "loadScript('contractTest.js');" | tee contract.log

if ! grep -q 'A is 5 (expected 0x5)' contract.log; then
  echo "The contract execution log does not contain expected output 'A is 5 (expected 0x5)'" >&2
  exit 1
fi


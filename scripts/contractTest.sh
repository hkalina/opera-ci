#!/bin/bash
. scripts/helpers.sh

node=1

attach_and_exec $node "loadScript('scripts/contractTest.js');" | tee contract.log


if ! grep -q 'A is 1 (expected 0x1)' contract.log; then
  echo "The contract execution log does not contain expected output 'A is 1 (expected 0x1)'" >&2
  exit 1
fi

if ! grep -q 'A is 5 (expected 0x5)' contract.log; then
  echo "The contract execution log does not contain expected output 'A is 5 (expected 0x5)'" >&2
  exit 1
fi


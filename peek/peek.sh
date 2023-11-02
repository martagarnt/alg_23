#!/bin/bash

if [[ $(wc -l < "$1") -lt 6 ]]; then
  cat "$1"
else
  head -n3 "$1"
  echo "..."
  tail -n3 "$1"
fi

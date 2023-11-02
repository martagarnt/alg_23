#!/bin/bash

n_lines=3

# checking if the lines are defined

if [[ -z "$2" ]]; then
    n="$n_lines"
else
    n="$2"
fi

# checking the lines

lines_file=$(wc -l < "$1")

# making the printing

if [[ "$lines_file" -le $((2*n)) ]]; then
  cat "$1"
else
  echo "Warning: the output of this file will be only printing the $n first lines and the $n last lines "
  head -n "$n" "$1"
  echo "..."
  tail -n "$n" "$1"
fi

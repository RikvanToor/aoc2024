#!/bin/bash
day=$(date +%-d)
session=$(cat .session)
curl "https://adventofcode.com/2024/day/${day}/input" \
  -H "Cookie: session=${session}" \
  > "Sources/inputs/day$(date +%d).txt"
#!/usr/bin/env bash
# RAM watchdog: log every 60 s; flag docs/RAM_LOW when available memory < 1.5 GB (workers wait while the flag exists).
D="$(cd "$(dirname "$0")/.." && pwd)/docs"; while true; do A=$(free -m | awk '/Mem/{print $7}'); echo "$(date +%FT%T) avail_mb=$A" >> "$D/ram_watchdog.log"; if [ "$A" -lt 1500 ]; then touch "$D/RAM_LOW"; else rm -f "$D/RAM_LOW"; fi; sleep 60; done

#!/bin/sh

master="$(amixer | head -1 | cut -d "'" -f 2)";
volume="$(amixer get "${master}" | tail -1 | cut -d \[ -f 2 | cut -d \] -f 1)";

echo -n "${volume}";

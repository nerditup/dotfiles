#!/bin/sh

master="$(amixer | head -1 | cut -d "'" -f 2)"
echo -n "$(amixer get ${master} | tail -1 | cut -d \[ -f 2 | cut -d \] -f 1)"

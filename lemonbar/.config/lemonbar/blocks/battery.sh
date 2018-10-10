#!/bin/sh

echo -n "$(acpi | cut -d , -f 2 | cut -d " " -f 2)"

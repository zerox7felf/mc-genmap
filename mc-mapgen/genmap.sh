#!/bin/env bash

# Generate unmined map to /webcont/unmined
mkdir -p /webcont/unmined
/unmined/unmined-cli web render --world=/mc --output=/webcont/unmined --players

# Generate mcmap render to /webcont/mcmap
mkdir -p /webcont/mcmap
/mcmap/mcmap -center 0 0 -radius 2000 -shading -file /webcont/mcmap/output.png /mc

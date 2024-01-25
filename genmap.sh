#!/bin/env bash

/unmined/unmined-cli web render --world=/mc --output=/webcont/ --players
ln -sf /webcont/unmined.index.html /webcont/index.html

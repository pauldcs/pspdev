#!/bin/bash

export PSPDEV=/usr/local/pspdev
sudo mkdir -p $PSPDEV
sudo chown -R $USER: $PSPDEV
export PSPDEV=/usr/local/pspdev
export PATH=$PATH:$PSPDEV/bin
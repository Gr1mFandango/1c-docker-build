#!/bin/bash

x11vnc -q -nopw -forever -bg > /dev/null
nohup /opt/noVNC-1.0.0/utils/launch.sh >/dev/null 2>&1 &

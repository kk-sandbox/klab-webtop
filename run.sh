#!/bin/bash

set -v
docker run -it --name klab-webtop -h ubuntu-webtop -p 5901:5901 -p 6901:6901 -v $HOME/Public:/data kribakarans/webtop

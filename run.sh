#!/bin/bash

set -v
docker run -it --name ubuntu-webtop -h ubuntu-webtop -p 5901:5901 -p 6901:6901 -v $HOME/Public:/data ubuntu-webtop:dev

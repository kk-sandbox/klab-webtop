#!/bin/bash

VNC_HOST=localhost

# Remove stale VNC files
rm -rf /tmp/.X*-lock /tmp/.X11-unix $HOME/.vnc/*.pid

# Starting VNC server
echo -e "\n------------------ VNC session started ------------------"
echo -e "\nVNC server started on DISPLAY=:1"
echo -e "  => Connect via VNC viewer with $VNC_HOST:$VNC_PORT"
vncserver :1 -geometry $VNC_RESOLUTION -depth 24

# Starting noVNC server
echo -e "noVNC HTML client started:"
echo -e "  => Connect via http://$VNC_HOST:$NOVNC_PORT/vnc_auto.html?password=$VNC_PASSWD\n"
websockify -D --web=/usr/share/novnc/ $NOVNC_PORT $VNC_HOST:$VNC_PORT

# Monitoring VNC logs
echo -e "\n------------------ VNC session log ------------------\n"
tail -f $HOME/.vnc/*.log

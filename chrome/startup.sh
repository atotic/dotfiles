#!/usr/bin/bash
#keyboard
xmodmap ~/.Xmodmap

goma_ctl start

# gdb allow
sudo sysctl -w kernel.yama.ptrace_scope=0
# create terminals
pushd ~/chromium/src
#gnome-terminal --geometry=80x76 --window --title=gdb -- cgdb
gnome-terminal --geometry=80x70 --window --title=gdb
gnome-terminal --geometry=100x10 --window --title=server -- http-server -a 127.0.0.1 -p 9999 -c-1 /usr/local/google/home/atotic/chromium/src/third_party/blink/web_tests
gnome-terminal --geometry=100x40 --window
popd
# camera setup
uvcdynctrl --load=/usr/local/google/home/atotic/camera.cfg

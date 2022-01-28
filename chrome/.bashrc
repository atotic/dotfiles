# setting up a new machine
# rsync --progress -a ~/ atotic@atotic2.mtv.corp.google.com:~/
# go/keymap to setup .Xmodmap
# sudo apt-get install xfce4 google-chrome-unstable google-gdb cgdb guvcview  xautomation wmctrl universal-ctags
# sudo glinux-add-repo sublime-text stable
# sudo apt-get update
# sudo apt-get install google-sublime-text
# -- install npm for http-server
# sudo glinux-add-repo -p 600 typescript stable && sudo apt update && sudo apt install nodejs
# sudo npm install http-server -g
# cd chromium/src
# sudo ./build/install-build-deps.sh
# sudo ./build/install-build-deps-android.sh
#
# .inputrc needs "set enable-bracketed-paste off", otherwise cgdb does not work
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ATOTIC
# touchpad
# cat /usr/share/X11/xorg.conf.d/40-libinput.conf
# xinput --list
# https://wiki.archlinux.org/index.php/Libinput
# https://community.linuxmint.com/tutorial/view/1361
# colors
export RED='\x1b[31m'
export RESET="\x1b[0m"

export DEFAULT_TITLE='ready'

function set_title()
{
  echo -ne "\e]0;${@:-$DEFAULT_TITLE}\a"
}

export ANDROID_HOME=~/Android/Sdk
export ANDROID_SDK_ROOT=~/Android/Sdk
export ANDROID_AVD_HOME=~/.android/avd

# TIPS
# turn function keys on/off on keyboard
# echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode
#
# Sublime text
# Custom extensions in ~.config/sublime-text-3/Packages/User
# Add to context menu at: Context.sublime-menu
#
# Camera: Logitech 930e. Adjust pan/tilt/zoom with guvcview.
# uvcdynctrl should also work, but does not
#
# SSH_AGENT problems
# https://g3doc.corp.google.com/company/corp/goobuntu/xfce.md?cl=head
# While in a Chrome Remote Desktop Session (this will not work through SSH)
# Run xfconf-query -c xfce4-session -p /startup/ssh-agent/enabled -n -t bool -s false
# Restart chrome remote desktop sudo service chrome-remote-desktop restart
#
# Chrome remote desktop restart
alias crd_restart="sudo systemctl restart chrome-remote-desktop@atotic"

## exports

export PATH=$PATH:/usr/local/google/home/atotic/chromium/src/third_party/depot_tools
export PS1='\W$(__git_ps1 " (%s)")> '
export PROMPT_COMMAND='history -a'
export EDITOR="/bin/nano"
export DEBUGGER="/usr/bin/cgdb"
export NINJA_STATUS="%e %f/%t "
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
export TARGET="/usr/local/google/home/atotic/chromium/src/out/Develop/content_shell"
export CHROMIUM_SRC=${HOME}/chromium/src
export BUGFILE=file:///usr/local/google/home/atotic/chromium/layoutng/test.html
# Every asan run complains about this
export ASAN_OPTIONS=detect_odr_violation=0
export GOMA_DIR=${HOME}/goma
#(auto configured) 15
export GOMA_MAX_SUBPROCS=40
#(auto configured) 14
export GOMA_MAX_SUBPROCS_LOW=39

export PYTHONPATH=$PATH:/usr/local/google/home/atotic/chromium/src/third_party/catapult/tracing/tracing/proto/

export NINJA_SUMMARIZE_BUILD=1
alias ninjasumo="~/depot_tools/post_build_ninja_summary.py -C out/Optimized/"
alias ninjasum="~/depot_tools/post_build_ninja_summary.py -C out/Develop/"

## aliases
alias goma_start="${GOMA_DIR}/goma_ctl.py ensure_start"
alias xclip="xclip -selection c"
# removes journal files which can be quite large
alias dfclean="sudo journalctl --vacuum-size=50M"
alias browserstack="/usr/local/google/home/atotic/bin/BrowserStackLocal --key h3tuhfptoctaGjVwsqQD"
function http-ser {
  reset
  set_title http-tests
  trap 'set_title ready' INT
  http-server -a 127.0.0.1 -p 9999 -c-1 /usr/local/google/home/atotic/chromium/src/third_party/blink/web_tests
  set_title ready
}

function http-serng {
  reset
  set_title http-serng
  trap 'set_title ready' INT
  http-server -a 127.0.0.1 -p 9999 -c-1 /usr/local/google/home/atotic/chromium/layoutng
  set_title ready
}

## Clusterfuzz setup
#export BUGFILE="/usr/local/google/home/atotic/.clusterfuzz/cache/testcases/6362170727333888_testcase/testcase.html"
#export BLINK_FEATURES=''

# Graphics log "
## Standard layoutng setup.
# --disable-blink-features=PaintUnderInvalidationChecking
function layoutng {
  export BLINK_FEATURES=' --enable-blink-features=LayoutNG --expose-internals-for-testing --vmodule="*/paint/*=0,*/graphics/*=0"'
  export TEST_FLAGS=''
  export DEFAULT_TITLE='layoutng'
  set_title
}

# cc layer debugging --vmodule="layer_tree_host=3"
# paint layer debugging --vmodule="*/paint/*=2,*/graphics/*=3"
function paintng {
  export BLINK_FEATURES='--enable-blink-features=LayoutNG  --expose-internals-for-testing --vmodule="*/paint/*=3,*/graphics/*=3"'
  export TEST_FLAGS='--additional-driver-flag=--enable-blink-features=LayoutNG'
  export DEFAULT_TITLE='paintng'
  set_title
}

function tableng {
  # export BLINK_FEATURES='--enable-blink-features=LayoutNGTable  --expose-internals-for-testing --vmodule="*/paint/*=0,*/graphics/*=0"'
  BLINK_FEATURES='--expose-internals-for-testing --vmodule="*/paint/*=0,*/graphics/*=0"'
  export TEST_FLAGS=''
  #--additional-driver-flag=--enable-blink-features=LayoutNGTable'
  export DEFAULT_TITLE='tableng'
  set_title
}

function flexng {
  export BLINK_FEATURES='--enable-blink-features=LayoutNGFlexBox  --expose-internals-for-testing'
  export TEST_FLAGS='--additional-driver-flag=--enable-blink-features=LayoutNGFlexBox'
  export DEFAULT_TITLE='flex_ng'
  set_title
}

function compositepaint {
  export BLINK_FEATURES='--enable-blink-features=CompositeAfterPaint  --expose-internals-for-testing'
  export TEST_FLAGS='--additional-driver-flag=--enable-blink-features=CompositeAfterPaint'
  export DEFAULT_TITLE='compositepaint'
  set_title
}

function paintnong {
  export BLINK_FEATURES='--expose-internals-for-testing --vmodule="*/paint/*=2,*/graphics/*=3"'
  export TEST_FLAGS='--additional-driver-flag=--enable-blink-features=LayoutNG'
  export DEFAULT_TITLE='paint_nong'
  set_title
}

function layoutngexperimental {
  export BLINK_FEATURES='--enable-blink-features=AutoExpandDetailsElement  --expose-internals-for-testing'
  export TEST_FLAGS='--additional-driver-flag=--enable-blink-features=LayoutNG'
  export DEFAULT_TITLE='layoutng_experimental'
  set_title
}

function asan {
  export DEFAULT_TITLE='asan'
  alias runasan='out/asan/content_shell $BLINK_FEATURES $BUGFILE'
  set_title
}

function clusterfuzz {
  export DEFAULT_TITLE='cluster'
  alias runcluster='out/Cluster/content_shell $BUGFILE'
  set_title
}

function nong {
  export BLINK_FEATURES='--expose-internals-for-testing --disable-blink-features=LayoutNG --disable-blink-features=LayoutNGTable'
  export TEST_FLAGS='--additional-driver-flag=--disable-blink-features=LayoutNG --additional-driver-flag=--disable-blink-features=LayoutNGTable'
  export DEFAULT_TITLE='nong'
  set_title
}

function notable {
  export BLINK_FEATURES='--expose-internals-for-testing --disable-blink-features=LayoutNGTable'
  export TEST_FLAGS='--additional-driver-flag=--disable-blink-features=LayoutNGTable'
  export DEFAULT_TITLE='notable'
  set_title
}


function set_layout_test {
  export BLINK_FEATURES="$BLINK_FEATURES --run-web-tests"
  export BUGFILE=$1
  export DEFAULT_TITLE="test $1"
}

function build {
  set_title build
  reset
  ninja -C out/Develop content_shell -j 500
  local status="$?"
  set_title
  return $status
}

#   ninja -C out/Optimized blink_tests -j 480
function buildo {
  set_title buildo
  reset
  ninja -C out/Optimized content_shell -j 500
  local status="$?"
  set_title
  return $status
}

function run {
  set_title run
  ./out/Develop/content_shell --no-sandbox $BLINK_FEATURES $BUGFILE --remote-debugging-port=9222
  set_title
}
function runo {
  set_title run optimized
  ./out/Optimized/content_shell --no-sandbox $BLINK_FEATURES $BUGFILE $@
  set_title
}
function runt {
  set_title runt
  python third_party/blink/tools/run_web_tests.py --target=Develop $TEST_FLAGS
  rm -rf /tmp/.org.chromium.Chromium.*
}

export CHROME_FLAGS=" \
--remote-debugging-port=9222 \
--enable-logging=stderr \
--disable-logging-redirect \
--user-data-dir=/usr/local/google/home/atotic/remote-profile \
--disable-breakpad \
"

function runc {
  ./out/Optimized/chrome $CHROME_FLAGS $BLINK_FEATURES --user-data-dir=remote-profile
}

function runcd {
  ./out/Develop/chrome $CHROME_FLAGS  --renderer-cmd-prefix="gnome-terminal --tab --title=renderer --command gdb --args $BLINK_FEATURES"
}
alias buildc="autoninja -C out/Optimized chrome"

#alias debugc="./out/Develop/chrome --no-sandbox --renderer-startup-dialog --single-process $BUGFILE"
alias buildt="ninja -C out/Develop -k 1000 blink_tests -j 480"
alias buildot="ninja -C out/Optimized -k 1000 blink_tests -j 480"
alias runtt="./out/Develop/webkit_unit_tests --gtest_filter=NGAbsoluteUtilsTest*"
alias run_unit_tests="./out/Optimized/blink_unittests"
alias builda="autoninja -C out/Android chrome_public_apk && out/Android/bin/chrome_public_apk install"
alias adb="/usr/local/google/home/atotic/chromium/src/third_party/android_sdk/public/platform-tools/adb"

# alias runt="./out/Develop/webkit_unit_tests --gtest_filter=*"
alias gitpull="git pull --ff-only && gclient sync -D && autoninja -C out/Develop blink_tests && autoninja -C out/Optimized chrome"
alias gitlogng="git log --grep='layoutng' -i --since='1 month ago'"
alias gitcltry="git cl try -b linux-rel -b  linux_layout_tests_layout_ng"
alias flakes="source ~/bin/flakes.sh"
alias bots="git cl try --bot=linux-rel --bot=linux_layout_tests_layout_ng"

alias buildp="autoninja -C out/Profiling chrome"
export CPUPROFILE_FREQUENCY=1000

# --disable-gpu for faster startup 919556
export CONTENT_SHELL_FLAGS=" \
--disable-gpu \
--no-sandbox \
--renderer-startup-dialog \
--renderer-process-limit=1 \
--vmodule="*/paint/*=2,*/graphics/*=3" \
"

export RR_FLAGS=" \
--no-sandbox \
--disable-hang-monitor \
--disable-gpu \
--single-process \
--disable-seccomp-sandbox \
--disable-setuid-sandbox \
"

export LAUNCH_DEBUGGER_FOR_NEW_RENDERERS=1
export CONTENT_SHELL_BINARY="./out/Develop/content_shell"
#gdb --version 10.0-gg5
function debug {
  set_title debug
  reset
  trap 'set_title ready' INT
  local RENDERREGEX='Renderer \(([[:digit:]]+)\) paused'
  local DEVTOOLREGEX='DevTools listening on ws://(127.0.0.1:[[:digit:]]+/).*'
  local ATTACH_DEBUGGER=1
  ./out/Develop/content_shell $CONTENT_SHELL_FLAGS $BLINK_FEATURES $BUGFILE 3>&1 1>&2 2>&3 | {
    while IFS= read -r line
    do
      if [[ "$line" =~ $RENDERREGEX ]]
      then
        echo "READY " ${BASH_REMATCH[1]}
        SAVED_CLIPBOARD=$(xclip -selection clipboard -o)
# copy line to selection
        echo -n attach ${BASH_REMATCH[1]} | xsel -i -b
        set_title "$DEFAULT_TITLE debug ${BASH_REMATCH[1]}"
# paste line into cgdb
        if [[ $ATTACH_DEBUGGER == 1 ]]
        then
          ATTACH_DEBUGGER=0
          wmctrl -F -a gdb
          sleep 0.1
          echo "key Return" | xte
          echo "str attach ${BASH_REMATCH[1]}" | xte
          echo "key Return" | xte
          echo "str s1" | xte
          echo "key Return" | xte
          echo $SAVED_CLIPBOARD | xclip -selection c
        else
# launches debugger in new window
          if [ LAUNCH_DEBUGGER_FOR_NEW_RENDERERS ]
          then
            gnome-terminal --geometry=80x48 --hide-menubar --title=renderer -- cgdb -- --pid=${BASH_REMATCH[1]}
#            gnome-terminal --geometry=80x48 --hide-menubar --title=renderer -- cgdb -- --pid=${BASH_REMATCH[1]} --eval-command=s1
          else
            echo "not launching renderer gdbs*"
          fi
        fi
      elif [[ "$line" =~ $DEVTOOLREGEX ]]
      then
        printf "DEVTOOLS http://%s\n" ${BASH_REMATCH[1]}
      fi
      printf "%s\n" "$line"
    done

  }
  set_title
}


function debugc {
  set_title debug
  reset
  trap 'set_title debug_chrome' INT
  local RENDERREGEX='Renderer \(([[:digit:]]+)\) paused'
  local DEVTOOLREGEX='DevTools listening on ws://(127.0.0.1:[[:digit:]]+/).*'
  local ATTACH_DEBUGGER=1
  ./out/Develop/chrome --no-sandbox --renderer-startup-dialog --user-data-dir=remote-profile --renderer-process-limit=1 $BLINK_FEATURES $BUGFILE 3>&1 1>&2 2>&3 | {
    while IFS= read -r line
    do
      if [[ "$line" =~ $RENDERREGEX ]]
      then
        echo "READY " ${BASH_REMATCH[1]}
# copy line to selection
        echo -n attach ${BASH_REMATCH[1]} | xsel -i -b
        set_title "$DEFAULT_TITLE debug ${BASH_REMATCH[1]}"
# paste line into cgdb
        if [[ $ATTACH_DEBUGGER == 1 ]]
        then
          ATTACH_DEBUGGER=0
          wmctrl -a gdb
          sleep 0.1
          echo "key Return" | xte
          echo "str attach ${BASH_REMATCH[1]}" | xte
          echo "key Return" | xte
          echo "str s1" | xte
          echo "key Return" | xte
        else
# launches debugger in new window
        gnome-terminal --geometry=80x48 --hide-menubar --title=renderer -- cgdb -- --pid=${BASH_REMATCH[1]} --eval-command=s1
#          echo "not launching renderer gdbs*"
        fi
      elif [[ "$line" =~ $DEVTOOLREGEX ]]
      then
        printf "DEVTOOLS http://%s\n" ${BASH_REMATCH[1]}
      fi
      printf "%s\n" "$line"
    done

  }
  set_title
}

export SLOW_TESTS=" \
--ignore-tests=external/wpt/offscreen-canvas \
--ignore-tests=external/wpt/html/the-xhtml-syntax \
--ignore-tests=external/wpt/WebCryptoAPI \
--ignore-tests=fast/peerconnection \
--ignore-tests=http/tests \
--ignore-tests=external/wpt/websockets \
--ignore-tests=virtual/web-bluetooth-new-permissions-backend \
--ignore-tests=virtual/no-auto-wpt-origin-isolation \
--ignore-tests=external/wpt/bluetooth \
--ignore-tests=bluetooth \
--ignore-tests=virtual \
"

export COMMON_TEST_FLAGS="\
--no-manifest-update \
--no-build \
--skip-timeouts \
--order=none \
--num-retries=0 -f \
--jobs=60 \
"

# test flag switches

function profiling_off {
  export BLINK_FEATURES=`echo $BLINK_FEATURES | sed -e 's/--enable-profiling//g'`
  export BLINK_FEATURES=`echo $BLINK_FEATURES | sed -e 's/--profiling-at-start=renderer//g'`
  export BLINK_FEATURES=`echo $BLINK_FEATURES | sed -e 's/-no-sandbox//g'`
  unset HEAP_PROFILE_TIME_INTERVAL
}
function profiling_on {
  profiling_off
  export HEAPPROFILE=/usr/local/google/home/atotic/prof/layoutng
  export HEAP_PROFILE_TIME_INTERVAL=60
  export BLINK_FEATURES="$BLINK_FEATURES --enable-profiling --profiling-at-start=renderer --no-sandbox"
}

function manifest_off {
  manifest_on
  export COMMON_TEST_FLAGS="$COMMON_TEST_FLAGS --no-manifest-update"
}
function manifest_on {
  export COMMON_TEST_FLAGS=`echo $COMMON_TEST_FLAGS | sed -e 's/--no-manifest-update//g'`
}

function retries_off {
  export COMMON_TEST_FLAGS=`echo $COMMON_TEST_FLAGS | sed -e 's/--num-retries=1/--num-retries=0/g'`
}
function retries_on {
  export COMMON_TEST_FLAGS=`echo $COMMON_TEST_FLAGS | sed -e 's/--num-retries=0/--num-retries=1/g'`
}

function gc_on {
  export BLINK_FEATURES="$BLINK_FEATURES --js-flags=--expose-gc"
}

# --vmodule="*/paint/*=3,*/graphics/*=3"
function vlog_on {
  export BLINK_FEATURES=`echo $BLINK_FEATURES | sed -e  's/--vmodule=\"\*\/paint\/\*=[0-9],\*\/graphics\/\*=[0-9]/--vmodule=\"\*\/paint\/\*=3,\*\/graphics\/\*=3/g'`
  echo $BLINK_FEATURES
}

function vlog_off {
  export BLINK_FEATURES=`echo $BLINK_FEATURES | sed -e  's/--vmodule=\"\*\/paint\/\*=[0-9],\*\/graphics\/\*=[0-9]/--vmodule=\"\*\/paint\/\*=0,\*\/graphics\/\*=0/g'`
  echo $BLINK_FEATURES
}

function experimental_features_on {
  export CONTENT_SHELL_FLAGS="$CONTENT_SHELL_FLAGS --enable-experimental-web-platform-features"
  echo CONTENT_SHELL_FLAGS $CONTENT_SHELL_FLAGS
}

function experimental_features_off {
  experimental_features_on
  export CONTENT_SHELL_FLAGS=`echo $CONTENT_SHELL_FLAGS | sed -e 's/--enable-experimental-web-platform-features//g'`
  echo CONTENT_SHELL_FLAGS $CONTENT_SHELL_FLAGS
}

function testall {
  set_title testall
  time="$(time ./third_party/blink/tools/run_web_tests.py --target=Optimized $TEST_FLAGS $COMMON_TEST_FLAGS $SLOW_TESTS $@)"
  rm -rf /tmp/.org.chromium*
  set_title
}

# read all tests from a file
export TESTLIST='/usr/local/google/home/atotic/chromium/layoutng/tables/test_list_all.txt'
export TESTLIST='/usr/local/google/home/atotic/chromium/layoutng/testlist/shadowdom.txt'

function testallf {
  testall --test-list=$TESTLIST
}
#alias testallf='testall --test-list=$TESTLIST'

alias testallng="layoutng && testall"
alias testallnong="nong && testall"

function xv_testallng {
  set_title xv_testalng
  time="$(./testing/xvfb.py python third_party/blink/tools/run_web_tests.py --target=Optimized $TEST_FLAGS $COMMON_TEST_FLAGS $SLOW_TESTS $@)"
  rm -rf /tmp/.org.chromium*
  set_title
}

function testallnong {
  set_title testall_nong
  time="$(time python third_party/blink/tools/run_web_tests.py --target=Optimized $COMMON_TEST_FLAGS $SLOW_TESTS $@)"
  rm -rf /tmp/.org.chromium*
  set_title
}

function rebaseline {
  set_title rebaseline
  ./third_party/blink/tools/run_web_tests.py --target=Optimized $TEST_FLAGS --reset-results $@
  echo "To rebaseline all platforms, run ./third_party/blink/tools/blink_tool.py rebaseline-cl"
  set_title
}

function gitcltry {
  git cl try -b linux_layout_tests_layout_ng -b linux_chromium_rel_ng
}

# setup
layoutng

# ./out/Develop/chrome --no-sandbox --renderer-process-limit=1 --renderer-startup-dialog $BLINK_FEATURES $BUGFILE

set print address on
set print pretty on
set print frame-arguments none
# turns off colored output in gdb 8.3:
# https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=blob;f=gdb/NEWS
set style enabled on
# removes "program is being debugged" prompts
set confirm off
# turn off shared library loading
set auto-solib-add on
# debugging symbol table https://sourceware.org/gdb/onlinedocs/gdb/Symbols.html#Symbols
# Perf issue trying to lookup namespaces with gdb_index https://sourceware.org/bugzilla/show_bug.cgi?id=18141
show print symbol-loading
maint set symbol-cache-size 4196
set pagination off
set max-completions 2
# some magic that might be needed to make rr work
handle SIGSYS nostop noprint pass

define exit
  quit
end

define s1
#  sharedlibrary libblink
#  sharedlibrary libbase
#  sharedlibrary libwtf
  set disassemble-next-line off
  signal SIGUSR1
end

define ppoff
  disable pretty-printer
end
define ppon
  enable pretty-printer
end


define pstr
 python clipboard.copy( gdb.parse_and_eval("ToString().Latin1().data()").string())
end

define sbr
  save breakpoints ~/breaks
end
define rbr
  source ~/breaks
end

define ShowLayoutTree
  br layout_ng_block_flow.cc:71
  comm
  p ShowLayoutTreeForThis()
  p fragment->ShowFragmentTree()
  end
end

define DebugName
  comm
  p DebugName()
  end
  p DebugName()
end

define c
  cont
end

define sf
  skip
  fin
end

alias -a rfin = reverse-finish

source /usr/local/google/home/atotic/chromium/src/tools/gdb/gdbinit
python
import sys
# chrome specific gdb libraries
sys.path.insert(0, "/usr/local/google/home/atotic/chromium/src/third_party/blink/tools/gdb/")
# import blink
sys.path.insert(0, "/usr/local/google/home/atotic/chromium/src/tools/gdb/")
sys.path.insert(0, "/usr/local/google/home/atotic/bin")
#
#import gdb_chrome
# sys.path.append("/usr/local/lib/python2.7/dist-packages")
#import clipboard
#import ng_gdb
# python reload(ng_gdb)
print ".gdbinit Ready"

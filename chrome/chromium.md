# debugging chrome
cgdb out/Develop/chrome
set args -remote-debugging-port=9222  --user-data-dir=/usr/local/google/home/atotic/remote-profile --disable-breakpad  --disable-seccomp-sandbox --disable-gpu  --renderer-startup-dialog --renderer-process-limit=1 file:///usr/local/google/home/atotic/chromium/layoutng/test.html

# asan chrome
./out/asan/chrome --no-first-run --user-data-dir=/usr/local/google/home/atotic/tmp2  --no-sandbox $BUGFILE

./out/Optimized/chrome --no-first-run --user-data-dir=/usr/local/google/home/atotic/tmp2  --no-sandbox $BUGFILE

# work with branches
Find branchnumber at:
https://chromiumdash.appspot.com/branches

gclient sync --with_branch_heads
git fetch
git checkout -b BRANCHNAME branch-heads/BRANCHNUMBER
gclient sync

# Crash browser
https://chromiumdash.appspot.com/releases?platform=Windows

Query all crashes with "*Table*" on the stack.

- Query all crashes that have Table in release
product_name="Chrome" AND expanded_custom_data.ChromeCrashProto.channel='canary' AND product.Version='91.0.4444.0' AND expanded_custom_data.ChromeCrashProto.ptype='renderer' AND EXISTS (SELECT 1 FROM UNNEST(CrashedStackTrace.StackFrame) WHERE FunctionName LIKE '%Table%')

- Query all crashes that have table since date
product_name="Chrome" AND expanded_custom_data.ChromeCrashProto.channel='canary' AND expanded_custom_data.ChromeCrashProto.ptype='renderer' AND EXISTS (SELECT 1 FROM UNNEST(CrashedStackTrace.StackFrame) WHERE FunctionName LIKE '%Table%') AND FORMAT_TIMESTAMP('%Y/%m/%d', TIMESTAMP_MICROS(upload_time*1000), "UTC")>'2021/03/15'


# RR debugging
https://docs.google.com/document/d/1_2_smRPXbWxTyYej2MhZw6-wOIt7n1F6cw6j5Q-RxIw/edit
https://chromium.googlesource.com/chromium/src/+/

Setup:
in .gdbinit: set auto-solib-add on

cd out/Develop
rr record ./content_shell --no-sandbox --disable-hang-monitor --single-process --disable-gpu $BLINK_FEATURES $BUGFILE
rr replay -d cgdb

# Layout tests

./third_party/blink/tools/run_web_tests.py --target=Optimized $TEST_FLAGS $COMMON_TEST_FLAGS $SLOW_TESTS --repeat-each=100 --child-processes=1 external/wpt/resize-observer/iframe-same-origin.html

# content_shell test
./out/Optimized/content_shell $BLINK_FEATURES --run-web-tests --single-process external/wpt/resize-observer/iframe-same-origin.html


in gdb

set args  --expose-internals-for-testing --single-process https://output.jsbin.com/sikoyol/quiet

set args  --expose-internals-for-testing --run-web-tests --single-process external/wpt/resize-observer/iframe-same-origin.html

enable gc!
--js-flags=--expose-gc
# blink_unittests

buildot && ./out/Optimized/blink_unittests  $BLINK_FEATURES --gtest_filter="*HTMLPreloadScannerTest.JavascriptBaseUrl*"

cgdb ./out/Develop/blink_unittests

set args --enable-blink-features=LayoutNGTable --single-process-tests --gtest_filter="*NGBoxFragmentPainterTest*"

rr record ./blink_unittests --single-process-tests --gtest_filter="*ParameterizedTextOffsetMappingTest*"

class MultiColumnRenderingTest : public RenderingTest,
                                 private ScopedLayoutNGTableForTest {
 public:
  MultiColumnRenderingTest() : ScopedLayoutNGTableForTest(false) {}

#content_browsertests
autoninja -C out/Optimized content_browsertests

./out/Optimized/content_browsertests  --test-laucher-jobs=30 --gtest_filter="*FormControlsBrowserTest.Checkbox*"

To generate expectations:
./out/Optimized/content_browsertests  --generate-accessibility-test-expectations --gtest_filter="*All/DumpAccessibilityTreeTest.AccessibilityCustomRowElement/*"

# run wpt server

cd third_party/WebKit
blink/tools/run_blink_wptserve.py
http://localhost:8001/

# rebaseline
# create new patch
# kicks off try jobs
./third_party/blink/tools/blink_tool.py rebaseline-cl
# when try jobs complete, run again
./third_party/blink/tools/blink_tool.py rebaseline-cl --test-name-file=/usr/local/google/home/atotic/chromium/layoutng/rebaseline.txt

./third_party/blink/tools/blink_tool.py rebaseline-cl --builders=win10_chromium_x64_rel_ng --test-name-file=/usr/local/google/home/atotic/chromium/layoutng/rebaseline.txt

# running wpt tests locally

To run scaled content in content_shell: content_shell, html { zoom: 1.5;}

# running perf locally

./tools/perf/run_benchmark run blink_perf.paint --browser-executable=/usr/local/google/home/atotic/chromium/src/out/Optimized/chrome --story-filter=large-table-background-change.html

# bisect-builds
https://omahaproxy.appspot.com/ for branch base position for --good arguments
do not use version numbers for good/bad. There are problems with branches.

python tools/bisect-builds.py --use-local-cache --archive linux64 --good=722274 -- --no-first-run --user-data-dir=/usr/local/google/home/atotic/tmp2 http://localhost:9999/external/wpt/css/css-tables/width-distribution/assignable_table_width_redistribution.tentative.html

python tools/bisect-builds.py -a mac64 -g 856488 -b 870763 --use-local-cache --command="%p %a --disable-blink-features=LayoutNGTable"

python tools/bisect-builds.py --use-local-cache --archive linux64 --good=93.0.4577.82 --bad=94.0.4606.54 -- --no-first-run --user-data-dir=/usr/local/google/home/atotic/tmp2 file:///usr/local/google/home/atotic/chromium/layoutng/test.html


# ANDROID ANDROID ANDROID
chrishtr untried crow method looks promising:
https://docs.google.com/document/d/1zgXs4tfWKNtLRnI4FYA-XiK0GRyDMtdlibgqjrBWnFw/edit

autoninja -C out/Android chrome_public_apk
./out/Android/bin/chrome_public_apk install

https://chromium.googlesource.com/chromium/src/+/master/docs/android_build_instructions.md

Android studio
If AVD Manager is not showing up, do ctrl-shift-A, search for AVD manager
start the emulator

Only works when I start Android Studio from command line:
/opt/android-studio-with-blaze-stable/bin/studio.sh

| adb devices
93NAY0DSK5  device
emulator-5554 device

Binaries for emulator and phone are different.
target_cpu = "x86" for emulator
target_cpu = "arm64" for phone

localhost on android phones is 10.0.2.2
http://10.0.2.2:9999/

| autoninja -C out/Android chrome_public_apk
chrome_public_apk
adb logcat
c++ #include "cutils/log.h"
use ALOGD

autoninja -C out/Android chrome_public_test_apk
./out/Android/bin/run_chrome_public_test_apk
--wait-for-java-debugger

./build/android/gradle/generate_gradle.py --output-directory out/Android

master/docs/linux_debugging.md#Time-travel-debugging-with-rr

# local benchmarks
https://chromium.googlesource.com/chromium/src/+/master/docs/speed/benchmark/harnesses/rendering.md#How-to-run-rendering-benchmarks-on-local-devices


#sublime and chromium
https://chromium.googlesource.com/chromium/src/+/master/docs/linux_sublime_dev.md#Code-Completion-with-SublimeClang-Linux-Only

# switching users for git cl
depot-tools-auth login https://codereview.chromium.org

# bisecting builds
https://www.chromium.org/developers/bisect-builds-py

# cleaner logging++
logging::SetLogItems(false, false, false, false);

# this is where output of the layer tree is generated.
std::unique_ptr<JSONObject> GraphicsLayerAsJSON

# create green png
# and convert to data url
convert -size 400x200 canvas:green green.png
 ~/bin/image64.sh green.png

# profiling
szager document: https://chromium.googlesource.com/chromium/src/+/master/docs/profiling.md
pprof -http=127.0.0.1:5555 ~/chromium/src/out/Profiling/chrome fixed_grid_lots_of_data_html-interactions-JB3lBz.profile.pb
./tools/perf/run_benchmark run "blink_perf.layout" --story-filter=fixed-grid-lots-of-data.html --browser-executable=/usr/local/google/home/atotic/chromium/src/out/Profiling/chrome --interval-profiling-target=renderer:main --interval-profiling-frequency=1000 --interval-profiling-period=interactions --output-dir=/usr/local/google/home/atotic/chromium/layoutng/perf

# profiling
# display profile chart
pprof -sample_index=inuse_space  -web ~/prof/layoutng.43155.0001.heap
pprof -sample_index=inuse_objects  -web ~/prof/layoutng.43155.0001.heap
use profiling_on/profiling_off shortcut

export HEAPPROFILE=/usr/local/google/home/atotic/prof/layoutng
set HEAP_PROFILE_TIME_INTERVAL=60

Profiling CPU:
export CPUPROFILE_FREQUENCY=100

CPUPROFILE=~/prof/dragdrop.call out/Optimized/content_shell --single-process $BLINK_FEATURES $BUGFILE

CPUPROFILE=~/prof/dragdrop.call out/Optimized/content_shell --enable-profiling --profiling-at-start=renderer --no-sandbox --single-process $BLINK_FEATURES $BUGFILE

pprof -http=:5555 ./out/Optimized/content_shell ~/prof/dragdrop.call
ls -l ~/prof/table*

# enable attach
sudo sysctl -w kernel.yama.ptrace_scope=0

# git tools

depot tools tutorial: https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html
# all my commits
https://chromium.googlesource.com/chromium/src/+log/master?author=atotic
# Log changes to a file
git log  -- third_party/WebKit/LayoutTests/TestExpectations
# Log actual changes in a file
git log -p filename
# Only Log changes for some specific lines in file
git log -L 1,1:some-file.txt

git show 529786f10d1317d79385fb9a36de848a6ae5048b -- file1.txt | git apply -

# clusterfuzz
ClusterFuzz-Ignore is the tag for ignoring

# commit stats
https://clstats.corp.google.com/?user=atotic&when=2020-08-18%3A2021-02-16&backend=chrome&tz=

# google docs debugging

append ?mode=canvas or ?mode=html to force the mode

# image compare:
compare -compose src old.png new.png diff.png

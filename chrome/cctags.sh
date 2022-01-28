#!/bin/bash
ctags --languages=C++ --exclude=third_party --exclude=.git --exclude=build --exclude=out --exclude=tools --exclude=mojo --exclude=base -R -f .tmp_tags
ctags --languages=C++ -a -R -f .tmp_tags third_party/blink
mv .tmp_tags .tags


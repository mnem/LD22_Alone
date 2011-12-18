#!/bin/bash
AUDIO_SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $AUDIO_SRC
ls *.wav | cut -d . -f 1 | xargs -I filename lame --preset 64 filename.wav ${AUDIO_SRC}/../../src/main/as3/embedded/filename.mp3


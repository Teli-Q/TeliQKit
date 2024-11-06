#!/bin/bash

export LC_CTYPE=en_US.UTF-8

xcodebuild clean docbuild -scheme TeliQKit \
    -destination generic/platform=macos \
    -skipPackagePluginValidation \
    OTHER_DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path TeliQKit --output-path ./docs"

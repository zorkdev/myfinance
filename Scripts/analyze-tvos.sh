#!/bin/bash

xcodebuild clean \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-tvOS

xcodebuild build \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-tvOS \
    -destination 'platform=tvOS Simulator,name=Apple TV 4K' \
    > build.log

/usr/local/bin/mint run swiftlint swiftlint analyze \
    --config .swiftlint_analyze.yml \
    --compiler-log-path build.log \
    --reporter emoji
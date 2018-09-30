#!/usr/bin/env bash

load lib

export PATH="$PWD:$PATH"

skip_unless_comprehensive_test() {
	[[ $CIRCLE_BRANCH = master ]] || skip
}

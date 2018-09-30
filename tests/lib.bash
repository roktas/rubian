#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Copy/paste and reformatted code from Dokku https://github.com/dokku/dokku.
# Below is the original (MIT) LICENSE:
#
#  Copyright (C) 2014 Jeff Lindsay
#
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and associated documentation files (the "Software"),
#  to deal in the Software without restriction, including without limitation
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,
#  and/or sell copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included
#  in all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
#  IN THE SOFTWARE.
# ------------------------------------------------------------------------------

flunk() {
	{
		if [[ $# -eq 0 ]]; then
			cat -
		else
			echo "$*"
		fi
	}
	return 1
}

# ShellCheck doesn't know about $status from Bats
# shellcheck disable=SC2154
# shellcheck disable=SC2120
assert_success() {
	if [[ $status -ne 0 ]]; then
		flunk "command failed with exit status $status"
	elif [[ $# -gt 0 ]]; then
		assert_output "$1"
	fi
}

assert_failure() {
	if [[ $status -eq 0 ]]; then
		flunk "expected failed exit status"
	elif [[ $# -gt 0 ]]; then
		assert_output "$1"
	fi
}

assert_equal() {
	if [[ $1 != "$2" ]]; then
		{
			echo "expected: $1"
			echo "actual:   $2"
		} | flunk
	fi
}

# ShellCheck doesn't know about $output from Bats
# shellcheck disable=SC2154
assert_output() {
	local expected
	if [[ $# -eq 0 ]]; then
		expected=$(cat -)
	else
		expected=$1
	fi
	assert_equal "$expected" "$output"
}

# ShellCheck doesn't know about $output from Bats
# shellcheck disable=SC2154
assert_output_contains() {
	local input=$output
	local expected=$1
	local count=${2:-1}
	local found=0

	until [[ ${input/$expected/} = "$input" ]]; do
		input=${input/$expected/}
		((found+=1))
	done

	assert_equal "$count" "$found"
}

# ShellCheck doesn't know about $lines from Bats
# shellcheck disable=SC2154
assert_line() {
	if [[ $1 -ge 0 ]] 2>/dev/null; then
		assert_equal "$2" "${lines[$1]}"
	else
		local line
		for line in "${lines[@]}"; do
			if [[ $line = "$1" ]]; then
				return 0
			fi
		done
		flunk "expected line '$1'"
	fi
}

refute_line() {
	if [[ $1 -ge 0 ]] 2>/dev/null; then
		local num_lines=${#lines[@]}
		if [[ $1 -lt "$num_lines" ]]; then
			flunk "output has $num_lines lines"
		fi
	else
		local line
		for line in "${lines[@]}"; do
			if [[ "$line" = "$1" ]]; then
				flunk "expected to not find line '$line'"
			fi
		done
	fi
}

assert() {
	if ! "$*"; then
		flunk "failed: $*"
	fi
}

assert_exit_status() {
	assert_equal "$status" "$1"
}

assert_start_with() {
	case $1 in
	$2*)
		return 0
		;;
	esac
	{
		echo "expected: $1"
		echo "actual:   $2"
	} | flunk
}

assert_line_start_with() {
	if [[ $1 -ge 0 ]] 2>/dev/null; then
		assert_start_with "${lines[$1]}" "$2"
	else
		local line
		for line in "${lines[@]}"; do
			case $line in
			$1*)
				continue
				;;
			esac
			flunk "expected line '$1'"
		done
	fi
}

assert_end_with() {
	case $1 in
	*$2)
		return 0
		;;
	esac
	{
		echo "expected: $1"
		echo "actual:   $2"
	} | flunk
}

assert_line_end_with() {
	if [[ $1 -ge 0 ]] 2>/dev/null; then
		assert_end_with "${lines[$1]}" "$2"
	else
		local line
		for line in "${lines[@]}"; do
			case $line in
			*$1)
				continue
				;;
			esac
			flunk "expected line '$1'"
		done
	fi
}

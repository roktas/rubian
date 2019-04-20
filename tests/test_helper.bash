#!/usr/bin/env bash

load lib

export PATH="$PWD:$PATH"

skip_unless_comprehensive_test() {
	[[ $CIRCLE_BRANCH = master ]] || skip
}

inject_ruby_stubs() {
	local stub

	for stub in ruby_depends ruby_fetch ruby_build; do
		eval -- "${stub}() { :; }"
	done

	webcat() {
		cat ./tests/index.txt
	}

	ruby_install() {
		local version=$1

		local prefix
		prefix=$(installation_prefix "$version")

		mkdir -p "$prefix/bin"
		touch "$prefix/$SHIBBOLETH"

		local prog

		# shellcheck disable=2154
		for prog in ruby "${ruby_slave_programs[@]}"; do
			local path=$prefix/bin/$prog
			cat >"$path" <<-PROG
				#!/bin/sh
				echo "$prog" "$version"
			PROG
			chmod +x "$path"
		done
	}
}

uninject_ruby_stubs() {
	rm -rf -- /opt/rubies

	local prog
	for prog in ruby "${ruby_slave_programs[@]}"; do
		rm -f "/usr/local/bin/$prog" "/etc/alternatives/$prog" "/var/lib/dpkg/alternatives/$prog"
	done
}

ensure_no_ruby() {
	command -v ruby "${ruby_slave_programs[@]}" &>/dev/null || return 0
}

bats_cry() {
	local arg

	for arg; do
		echo -e "\\e[1;38;5;11m$arg\\e[0m" >&3
	done
}

bats_die() {
	local arg

	for arg; do
		echo -e "\\e[1;38;5;198m$arg\\e[0m" >&3
	done

	exit 1
}

bats_see() {
	"$@" >&3 2>&3
}

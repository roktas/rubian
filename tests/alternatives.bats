#!/usr/bin/env bats

# Alternatives tests

load test_helper

inject_ruby_stubs() {
	local stub

	for stub in ruby_depends ruby_fetch ruby_build; do
		eval -- "${stub}() { :; }"
	done

	ruby_install() {
		local version=$1

		local prefix
		prefix=$(prefix "$version")

		mkdir -p "$prefix/bin"
		touch "$prefix/$SHIBBOLETH"

		local prog
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

setup() {
	export -f inject_ruby_stubs uninject_ruby_stubs ensure_no_ruby
}

teardown() {
	uninject_ruby_stubs
	unset -f inject_ruby_stubs uninject_ruby_stubs ensure_no_ruby
}

@test 'Calculating highest priority for typical suites' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		declare -Ag legacy=([version]=1.2.2)
		declare -Ag stable=([version]=1.2.3)
		declare -Ag unstable=([version]=1.2.4-preview2)

		main install legacy stable unstable &>/dev/null
		highest_priority_prefix
	EOF

	assert_success

	[[ ${lines[0]} = '/opt/rubies/1.2.3' ]]
}

@test 'Calculating highest priority for single preview version' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		declare -Ag unstable=([version]=1.2.4-preview2)

		main install unstable &>/dev/null
		highest_priority_prefix
	EOF

	assert_success

	[[ ${lines[0]} = '/opt/rubies/1.2.4-preview2' ]]
}

@test 'Calculating highest priority for preview versions only' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		declare -Ag stable=([version]=1.2.3-preview2)
		declare -Ag unstable=([version]=1.2.4-preview2)

		main install stable unstable &>/dev/null
		[[ -n $(highest_priority_prefix) ]] || echo none
	EOF

	assert_success

	[[ ${lines[0]:-} = 'none' ]]
}

@test 'Installing and uninstalling alternatives one by one' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		declare -Ag legacy=([version]=1.2.2)
		declare -Ag stable=([version]=1.2.3)
		declare -Ag unstable=([version]=1.2.4-preview2)

		main install unstable &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 1.2.4-preview2' ]]
	[[ ${lines[1]} = 'gem 1.2.4-preview2'  ]]

	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		declare -Ag legacy=([version]=1.2.2)
		declare -Ag stable=([version]=1.2.3)
		declare -Ag unstable=([version]=1.2.4-preview2)

		main install legacy &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 1.2.2' ]]
	[[ ${lines[1]} = 'gem 1.2.2'  ]]


	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		declare -Ag legacy=([version]=1.2.2)
		declare -Ag stable=([version]=1.2.3)
		declare -Ag unstable=([version]=1.2.4-preview2)

		main install stable &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 1.2.3' ]]
	[[ ${lines[1]} = 'gem 1.2.3'  ]]

	run bash -s <<-'EOF'
		. ./rubian

		main uninstall 1.2.3 &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 1.2.2' ]]
	[[ ${lines[1]} = 'gem 1.2.2'  ]]

	run bash -s <<-'EOF'
		. ./rubian

		main uninstall 1.2.2 &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 1.2.4-preview2' ]]
	[[ ${lines[1]} = 'gem 1.2.4-preview2'  ]]

	run bash -s <<-'EOF'
		. ./rubian

		main uninstall 1.2.4-preview2 &>/dev/null

		ensure_no_ruby
	EOF

	assert_success
}

@test 'Installing and uninstalling alternatives in bulk' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		declare -Ag legacy=([version]=1.2.2)
		declare -Ag stable=([version]=1.2.3)
		declare -Ag unstable=([version]=1.2.4-preview2)

		main install legacy stable unstable &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 1.2.3' ]]
	[[ ${lines[1]} = 'gem 1.2.3'  ]]

	run bash -s <<-'EOF'
		. ./rubian

		main uninstall 1.2.3 1.2.2 1.2.4-preview2 &>/dev/null

		ensure_no_ruby
	EOF

	assert_success
}

#!/usr/bin/env bats

# Initialization tests

load test_helper

setup() {
	export -f inject_ruby_stubs uninject_ruby_stubs ensure_no_ruby
	export -f bats_cry bats_die bats_see
}

teardown() {
	uninject_ruby_stubs
	unset -f inject_ruby_stubs uninject_ruby_stubs ensure_no_ruby
	unset -f bats_cry bats_die bats_see
}

@test 'Initializing version by prefix table' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		mkdir -p "$RUBIES/2.1.0"
		touch $_/.rubian

		mkdir -p "$RUBIES"/4.5.6

		load_installed 2>/dev/null

		echo ${#installed_version_by_prefix[@]}
		echo ${installed_version_by_prefix["$RUBIES/2.1.0"]}

		rm -rf -- "$RUBIES"
	EOF

	assert_success

	[[ ${lines[0]} = '1'     ]]
	[[ ${lines[1]} = '2.1.0' ]]
}

@test 'Initializing version by prefix table in the lack of signature' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		mkdir -p "$RUBIES/4.5.6"

		load_installed 2>/dev/null

		echo ${#installed_version_by_prefix[@]}

		rm -rf -- "$RUBIES"
	EOF

	assert_success

	[[ ${lines[0]} = '0' ]]
}

@test 'Initializing string by version table' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		load_available 2>/dev/null

		echo ${available_version_by_string[latest]}
	EOF

	assert_success

	[[ ${lines[0]} = '2.6.3' ]]
}

@test 'Support only >= 2.1.3' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		load_available 2>/dev/null

		echo ${available_version_by_string[2.0]:-none}
		echo ${available_version_by_string[2.1.0]:-none}
		echo ${available_version_by_string[2.1.1]:-none}
		echo ${available_version_by_string[2.1.2]:-none}
		echo ${available_version_by_string[2.1.3]:-none}
		echo ${available_version_by_string[2.1]:-none}
	EOF

	assert_success

	[[ ${lines[0]} = 'none'  ]]
	[[ ${lines[1]} = 'none'  ]]
	[[ ${lines[2]} = 'none'  ]]
	[[ ${lines[3]} = 'none'  ]]
	[[ ${lines[4]} = '2.1.3' ]]
	[[ ${lines[5]} = '2.1.9' ]]
}

#!/usr/bin/env bats

# Alternatives tests

load test_helper

setup() {
	export -f inject_ruby_stubs uninject_ruby_stubs ensure_no_ruby
}

teardown() {
	uninject_ruby_stubs
	unset -f inject_ruby_stubs uninject_ruby_stubs ensure_no_ruby
}

@test 'Calculating highest priority for typical versions' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		main install 2.2.0 2.2.1 2.3.0-preview1 &>/dev/null
		highest_priority_prefix
	EOF

	assert_success

	[[ ${lines[0]} = '/opt/rubies/2.2.1' ]]
}

@test 'Calculating highest priority for single preview version' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		main install 2.3.0-preview1 &>/dev/null
		highest_priority_prefix
	EOF

	assert_success

	[[ ${lines[0]} = '/opt/rubies/2.3.0-preview1' ]]
}

@test 'Calculating highest priority for preview versions only' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		main install 2.2.0-preview1 2.3.0-preview1 &>/dev/null
		[[ -n $(highest_priority_prefix) ]] || echo none
	EOF

	assert_success

	[[ ${lines[0]:-} = 'none' ]]
}

@test 'Installing and uninstalling alternatives one by one' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		main install 2.3.0-preview1 &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 2.3.0-preview1' ]]
	[[ ${lines[1]} = 'gem 2.3.0-preview1'  ]]

	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		main install 2.2.1 &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 2.2.1' ]]
	[[ ${lines[1]} = 'gem 2.2.1'  ]]


	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		main install 2.2.0 &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 2.2.0' ]]
	[[ ${lines[1]} = 'gem 2.2.0'  ]]

	run bash -s <<-'EOF'
		. ./rubian

		main uninstall 2.2.0 &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 2.2.1' ]]
	[[ ${lines[1]} = 'gem 2.2.1'  ]]

	run bash -s <<-'EOF'
		. ./rubian

		main uninstall 2.2.1 &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 2.3.0-preview1' ]]
	[[ ${lines[1]} = 'gem 2.3.0-preview1'  ]]

	run bash -s <<-'EOF'
		. ./rubian

		main uninstall 2.3.0-preview1 &>/dev/null

		ensure_no_ruby
	EOF

	assert_success
}

@test 'Installing and uninstalling alternatives in bulk' {
	run bash -s <<-'EOF'
		. ./rubian && inject_ruby_stubs

		declare -Ag legacy=([version]=2.2.1)
		declare -Ag stable=([version]=2.2.0)
		declare -Ag unstable=([version]=2.3.0-preview1)

		main install 2.2.1 2.2.0 2.3.0-preview1 &>/dev/null

		ruby
		gem
	EOF

	assert_success

	[[ ${lines[0]} = 'ruby 2.3.0-preview1' ]]
	[[ ${lines[1]} = 'gem 2.3.0-preview1'  ]]

	run bash -s <<-'EOF'
		. ./rubian

		main uninstall 2.2.0 2.2.1 2.3.0-preview1 &>/dev/null

		ensure_no_ruby
	EOF

	assert_success
}

#!/usr/bin/env bats

# Initialization tests

load test_helper

@test 'Initializing version by prefix table' {
	run bash -s <<-'EOF'
		. ./rubian

		mkdir -p "$RUBIES/1.2.3"
		touch $_/.rubian

		mkdir -p "$RUBIES"/4.5.6

		initialize

		echo ${#installed_version_by_prefix[@]}
		echo ${installed_version_by_prefix["$RUBIES/1.2.3"]}

		rm -rf -- "$RUBIES"
	EOF

	assert_success

	[[ ${lines[0]} = '1'     ]]
	[[ ${lines[1]} = '1.2.3' ]]
}

@test 'Initializing version by prefix table in the lack of signature' {
	run bash -s <<-'EOF'
		. ./rubian

		mkdir -p "$RUBIES/4.5.6"

		initialize

		echo ${#installed_version_by_prefix[@]}

		rm -rf -- "$RUBIES"
	EOF

	assert_success

	[[ ${lines[0]} = '0' ]]
}

@test 'Initializing suite  by version table' {
	run bash -s <<-'EOF'
		. ./rubian

		declare -Ag stable=([version]=1.2.3)

		initialize

		echo ${available_suite_by_version[1.2.3]}
	EOF

	assert_success

	[[ ${lines[0]} = 'stable' ]]
}

@test 'Initializing suite by version wrappers' {
	run bash -s <<-'EOF'
		. ./rubian

		declare -Ag stable=(
			[version]=1.2.3
			[major]=1.2
			[sha256]=ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
			[gem]=4.5.6
			[bundler]=7.8.9
		)

		initialize

		version_by_suite stable
		major_by_suite stable
		sha256_by_suite stable
		gem_by_suite stable
		bundler_by_suite stable

	EOF

	assert_success

	[[ ${lines[0]} = '1.2.3' ]]
	[[ ${lines[1]} = '1.2'   ]]
	[[ ${lines[2]} = 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff' ]]
	[[ ${lines[3]} = '4.5.6' ]]
	[[ ${lines[4]} = '7.8.9' ]]
}

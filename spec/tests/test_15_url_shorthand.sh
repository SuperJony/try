# URL shorthand tests
# Spec: command_line.md (clone shortcuts)

section "url-shorthand"

# Test: cd <url> acts as clone shorthand
output=$(try_run --path="$TEST_TRIES" --and-exit exec cd https://github.com/user/repo  2>&1)
if echo "$output" | grep -q "git clone"; then
    pass
else
    fail "cd <url> should trigger git clone" "git clone command" "$output" "command_line.md#clone"
fi

# Test: cd <url> with custom name
output=$(try_run --path="$TEST_TRIES" --and-exit exec cd https://github.com/user/repo my-fork 2>&1)
if echo "$output" | grep -q "my-fork"; then
    pass
else
    fail "cd <url> <name> should use custom name" "my-fork in output" "$output" "command_line.md#clone"
fi

# Test: bare URL (without cd) also triggers clone
output=$(try_run --path="$TEST_TRIES" --and-exit exec https://github.com/user/repo 2>&1)
if echo "$output" | grep -q "git clone"; then
    pass
else
    fail "bare URL should trigger git clone" "git clone command" "$output" "command_line.md#clone"
fi

# Test: GitHub tree page URL is normalized before cloning
output=$(try_run --path="$TEST_TRIES" --and-exit exec https://github.com/user/repo/tree/main 2>&1)
clone_line=$(echo "$output" | grep "^[[:space:]]*git clone")
if echo "$clone_line" | grep -q "git clone --branch 'main' 'https://github.com/user/repo'"; then
    pass
else
    fail "GitHub tree URL should clone the repository URL" "git clone --branch 'main' 'https://github.com/user/repo'" "$output" "command_line.md#clone"
fi

if echo "$clone_line" | grep -q "/tree/main"; then
    fail "GitHub tree path should not be passed to git clone" "no /tree/main in git clone line" "$output" "command_line.md#clone"
else
    pass
fi

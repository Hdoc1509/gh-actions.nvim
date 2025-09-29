unstable_message_regex='\w+(\(.*\))?:!'

last_tag=$(git describe --tags --abbrev=0)
breaking_changes_count=$(
  git log "$last_tag"..HEAD --oneline |
    grep --count --extended-regexp "$unstable_message_regex"
)

info_log "Major 0 release!\n"

trigger_release

# NOTE: uncomment to test
# breaking_changes_count=1

if [[ $breaking_changes_count -gt 0 ]]; then
  add_breaking_changes_message "patch"
fi

reminder_message

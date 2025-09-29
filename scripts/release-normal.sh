info_log "Normal release!\n"

trigger_release

breaking_changes_count=$(
  sed --quiet '5p' "$CHANGELOG_FILE" | grep --count "Major"
)

# NOTE: uncomment to test
# breaking_changes_count=1

if [[ $breaking_changes_count -gt 0 ]]; then
  add_breaking_changes_message "minor"
fi

reminder_message

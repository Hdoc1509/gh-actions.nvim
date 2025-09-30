breaking_change_message_file=$REPO_ROOT/scripts/breaking-change-message.tmpl.md

trigger_release() {
  if ! pnpm changeset version; then
    echo && error_log "Error while generating changelog!" && exit 1
  fi
}

add_breaking_changes_message() {
  local compatible_semver=$1
  local version_lazy
  local version_packer
  local major_v
  local major_minor_v

  if [[ $compatible_semver == "patch" ]]; then
    major_minor_v=$(cut --delimiter=. --fields=1,2 <<<"$PREVIOUS_VERSION")
    version_lazy="tag = 'v$major_minor_v.X'\` or \`version = '~$PREVIOUS_VERSION'"
    version_packer="tag = 'v$major_minor_v.*'"
  elif [[ $compatible_semver == "minor" ]]; then
    major_v=$(cut --delimiter=. --fields=1 <<<"$PREVIOUS_VERSION")
    version_lazy="tag = 'v$major_v.X.X'\` or \`version = '^$PREVIOUS_VERSION'"
    version_packer="tag = 'v$major_v.*.*'"
  else
    error_log "Invalid compatible semver: $compatible_semver" && exit 1
  fi

  echo && warn_log "Breaking changes detected!"
  info_log "Generating breaking change message..."

  sed -i "4r $breaking_change_message_file" "$CHANGELOG_FILE"
  sed -i "s/{{ compatible_semver }}/$compatible_semver/" "$CHANGELOG_FILE"
  sed -i "s/{{ version_lazy }}/$version_lazy/" "$CHANGELOG_FILE"
  sed -i "s/{{ version_packer }}/$version_packer/" "$CHANGELOG_FILE"
  sed -i "s/  \(Migrating\)/  #### \1/" "$CHANGELOG_FILE"
  sed -i "s/  \(Why\)/  #### \1/" "$CHANGELOG_FILE"

  success_log "Breaking changes message generated!"
}

reminder_message() {
  local new_version
  new_version=$(sed --quiet '3p' "$CHANGELOG_FILE" | awk '{ print $2 }')

  echo && warn_log "Don't forget to commit the changes:"
  command_snippet "git" "commit -m 'chore: release v$new_version'"
  echo && warn_log "Don't forget to generate git tags:"
  command_snippet "pnpm" "changeset tag"
}

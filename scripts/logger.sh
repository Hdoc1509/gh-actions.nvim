success_log() {
  tput setaf 34
  echo -e "[RELEASE]: $1"
  tput sgr0
}

error_log() {
  tput setaf 198
  echo -e "[RELEASE]: $1"
  tput sgr0
}

info_log() {
  tput setaf 111
  echo -e "[RELEASE]: $1"
  tput sgr0
}

warn_log() {
  tput setaf 141
  echo -e "[RELEASE]: $1"
  tput sgr0
}

command_snippet() {
  tput setaf 34
  echo -n "> "
  tput setaf 111
  echo -n "$1 "
  tput setaf 75
  echo "$2"
  tput sgr0
}

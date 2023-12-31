#!/bin/bash

export NODE_OPTIONS=--openssl-legacy-provider

MODE_ENC=("aes-128-cbc" "aes-192-cbc" "aes-256-cbc" "aes-128-cbc_base64" "aes-192-cbc_base64" \
"aes-256-cbc_base64" "aes-128-cbc_zlib" "aes-192-cbc_zlib" "aes-256-cbc_zlib" "aria-128-cbc" \
"aria-192-cbc" "aria-256-cbc" "base64" "camellia-128-cbc" "camellia-192-cbc" "camellia-256-cbc" \
"ccrypt" "des" "des-cbc" "des-ede" "des-ede-cbc" "des-ede3" "des-ede3-cbc" "des3" "desx" "desx-cbc" \
"gcrypt" "sm4" "sm4-cbc" "zlib")
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo null)

# The [[ -t 1 ]] check only works when the function is not called from
# a subshell (like in `$(...)` or `(...)`, so this hack redefines the
# function at the top level to always return false when stdout is not
# a tty.
if [[ -t 1 ]]; then
  is_tty() {
    true
  }
else
  is_tty() {
    false
  }
fi

setup_color() {
  # Only use colors if connected to a terminal
  if ! is_tty; then
    BLACK=""
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    MAGENTA=""
    CYAN=""
    WHITE=""
    BOLD=""
    ITALIC=""
    UNDERLINE=""
    RESET=""
    return
  fi

  BLACK=$(printf '\033[90m')
  RED=$(printf '\033[91m')
  GREEN=$(printf '\033[92m')
  YELLOW=$(printf '\033[93m')
  BLUE=$(printf '\033[94m')
  MAGENTA=$(printf '\033[95m')
  CYAN=$(printf '\033[96m')
  WHITE=$(printf '\033[97m')
  BOLD=$(printf '\033[1m')
  ITALIC=$(printf '\033[3m')
  UNDERLINE=$(printf '\033[4m')
  RESET=$(printf '\033[0m')
}

info() {
  echo "${RESET}${BOLD}${GREEN}Info:${WHITE} $@${RESET}"
}

error() {
  echo "${RESET}${BOLD}${RED}Error: $@${RESET}"
}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

banner() {
  echo "${RESET}${BOLD}${RED}╔═════════════════════════════════════════════════════════╗
║${YELLOW}        ┏━┓╻ ╻┏━╸╻  ╻     ┏━╸┏━┓┏┳┓┏━┓╻╻  ┏━╸┏━┓         ${RED}║
║${YELLOW}        ┗━┓┣━┫┣╸ ┃  ┃  ╺━╸┃  ┃ ┃┃┃┃┣━┛┃┃  ┣╸ ┣┳┛         ${RED}║
║${YELLOW}        ┗━┛╹ ╹┗━╸┗━╸┗━╸   ┗━╸┗━┛╹ ╹╹  ╹┗━╸┗━╸╹┗╸         ${RED}║
╚═════════════════════════════════════════════════════════╝
${CYAN}  Author : ${WHITE}Barudak Rosul
${CYAN}  Version: ${WHITE}$VERSION
${CYAN}  GitHub : ${WHITE}${UNDERLINE}https://github.com/BarudakRosul${RESET}"
}

main_menu_type_shell() {
  trap "echo; error 'Program cancelled!'; exit 127;" INT TERM ERR

  clear
  banner
  echo "${RESET}${BOLD}${RED}╔═════════════════════════════════════════════════════════╗
║${YELLOW}          Choose your type shell for encrypted           ${RED}║
╚═════════════════════════════════════════════════════════╝
${GREEN}  1. ${WHITE}bash (Bourne Again Shell)
${GREEN}  2. ${WHITE}sh (Bourne Shell)
${GREEN}  3. ${WHITE}zsh (Z Shell)
${GREEN}  4. ${WHITE}ksh (Korn Shell)
${GREEN}  5. ${WHITE}mksh (MirBSD Korn Shell)
${RED}  0. Exit
╔═════════════════════════════════════════════════════════╗
╚═════════════════════════════════════════════════════════╝"
  read -p "${RESET}${BOLD}${WHITE}Choose ${GREEN}>>${RESET} " response
  case $response in
    0 | 00) info "The program exited by user!"; exit 0;;
    1 | 01) TYPE_SHELL="bash";;
    2 | 02) TYPE_SHELL="sh";;
    3 | 03) TYPE_SHELL="zsh";;
    4 | 04) TYPE_SHELL="ksh";;
    5 | 05) TYPE_SHELL="mksh";;
    "" | " ") error "Please select a menus!"; exit 1;;
    *) error "Wrong input! Please try again!"; exit 1;;
  esac

  trap - INT TERM ERR
}

main_menu_mode() {
  trap "echo; error 'Program cancelled!'; exit 127;" INT TERM ERR

  local response
  local number
  local space
  clear
  banner
  echo "${RESET}${BOLD}${RED}╔═════════════════════════════════════════════════════════╗
║${YELLOW}            Choose your mode for encrypted               ${RED}║
╚═════════════════════════════════════════════════════════╝${RESET}"
  for ((i=0;i<${#MODE_ENC[@]};i++)); do
    number=$((i + 1))
    space=""
    if (( 1 == ${#number} )); then
      space=" "
    fi
    mode=$(printf "${MODE_ENC[i]}" | sed 's/_zlib/ (zlib)/' | sed 's/_base64/ (base64)/')
    echo "${RESET}${BOLD}${GREEN} ${space}$((number)). ${WHITE}$mode${RESET}"
  done
  echo "${RESET}${BOLD}${RED}  0. Exit
╔═════════════════════════════════════════════════════════╗
╚═════════════════════════════════════════════════════════╝${RESET}"
  read -p "${RESET}${BOLD}${WHITE}Choose ${GREEN}>>${RESET} " response
  if (( ${#response} == 2 )); then
    response=${response##0}
  fi
  if (( $response > ${#MODE_ENC[@]} )); then
    error "Wrong input! Please try again!"
    exit 1
  fi
  case $response in
    0 | 00) info "The program exited by user!"; exit 0;;
    [0-9] | [0-9][0-9]) MODE=${MODE_ENC[response - 1]};;
    "" | " ") error "Please select a menus!"; exit 1;;
    *) error "Wrong input! Please try again!"; exit 1;;
  esac

  trap - INT TERM ERR
}

main_menu_input_file() {
  trap "echo; error 'Program cancelled!'; exit 127;" INT TERM ERR

  clear
  banner
  mode=$(printf "$MODE" | sed 's/_zlib/ (zlib)/' | sed 's/_base64/ (base64)/')
  echo "${RESET}${BOLD}${RED}╔═════════════════════════════════════════════════════════╗
║${YELLOW}      Input your file in \"file\" folder for encrypt       ${RED}║
╚═════════════════════════════════════════════════════════╝
${WHITE}  File type   : ${GREEN}${UNDERLINE}$TYPE_SHELL${RESET}${BOLD}
${WHITE}  Encrypt mode: ${GREEN}${UNDERLINE}$mode${RESET}${BOLD}
${RED}╔═════════════════════════════════════════════════════════╗
╚═════════════════════════════════════════════════════════╝${RESET}"
  read -p "${RESET}${BOLD}${WHITE}Script ${GREEN}>>${RESET} " input

  if [[ $input == "" || $input == " " ]]; then
    error "Please input your file name!"
    exit 1
  elif ! [[ -f file/$input || -r file/$input ]]; then
    error "No such file \"$input\" in directory \"file\""
    exit 1
  elif [[ -f out/$input || -r out/$input ]]; then
    error "The file \"$input\" is already compressed!"
    exit 1
  fi

  INPUT=$input

  trap - INT TERM ERR
}

main() {
  setup_color
  main_menu_type_shell
  main_menu_mode
  main_menu_input_file
  bash lib/${MODE}.sh -t ${TYPE_SHELL} -i file/${INPUT} -o out/${INPUT}
}

setup_color

for ((i=0;i<${#MODE_ENC[@]};i++)); do
  test -f lib/${MODE_ENC[i]}.sh && test -r lib/${MODE_ENC[i]}.sh || {
    error "Some files are missing!"
    info "Please install the script from github <https://github.com/BarudakRosul/shell-compiler>"
    exit 1
  }
done

command_exists ncssl || {
  error "The program \`ncssl' is not installed."
  info "Please installed the program and try again."
  exit 127
}

 command_exists ccrypt || {
  error "The program \`ccrypt' is not installed."
  info "Please installed the program and try again."
  exit 127
}

 command_exists gcrypt || {
  error "The program \`gcrypt' is not installed."
  info "Please installed the program and try again."
  exit 127
}

main

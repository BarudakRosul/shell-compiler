#!/bin/bash

install_pkg_on_termux() {
  pkg update -y && pkg upgrade -y
  pkg install git xz-utils jq ccrypt nodejs -y

  # Install package ncssl
  npm -g install @fajarkim/node-openssl-enc

  # Install package gcrypt
  npm -g install @barudakrosul/gcrypt
}

install_pkg_on_linux() {
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install git xz-utils jq ccrypt nodejs -y

  # Check package npm is installed or not
  npm --version 2>&1 >/dev/null || sudo apt install npm -y

  # Install package ncssl
  npm -g install @fajarkim/node-openssl-enc

  # Install package gcrypt
  npm -g install @barudakrosul/gcrypt
}

case $HOME in
  */com.termux/*) install_pkg_on_termux;;
  *) install_pkg_on_linux;;
esac

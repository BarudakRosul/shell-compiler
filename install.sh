#!/bin/bash

install_pkg_on_termux() {
  pkg update -y && pkg upgrade -y
  pkg install git openssl-tool xz-utils jq ccrypt nodejs -y
  npm -g install @barudakrosul/gcrypt
}

install_pkg_on_linux() {
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install build-essential checkinstall zlib1g-dev tar wget git xz-utils jq ccrypt nodejs make -y
  cd /usr/local/src
  sudo wget https://www.openssl.org/source/openssl-3.2.0.tar.gz
  sudo tar -xf openssl-3.2.0.tar.gz
  cd openssl-3.2.0
  sudo ./config linux-elf --prefix=/usr/local/ssl --openssldir=/usr/local/ssl zlib enable-zstd zlib-dynamic enable-zstd-dynamic shared
  sudo make && sudo make install
  cd
  npm -g install @barudakrosul/gcrypt
  openssl version
  openssl
}

case $HOME in
  */com.termux/*) install_pkg_on_termux;;
  *) install_pkg_on_linux;;
esac

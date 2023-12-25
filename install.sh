#!/bin/bash

install_pkg_on_termux() {
  pkg update -y && pkg upgrade -y
  pkg install build-essential openssl openssl-tool zlib zlib-static git xz-utils jq ccrypt nodejs make clang perl -y
  cd
  wget https://www.openssl.org/source/openssl-3.2.0.tar.gz
  tar -xf openssl-3.2.0.tar.gz
  cd openssl-3.2.0
  ./config --prefix=$PREFIX --openssldir=$PREFIX zlib enable-zstd zlib-dynamic enable-zstd-dynamic shared
  make && make install
  cd
  npm -g install @barudakrosul/gcrypt
}

install_pkg_on_linux() {
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install build-essential checkinstall zlib1g-dev tar wget openssl git xz-utils jq ccrypt nodejs make clang perl -y
  cd /usr/local/src
  sudo wget https://www.openssl.org/source/openssl-3.2.0.tar.gz
  sudo tar -xf openssl-3.2.0.tar.gz
  cd openssl-3.2.0
  sudo ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl zlib enable-zstd zlib-dynamic enable-zstd-dynamic shared
  sudo make && sudo make install
  cd
  npm -g install @barudakrosul/gcrypt
}

case $HOME in
  */com.termux/*) install_pkg_on_termux;;
  *) install_pkg_on_linux;;
esac

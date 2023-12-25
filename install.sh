#!/bin/bash

install_pkg_on_termux() {
  pkg update -y && pkg upgrade -y
  pkg install git openssl-tool xz-utils jq ccrypt nodejs -y
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
  cd /etc/ld.so.conf.d/
  echo '/usr/local/ssl/lib64' > openssl-3.2.0.conf
  sudo ldconfig -v
  mv /usr/bin/c_rehash /usr/bin/c_rehash.bak
  mv /usr/bin/openssl /usr/bin/openssl.bak
  echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/ssl/bin"' > /etc/environment
  source /etc/environment
  cd
  npm -g install @barudakrosul/gcrypt
}

case $HOME in
  */com.termux/*) install_pkg_on_termux;;
  *) install_pkg_on_linux;;
esac

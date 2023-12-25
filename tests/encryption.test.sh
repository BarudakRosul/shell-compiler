#!/bin/bash
set -e

MODE_ENC=("aes-128-cbc" "aes-192-cbc" "aes-256-cbc" "aes-128-cbc_base64" "aes-192-cbc_base64" \
"aes-256-cbc_base64" "aes-128-cbc_zlib" "aes-192-cbc_zlib" "aes-256-cbc_zlib" "aria-128-cbc" \
"aria-192-cbc" "aria-256-cbc" "base64" "camellia-128-cbc" "camellia-192-cbc" "camellia-256-cbc" \
"ccrypt" "des-ede" "des-ede3" "des-ede-cbc" "des-ede3-cbc" "gcrypt" "zlib")

rm -rf file/* out/*
echo "[!] Testing code for bash script file"

for ((i=0;i<${#MODE_ENC[@]};i++)); do
  # Skip test for using zlib mode if openssl is version 3.0.*
  if openssl version | grep -i 3.0 >/dev/null 2>&1; then
    if echo "${MODE_ENC[i]}" | grep -i zlib >/dev/null 2>&1; then
      continue
    fi
  fi
  cat <<'EOF' > file/example-${MODE_ENC[i]}.sh
#!/bin/bash
echo "Hello world!"
EOF
  echo "> Check encryption with mode ${MODE_ENC[i]}"
  bash lib/${MODE_ENC[i]}.sh -t bash -i file/example-${MODE_ENC[i]}.sh -o out/example-${MODE_ENC[i]}.sh || exit $?
  echo "> Run the encrypted script file"
  bash out/example-${MODE_ENC[i]}.sh || exit $?
  echo
done

rm -rf file/* out/*
echo "[!] Testing code for sh script file"

for ((i=0;i<${#MODE_ENC[@]};i++)); do
  # Skip test for using zlib mode if openssl is version 3.0.*
  if openssl version | grep -i 3.0 >/dev/null 2>&1; then
    if echo "${MODE_ENC[i]}" | grep -i zlib >/dev/null 2>&1; then
      continue
    fi
  fi
  cat <<'EOF' > file/example-${MODE_ENC[i]}.sh
#!/bin/sh
echo "Hello world!"
EOF
  echo "> Check encryption with mode ${MODE_ENC[i]}"
  bash lib/${MODE_ENC[i]}.sh -t sh -i file/example-${MODE_ENC[i]}.sh -o out/example-${MODE_ENC[i]}.sh || exit $?
  echo "> Run the encrypted script file"
  sh out/example-${MODE_ENC[i]}.sh || exit $?
  echo
done

rm -rf file/* out/*
echo "[!] Testing code for zsh script file"

for ((i=0;i<${#MODE_ENC[@]};i++)); do
  # Skip test for using zlib mode if openssl is version 3.0.*
  if openssl version | grep -i 3.0 >/dev/null 2>&1; then
    if echo "${MODE_ENC[i]}" | grep -i zlib >/dev/null 2>&1; then
      continue
    fi
  fi
  cat <<'EOF' > file/example-${MODE_ENC[i]}.sh
#!/bin/zsh
echo "Hello world!"
EOF
  echo "> Check encryption with mode ${MODE_ENC[i]}"
  bash lib/${MODE_ENC[i]}.sh -t zsh -i file/example-${MODE_ENC[i]}.sh -o out/example-${MODE_ENC[i]}.sh || exit $?
  echo "> Run the encrypted script file"
  zsh out/example-${MODE_ENC[i]}.sh || exit $?
  echo
done

rm -rf file/* out/*
echo "[!] Testing code for ksh script file"

for ((i=0;i<${#MODE_ENC[@]};i++)); do
  # Skip test for using zlib mode if openssl is version 3.0.*
  if openssl version | grep -i 3.0 >/dev/null 2>&1; then
    if echo "${MODE_ENC[i]}" | grep -i zlib >/dev/null 2>&1; then
      continue
    fi
  fi
  cat <<'EOF' > file/example-${MODE_ENC[i]}.sh
#!/bin/ksh
echo "Hello world!"
EOF
  echo "> Check encryption with mode ${MODE_ENC[i]}"
  bash lib/${MODE_ENC[i]}.sh -t ksh -i file/example-${MODE_ENC[i]}.sh -o out/example-${MODE_ENC[i]}.sh || exit $?
  echo "> Run the encrypted script file"
  ksh out/example-${MODE_ENC[i]}.sh || exit $?
  echo
done

rm -rf file/* out/*
echo "[!] Testing code for mksh script file"

for ((i=0;i<${#MODE_ENC[@]};i++)); do
  # Skip test for using zlib mode if openssl is version 3.0.*
  if openssl version | grep -i 3.0 >/dev/null 2>&1; then
    if echo "${MODE_ENC[i]}" | grep -i zlib >/dev/null 2>&1; then
      continue
    fi
  fi
  cat <<'EOF' > file/example-${MODE_ENC[i]}.sh
#!/bin/bash
echo "Hello world!"
EOF
  echo "> Check encryption with mode ${MODE_ENC[i]}"
  bash lib/${MODE_ENC[i]}.sh -t mksh -i file/example-${MODE_ENC[i]}.sh -o out/example-${MODE_ENC[i]}.sh || exit $?
  echo "> Run the encrypted script file"
  mksh out/example-${MODE_ENC[i]}.sh || exit $?
  echo
done

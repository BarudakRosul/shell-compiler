#!/bin/bash
set -e

export NODE_OPTIONS=--openssl-legacy-provider

MODE_ENC=("aes-128-cbc" "aes-192-cbc" "aes-256-cbc" "aes-128-cbc_base64" "aes-192-cbc_base64" \
"aes-256-cbc_base64" "aes-128-cbc_zlib" "aes-192-cbc_zlib" "aes-256-cbc_zlib" "aria-128-cbc" \
"aria-192-cbc" "aria-256-cbc" "base64" "camellia-128-cbc" "camellia-192-cbc" "camellia-256-cbc" \
"ccrypt" "des" "des-cbc" "des-ede" "des-ede-cbc" "des-ede3" "des-ede3-cbc" "des3" "desx" "desx-cbc" \
"gcrypt" "sm4" "sm4-cbc" "zlib")

rm -rf file/* out/*
echo "[!] Testing code for bash script file"

for ((i=0;i<${#MODE_ENC[@]};i++)); do
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
  cat <<'EOF' > file/example-${MODE_ENC[i]}.sh
#!/bin/mksh
echo "Hello world!"
EOF
  echo "> Check encryption with mode ${MODE_ENC[i]}"
  bash lib/${MODE_ENC[i]}.sh -t mksh -i file/example-${MODE_ENC[i]}.sh -o out/example-${MODE_ENC[i]}.sh || exit $?
  echo "> Run the encrypted script file"
  mksh out/example-${MODE_ENC[i]}.sh || exit $?
  echo
done

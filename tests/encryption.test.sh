#!/bin/bash
set -e

MODE_ENC=("aes-128-cbc" "aes-192-cbc" "aes-256-cbc" "aria-128-cbc" "aria-192-cbc" "aria-256-cbc" \
"base64" "camellia-128-cbc" "camellia-192-cbc" "camellia-256-cbc" "zlib")

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

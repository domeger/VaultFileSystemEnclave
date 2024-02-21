set -eo pipefail

anjuna-nitro-netd-parent \
  --enclave-name "vault" --expose 8200 --daemonize

# Wait for the network daemon(s) to start
sleep 2

anjuna-nitro-cli run-enclave \
  --enclave-name "vault" \
  --cpu-count 2 \
  --memory 1024 \
  --eif-path vault.eif \
  --debug-mode




docker build . -t vault

anjuna-nitro-cli build-enclave \
  --docker-uri vault \
  --enclave-config-file enclave-config.yaml \
  --output-file vault.eif | tee arc-build.log



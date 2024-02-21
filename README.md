[![GitHub Release](https://img.shields.io/github/release/dani-garcia/vaultwarden.svg)](https://github.com/domeger/Anjuna-VaultWithConsul/releases/latest)
[![GPL-3.0 Licensed](https://img.shields.io/github/license/dani-garcia/vaultwarden.svg)](https://www.gnu.org/licenses/gpl-3.0.txt)

# Anjuna Security: Hashicorp Vault

**Requirements:** Amazon AMI\
**Technologies:** Vault, Anjuna Runtime, and Docker\
**Instance Type:** m5.xlarge or higher instance

# Instance Preparation 
Complete the steps in our docs to be able to complete this step by step setup of Vault with Consul storage.

![1]([https://github.com/domeger/Anjuna-VaultWithConsul/main/1.png](https://github.com/domeger/VaultFileSystemEnclave/blob/main/1.png))

[![2](https://github.com/domeger/Anjuna-VaultWithConsul/main/2.png)](https://github.com/domeger/VaultFileSystemEnclave/blob/main/1.png)

[![3](https://github.com/domeger/Anjuna-VaultWithConsul/main/3.png)](https://github.com/domeger/VaultFileSystemEnclave/blob/main/1.png)

[![4](https://github.com/domeger/Anjuna-VaultWithConsul/main/4.png)](https://github.com/domeger/VaultFileSystemEnclave/blob/main/1.png)

**Getting Started:**

**Step 1:**

Run the following commands:

`./build.sh`

`./run.sh`

**Step 2:**

# Vault Client Setup
**Step 1:**
`sudo yum install -y yum-utils`

**Step 2:**
`sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo`

**Step 3:**
`sudo yum -y install vault`

# Vault Setup (Sealed Version)

**Step 3:**
We will than verify the enclave is running.
`anjuna-nitro-cli describe-enclaves | jq`

![Nitro Status](https://github.com/domeger/Anjuna-VaultWithConsul/blob/main/EnclaveStatus.png)

**Step 4:**
Verify you can communicate with your Vault instance
```
curl -s http://localhost:8200/v1/sys/health | jq -r 
export VAULT_ADDR='http://localhost:8200'
export VAULT_TOKEN=
vault status
```

![Vault Status](https://github.com/domeger/Anjuna-VaultWithConsul/blob/main/VaultStatus.png)

**Step 5:**
Initialize the Vault Repo and make sure you copy the keys that are display on your screen, these will be necessary to unseal vault to access it.

```vault operator init```


**Optional:**
Terminate the instance if your done testing.

`anjuna-nitro-cli terminate-enclave`

# Copying or Reusing

This project has mixed licencing. You are free to copy, redistribute and/or modify aspects of this work under the terms of each licence accordingly (unless otherwise specified).

Included scripts are free software licenced under the terms of the [GNU General Public License, version 3](https://www.gnu.org/licenses/gpl-3.0.txt).

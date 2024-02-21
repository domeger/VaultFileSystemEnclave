[![GitHub Release](https://img.shields.io/github/release/dani-garcia/vaultwarden.svg)](https://github.com/domeger/Anjuna-VaultWithConsul/releases/latest)
[![GPL-3.0 Licensed](https://img.shields.io/github/license/dani-garcia/vaultwarden.svg)](https://www.gnu.org/licenses/gpl-3.0.txt)

# Anjuna Security: Hashicorp Vault

**Requirements:** Amazon AMI\
**Technologies:** Vault, Anjuna Runtime, and Docker\
**Instance Type:** m5.xlarge or higher instance

# Instance Preparation 

**Create Your EC2 Instance Using the Following:**

![Nitro 1](https://github.com/domeger/VaultFileSystemEnclave/blob/main/1.png)
![Nitro 2](https://github.com/domeger/VaultFileSystemEnclave/blob/main/2.png)
![Nitro 3](https://github.com/domeger/VaultFileSystemEnclave/blob/main/3.png)
![Nitro 4](https://github.com/domeger/VaultFileSystemEnclave/blob/main/4.png)

**Getting Started:**

**Step 1:**

Run the following commands:

Go into your install.sh and replace <apikey> with your API key from the [Anjuna Resource Center](https://downloads.anjuna.io)

`./install.sh`

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

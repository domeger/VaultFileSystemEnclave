set -eo pipefail

if [ -f .env ]; then
export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

cat << "EOF"
 ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄     ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌   ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌     ▐░▌ ▀▀▀▀▀█░█▀▀▀ ▐░▌       ▐░▌▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌    ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌
▐░▌       ▐░▌▐░▌▐░▌    ▐░▌      ▐░▌    ▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌       ▐░▌        ▐░▌     ▐░▌       ▐░▌
▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▌   ▐░▌      ▐░▌    ▐░▌       ▐░▌▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄█░▌        ▐░▌     ▐░▌       ▐░▌
▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌      ▐░▌    ▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌        ▐░▌     ▐░▌       ▐░▌
▐░█▀▀▀▀▀▀▀█░▌▐░▌   ▐░▌ ▐░▌      ▐░▌    ▐░▌       ▐░▌▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀█░▌        ▐░▌     ▐░▌       ▐░▌
▐░▌       ▐░▌▐░▌    ▐░▌▐░▌      ▐░▌    ▐░▌       ▐░▌▐░▌    ▐░▌▐░▌▐░▌       ▐░▌        ▐░▌     ▐░▌       ▐░▌
▐░▌       ▐░▌▐░▌     ▐░▐░▌ ▄▄▄▄▄█░▌    ▐░█▄▄▄▄▄▄▄█░▌▐░▌     ▐░▐░▌▐░▌       ▐░▌ ▄  ▄▄▄▄█░█▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌
▐░▌       ▐░▌▐░▌      ▐░░▌▐░░░░░░░▌    ▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░▌       ▐░▌▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
 ▀         ▀  ▀        ▀▀  ▀▀▀▀▀▀▀      ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀         ▀  ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ 
EOF

echo "Installing AWS Linux Extra"
echo "---------------------------"
sudo amazon-linux-extras install -y aws-nitro-enclaves-cli
echo "Installing AWS Nitro Dev and OpenSSL Env"
sudo yum install -y aws-nitro-enclaves-cli-devel jq openssl11-libs
sleep 1

echo "Modifying EC2 User"
echo "---------------------------"
sudo usermod -aG ne ec2-user
echo "Adding EC2-USER to Docker Group"
sudo usermod -aG docker ec2-user
sleep 1

echo "Installing AWS Nitro Runtime"
echo "---------------------------"
wget https://api.downloads.anjuna.io/v1/releases/anjuna-nitro-runtime.1.36.0003.tar.gz \
--header="X-Anjuna-Auth-Token:<api-token>"

sudo mkdir -p /opt/anjuna/nitro
sudo tar -xvoz -C /opt/anjuna/nitro -f anjuna-nitro-runtime.1.36.0003.tar.gz

echo "Installing AWS Nitro Runtime License"
echo "---------------------------"
cd /opt/anjuna/
sudo wget https://api.downloads.anjuna.io/v1/releases/license/nitro/license.yaml \
--header="X-Anjuna-Auth-Token:<api-token>"

echo "Installing Docker"
echo "---------------------------"
sudo yum install -y docker
sleep 1

echo "Enable Docker"
echo "---------------------------"
sudo systemctl enable docker
sleep 1

echo "Enable Kernel Module"
echo "---------------------------"
echo 'KERNEL=="vsock", MODE="660", GROUP="ne"' | sudo tee /etc/udev/rules.d/51-vsock.rules
sleep 1

echo "Reloading UDEVADM" 
echo "---------------------------"
sudo udevadm control --reload

echo "Trigger UDEVADM"
echo "---------------------------"
sudo udevadm trigger
sleep 1

echo "Change Allocator Memory"
echo "---------------------------"
sudo sed -i 's/^memory_mib:.*/memory_mib: '8192/'' /etc/nitro_enclaves/allocator.yaml
sleep 1

echo "Change Allocator CPU"
echo "---------------------------"
sudo sed -i 's/^cpu_count:.*/cpu_count: '2/'' /etc/nitro_enclaves/allocator.yaml
sleep 1

echo "Starting Allocator"
echo "---------------------------"
sudo systemctl restart nitro-enclaves-allocator.service
sleep 1

echo "Enable Allocator" 
echo "---------------------------"
sudo systemctl enable nitro-enclaves-allocator.service
sleep 1

echo "Start and Enable Docker"
echo "---------------------------"
sudo systemctl restart docker && sudo systemctl enable docker
sleep 1

echo "Net Cap Enabled"
echo "---------------------------"
sudo setcap cap_net_bind_service=+ep /opt/anjuna/nitro/bin/anjuna-nitro-netd-parent
sleep 1

echo "Create Log Directory"
echo "---------------------------"
sudo mkdir -p /var/log/nitro_enclaves
sudo chown $(whoami):$(whoami) /var/log/nitro_enclaves/
sleep 1

echo "Export Variables"
echo "---------------------------"
echo 'export PATH=$PATH:/opt/anjuna/nitro/bin' >> ~/.bash_profile
source ~/.bash_profile
sleep 1

if [ "$#" -eq 0 ]; then
  exec sudo su -l $USER
fi

echo -e "\033[32mCompleted installation \u2713\033[0m\n\nYou may now use the Anjuna Nitro Runtime!

Note: you may need to cd back to the dir you downloaded the quickstart into.

Continue by running ./build.sh"
echo -ne '
'


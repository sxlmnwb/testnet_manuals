#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#    NEED PRIVILEGE ACCESS root:x:0:0:root:/root:/bin/bash
#

echo ""
if [ $(/usr/bin/id -u) -ne 0 ]; then
    echo "[!] NEED PRIVILEGE ACCESS root:x:0:0:root:/root:/bin/bash";
    echo "[!] TYPE 'sudo bash install.sh'";
    echo ""
exit 1
fi

v=0.12.0

echo "  ██████ ▒██   ██▒ ██▓     ███▄ ▄███▓ ███▄    █  █     █░▓█████▄ ";
echo "▒██    ▒ ▒▒ █ █ ▒░▓██▒    ▓██▒▀█▀ ██▒ ██ ▀█   █ ▓█░ █ ░█▒██▒ ▄██░";
echo "░ ▓██▄   ░░  █   ░▒██░    ▓██    ▓██░▓██  ▀█ ██▒▒█░ █ ░█ ▒██░█▀  ";
echo "  ▒   ██▒ ░ █ █ ▒ ▒██░    ▒██    ▒██ ▓██▒  ▐▌██▒░█░ █ ░█ ░▓█  ▀█▓";
echo "▒██████▒▒▒██▒ ▒██▒░██████▒▒██▒   ░██▒▒██░   ▓██░░░██▒██▓ ░▒▓███▀▒";
echo "▒ ▒▓▒ ▒ ░▒▒ ░ ░▓ ░░ ▒░▓  ░░ ▒░   ░  ░░ ▒░   ▒ ▒ ░ ▓░▒ ▒  ▒░▒   ░ ";
echo "░ ░▒  ░ ░░░   ░▒ ░░ ░ ▒  ░░  ░      ░░ ░░   ░ ▒░  ▒ ░ ░   ░    ░ ";
echo "░  ░  ░   ░    ░    ░ ░   ░      ░      ░   ░ ░   ░   ░ ░        ";
echo "      ░   ░    ░      ░  ░       ░            ░     ░          ░ ";
echo "           Dusk Network - Wallet CLI Installer v$v               ";
echo ""
sleep 1

# Update
sudo apt-get update

# Package
sudo apt-get install tar wget curl -y

cd $HOME
wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb

# Update Package
sudo apt-get update
sudo apt install libssl-dev -y

# Get Wallet
wget -q "https://github.com/dusk-network/wallet-cli/releases/download/v$v/ruskwallet$v-linux-x64.tar.gz"
tar -xf "ruskwallet$v-linux-x64.tar.gz"
rm -rf "ruskwallet$v-linux-x64.tar.gz"
cd "rusk-wallet$v-linux-x64"
./rusk-wallet

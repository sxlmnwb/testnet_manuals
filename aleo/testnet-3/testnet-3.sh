#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#    NEED PRIVILEGE ACCESS root:x:0:0:root:/root:/bin/bash
#

echo ""
if [ $(/usr/bin/id -u) -ne 0 ]; then
    echo "[!] NEED PRIVILEGE ACCESS root:x:0:0:root:/root:/bin/bash";
    echo "[!] TYPE 'sudo bash testnet-3.sh'";
    echo ""
exit 1
fi

echo "  ██████ ▒██   ██▒ ██▓     ███▄ ▄███▓ ███▄    █  █     █░▓█████▄ ";
echo "▒██    ▒ ▒▒ █ █ ▒░▓██▒    ▓██▒▀█▀ ██▒ ██ ▀█   █ ▓█░ █ ░█▒██▒ ▄██░";
echo "░ ▓██▄   ░░  █   ░▒██░    ▓██    ▓██░▓██  ▀█ ██▒▒█░ █ ░█ ▒██░█▀  ";
echo "  ▒   ██▒ ░ █ █ ▒ ▒██░    ▒██    ▒██ ▓██▒  ▐▌██▒░█░ █ ░█ ░▓█  ▀█▓";
echo "▒██████▒▒▒██▒ ▒██▒░██████▒▒██▒   ░██▒▒██░   ▓██░░░██▒██▓ ░▒▓███▀▒";
echo "▒ ▒▓▒ ▒ ░▒▒ ░ ░▓ ░░ ▒░▓  ░░ ▒░   ░  ░░ ▒░   ▒ ▒ ░ ▓░▒ ▒  ▒░▒   ░ ";
echo "░ ░▒  ░ ░░░   ░▒ ░░ ░ ▒  ░░  ░      ░░ ░░   ░ ▒░  ▒ ░ ░   ░    ░ ";
echo "░  ░  ░   ░    ░    ░ ░   ░      ░      ░   ░ ░   ░   ░ ░        ";
echo "      ░   ░    ░      ░  ░       ░            ░     ░          ░ ";
echo "            Auto Installer testnet-3 For Aleo v2.0.2             ";
echo ""
sleep 1

# Package
cd $HOME
apt-get update
apt-get upgrade -y
apt-get install build-essential curl clang gcc libssl-dev llvm make pkg-config tmux xz-utils pkg-config ufw cargo -y

# Enable ufw
echo ""
echo "[!] TYPE 'Y' FOR ALLOW FIREWALL";
echo ""
ufw enable

# Open ports on system
ufw allow 4133/tcp
ufw allow 3033/tcp

# Clone snarkOS
git clone https://github.com/AleoHQ/snarkOS.git --depth 1

# Install snarkOS
cd snarkOS
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "/root/.cargo/env"
cargo install cargo --force
cargo install --path .

# Create new account
snarkos account new

# End

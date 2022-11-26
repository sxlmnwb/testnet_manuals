#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#    NEED PRIVILEGE ACCESS root:x:0:0:root:/root:/bin/bash
#

echo ""
if [ $(/usr/bin/id -u) -ne 0 ]; then
    echo "[!] NEED PRIVILEGE ACCESS root:x:0:0:root:/root:/bin/bash";
    echo "[!] TYPE 'sudo bash testnet.sh'";
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
echo "                Chainflip - TESTNET NODE Installer               ";
echo ""
sleep 1

# Update
apt-get update && apt-get upgrade -y

# Install Package
apt-get install wget -y

# Install libssl1.1 ubuntu 20.04
cd $HOME
apt-get install libssl1.1 -y
apt-get update

# Adding Chainflip APT Repo
mkdir -p /etc/apt/keyrings
curl -fsSL repo.chainflip.io/keys/gpg | gpg --dearmor -o /etc/apt/keyrings/chainflip.gpg
gpg --show-keys /etc/apt/keyrings/chainflip.gpg
echo "deb [signed-by=/etc/apt/keyrings/chainflip.gpg] https://repo.chainflip.io/perseverance/ focal main" | tee /etc/apt/sources.list.d/chainflip.list

# Install chainflip-cli / node / engine
apt-get update
apt-get install chainflip-cli chainflip-node chainflip-engine -y

# Setup Private Key
mkdir /etc/chainflip/keys
if [ ! $PRIVATE_KEY ]; then
    echo ""
    echo "[!] EXAMPLE 9e7107efb0043b430e2cbffcf9xxxxxxxxxxxxxxxxx"
    echo "[!] PRIVATE KEY ON METAMASK"
    echo ""
	read -p "[ENTER YOUR PRIVATE KEY] > " PRIVATE_KEY
	echo 'export PRIVATE_KEY='$PRIVATE_KEY >> $HOME/.bash_profile
fi
    echo -n "$PRIVATE_KEY" >> /etc/chainflip/keys/ethereum_key_file
    echo ""
    echo "YOUR PRIVATE KEY   : $PRIVATE_KEY"
    echo ""

# Create Signing Keys
chainflip-node key generate >> sign_key.txt
echo "[!] YOUR SIGN KEY (BACKUP YOUR SIGN KEY)"
echo ""
cat sign_key.txt
echo ""
if [ ! $SECRET_SEED ]; then
    echo "[!] EXAMPLE 0x3f41c7492053246e899d55991xxxxxxxxxxxxxxxxx"
    echo "[!] SECRET SEED AS SHOWN YOUR SIGN KEY"
    echo ""
	read -p "[ENTER YOUR SECRET SEED] > " SECRET_SEED
	echo 'export SECRET_SEED='$SECRET_SEED >> $HOME/.bash_profile
fi
    echo -n "${SECRET_SEED:2}" | tee /etc/chainflip/keys/signing_key_file
    echo ""
    echo "YOUR SECRET SEED   : $SECRET_SEED"
    echo ""

# Create Node Key
chainflip-node key generate-node-key --file /etc/chainflip/keys/node_key_file
echo "[!] YOUR NODE KEY (BACKUP YOUR NODE KEY)"
echo ""
cat /etc/chainflip/keys/node_key_file

# Create configuration chainflip
mkdir -p /etc/chainflip/config
echo ""
if [ ! $IP_SERVER ]; then
    echo "[!] EXAMPLE 154.xx.139.xx"
    echo "[!] MATCH YOUR IP VPS LOGIN INTO SSH"
    echo ""
	read -p "[ENTER YOUR IP SERVER] > " IP_SERVER
	echo 'export IP_SERVER='$IP_SERVER >> $HOME/.bash_profile
fi    
    echo ""
    echo "YOUR IP SERVER     : $IP_SERVER"
    echo ""
tee /etc/chainflip/config/Default.toml > /dev/null <<EOF
# Default configurations for the CFE
[node_p2p]
node_key_file = "/etc/chainflip/keys/node_key_file"
ip_address="$IP_SERVER"
port = "8078"

[state_chain]
ws_endpoint = "ws://127.0.0.1:9944"
signing_key_file = "/etc/chainflip/keys/signing_key_file"

[eth]
# Ethereum RPC endpoints (websocket and http for redundancy).
ws_node_endpoint = "wss://eth-goerli.g.alchemy.com/v2/A263glFXKJrUxohSq2_hTQOqOlueEExM"
http_node_endpoint = "https://eth-goerli.g.alchemy.com/v2/A263glFXKJrUxohSq2_hTQOqOlueEExM"

# Ethereum private key file path. This file should contain a hex-encoded private key.
private_key_file = "/etc/chainflip/keys/ethereum_key_file"

[signing]
db_file = "/etc/chainflip/data.db"
EOF

# Register And Start Service
systemctl enable chainflip-node
systemctl start chainflip-node

echo "SETUP FINISHED CHAINFLIP NODE"
echo ""
echo "CHECK RUNNING LOGS : tail -f /var/log/chainflip-node.log"
echo ""
echo "IF THE LOGS SYNC, YOU CAN CREATE THE VALIDATOR"
echo ""

# End

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
echo "              Chainflip - Setup Validator Installer              ";
echo ""
sleep 1

# Set Validator Name
if [ ! $VALIDATOR_NAME ]; then
	read -p "[ENTER YOUR VALIDATOR NAME] > " VALIDATOR_NAME
	echo 'export VALIDATOR_NAME='$VALIDATOR_NAME >> $HOME/.bash_profile
fi
# Register And Start Service
systemctl enable chainflip-engine
systemctl start chainflip-engine
echo "[!] LOADING FOR STARTING SERVICE ..."
sleep 10

# Register Validator Key
chainflip-cli --config-path /etc/chainflip/config/Default.toml register-account-role Validator
echo "[!] LOADING FOR SYNC ..."
sleep 10
echo "[!] LOADING FOR SYNC ....."
sleep 10
echo "[!] LOADING FOR SYNC ......."
sleep 10
echo "[!] LOADING FOR SYNC ........."
sleep 10
echo "[!] LOADING FOR SYNC ..........."
sleep 10
echo "[!] LOADING FOR SYNC ............."
sleep 10
echo "[!] DONE"

# Active Validator Key
chainflip-cli --config-path /etc/chainflip/config/Default.toml activate

# Rotate Validator Key
chainflip-cli --config-path /etc/chainflip/config/Default.toml rotate

# Enable Validator Name
chainflip-cli --config-path /etc/chainflip/config/Default.toml vanity-name $VALIDATOR_NAME

echo "SETUP FINISHED"
echo ""
echo "CHECK RUNNING LOGS : tail -f /var/log/chainflip-engine.log"
echo ""
echo "YOU CHECK ACTIVICE VALIDATOR HERE :"
echo "https://stake-perseverance.chainflip.io/nodes"
echo ""

# End

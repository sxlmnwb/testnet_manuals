#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#    NEED PRIVILEGE ACCESS root:x:0:0:root:/root:/bin/bash
#

echo ""
if [ $(/usr/bin/id -u) -ne 0 ]; then
    echo "[!] NEED PRIVILEGE ACCESS root:x:0:0:root:/root:/bin/bash";
    echo "[!] TYPE 'sudo bash validator.sh'";
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
echo "             Auto Installer Q Blockchain - Validator             ";
echo ""
sleep 1

# Install dependencies
cd $HOME
apt-get update
apt-get upgrade -y
apt-get install git docker docker-compose -y

# Getting testnet
git clone https://gitlab.com/q-dev/testnet-public-tools
cd testnet-public-tools/testnet-validator
mkdir keystore
touch keystore/pwd.txt

# Create Wallet And Password
if [ ! $PASSWORD ]; then
    echo ""
    echo "[!] CREATE PASSWORD keystore/pwd.txt"
    echo ""
	read -p "[TYPE YOUR PASSWORD] > " PASSWORD
	echo $PASSWORD >> keystore/pwd.txt
fi

docker run --entrypoint="" --rm -v $PWD:/data -it qblockchain/q-client:testnet geth account new --datadir=/data --password=/data/keystore/pwd.txt

echo "[!] AFTER FINISH TYPE 'cd testnet-public-tools/testnet-validator'"
echo ""

# End

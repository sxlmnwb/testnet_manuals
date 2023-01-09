#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

echo -e "\033[0;31m"
echo "  ██████ ▒██   ██▒ ██▓     ███▄ ▄███▓ ███▄    █  █     █░▓█████▄ ";
echo "▒██    ▒ ▒▒ █ █ ▒░▓██▒    ▓██▒▀█▀ ██▒ ██ ▀█   █ ▓█░ █ ░█▒██▒ ▄██░";
echo "░ ▓██▄   ░░  █   ░▒██░    ▓██    ▓██░▓██  ▀█ ██▒▒█░ █ ░█ ▒██░█▀  ";
echo "  ▒   ██▒ ░ █ █ ▒ ▒██░    ▒██    ▒██ ▓██▒  ▐▌██▒░█░ █ ░█ ░▓█  ▀█▓";
echo "▒██████▒▒▒██▒ ▒██▒░██████▒▒██▒   ░██▒▒██░   ▓██░░░██▒██▓ ░▒▓███▀▒";
echo "▒ ▒▓▒ ▒ ░▒▒ ░ ░▓ ░░ ▒░▓  ░░ ▒░   ░  ░░ ▒░   ▒ ▒ ░ ▓░▒ ▒  ▒░▒   ░ ";
echo "░ ░▒  ░ ░░░   ░▒ ░░ ░ ▒  ░░  ░      ░░ ░░   ░ ▒░  ▒ ░ ░   ░    ░ ";
echo "░  ░  ░   ░    ░    ░ ░   ░      ░      ░   ░ ░   ░   ░ ░        ";
echo "      ░   ░    ░      ░  ░       ░            ░     ░          ░ ";
echo "      Auto Installer lava-testnet-1 For LAVA NETWORK v0.4.0      ";
echo -e "\e[0m"
sleep 1

# Variable
LAVA_WALLET=wallet
LAVA=lavad
LAVA_ID=lava-testnet-1
LAVA_FOLDER=.lava
LAVA_VER=v0.4.0
LAVA_BINARY=https://lava-binary-upgrades.s3.amazonaws.com/testnet
LAVA_GENESIS=https://raw.githubusercontent.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T/main/testnet-1/genesis_json/genesis.json
LAVA_ADDRBOOK=https://snapshots1-testnet.nodejumper.io/lava-testnet/addrbook.json
LAVA_DENOM=ulava
LAVA_PORT=15

echo "export LAVA_WALLET=${LAVA_WALLET}" >> $HOME/.bash_profile
echo "export LAVA=${LAVA}" >> $HOME/.bash_profile
echo "export LAVA_ID=${LAVA_ID}" >> $HOME/.bash_profile
echo "export LAVA_FOLDER=${LAVA_FOLDER}" >> $HOME/.bash_profile
echo "export LAVA_VER=${LAVA_VER}" >> $HOME/.bash_profile
echo "export LAVA_REPO=${LAVA_REPO}" >> $HOME/.bash_profile
echo "export LAVA_GENESIS=${LAVA_GENESIS}" >> $HOME/.bash_profile
echo "export LAVA_ADDRBOOK=${LAVA_ADDRBOOK}" >> $HOME/.bash_profile
echo "export LAVA_DENOM=${LAVA_DENOM}" >> $HOME/.bash_profile
echo "export LAVA_PORT=${LAVA_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $LAVA_NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " LAVA_NODENAME
	echo 'export LAVA_NODENAME='$LAVA_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$LAVA_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$LAVA_ID\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$LAVA_PORT\e[0m"
echo ""

# Update
sudo apt update && sudo apt upgrade -y

# Package
sudo apt install curl jq lz4 build-essential -y

# Get testnet version of lava
cd $HOME
curl -L $LAVA_BINARY/$LAVA_VER/$LAVA > $LAVA
chmod +x $LAVA
sudo mv $LAVA /usr/bin/

# Init generation
$LAVA config chain-id $LAVA_ID
$LAVA config keyring-backend test
$LAVA config node tcp://localhost:${LAVA_PORT}657
$LAVA init $LAVA_NODENAME --chain-id $LAVA_ID

# Download genesis and addrbook
curl -Ls $LAVA_GENESIS > $HOME/$LAVA_FOLDER/config/genesis.json
curl -Ls $LAVA_ADDRBOOK > $HOME/$LAVA_FOLDER/config/addrbook.json

# Set peers and seeds
SEEDS="3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$LAVA_FOLDER/config/config.toml

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LAVA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${LAVA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LAVA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LAVA_PORT}660\"%" $HOME/$LAVA_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${LAVA_PORT}317\"%; s%^address = \":8080\"%address = \":${LAVA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${LAVA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${LAVA_PORT}091\"%" $HOME/$LAVA_FOLDER/config/app.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$LAVA_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$LAVA_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$LAVA_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$LAVA_FOLDER/config/app.toml

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025$LAVA_DENOM\"/" $HOME/$LAVA_FOLDER/config/app.toml

# Enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$LAVA_FOLDER/config/config.toml

# Enable snapshots
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $LAVA_FOLDER/config/app.toml
$LAVA tendermint unsafe-reset-all --home $HOME/$LAVA_FOLDER --keep-addr-book
SNAP_NAME=$(curl -s https://snapshots1-testnet.nodejumper.io/lava-testnet/ | egrep -o ">lava-testnet-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots1-testnet.nodejumper.io/lava-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/$LAVA_FOLDER

# Create Service
sudo tee /etc/systemd/system/$LAVA.service > /dev/null <<EOF
[Unit]
Description=$LAVA
After=network-online.target

[Service]
User=$USER
ExecStart=$(which $LAVA) start --home $HOME/$LAVA_FOLDER
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $LAVA
sudo systemctl start $LAVA

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $LAVA -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[31mcurl -s localhost:${LAVA_PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End

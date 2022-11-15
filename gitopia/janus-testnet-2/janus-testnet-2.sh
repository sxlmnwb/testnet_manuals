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
echo "        Auto Installer janus-testnet-2 For GITOPIA v1.2.0        ";
echo -e "\e[0m"
sleep 1

# Variable
TLORE_WALLET=wallet
TLORE=gitopiad
TLORE_ID=gitopia-janus-testnet-2
TLORE_FOLDER=.gitopia
TLORE_VER=v1.2.0
TLORE_REPO=gitopia://gitopia/gitopia
TLORE_GENESIS=https://server.gitopia.com/raw/gitopia/testnets/master/gitopia-janus-testnet-2/genesis.json.gz
TLORE_ADDRBOOK=https://snapshots.kjnodes.com/gitopia-testnet/addrbook.json
TLORE_DENOM=utlore
TLORE_PORT=41

echo "export TLORE_WALLET=${TLORE_WALLET}" >> $HOME/.bash_profile
echo "export TLORE=${TLORE}" >> $HOME/.bash_profile
echo "export TLORE_ID=${TLORE_ID}" >> $HOME/.bash_profile
echo "export TLORE_FOLDER=${TLORE_FOLDER}" >> $HOME/.bash_profile
echo "export TLORE_VER=${TLORE_VER}" >> $HOME/.bash_profile
echo "export TLORE_REPO=${TLORE_REPO}" >> $HOME/.bash_profile
echo "export TLORE_GENESIS=${TLORE_GENESIS}" >> $HOME/.bash_profile
echo "export TLORE_DENOM=${TLORE_DENOM}" >> $HOME/.bash_profile
echo "export TLORE_PORT=${TLORE_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $TLORE_NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " TLORE_NODENAME
	echo 'export NODENAME='$TLORE_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$TLORE_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$TLORE_ID\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$TLORE_PORT\e[0m"
echo ""

# Update
sudo apt-get update && sudo apt-get upgrade -y

# Package
sudo apt-get install curl pkg-config libssl-dev liblz4-tool chrony bsdmainutils clang tar build-essential ncdu git wget jq make gcc rustc cargo tmux unzip -y

# Install GO
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

# Install git remote helper
curl https://get.gitopia.com | bash

# Get testnet version of TLOREru
cd $HOME
git clone -b v1.2.0 $TLORE_REPO
cd gitopia
make build
sudo mv ./build/gitopiad /usr/local/bin/ || exit

# GenTx generation
$TLORE config chain-id $TLORE_ID
$TLORE config keyring-backend test
$TLORE config node tcp://localhost:${TLORE_PORT}657
$TLORE init $TLORE_NODENAME --chain-id $TLORE_ID
curl -s $TLORE_GENESIS -o $HOME/genesis.json.gz
gunzip $HOME/genesis.json.gz
mv $HOME/genesis.json $HOME/$TLORE_FOLDER/config/genesis.json
curl -s $TLORE_ADDRBOOK -o $HOME/$TLORE_FOLDER/config/addrbook.json

# Genesis sha256
shasum -a 256 $HOME/$TLORE_FOLDER/config/genesis.json

# Set Seeds And Peers
SEEDS="399d4e19186577b04c23296c4f7ecc53e61080cb@seed.gitopia.com:26656"
#PEERS=""
sed -i.default "s/^seeds *=.*/seeds = \"$SEEDS\"/;" $HOME/$TLORE_FOLDER/config/config.toml
#sed -i.default "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/;" $HOME/$TLORE_FOLDER/config/config.toml

# Set Config Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${TLORE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${TLORE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${TLORE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${TLORE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${TLORE_PORT}660\"%" $HOME/$TLORE_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${TLORE_PORT}317\"%; s%^address = \":8080\"%address = \":${TLORE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${TLORE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${TLORE_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${TLORE_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${TLORE_PORT}546\"%" $HOME/$TLORE_FOLDER/config/app.toml

# Set Config Gas
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001$TLORE_DENOM\"/" $HOME/$TLORE_FOLDER/config/app.toml

# Set Config prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$TLORE_FOLDER/config/config.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$TLORE_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$TLORE_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$TLORE_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$TLORE_FOLDER/config/app.toml
$TLORE tendermint unsafe-reset-all --home $HOME/$TLORE_FOLDER

# Create Service
sudo tee /etc/systemd/system/$TLORE.service > /dev/null <<EOF
[Unit]
Description=$TLORE
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=$(which $TLORE) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $TLORE
sudo systemctl start $TLORE

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $TLORE -o cat\e[0m"
echo ""

# End

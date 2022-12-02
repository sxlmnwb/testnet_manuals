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
echo "            Auto Installer mamaki For CALESTIA v0.6.0            ";
echo -e "\e[0m"
sleep 1

# Variable
TIA_WALLET=wallet
TIA=celestia-appd
TIA_ID=mamaki
TIA_FOLDER=.celestia-app
TIA_VER=v0.6.0
TIA_REPO=https://github.com/celestiaorg/celestia-app
TIA_REPO_NETWORK=https://github.com/celestiaorg/networks
#TIA_GENESIS=
#TIA_ADDRBOOK=
TIA_DENOM=utia
TIA_PORT=20

echo "export TIA_WALLET=${TIA_WALLET}" >> $HOME/.bash_profile
echo "export TIA=${TIA}" >> $HOME/.bash_profile
echo "export TIA_ID=${TIA_ID}" >> $HOME/.bash_profile
echo "export TIA_FOLDER=${TIA_FOLDER}" >> $HOME/.bash_profile
echo "export TIA_VER=${TIA_VER}" >> $HOME/.bash_profile
echo "export TIA_REPO=${TIA_REPO}" >> $HOME/.bash_profile
echo "export TIA_REPO_NETWORK=${TIA_REPO_NETWORK}" >> $HOME/.bash_profile
echo "export TIA_GENESIS=${TIA_GENESIS}" >> $HOME/.bash_profile
#echo "export TIA_ADDRBOOK=${TIA_ADDRBOOK}" >> $HOME/.bash_profile
echo "export TIA_DENOM=${TIA_DENOM}" >> $HOME/.bash_profile
echo "export TIA_PORT=${TIA_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $TIA_NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " TIA_NODENAME
	echo 'export TIA_NODENAME='$TIA_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$TIA_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$TIA_ID\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$TIA_PORT\e[0m"
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

# Get testnet version of mis
cd $HOME
rm -rf celestia-app
git clone $TIA_REPO
cd celestia-app
git checkout $TIA_VER
make install
mv $HOME/go/bin/$TIA /usr/bin/

# download network tools
cd $HOME
rm -rf networks
git clone $TIA_REPO_NETWORK

# GenTx generation
$TIA config chain-id $TIA_ID
$TIA config keyring-backend test
$TIA config node tcp://localhost:${TIA_PORT}657

# Init generation
$TIA init $TIA_NODENAME --chain-id $TIA_ID

# Download genesis and addrbook
cp $HOME/networks/$TIA_ID/genesis.json $HOME/.celestia-app/config

# Set Seeds Peers And Boots
#SEEDS=""
BOOTSTRAP_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')
MY_PEER=$(celestia-appd tendermint show-node-id)@$(curl -s ifconfig.me)$(grep -A 9 "\[p2p\]" ~/.celestia-app/config/config.toml | egrep -o ":[0-9]+")
PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/peers.txt | tr -d '\n' | head -c -1 | sed s/"$MY_PEER"// | sed "s/,,/,/g")
sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTSTRAP_PEERS\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^persistent-peers *=.*/persistent-peers = \"$PEERS\"/" $HOME/.celestia-app/config/config.toml
#sed -i.default "s/^seeds *=.*/seeds = \"$SEEDS\"/;" $HOME/$TIA_FOLDER/config/config.toml

# Use Custom Settings
use_legacy="false"
pex="true"
max_connections="90"
peer_gossip_sleep_duration="2ms"
sed -i.bak -e "s/^use-legacy *=.*/use-legacy = \"$use_legacy\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^pex *=.*/pex = \"$pex\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^max-connections *=.*/max-connections = \"$max_connections\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^peer-gossip-sleep-duration *=.*/peer-gossip-sleep-duration = \"$peer_gossip_sleep_duration\"/" $HOME/.celestia-app/config/config.toml

# Set Custom Ports
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${TIA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${TIA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${TIA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${TIA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${TIA_PORT}660\"%" $HOME/$TIA_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${TIA_PORT}317\"%; s%^address = \":8080\"%address = \":${TIA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${TIA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${TIA_PORT}091\"%" $HOME/$TIA_FOLDER/config/app.toml

# Set Config Gas
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0$TIA_DENOM\"/" $HOME/$TIA_FOLDER/config/app.toml

# Set Config prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$TIA_FOLDER/config/config.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$TIA_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$TIA_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$TIA_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$TIA_FOLDER/config/app.toml

# Disable Indexing And Clean
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$TIA_FOLDER/config/config.toml
$TIA tendermint unsafe-reset-all --home $HOME/$TIA_FOLDER

# Create Service
sudo tee /etc/systemd/system/$TIA.service > /dev/null <<EOF
[Unit]
Description=$TIA
After=network-online.target

[Service]
User=$USER
ExecStart=$(which $TIA) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $TIA
sudo systemctl start $TIA

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $TIA -o cat\e[0m"
echo ""

# End

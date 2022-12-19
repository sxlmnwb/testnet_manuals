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
echo "          Auto Installer testnet-1 For Humans AI v1.0.0          ";
echo -e "\e[0m"
sleep 1

# Variable
HEART_WALLET=wallet
HEART=humansd
HEART_ID=testnet-1
HEART_FOLDER=.humans
HEART_VER=v1.0.0
HEART_REPO=https://github.com/humansdotai/humans
HEART_GENESIS=https://rpc-testnet.humans.zone/genesis
HEART_ADDRBOOK=https://snapshots.polkachu.com/testnet-addrbook/humans/addrbook.json
HEART_DENOM=uheart
HEART_PORT=12

echo "export HEART_WALLET=${HEART_WALLET}" >> $HOME/.bash_profile
echo "export HEART=${HEART}" >> $HOME/.bash_profile
echo "export HEART_ID=${HEART_ID}" >> $HOME/.bash_profile
echo "export HEART_FOLDER=${HEART_FOLDER}" >> $HOME/.bash_profile
echo "export HEART_VER=${HEART_VER}" >> $HOME/.bash_profile
echo "export HEART_REPO=${HEART_REPO}" >> $HOME/.bash_profile
echo "export HEART_GENESIS=${HEART_GENESIS}" >> $HOME/.bash_profile
#echo "export HEART_ADDRBOOK=${HEART_ADDRBOOK}" >> $HOME/.bash_profile
echo "export HEART_DENOM=${HEART_DENOM}" >> $HOME/.bash_profile
echo "export HEART_PORT=${HEART_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $HEART_NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " HEART_NODENAME
	echo 'export HEART_NODENAME='$HEART_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$HEART_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$HEART_ID\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$HEART_PORT\e[0m"
echo ""

# Update
sudo apt update && sudo apt upgrade -y

# Package
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

# Install GO
ver="1.18.2"
cd $HOME
rm -rf go
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

# Get testnet version of mis
cd $HOME
rm -rf humans
git clone $HEART_REPO
cd humans
git checkout $HEART_VER
go build -o $HEART cmd/humansd/main.go
sudo mv $HEART /usr/bin/

# Init generation
$HEART config chain-id $HEART_ID
$HEART config keyring-backend test
$HEART config node tcp://localhost:${QCK_PORT}657
$HEART init $HEART_NODENAME --chain-id $HEART_ID

# Download genesis and addrbook
curl -Ls $HEART_GENESIS | jq -r .result.genesis > $HOME/$HEART_FOLDER/config/genesis.json
wget $HEART_ADDRBOOK -O $HOME/$HEART_FOLDER/config/addrbook.json

# Set peers and seeds
SEEDS=ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:18456
PEERS=b2c4407beadead20cad5f8dd541bc70b289e1819@65.109.90.33:18456
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$HEART_FOLDER/config/config.toml
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$HEART_FOLDER/config/config.toml

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${HEART_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${HEART_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${HEART_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${HEART_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${HEART_PORT}660\"%" $HOME/$HEART_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${HEART_PORT}317\"%; s%^address = \":8080\"%address = \":${HEART_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${HEART_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${HEART_PORT}091\"%" $HOME/$HEART_FOLDER/config/app.toml

# Update block time parameters
CONFIG_TOML="$HOME/.humans/config/config.toml"
 sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $CONFIG_TOML
 sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $CONFIG_TOML

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="2000"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$HEART_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$HEART_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$HEART_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$HEART_FOLDER/config/app.toml

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.01$HEART_DENOM\"/" $HOME/$HEART_FOLDER/config/app.toml

# Set indexer
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$HEART_FOLDER/config/config.toml

# State sync
cd $HOME
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HEART_FOLDER/config/app.toml
sed -i -e "s/^snapshot-keep-recent *=.*/snapshot-keep-recent = \"5\"/" $HEART_FOLDER/config/app.toml

cp $HOME/$HEART_FOLDER/data/priv_validator_state.json $HOME/$HEART_FOLDER/priv_validator_state.json.backup

$HEART tendermint unsafe-reset-all --home $HOME/$HEART_FOLDER --keep-addr-book

SNAP_RPC="https://humans-testnet-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/$HEART_FOLDER/config/config.toml

mv $HOME/$HEART_FOLDER/priv_validator_state.json.backup $HOME/$HEART_FOLDER/data/priv_validator_state.json

# Create Service
sudo tee /etc/systemd/system/$HEART.service > /dev/null <<EOF
[Unit]
Description=$HEART
After=network-online.target

[Service]
User=$USER
ExecStart=$(which $HEART) start --home $HOME/$HEART_FOLDER
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $HEART
sudo systemctl start $HEART

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $HEART -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[31mcurl -s localhost:${HEART_PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End

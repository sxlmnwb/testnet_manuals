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
echo "           Auto Installer loyal-1 For LOYAL v0.25.1.3            ";
echo -e "\e[0m"
sleep 1

# Variable
LYL_WALLET=wallet
LYL=loyald
LYL_ID=loyal-1
LYL_PORT=56
LYL_FOLDER=.loyal
LYL_VER=v0.25.1.3
LYL_REPO=https://github.com/LoyalLabs/loyal
LYL_GENESIS=https://raw.githubusercontent.com/LoyalLabs/net/main/mainnet/genesis.json
LYL_ADDRBOOK=https://snapshots.polkachu.com/testnet-addrbook/loyal/addrbook.json
LYL_DENOM=ulyl

echo "export LYL_WALLET=${LYL_WALLET}" >> $HOME/.bash_profile
echo "export LYL=${LYL}" >> $HOME/.bash_profile
echo "export LYL_ID=${LYL_ID}" >> $HOME/.bash_profile
echo "export LYL_PORT=${LYL_PORT}" >> $HOME/.bash_profile
echo "export LYL_FOLDER=${LYL_FOLDER}" >> $HOME/.bash_profile
echo "export LYL_VER=${LYL_VER}" >> $HOME/.bash_profile
echo "export LYL_REPO=${LYL_REPO}" >> $HOME/.bash_profile
echo "export LYL_GENESIS=${LYL_GENESIS}" >> $HOME/.bash_profile
echo "export LYL_ADDRBOOK=${LYL_ADDRBOOK}" >> $HOME/.bash_profile
echo "export LYL_DENOM=${LYL_DENOM}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $LYL_NODENAME ]; then
        read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " LYL_NODENAME
        echo 'export NODENAME='$LYL_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$LYL_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$LYL_ID\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$LYL_PORT\e[0m"
echo ""

# Update
sudo apt-get update && sudo apt-get upgrade -y

# Package
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

# Get testnet version of loyal
cd $HOME
wget https://github.com/LoyalLabs/loyal/releases/download/$LYL_VER/loyal_v0.25.1.3_linux_amd64.tar.gz
tar xzf loyal_v0.25.1.3_linux_amd64.tar.gz
chmod 775 loyald
sudo mv loyald /usr/local/bin/
sudo rm loyal_v0.25.1.3_linux_amd64.tar.gz

# GenTx generation
$LYL config chain-id $LYL_ID
$LYL config keyring-backend test
$LYL config node tcp://localhost:${LYL_PORT}657
$LYL init $LYL_NODENAME --chain-id $LYL_ID

# Download genesis and addrbook
wget $LYL_GENESIS -O $HOME/$LYL_FOLDER/config/genesis.json
wget $LYL_ADDRBOOK -O $HOME/$LYL_FOLDER/config/addrbook.json

# Set Seeds And Peers
SEEDS=ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:17856
PEERS=2e760116a3c6af2bb040633bdf88a8052912aa37@65.108.233.109:17856
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.loyal/config/config.toml
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$LYL_FOLDER/config/config.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="2000"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$LYL_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$LYL_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$LYL_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$LYL_FOLDER/config/app.toml

# Set port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LYL_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${LYL_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LYL_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LYL_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LYL_PORT}660\"%" $HOME/$LYL_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${LYL_PORT}317\"%; s%^address = \":8080\"%address = \":${LYL_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${LYL_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${LYL_PORT}091\"%" $HOME/$LYL_FOLDER/config/app.toml


# Enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$LYL_FOLDER/config/config.toml

# Set minimum gas
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.000025$LYL_DENOM\"/" $HOME/$LYL_FOLDER/config/app.toml

# Set indexer
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$LYL_FOLDER/config/config.toml

# State sync
cd $HOME
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $LYL_FOLDER/config/app.toml
sed -i -e "s/^snapshot-keep-recent *=.*/snapshot-keep-recent = \"5\"/" $LYL_FOLDER/config/app.toml

cp $HOME/$LYL_FOLDER/data/priv_validator_state.json $HOME/$LYL_FOLDER/priv_validator_state.json.backup

$LYL tendermint unsafe-reset-all --home $HOME/$LYL_FOLDER --keep-addr-book

SNAP_RPC="https://loyal-testnet-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.loyal/config/config.toml

mv $HOME/$LYL_FOLDER/priv_validator_state.json.backup $HOME/$LYL_FOLDER/data/priv_validator_state.json

# Create Service
sudo tee /etc/systemd/system/$LYL.service > /dev/null <<EOF
[Unit]
Description=$LYL
After=network.target

[Service]
User=$USER
ExecStart=$(which $LYL) start --home $HOME/$LYL_FOLDER
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $LYL
sudo systemctl start $LYL

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m";
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $LYL -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[31mcurl -s localhost:${LYL_PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End

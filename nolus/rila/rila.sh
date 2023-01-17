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
echo "           Auto Installer nolus-rila For NOLUS v0.1.39           ";
echo -e "\e[0m"
sleep 1

# Variable
NOLUS_WALLET=wallet
NOLUS=nolusd
NOLUS_ID=nolus-rila
NOLUS_FOLDER=.nolus
NOLUS_VER=v0.1.39
NOLUS_REPO=https://github.com/Nolus-Protocol/nolus-core
NOLUS_GENESIS=https://snapshots.kjnodes.com/nolus-testnet/genesis.json
NOLUS_ADDRBOOK=https://snapshots.kjnodes.com/nolus-testnet/addrbook.json
NOLUS_DENOM=unls
NOLUS_PORT=13

echo "export NOLUS_WALLET=${NOLUS_WALLET}" >> $HOME/.bash_profile
echo "export NOLUS=${NOLUS}" >> $HOME/.bash_profile
echo "export NOLUS_ID=${NOLUS_ID}" >> $HOME/.bash_profile
echo "export NOLUS_FOLDER=${NOLUS_FOLDER}" >> $HOME/.bash_profile
echo "export NOLUS_VER=${NOLUS_VER}" >> $HOME/.bash_profile
echo "export NOLUS_REPO=${NOLUS_REPO}" >> $HOME/.bash_profile
echo "export NOLUS_GENESIS=${NOLUS_GENESIS}" >> $HOME/.bash_profile
echo "export NOLUS_ADDRBOOK=${NOLUS_ADDRBOOK}" >> $HOME/.bash_profile
echo "export NOLUS_DENOM=${NOLUS_DENOM}" >> $HOME/.bash_profile
echo "export NOLUS_PORT=${NOLUS_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $NOLUS_NODENAME ]; then
        read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " NOLUS_NODENAME
        echo 'export NOLUS_NODENAME='$NOLUS_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$NOLUS_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$NOLUS_ID\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$NOLUS_PORT\e[0m"
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

# Get testnet version of nolus
cd $HOME
rm -rf nolus-core
git clone $NOLUS_REPO
cd nolus-core
git checkout $NOLUS_VER
make install
sudo mv $HOME/go/bin/$NOLUS /usr/bin/

# Init generation
$NOLUS config chain-id $NOLUS_ID
$NOLUS config keyring-backend test
$NOLUS config node tcp://localhost:${NOLUS_PORT}657
$NOLUS init $NOLUS_NODENAME --chain-id $NOLUS_ID

# Download genesis and addrbook
curl -Ls $NOLUS_GENESIS > $HOME/$NOLUS_FOLDER/config/genesis.json
curl -Ls $NOLUS_ADDRBOOK > $HOME/$NOLUS_FOLDER/config/addrbook.json

# Add seeds
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@nolus-testnet.rpc.kjnodes.com:43659\"|" $HOME/$NOLUS_FOLDER/config/config.toml

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${NOLUS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${NOLUS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${NOLUS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${NOLUS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${NOLUS_PORT}660\"%" $HOME/$NOLUS_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${NOLUS_PORT}317\"%; s%^address = \":8080\"%address = \":${NOLUS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${NOLUS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${NOLUS_PORT}091\"%" $HOME/$NOLUS_FOLDER/config/app.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="19"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$NOLUS_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$NOLUS_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$NOLUS_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$NOLUS_FOLDER/config/app.toml

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025$NOLUS_DENOM\"/" $HOME/$NOLUS_FOLDER/config/app.toml

# Enable snapshots
rm -rf $HOME/$NOLUS_FOLDER/data
curl -L https://snapshots.kjnodes.com/nolus-testnet/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/$NOLUS_FOLDER

# Create Service
sudo tee /etc/systemd/system/$NOLUS.service > /dev/null <<EOF
[Unit]
Description=$NOLUS
After=network-online.target

[Service]
User=$USER
ExecStart=$(which $NOLUS) start --home $HOME/$NOLUS_FOLDER
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $NOLUS
sudo systemctl start $NOLUS

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $NOLUS -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[31mcurl -s localhost:${NOLUS_PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End

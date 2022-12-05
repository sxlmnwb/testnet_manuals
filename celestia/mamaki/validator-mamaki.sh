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

echo "export TIA_WALLET=${TIA_WALLET}" >> $HOME/.bash_profile
echo "export TIA=${TIA}" >> $HOME/.bash_profile
echo "export TIA_ID=${TIA_ID}" >> $HOME/.bash_profile
echo "export TIA_FOLDER=${TIA_FOLDER}" >> $HOME/.bash_profile
echo "export TIA_VER=${TIA_VER}" >> $HOME/.bash_profile
echo "export TIA_REPO=${TIA_REPO}" >> $HOME/.bash_profile
echo "export TIA_REPO_NETWORK=${TIA_REPO_NETWORK}" >> $HOME/.bash_profile
#echo "export TIA_GENESIS=${TIA_GENESIS}" >> $HOME/.bash_profile
#echo "export TIA_ADDRBOOK=${TIA_ADDRBOOK}" >> $HOME/.bash_profile
echo "export TIA_DENOM=${TIA_DENOM}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $TIA_NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " TIA_NODENAME
	echo 'export TIA_NODENAME='$TIA_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$TIA_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$TIA_ID\e[0m"
echo ""

# Update
sudo apt update && sudo apt upgrade -y

# Package
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

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
git checkout tags/$TIA_VER -b $TIA_VER
make install
mv $HOME/go/bin/$TIA /usr/bin/

# download network tools
cd $HOME
rm -rf networks
git clone $TIA_REPO_NETWORK

# Init generation
$TIA init $TIA_NODENAME --chain-id $TIA_ID

# Download genesis and addrbook
cp $HOME/networks/$TIA_ID/genesis.json $HOME/.celestia-app/config

# Set Bootstap Peers
BOOTSTRAP_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')
echo $BOOTSTRAP_PEERS
sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTSTRAP_PEERS\"/" $HOME/.celestia-app/config/config.toml

# Set Config Pruning
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"
sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$PRUNING_KEEP_RECENT\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$PRUNING_INTERVAL\"/" $HOME/.celestia-app/config/app.toml

# Configure validator mode
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml

# Reset network
$TIA tendermint unsafe-reset-all --home $HOME/.celestia-app

# Enable snapshot
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | \
    egrep -o ">mamaki.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/.celestia-app/data/

# Create Service
sudo tee /etc/systemd/system/$TIA.service > /dev/null <<EOF
[Unit]
Description=celestia-appd Cosmos daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which $TIA) start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

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

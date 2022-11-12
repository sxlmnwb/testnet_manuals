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
echo "            Auto Installer quark-1 For NEUTRON v0.1.1            ";
echo -e "\e[0m"
sleep 1

# Set Vars
if [ ! $NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo -e "YOUR NODE NAME : \e[1m\e[31m$NODENAME\e[0m"

# Update
sudo apt-get update && sudo apt-get upgrade -y

# Package
sudo apt-get install curl build-essential git wget jq make gcc rustc cargo tmux unzip -y

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

# Get testnet version of neutron
git clone -b v0.1.1 https://github.com/neutron-org/neutron.git
cd neutron
make install
sudo mv $HOME/go/bin/neutrond /usr/local/bin/
sudo chmod 775 /usr/local/bin/neutrond

# Neutrond version
neutrond version --long

# GenTx generation
neutrond config chain-id quark-1
neutrond config keyring-backend file
neutrond init "$NODENAME" --chain-id quark-1

# Genesis File
curl -s https://raw.githubusercontent.com/neutron-org/testnets/main/quark/genesis.json > ~/.neutrond/config/genesis.json
curl -s https://raw.githubusercontent.com/sergiomateiko/addrbooks/main/neutron/addrbook.json > ~/.neutrond/config/addrbook.json

# Genesis sha256
sha256sum ~/.neutrond/config/genesis.json
sha256sum ~/.neutrond/config/addrbook.json

#Set Seeds And Peers
SEEDS="e2c07e8e6e808fb36cca0fc580e31216772841df@seed-1.quark.ntrn.info:26656,c89b8316f006075ad6ae37349220dd56796b92fa@tenderseed.ccvalidators.com:29001"
PEERS="3f4ecffa24ad9cc38b3aa44aee837cbf660640c4@rpc.neutron.ppnv.space:11656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.neutrond/config/config.toml

#Set Minimum Gas Price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001untrn\"/" $HOME/.neutrond/config/app.toml

#Set Timeout Commit
TIME="2s"
sed -i -e "s/^timeout_commit *=.*/timeout_commit = \"$TIME\"/;" $HOME/.neutrond/config/config.toml

#Create Service
sudo tee /etc/systemd/system/neutrond.service > /dev/null <<EOF
[Unit]
Description=Neutrond daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which neutrond) start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

#Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable neutrond
sudo systemctl start neutrond

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m";
echo ""
echo -e "Check Running Logs: \e[1m\e[31mjournalctl -u neutrond -f -o cat\e[0m"
echo ""
# End

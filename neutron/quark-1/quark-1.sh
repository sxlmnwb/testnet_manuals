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
echo "              Auto Installer quark-1 For NEUTRON                 ";
echo -e "\e[0m"
sleep 2

# Set Vars
if [ ! $NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo -e "YOUR NODE NAME : \e[1m\e[31m$NODENAME\e[0m"

# Update
sudo apt-get update && sudo apt-get upgrade -y

# Package
apt-get install curl build-essential git wget jq make gcc rustc cargo tmux unzip -y

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

# install Hermes IBC Relayer
cargo install --version 0.14.1 ibc-relayer-cli --bin hermes --locked

# Get testnet version of neutron
git clone -b v0.1.1 https://github.com/neutron-org/neutron.git
cd neutron
make install

# Neutrond version
neutrond version --long

# GenTx generation
neutrond init $NODENAME --chain-id quark-1

# Genesis File
curl -s https://raw.githubusercontent.com/neutron-org/testnets/main/quark/genesis.json > ~/.neutrond/config/genesis.json

# Genesis sha256
sha256sum ~/.neutrond/config/genesis.json

#Set Seeds And Peers
SEEDS="e2c07e8e6e808fb36cca0fc580e31216772841df@seed-1.quark.ntrn.info:26656,c89b8316f006075ad6ae37349220dd56796b92fa@tenderseed.ccvalidators.com:29001"
PEERS="fcde59cbba742b86de260730d54daa60467c91a5@23.109.158.180:26656,5bdc67a5d5219aeda3c743e04fdcd72dcb150ba3@65.109.31.114:2480,3e9656706c94ae8b11596e53656c80cf092abe5d@65.21.250.197:46656,9cb73281f6774e42176905e548c134fc45bbe579@162.55.134.54:26656,27b07238cf2ea76acabd5d84d396d447d72aa01b@65.109.54.15:51656,f10c2cb08f82225a7ef2367709e8ac427d61d1b5@57.128.144.247:26656,20b4f9207cdc9d0310399f848f057621f7251846@222.106.187.13:40006,5019864f233cee00f3a6974d9ccaac65caa83807@162.19.31.150:55256,2144ce0e9e08b2a30c132fbde52101b753df788d@194.163.168.99:26656,b37326e3acd60d4e0ea2e3223d00633605fb4f79@nebula.p2p.org:26656"
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
User=$NODENAME
ExecStart=$HOME/go/bin/neutrond start
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
sudo systemctl restart neutrond

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m";
echo ""
echo -e "Check Running Logs: \e[1m\e[31mjournalctl -u neutrond -f -o cat\e[0m"
# End

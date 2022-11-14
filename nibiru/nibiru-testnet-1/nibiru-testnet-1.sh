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
echo "        Auto Installer nibiru-testnet-1 For NIBIRU v0.15.0       ";
echo -e "\e[0m"
sleep 1

# Variable
NIBI_WALLET=wallet
NIBI=nibid
NIBI_ID=nibiru-testnet-1
NIBI_FOLDER=.nibid
NIBI_VER=v0.15.0
NIBI_REPO=https://github.com/NibiruChain/nibiru.git
NIBI_GENESIS=https://rpc.testnet-1.nibiru.fi/genesis
NIBI_ADDRBOOK=https://raw.githubusercontent.com/elangrr/testnet_guide/main/nibiru/addrbook.json
NIBI_DENOM=unibi
echo "export NIBI_WALLET=${NIBI_WALLET}" >> $HOME/.bash_profile
echo "export NIBI=${NIBI}" >> $HOME/.bash_profile
echo "export NIBI_ID=${NIBI_ID}" >> $HOME/.bash_profile
echo "export NIBI_FOLDER=${NIBI_FOLDER}" >> $HOME/.bash_profile
echo "export NIBI_VER=${NIBI_VER}" >> $HOME/.bash_profile
echo "export NIBI_REPO=${NIBI_REPO}" >> $HOME/.bash_profile
echo "export NIBI_GENESIS=${NIBI_GENESIS}" >> $HOME/.bash_profile
echo "export NIBI_DENOM=${NIBI_DENOM}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $NIBI_NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " NIBI_NODENAME
	echo 'export NODENAME='$NIBI_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$NIBI_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$NIBI_ID\e[0m"
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

# Get testnet version of nibiru
cd $HOME
git clone $NIBI_REPO
cd nibiru
git checkout v0.15.0
make build
sudo mv ./build/nibid /usr/local/bin/ || exit

# GenTx generation
$NIBI config chain-id $NIBI_ID
$NIBI config keyring-backend file
$NIBI init $NIBI_NODENAME --chain-id $NIBI_ID
curl -s $NIBI_GENESIS | jq -r .result.genesis > $HOME/$NIBI_FOLDER/config/genesis.json
curl -s $NIBI_ADDRBOOK -o $HOME/$NIBI_FOLDER/config/addrbook.json

# Set Seeds And Peers
#SEEDS="8e1590558d8fede2f8c9405b7ef550ff455ce842@51.79.30.9:26656,bfffaf3b2c38292bd0aa2a3efe59f210f49b5793@51.91.208.71:26656,106c6974096ca8224f20a85396155979dbd2fb09@198.244.141.176:26656"
PEERS="5c30c7e8240f2c4108822020ae95d7b5da727e54@65.108.75.107:19656,dd8b9d6b2351e9527d4cac4937a8cb8d6013bb24@185.165.240.179:26656,55b33680faaad0889dddcd940c4e7f77cc74186a@194.163.151.154:26656,31b592b7b8e37af2a077c630a96851fe73b7386f@138.201.251.62:26656,97e599a3709d73936217e469bcea4cd1e5d837a0@178.62.24.214:39656,5eecfdf089428a5a8e52d05d18aae1ad8503d14c@65.108.141.109:19656,7ddc65049ebdab36cef6ceb96af4f57af5804a88@77.37.176.99:16656,ca251c4c914c0c70a32a2fdc00a6ea519a0a8856@45.141.122.178:26656,dd2a68405c170f14211a0c50ab6e0c1d48b4faf3@207.180.242.141:26656,2fc98a228dee1826d67e8a2dbd553989118a49cc@5.9.22.14:60656,2cd56c7b5d19b60246960a92b928a99d5c272210@154.26.138.94:26656,ff597c3eea5fe832825586cce4ed00cb7798d4b5@65.109.53.53:26656,ab5255a0607b7bdde58b4c7cd090c25255503bc6@199.175.98.111:36656,6369e3aefce2560b2073913d9317b3e9a0b06ab5@65.108.9.25:39656,16a5f0db538cafa0399c5a2b32b1d014b17932d4@162.55.27.100:39656,dc9554474fab76a9d62d4ab5d833f9fa7487a4eb@20.115.40.141:39656,35d8f676cf4db0f4ed7f3a8750daf8010797bdc4@135.181.116.109:20086,4be11bdbbab4541f7b663bcae8367928d48d3c4c@131.153.203.247:39656,ac8e43ccbdf25be95d7b85178c66f45453df0c7d@94.103.91.28:39656,1b49b68b6547b209c2c2ac8a5901a0d6c26edf03@92.63.98.244:26656,1004b58a7925cec67a36e41222474e44f0719ff5@5.161.124.79:39656,e977310b55bf8d50644647d0e30f272eddac12e8@65.108.58.98:36656"
#sed -i "s/^seeds *=.*/seeds = \"$SEEDS\"/;" $HOME/$NIBI_FOLDER/config/config.toml
sed -i.default "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/;" $HOME/$NIBI_FOLDER/config/config.toml

# Set Config Timeout
CONFIG_TOML="$HOME/$NIBI_FOLDER/config/config.toml"
sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $CONFIG_TOML
sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $CONFIG_TOML
sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $CONFIG_TOML
sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $CONFIG_TOML

# Set Config Gas
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025$NIBI_DENOM\"/" $HOME/$NIBI_FOLDER/config/app.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$NIBI_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$NIBI_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$NIBI_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$NIBI_FOLDER/config/app.toml
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$NIBI_FOLDER/config/config.toml
$NIBI tendermint unsafe-reset-all --home $HOME/$NIBI_FOLDER

# Create Service
sudo tee /etc/systemd/system/$NIBI.service > /dev/null <<EOF
[Unit]
Description=$NIBI
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=$(which $NIBI) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $NIBI
sudo systemctl restart $NIBI

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $NIBI -o cat\e[0m"
echo ""

# End

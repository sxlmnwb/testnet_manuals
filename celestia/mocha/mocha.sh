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
echo "            Auto Installer mocha For CELESTIA v0.11.1            ";
echo -e "\e[0m"
sleep 1

# Variable
TIA_WALLET=wallet
TIA=celestia-appd
TIA_ID=mocha
TIA_FOLDER=.celestia-app
TIA_VER=v0.11.1
TIA_REPO=https://github.com/celestiaorg/celestia-app
TIA_GENESIS=https://snapshots.polkachu.com/testnet-genesis/celestia/genesis.json
TIA_ADDRBOOK=https://snapshots.polkachu.com/testnet-addrbook/celestia/addrbook.json
TIA_DENOM=utia
TIA_PORT=16

echo "export TIA_WALLET=${TIA_WALLET}" >> $HOME/.bash_profile
echo "export TIA=${TIA}" >> $HOME/.bash_profile
echo "export TIA_ID=${TIA_ID}" >> $HOME/.bash_profile
echo "export TIA_FOLDER=${TIA_FOLDER}" >> $HOME/.bash_profile
echo "export TIA_VER=${TIA_VER}" >> $HOME/.bash_profile
echo "export TIA_REPO=${TIA_REPO}" >> $HOME/.bash_profile
echo "export TIA_REPO_NETWORK=${TIA_REPO_NETWORK}" >> $HOME/.bash_profile
echo "export TIA_GENESIS=${TIA_GENESIS}" >> $HOME/.bash_profile
echo "export TIA_ADDRBOOK=${TIA_ADDRBOOK}" >> $HOME/.bash_profile
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

# Get testnet version of celestia
cd $HOME
rm -rf celestia-app
git clone $TIA_REPO
cd celestia-app
git checkout $TIA_VER
make install
mv $HOME/go/bin/$TIA /usr/bin/

# Init generation
$TIA config chain-id $TIA_ID
$TIA config keyring-backend test
$TIA config node tcp://localhost:${TIA_PORT}657
$TIA init $TIA_NODENAME --chain-id $TIA_ID

# Download genesis and addrbook
curl -Ls $TIA_GENESIS > $HOME/$TIA_FOLDER/config/genesis.json
curl -Ls $TIA_ADDRBOOK > $HOME/$TIA_FOLDER/config/addrbook.json

# Set Seers and Peers
SEEDS=ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:11656
PEERS=3f4355f8c072b6ce3966af81af61ff1c8cf05cfa@65.108.158.250:26656,614e6d0aa9e7a19a9c848fb309cfb295a91b1add@95.216.102.235:26656,eb64c08c62219e55743cb9e395d73fe2ca8d486a@89.58.47.76:26656,858c45dd84f96631ed0ee1d0f717f8b51aaee19f@217.76.53.181:26656,1eaec90139d37c1beabdc1aa156125c22457dc6f@91.107.152.98:26656,078463a61c4298857ecb454a93f614d09eb6b1e4@5.78.61.11:26656,b03b9d03cf3f523b9cbbe08bf52ac97c648fbf37@109.205.183.222:26656,368dadf0a3b279fa40757b5839a61a61b16cbfd1@91.223.236.183:26656,ec0e55dc50b1747ad0df85b84b49016411194005@91.107.140.88:26656,3025feace255ba0e7aab053ab63a7a97d515efef@5.161.137.180:26656,ccf6fc804b9f615460758f6be476d39bce3375e7@5.161.147.249:26656,16908a5ac3cff7448d25a10a6f7028c523f7be26@185.135.137.224:26661
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/$TIA_FOLDER/config/config.toml

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${TIA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${TIA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${TIA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${TIA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${TIA_PORT}660\"%" $HOME/$TIA_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${TIA_PORT}317\"%; s%^address = \":8080\"%address = \":${TIA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${TIA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${TIA_PORT}091\"%" $HOME/$TIA_FOLDER/config/app.toml

# Set Config Pruning
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"
sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/$TIA_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$PRUNING_KEEP_RECENT\"/" $HOME/$TIA_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$PRUNING_INTERVAL\"/" $HOME/$TIA_FOLDER/config/app.toml

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001$TIA_DENOM\"/" $HOME/$TIA_FOLDER/config/app.toml

# Set indexer
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$TIA_FOLDER/config/config.toml

# Enable snapshots
cd $HOME
rm -rf ~/$TIA_FOLDER/data
mkdir -p ~/$TIA_FOLDER/data
curl -L https://snapshots.kjnodes.com/celestia-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$TIA_FOLDER

# Create Service
sudo tee /etc/systemd/system/$TIA.service > /dev/null <<EOF
[Unit]
Description=$TIA
After=network-online.target

[Service]
User=$USER
ExecStart=$(which $TIA) start --home $HOME/$TIA_FOLDER
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
echo -e "CHECK LOCAL STATUS : \e[1m\e[31mcurl -s localhost:${TIA_PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End

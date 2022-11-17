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
echo "           Auto Installer atlantic-1 For SEI v1.0.6beta          ";
echo -e "\e[0m"
sleep 1

# Variable
SEI_WALLET=wallet
SEI=seid
SEI_ID=atlantic-1
SEI_FOLDER=.sei
SEI_VER=1.0.6beta
SEI_REPO=https://github.com/sei-protocol/sei-chain.git
SEI_GENESIS=https://raw.githubusercontent.com/sei-protocol/testnet/main/sei-incentivized-testnet/genesis.json
SEI_ADDRBOOK=https://raw.githubusercontent.com/sei-protocol/testnet/main/sei-incentivized-testnet/addrbook.json
SEI_DENOM=usei
SEI_PORT=12

echo "export SEI_WALLET=${SEI_WALLET}" >> $HOME/.bash_profile
echo "export SEI=${SEI}" >> $HOME/.bash_profile
echo "export SEI_ID=${SEI_ID}" >> $HOME/.bash_profile
echo "export SEI_FOLDER=${SEI_FOLDER}" >> $HOME/.bash_profile
echo "export SEI_VER=${SEI_VER}" >> $HOME/.bash_profile
echo "export SEI_REPO=${SEI_REPO}" >> $HOME/.bash_profile
echo "export SEI_GENESIS=${SEI_GENESIS}" >> $HOME/.bash_profile
echo "export SEI_DENOM=${SEI_DENOM}" >> $HOME/.bash_profile
echo "export SEI_PORT=${SEI_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $SEI_NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " SEI_NODENAME
	echo 'export NODENAME='$SEI_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$SEI_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$SEI_ID\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$SEI_PORT\e[0m"
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

# Get testnet version of SEIru
cd $HOME
git clone -b $SEI_VER $SEI_REPO
cd sei-chain
git checkout $SEI_VER
make install

# GenTx generation
$SEI config chain-id $SEI_ID
$SEI config keyring-backend test
$SEI config node tcp://localhost:${SEI_PORT}657

# Init generation
$SEI init $SEI_NODENAME --chain-id $SEI_ID


# Download genesis and addrbook
curl -s $SEI_GENESIS -o $HOME/$SEI_FOLDER/config/genesis.json
curl -s $SEI_ADDRBOOK -o $HOME/$SEI_FOLDER/config/addrbook.json

# Set Seeds And Peers
SEEDS="df1f6617ff5acdc85d9daa890300a57a9d956e5e@sei-atlantic-1.seed.rhinostake.com:16660"
PEERS="22991efaa49dbaae857669d44cb564406a244811@18.222.18.162:26656,a37d65086e78865929ccb7388146fb93664223f7@18.144.13.149:26656,873a358b46b07c0c7c0280397a5ad27954a10633@141.95.175.196:26656,e66f9a9cab4428bfa3a7f32abbedbc684e734a48@185.193.17.129:12656,16225e262a0d38fe73073ab199f583e4a607e471@135.181.59.162:19656,2efd524f097b3fef2d26d0031fda21a72a51a765@38.242.213.174:12656,3b5ae3a1691d4ed24e67d7fe1499bc081c3ad8b0@65.108.131.189:20956,ad6d30dc6805df4f48b49d9013bbb921a5713fa6@20.211.82.153:26656,4e53c634e89f7b7ecff98e0d64a684269403dd78@38.242.235.141:26656,da5f6fcd1cd2ba8c7de8a06fb3ab56ab6a8157cf@38.242.235.142:26656,89e7d8c9eefc1c9a9b3e1faff31c67e0674f9c08@165.227.11.230:26656,94b6fa7ae5554c22e81a81e4a0928c48e41801d8@88.99.3.158:10956,b95aa07e60928fbc5ba7da9b6fe8c51798bd40be@51.250.6.195:26656,94b72206c0b0007494e20e2f9b958cd57e970d48@209.145.50.102:26656,94cf3893ded18bc6e3991d5add88449cd3f6c297@65.108.230.75:26656,82de728de0d663c03a820e570b94adac19c09adf@5.9.80.215:26656,5e1f8ccfa64dfd1c17e3fdac0dbf50f5fcc1acc3@209.126.7.113:26656,6a5113e8412f68bbeab733bb1297a0a38f884f7c@162.55.80.116:26656,7c95b2eec599369bebb8281b960589dc2857548a@164.215.102.44:26656,4bf8aa7b80f4db8a6f2abf5d757c9cab5d3f4d85@188.40.98.169:26656,9e38cf7ccb898632482a09b26ecba3f7e1a9e300@51.75.135.46:26656,641eea8d26c4b3b479b95a2cb4bd04712f3eda29@135.181.249.71:12656,8625abf6079da0e3326b0ad74c9c0e263af39654@137.184.44.146:12656,11c84300b4417af7e6c081f413003176b33b3877@51.75.135.47:26656,8a349512cf1ce179a126cb8762aea955ca1a261f@195.201.243.40:26651,6c27c768936ff8eebde94fe898b54df71f936e48@47.156.153.124:56656,7f037abdf485d02b95e50e9ba481166ddd6d6cae@185.144.99.65:26656,90916e0b118f2c00e90a40a0180b275261b547f2@65.108.72.121:26656,02be57dc6d6491bf272b823afb81f24d61243e1e@141.94.139.233:26656,ed3ec09ab24b8fcf0a36bc80de4b97f1e379d346@38.242.206.198:26656,7caa7add8d8a279e2da67a72700ab2d4540fbc08@34.97.43.89:12656,cce4c3526409ec516107db695233f9b047d52bf6@128.199.59.125:36376,3f6e68bd476a7cd3f491105da50306f8ebb74643@65.21.143.79:21156"
sed -i.default "s/^seeds *=.*/seeds = \"$SEEDS\"/;" $HOME/$SEI_FOLDER/config/config.toml
sed -i.default "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/;" $HOME/$SEI_FOLDER/config/config.toml

# Sei Port Command Ceation
echo -e "\e[1m\e[32m create seiport command /usr/local/bin \e[0m" && sleep 3
echo echo curl -s localhost:${SEI_PORT}657/status >seiport
echo echo proxy PORT = :${SEI_PORT}658 >>seiport
echo echo RPC server PORT = :${SEI_PORT}657 >>seiport
echo echo pprof listen PORT = :${SEI_PORT}060 >>seiport
echo echo p2p PORT = :${SEI_PORT}656 >>seiport
echo echo prometheus PORT = :${SEI_PORT}660 >>seiport
echo echo api server PORT = :${SEI_PORT}317 >>seiport
echo echo rosetta PORT = :${SEI_PORT}080 >>seiport
echo echo gRPC server PORT = :${SEI_PORT}090 >>seiport
echo echo gRPC-web server PORT = :${SEI_PORT}091 >>seiport
chmod +x ./seiport
sudo mv ./seiport /usr/local/bin

# Disable Indexing
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.sei/config/config.toml

# Set Config Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${SEI_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${SEI_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${SEI_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${SEI_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${SEI_PORT}660\"%" $HOME/$SEI_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${SEI_PORT}317\"%; s%^address = \":8080\"%address = \":${SEI_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${SEI_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${SEI_PORT}091\"%" $HOME/$SEI_FOLDER/config/app.toml

# Set Config Gas
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0$SEI_DENOM\"/" $HOME/$SEI_FOLDER/config/app.toml

# Set Config prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$SEI_FOLDER/config/config.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$SEI_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$SEI_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$SEI_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$SEI_FOLDER/config/app.toml

# Reset
$SEI tendermint unsafe-reset-all --home $HOME/$SEI_FOLDER

# Create Service
sudo tee /etc/systemd/system/$SEI.service > /dev/null <<EOF
[Unit]
Description=$SEI
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=$(which $SEI) start --home $HOME/$SEI_FOLDER
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $SEI
sudo systemctl start $SEI

echo -e "\e[1m\e[31mThanks to NODEIST for the original script...\e[0m"
echo ""
echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $SEI -o cat\e[0m"
echo ""

# End

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
TIA_GENESIS=https://celestia-testnet.nodejumper.io:443/genesis
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
cd $HOME
curl -s $TIA_GENESIS | jq .result.genesis > ~/$TIA_FOLDER/config/genesis.json

# Set Seeds Peers And Boots
#SEEDS=""
BOOTS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')
PEERS="e5fa03c0d18d1e51182a7d787fc25c3e57f03d7b@celestia-testnet.nodejumper.io:29656,ff4a0e9cd3c5dbec947470005d578a816ce9a77a@5.189.166.45:2665,1d5f32e1b162b7dd289dce98fbf59fcb1cd916ba@195.201.168.245:2665,32c6d8b4f92c1b4ed89ed29c76c3e197af7712ad@167.86.105.58:2665,f0c58d904dec824605ac36114db28f1bf84f6ea3@144.76.112.238:2665,41d3911767a064c54a6298fb91f2819db077952b@82.66.59.148:2665,1e6aaaf2aee85a9f188e09a94eae1266a710650f@185.169.252.217:2665,e4dede13557645944e6e825c859094f833720034@95.111.244.100:2665,2775e75ff19be27cea90c7d5baf91a19eefad4b5@222.254.188.99:2665,e635793b069f73de913bad0d906e78b8490411eb@142.132.165.177:2665,7a305c17c50539481245ff22ea7b86835b2738c4@66.94.107.88:2665,e56142ceb38e6a42c2494a587c75d7008a936f28@88.99.140.242:2665,b609b52c82d941bde869d313a059806da3440caa@161.97.136.149:2665,3ed5ad604fb0a188507a4d3d083ef2be40279f79@173.212.224.115:2665,bb6fe400ec666e57e114e523ff09b7785ca303d5@8.219.67.147:2665,b56b0406abd33a0b99dfd0bee61df38c222e6d46@95.214.55.25:3165,6a076845f2d7943d601758d13fef1b42226b787a@95.217.208.108:2665,0b57a58b87b10d13fc68c964e0cdb5fb1b8895a2@62.141.39.240:2665,815cd9487821e6935c9cc1135b971fd4b3c00ccc@65.108.11.90:2665,e4188301d1f898e1e7c0e9de660a304930c45c78@51.255.171.182:2665,6270094395e8d94f159a3fa7aab2db73d5123385@104.52.67.223:2665,958ab9769dc3a8c5eb5c638869ec66b1a0794e1e@51.79.240.82:2665,519d96f9888015106f71ec147ee7452b630a86c0@207.180.217.16:2665,5b37597df806c7abe16dda64e6761a0e4b7ada4a@65.108.209.46:2665,2f619287b600353abad4a3176b9578041bbae42d@62.171.166.145:2665,580025dea8c5d2459606031423df38f41f21b80d@144.91.125.230:2665,7145da826bbf64f06aa4ad296b850fd697a211cc@46.4.23.42:5004,a0a93e2f49bd137888f5b9fcde6a7a141ecdc2af@70.34.244.65:2665,d42e086b410235e3a3079b90f8e8867b8c07bf02@45.94.58.217:2665,23fc7c787060ce43d54f95aa10117a7401d64569@65.108.60.54:2665,e2eddad9e56a7eb85d4b4c657c3ce77d31737ae6@185.234.69.139:2665,2f93a0af8465cea67004935fc220b754977cc17a@157.90.181.205:2665,b3e2c7df70e3d1cdb8df8ce58430adfef8eec487@144.91.86.8:2665,538860e48e47f1f97629e1a52cdee474c4077f26@94.250.203.2:2665,ceaea89fd7434de0dd39f15f15f9330739aa5b98@194.163.182.169:2665,f17415613f49f69af7c9928a1c6ca7e2e640dc7d@154.53.59.65:2665,12091c6adbb12e783ab48f1b8abb9f8db425e22e@75.119.150.7:2665,6f99a6456d85f25c88ec2b9c43066c0362745874@95.217.190.225:2665,9e262d5c127a4147977d19da6b6507bbc015eae7@65.108.156.1:2665,060a3966ac40e07e5f3d11d36970d03fac198776@49.12.229.55:2665,1f651fe15f88e860008f9fef700ed4b3e343f893@64.225.78.126:2665,de231748ff87f2159149116d803f93ad57a00f20@185.87.148.108:2665,80052a4ff269bf84a6c966d61176d6a6fb1bfd01@65.108.13.69:2665,ca99b351866a299ad4279dfb3cc600ca24da9f5e@65.108.11.90:2665,72b34325513863152269e781d9866d1ec4d6a93a@65.108.194.40:2665,92504bdb4d11275185527194466ca0cca99ba7cd@65.21.146.135:2665,5583207f2a2d67f291c08a675b202b94fed4e00f@65.108.73.173:2665,58847d316fe4d70717fc497cd8218f7de4bb7704@85.208.48.117:2665,c897ef5213793c85d37bb481871038f2ba771c66@164.68.113.162:2665,2e4084408b641a90c299a499c32874f0ab0f2956@65.108.44.149:2265,2376cf83e468ced1fb8ab7bb8e45d0eb6e278f3e@62.171.139.88:2665,044999029a558db1261367f61ddc17fd5fa4a81f@185.146.157.37:2665,136d85c94676eb624662e9bd8d5702a6099f8293@194.163.175.120:2665,ac6c6e8a3e6e5f70b46c17b5e055924ca0da8b40@167.86.115.183:2665,71acfd10fbe0b8466769a08acfd37948759d38cc@194.163.134.162:2665,5393441a70ab409de49f618b9979fd4416527a93@73.223.103.219:2665,cc3a4ef04862945158d9aa0b7f7ba1a30458aa7a@38.242.202.39:2665,6f924b369e6c8ac8041d8aedd8ba0b489ceab85b@143.244.186.193:2665,0f67feb59517cb84e130fb7f48571656344ce932@149.28.18.107:2665,19265d1892b04e6a520154f9cb395e6447c23657@104.156.232.71:2665,f5a5112649d3fcc242260821a2f8422c7700a9a7@64.227.180.110:2665,cb413cf7f68fff8ab89f56e3af2427d75ce4c6fa@207.148.78.160:2665,a02cdf3614ab71980ef7be0a690fc4af62c3ca41@38.242.231.213:2665,1a79b2e2cf2bbe5275a4a58c3425d77e9b678e82@38.242.202.182:2665,7516179c6e045ab88d5732eb372f6dcb405e9778@167.86.103.3:2665,43899a81c734cd89969e94b28232a94f4ff931f1@5.161.58.25:2665,e86063097c062757e9e1fcf887e5df982505e147@62.171.181.22:2665,27482946b91dc4487f8140689c5f13cb4b0c3c5c@135.181.90.235:2665,6c74e2732523139725f7586242db210f0eb20924@65.108.244.30:2665,234ac444aaaad3f4d2c260eb6e683edff6287afb@5.9.80.29:2665,25eb1ad9e6096b5ce036074c18076f53f663d247@161.97.145.226:2665,bf5c1d9e9f65ae21800558b468034d2b9f0a7319@65.21.137.84:2665,5af1a1de7dba82e2345dec17353f5aa61c5e5040@185.239.208.172:2665,47bfcbf78e35c7b3e109bea8bfe30ceb5ea065cb@45.94.58.193:2665,1471df8ca8d4cb8de70b433e89c576234e91faae@65.108.211.139:2665,fa54e261325b7b34c74a4521681f65379bcbdaaf@178.170.39.211:2665,7c645d8043f7592079fb1d48edad887e0deae354@5.9.16.182:2665,1b5344045902b019487084dd2ba2acb5c26b93e8@161.97.166.146:5753,5ca17c60113c786e64f5156d9f9c19f24b63da03@135.181.179.166:2665,aef9f8ca99bcf506edf9ef3cd36031c2dc0a59ef@194.233.76.179:2665,10aee0ce63457eff2fb5ab15323868bb8652d8b3@185.207.250.24:2665,7e01bc6481a33c37257ea78a3b8c9774a54169db@167.71.174.95:2665,b2a6536a271349faf652731e910d0efbd165e6fe@152.228.216.117:2665,e28529b05b9e2f02aed59143322bd9cfae788eb8@164.68.118.103:2665,6d9eb8d91ab3f8978b0e80c0f4fbffb150a54c0c@198.74.51.233:2665,9c8d7f9a55b99acb9d7bbfce98de2608b8d206dc@217.79.178.169:2665,2cdf041a2e0194393b47765d9c0bdd447e42c7db@159.89.107.9:2665,d05f648b117412b8989f3099de3d9664fda173e4@35.167.107.175:2665,79337e1b7bd36033181d1d8c6e3d7b9689b4aadb@95.153.99.146:2665,79be0ec0a297210908448ef03c25e0a3e5b2fb51@141.95.101.104:2665,a0b23bdd6c461b99867f0912165851406c316a45@93.66.255.195:2665,0c83ecd5fa20aedb5401494fd1865877c79dbe1f@167.179.91.181:2665,c0e5f68fa769306cb1398beb3bc6dc72a5221c10@207.244.255.242:2665,e4429e99609c8c009969b0eb73c973bff33712f9@141.94.73.39:4365,c6f94bc444f1614acf848221fabb65e77e2e1d9d@65.108.43.116:5610,f86120fa9bcf09e39e7e2373884c7018a4980fc5@164.68.100.86:2665,8ab259998593cb51d1b09d771e4d14b6625f6f96@83.136.233.215:2665,d39caee65b925a734b0661c51d5946f94586b1d0@178.238.229.107:2665,09263a4168de6a2aaf7fef86669ddfe4e2d004f6@142.132.209.229:5937,b2441b750f9f811a19ddf1c7723628a448266dbe@222.106.187.14:5014"
sed -i.default "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTS\"/;" $HOME/$TIA_FOLDER/config/config.toml
sed -i.default "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/;" $HOME/$TIA_FOLDER/config/config.toml
#sed -i.default "s/^seeds *=.*/seeds = \"$SEEDS\"/;" $HOME/$TIA_FOLDER/config/config.toml

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

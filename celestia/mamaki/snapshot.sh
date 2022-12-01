sudo systemctl stop celestia-appd

cp $HOME/.celestia-app/data/priv_validator_state.json $HOME/.celestia-app/priv_validator_state.json.backup
celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app --keep-addr-book

rm -rf $HOME/.celestia-app/data 

SNAP_NAME=$(curl -s https://snapshots3-testnet.nodejumper.io/celestia-testnet/ | egrep -o ">mamaki.*\.tar.lz4" | tr -d ">")
curl https://snapshots3-testnet.nodejumper.io/celestia-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.celestia-app

mv $HOME/.celestia-app/priv_validator_state.json.backup $HOME/.celestia-app/data/priv_validator_state.json

sudo systemctl restart celestia-appd
sudo journalctl -u celestia-appd -f --no-hostname -o cat
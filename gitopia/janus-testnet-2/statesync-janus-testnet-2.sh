#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

sudo systemctl stop gitopiad

cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup

rm -rf $HOME/.gitopia/data

echo -e "\e[1m\e[32mINFO\e[0m \e[1m\e[31mDOWNLOAD snapshot_latest.tar.lz4 | kjnodes\e[0m"
curl -L https://snapshots.kjnodes.com/gitopia-testnet/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.gitopia

mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json

sudo systemctl start gitopiad

echo -e "\e[1m\e[32mINFO\e[0m \e[1m\e[31mLOADING FOR CONNECT STATE SYNC ...\e[0m"
sleep 10
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu gitopiad -o cat\e[0m"

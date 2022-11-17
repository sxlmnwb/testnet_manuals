#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

sudo systemctl stop seid

cp $HOME/.sei/data/priv_validator_state.json $HOME/.sei/priv_validator_state.json.backup
seid tendermint unsafe-reset-all --home $HOME/.sei --keep-addr-book

SNAP_RPC="https://sei-testnet-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.sei/config/config.toml

mv $HOME/.sei/priv_validator_state.json.backup $HOME/.sei/data/priv_validator_state.json

sudo systemctl start seid
echo -e "\e[1m\e[32mINFO\e[0m \e[1m\e[31mLOADING FOR CONNECT STATE SYNC ...\e[0m"
sleep 10
sudo journalctl -u seid -f --no-hostname -o cat
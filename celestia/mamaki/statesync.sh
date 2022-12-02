#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

sudo systemctl stop celestia-appd

cp $HOME/.celestia-app/data/priv_validator_state.json $HOME/.celestia-app/priv_validator_state.json.backup

SNAP_RPC="https://rpc-mamaki.pops.one:443"
SNAP_RPC2="https://celestia-testnet-rpc.polkachu.com:443"
SNAP_RPC3="https://rpc.celestia.testnet.run:443"
SNAP_RPC4="https://rpc.mamaki.celestia.counterpoint.software:443"


LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC2,$SNAP_RPC3,$SNAP_RPC4\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.celestia-app/config/config.toml

mv $HOME/.celestia-app/priv_validator_state.json.backup $HOME/.celestia-app/data/priv_validator_state.json

sudo systemctl restart celestia-appd
echo -e "\e[1m\e[32mINFO\e[0m \e[1m\e[31mLOADING FOR CONNECT STATE SYNC ...\e[0m"
sleep 10
echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu celestia-appd -o cat\e[0m"
echo ""
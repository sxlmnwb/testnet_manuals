#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

systemctl stop neutrond
RPC="http://rpc.neutron.ppnv.space:11657"
LATEST_HEIGHT=$(curl -s $RPC/block | jq -r .result.block.header.height);
TRUST_HASH=$(curl -s $RPC/block?height=$LATEST_HEIGHT | jq -r .result.block_id.hash);
sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$LATEST_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.neutrond/config/config.toml
systemctl start neutrond
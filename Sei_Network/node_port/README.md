# Client

<p align="center">
  <img height="125" height="auto" src="https://raw.githubusercontent.com/sxlmnwb/testnet_manuals/master/Sei_Network/node_port/asset/client.PNG">
</p>

Change port client to "26657"
```
nano .sei/config/client.toml
```

# Config

<p align="center">
  <img height="125" height="auto" src="https://raw.githubusercontent.com/sxlmnwb/testnet_manuals/master/Sei_Network/node_port/asset/config.png">
</p>

Change port config to "26657"
```
nano .sei/config/config.toml
```

# Reboot Sei Network

If you have changed the port completely and do the command below
```
sudo systemctl restart seid
sudo systemctl start seid
sudo journalctl -fu seid -o cat
```

# Result

<p align="center">
  <img height="auto" height="auto" src="https://raw.githubusercontent.com/sxlmnwb/testnet_manuals/master/Sei_Network/node_port/asset/result.PNG">
</p>

If the result is like this, it means that the port you changed is running
```
curl localhost:26657/status
```
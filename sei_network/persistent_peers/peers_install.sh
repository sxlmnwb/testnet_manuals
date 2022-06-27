#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

PEERS="c934936c76c85240fc42044e3e95b266a02bbad4@167.86.70.196:26656,fca9e777bdfbc32ff8266e155618d85f0f414f91@38.242.213.68:26656,239414a6ee3ad949715b9626a2c212cbff96707d@149.102.139.101:26656,cc3485ff9363c261220eac38804e8d8a442e2bf7@178.128.250.108:26656,e935386a8b1d28d4b45f00af52fa925356d3ea09@194.163.189.60:26656,2a4bdcd8a1347275508219ca541fb85dba55cfc5@34.125.76.144:26656,3941c02ca312b819bd97bcdcff258093ae0f3eb7@104.248.20.240:36376,93091ef49a3839c385324eeac3ad45ac04507070@167.172.154.251:26656"
sudo sed -i "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/;" $HOME/.sei/config/config.toml
sudo systemctl restart seid
sudo systemctl start seid
sudo journalctl -fu seid -o cat

# End

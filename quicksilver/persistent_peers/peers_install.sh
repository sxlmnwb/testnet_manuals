#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

PEERS="1999a4a804a1946ab10def5c71eec02415bda479@161.97.82.203:26256"
sudo sed -i "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/;" $HOME/.quicksilverd/config/config.toml
sudo systemctl restart quicksilverd
sudo systemctl start quicksilverd
sudo journalctl -fu quicksilverd -o cat

# End
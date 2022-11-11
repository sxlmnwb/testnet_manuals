#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

sudo systemctl stop neutrond
sudo systemctl disable neutrond
sudo rm /etc/systemd/system/neutrond* -rf
sudo rm $(which neutrond) -rf
sudo rm $HOME/.neutrond* -rf
sudo rm $HOME/neutrond* -rf
sudo rm $HOME/go* -rf
sudo rm $HOME/neutron* -rf
sudo rm $HOME/.bash_profile* -f
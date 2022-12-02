#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

systemctl stop celestia-appd
celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | egrep -o ">mamaki.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - -C ~/.celestia-app/data/
systemctl restart celestia-appd 

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu celestia-appd -o cat\e[0m"
echo ""

# End

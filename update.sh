sudo rm -R ~/QbusOpenHab > /dev/null 2>&1    # Verwijderen van oude files
git clone https://github.com/QbusKoen/QbusClientServer ~/QbusOpenHab > /dev/null 2>&1    # Downloaden van nieuwe bestanden
sudo systemctl stop qbusclient.service > /dev/null 2>&1    # oude client stoppen
sudo systemctl stop qbusserver.service > /dev/null 2>&1    # oude server stoppen
sudo systemctl start qbusserver.service > /dev/null 2>&1   # nieuwe server starten
sudo systemctl start qbusclient.service > /dev/null 2>&1   # nieuwe client starten



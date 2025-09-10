iwctl --passphrase "YourPassword" station wlan0 connect "YourNetworkName"

# using network manager 
nmcli device wifi list
nmcli device wifi connect "YourNetworkName" password "YourPassword"
  
curl -fsSL https://raw.githubusercontent.com/alistairjoelquinn/arch-setup-script/main/bootstrap.sh | bash

github: read:user, repo, write:public_key

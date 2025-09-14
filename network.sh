iwctl --passphrase "YourPassword" station wlan0 connect "YourNetworkName"

# using network manager 
nmcli device wifi list
nmcli device wifi connect "YourNetworkName" password "YourPassword"
  
curl -fsSL https://raw.githubusercontent.com/alistairjoelquinn/arch-setup-script/main/bootstrap.sh | bash

notes:
github - read:user, repo, write:public_key
SETUP LANGUAGE SERVERS: do this like described in the neovim lsp folder
install : go, rust, lua, lua rocks

# Dotfiles

# Prerequisites
``` bash
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
```
``` bash
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-6.0
```
``` bash
dotnet tool install -g csharp-ls
```

# Install
``` bash
curl -Lks https://gist.githubusercontent.com/linuselander/698ad9546bce20542ea3ee719d8e913a/raw/f3564b7c83c80548ac9f64bbc033def289a8715b/dotfiles-setup.sh | /bin/bash
```

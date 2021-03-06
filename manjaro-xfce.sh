#!/bin/bash

echo "
██████████████████  ████████
██████████████████  ████████
██████████████████  ████████
██████████████████  ████████
████████            ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
████████  ████████  ████████
"

pacman_packages=(
    "chezmoi"
    "chromium"
    "discord"
    "keychain"
    "libreoffice-fresh"
    "lolcat"
    "neofetch"
    "noto-fonts-emoji"
    "numlockx"
    "nvm"
    "plank"
    "python-pip"
    "redshift"
    "thefuck"
    "tig"
    "tilix"
    "ttf-fira-code"
    "ttf-roboto-mono"
    "ttf-roboto"
    "zsh"
)

aur_packages=(
    "emote"
    "gotop-bin"
    "keybase-bin"
    "lightdm-webkit2-theme-glorious"
    "mullvad-vpn-bin"
    "spotify"
    "todoist-appimage"
    "ulauncher"
    "visual-studio-code-bin"
)

pip_packages=(
    "random-username"
)

npm_packages=(
    "yarn"
)

to_uninstall=(
    "onlyoffice-desktopeditors"
    "xfce4-terminal"
)

echo "Uninstall packages"
for package in "${to_uninstall[@]}"; do
    sudo pacman -R --noconfirm "$package"
done

echo "Update system"
sudo pacman --noconfirm -Syyu

##############
echo "Install yay"
sudo pacman -S --needed --noconfirm git base-devel yay

echo "Install Pacman packages"
for pacman_package in "${pacman_packages[@]}"; do
    sudo pacman -S --noconfirm "$pacman_package"
done

echo "Install AUR packages"
for aur_package in "${aur_packages[@]}"; do
    yay -S --noconfirm "$aur_package"
done

echo "Install pip packages"
for pip_package in "${pip_packages[@]}"; do
    pip3 install "$pip_package"
done
##############


##############
echo "Icons and Theme"
wget https://github.com/cbrnix/Flatery/archive/refs/heads/master.zip
unzip master.zip
mkdir ~/.icons/ -p
mv Flatery-master/Flatery* .icons
rm -rf Flatery-master
rm master.zip

wget https://github.com/EliverLara/Nordic/archive/refs/heads/master.zip
unzip master.zip
mkdir ~/.themes/Nordic-darker -p
mv Nordic-master/* .themes/Nordic-darker
rm -rf Nordic-master
rm master.zip
##############

##############
echo "Fonts"
sudo mkdir -p /usr/local/share/fonts/m/
cd /usr/local/share/fonts/m/
sudo wget https://github.com/fhavrlent/powerline-fonts/raw/main/MesloLGS_NF_Bold.ttf
sudo wget https://github.com/fhavrlent/powerline-fonts/raw/main/MesloLGS_NF_Bold_Italic.ttf
sudo wget https://github.com/fhavrlent/powerline-fonts/raw/main/MesloLGS_NF_Italic.ttf
sudo wget https://github.com/fhavrlent/powerline-fonts/raw/main/MesloLGS_NF_Regular.ttf
cd ~
##############

##############
echo "Set Node"
. ~/.nvm/nvm.sh
nvm install node


echo "Install npm packages"
for npm_package in "${npm_packages[@]}"; do
    npm i "$npm_package" -g
done
##############

##############
echo "Mullvad GPG key"
wget https://mullvad.net/media/mullvad-code-signing.asc
gpg2 --import mullvad-code-signing.asc
rm mullvad-code-signing.asc
##############

##############
echo "Import GPG Private key"
gpg --batch --import ~/.gpg/privkey.asc
(echo 5; echo y; echo save) |
gpg --command-fd 0 --no-tty --no-greeting -q --edit-key "$(
  gpg --list-packets <privkey.asc |
awk '$1=="keyid:"{print$2;exit}')" trust
##############

##############
echo "Install Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
rm .zshrc
##############

##############
echo "Dotfiles"
mkdir ~/.config/chezmoi -p
wget https://raw.githubusercontent.com/fhavrlent/manjaro-xfce-setup/main/chezmoi.toml
mv ./chezmoi.toml ~/.config/chezmoi
chezmoi init --apply --verbose fhavrlent
##############


##############
echo "Tilix theme"
mkdir ~/.config/tilix/schemes -p
wget https://raw.githubusercontent.com/arcticicestudio/nord-tilix/develop/src/json/nord.json
mv ./nord.json ~/.config/tilix/schemes
##############

##############
echo "Plank theme"
mkdir ~/.local/share/plank/themes -p
wget https://github.com/fhavrlent/manjaro-xfce-setup/raw/main/assets/mcOS-BS-iMacM1-DarkBlue.zip
unzip mcOS-BS-iMacM1-DarkBlue.zip -d ~/.local/share/plank/themes
rm mcOS-BS-iMacM1-DarkBlue.zip
##############

##############
echo "Greeter pre-setup"
sudo sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme=glorious #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
sudo sed -i 's/^debug_mode\s*=\s*\(.*\)/debug_mode=true #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
##############

##############
echo "Download wallpaper"
cd /usr/share/backgrounds/
sudo wget https://github.com/fhavrlent/manjaro-xfce-setup/raw/main/assets/twomoons.png
cd ~
##############

zsh -c "`curl -L https://raw.githubusercontent.com/fhavrlent/manjaro-xfce-setup/main/manjaro-xfce-zsh.sh`"


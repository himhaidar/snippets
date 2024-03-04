#!/bin/bash

#-- Cautions --#
echo "Make sure you're running this file as 'root'."
echo -e "This file will make changes to your system. Make sure\nyou are OK with the changes, before proceeding"

#-- Timezone --#
echo "Setting up timezone"
timedatectl set-ntp true
timedatectl set-timezone "Asia/Karachi"

#-- Users and Groups --#
NEW_USER=hey
echo -n "Do you want to create a new user? (y/n): "; read -r nu
if [ "$nu" == "y" ]; then
  echo -n "Username:"; read -r _uname
  NEW_USER=$_uname
  echo "Setting up users and groups"
  useradd --create-home --groups sudo --shell "/bin/bash" $NEW_USER
  mkdir -p /home/$NEW_USER/.ssh && touch /home/$NEW_USER/.ssh/authorized_keys
  sudo apt install -y rsync
  rsync --archive --chown=${USERNAME}:${USERNAME} /root/.ssh /home/${USERNAME}
fi

#-- Python --#
echo "Setting up Python"
apt-get update && apt-get install -y fail2ban python3 python3-pip python3-venv python-is-python3

#-- Nginx --#
echo "Setting up Nginx"
apt-get install -y nginx
rm -rf /etc/nginx/sites-enabled/default

#-- Firewall --#
echo -n "Do you want to setup firewall? (y/n): "; read -r fw
if [ "$fw" == "y" ]; then
  echo "Setting up firewall"
  apt-get install -y ufw
  ufw delete allow 8000
  ufw delete allow 'Nginx HTTP'
  ufw allow ssh
  ufw allow 80
  ufw allow 443
  ufw allow 'Nginx Full'
fi

#-- PostgreSQL --#
echo -n "Do you want to setup PostgreSQL? (y/n): "; read -r _pg
if [ "$_pg" == "y" ]; then
  echo "Setting up PostgreSQL"
  apt-get install -y postgresql
  sudo -i -u postgres psql -c "CREATE DATABASE ${DB_NAME}"
  sudo -i -u postgres psql -d greenlight -c "CREATE EXTENSION IF NOT EXISTS citext"
  sudo -i -u postgres psql -d greenlight -c "CREATE ROLE greenlight WITH LOGIN PASSWORD '${DB_PASSWORD}'"
  # sudo su - postgres
fi

#-- Let's Encrypt Certificates --#
echo -n "Do you want to setup Let's Encrypt certificates? (y/n): "; read -r le
if [ "$le" == "y" ]; then
  apt-get install -y certbot python3-certbot-nginx
  certbot --non-interactive --nginx -d haidarali.net -d www.haidarali.net --email himhaidar@icloud.com --agree-tos <<< "yes"
  systemctl enable certbot.timer --now
  systemctl status certbot.timer
fi

#-- Personalizing htop --#
echo "Personalizing htop"
apt-get install -y htop
mkdir -p /home/$NEW_USER/.config/htop && \
curl -L "https://raw.githubusercontent.com/imadkat/dotfiles/master/.config/htop/htoprc" \
                 -o "/home/$NEW_USER/.config/htop/htoprc";

#-- Permission --#
if [ "$nu" = "y" ]; then
  echo "Applying permissions"
  chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/ && chown $NEW_USER:$NEW_USER /home/$NEW_USER
  chmod 700 /home/$NEW_USER/.ssh && chmod +644 /home/$NEW_USER/.ssh/authorized_keys && chmod u+w /home/$NEW_USER
fi

#-- Clean up --#
echo "Cleaning up"
apt-get autoremove

#-- Exit Message --#
echo "Execute these manually:"
echo "  scp ~/.vimrc $NEW_USER@haidarali.net:~/.vimrc"
echo "  ssh-copy-id -i ~/.ssh/id_rsa.pub $NEW_USER@haidarali.net"
echo "Finshed. :)"

#-- Enable Firewall --#
[ "$fw" == "y" ] && ufw enable


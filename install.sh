#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading system..."
sudo apt update -y
sudo apt upgrade -y

# Modify ~/.bashrc for aliases
echo "Adding aliases to ~/.bashrc..."
cat <<EOL >> ~/.bashrc

# linux
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# docker
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcr='docker-compose run'
alias dclf='docker-compose logs -f'

alias dkt='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'

alias dkps="docker ps --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"

dke() {
  docker exec -it \$1 /bin/sh
}
EOL

# Source the updated ~/.bashrc
echo "Sourcing ~/.bashrc..."
source ~/.bashrc

# Docker setup
echo "Installing Docker..."
curl -sSL https://get.docker.com | sh

# Add user to docker group
echo "Adding user to docker group..."
sudo usermod -aG docker $USER

# Show groups to verify
echo "Verifying groups..."
groups

# Logout to apply changes
echo "Please logout and log back in to apply group changes."

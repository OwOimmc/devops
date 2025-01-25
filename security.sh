#!/bin/bash

# Change SSH port to a non-standard one (e.g., 22)
SSH_PORT="22"  # Set your custom SSH port here

# Define an array of ports to allow (dynamic configuration)
ALLOWED_PORTS=(
  "$SSH_PORT/tcp"  # SSH port
  "80/tcp"         # HTTP
  "443/tcp"        # HTTPS
)

# Ensure VPS is regularly updated with the latest security patches
echo "Step 1: Regular Updates"

# Update package lists and upgrade installed packages
echo "Updating and upgrading system..."
sudo apt update -y
sudo apt upgrade -y

# Install unattended-upgrades for automatic security updates
# echo "Installing unattended-upgrades for automatic updates..."
# sudo apt install unattended-upgrades -y
# sudo dpkg-reconfigure --priority=low unattended-upgrades

# Step 2: SSH Security
echo "Step 2: SSH Security"

# Disable root login
echo "Disabling root login..."
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config


echo "Changing SSH port to $SSH_PORT..."
sudo sed -i "s/^#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config

# Restart SSH service
echo "Restarting SSH service..."
sudo systemctl restart sshd

# Set up SSH keys (inform user to manually set up their SSH key)
echo "Please ensure you have set up SSH keys. Generate them with 'ssh-keygen' and use 'ssh-copy-id' to copy your key."
echo "ssh-copy-id username@your_server_ip"

# Step 3: Firewall Configuration with UFW
echo "Step 3: Firewall Configuration"

# Install UFW (if not installed)
echo "Installing UFW..."
sudo apt install ufw -y


# Allow necessary ports (loop through ALLOWED_PORTS)
echo "Allowing necessary ports..."
for PORT in "${ALLOWED_PORTS[@]}"; do
  sudo ufw allow $PORT
done

# Enable UFW
echo "Enabling UFW..."
sudo ufw enable

# Check the status of UFW
echo "Checking UFW status..."
sudo ufw status verbose

# Step 4: Install and Configure Fail2Ban
echo "Step 4: Fail2Ban Setup"

# Install Fail2Ban
echo "Installing Fail2Ban..."
sudo apt install fail2ban -y

# Configure Fail2Ban to protect SSH (change port to dynamic SSH_PORT)
echo "Configuring Fail2Ban for SSH protection on port $SSH_PORT..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo sed -i 's/^#enabled = true/enabled = true/' /etc/fail2ban/jail.local
sudo sed -i "s/^#port = ssh/port = $SSH_PORT/" /etc/fail2ban/jail.local

# Restart Fail2Ban to apply the configuration
echo "Restarting Fail2Ban..."
sudo systemctl restart fail2ban

# Check Fail2Ban status
echo "Checking Fail2Ban status..."
sudo fail2ban-client status
sudo fail2ban-client status sshd

echo "Security setup complete! Please verify all settings, especially SSH keys, SSH port, and firewall rules."

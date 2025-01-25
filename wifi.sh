#!/bin/bash

# Define the list of Wi-Fi networks
NETWORKS=(
  "SSID_1:Password_1"
  "SSID_2:Password_2"
  "SSID_3:Password_3"
)

# Initialize the priority counter
priority_counter=1

# Modify /etc/wpa_supplicant/wpa_supplicant.conf dynamically for each network
echo "Configuring Wi-Fi networks..."
for NETWORK in "${NETWORKS[@]}"; do
  SSID=$(echo $NETWORK | cut -d: -f1)
  PSWD=$(echo $NETWORK | cut -d: -f2)

  NETWORK_ENTRY="
network={
  scan_ssid=1
  ssid=\"$SSID\"
  psk=\"$PSWD\"
  priority=$priority_counter
}
"

  # Append the new network configuration
  echo "$NETWORK_ENTRY" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null

  # Increment the priority counter for the next network
  ((priority_counter++))
done

# Restart the networking service to apply changes
echo "Restarting networking service..."
sudo systemctl restart networking

echo "Wi-Fi configuration updated. Please review and confirm in /etc/wpa_supplicant/wpa_supplicant.conf."

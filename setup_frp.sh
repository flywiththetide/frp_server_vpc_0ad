#!/bin/bash

# Download and extract FRP
wget https://github.com/fatedier/frp/releases/download/v0.43.0/frp_0.43.0_linux_amd64.tar.gz
tar -xzf frp_0.43.0_linux_amd64.tar.gz
cd frp_0.43.0_linux_amd64

# Create the frps.ini configuration file
cat <<EOT > frps.ini
[common]
bind_port = 7000
EOT

# Create a systemd service for FRP
cat <<EOT > /etc/systemd/system/frps.service
[Unit]
Description=FRP Server Service
After=network.target

[Service]
ExecStart=/root/frp_0.43.0_linux_amd64/frps -c /root/frp_0.43.0_linux_amd64/frps.ini
WorkingDirectory=/root/frp_0.43.0_linux_amd64
Restart=always
User=root
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=frps

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd, enable, and start the frps service
systemctl daemon-reload
systemctl enable frps.service
systemctl start frps.service

# Open the required ports using UFW
ufw allow 7000
ufw allow 20595/udp

echo "FRP server setup completed!"

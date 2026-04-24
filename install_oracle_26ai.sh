#!/bin/bash
###############################################################################
# 🖤 7-AGENT-1 + ORACLE 26ai — AUTOMATED INSTALLER 🖤
# For Oracle E2.1 + Ubuntu 24.04 LTS
# Run this on your E2.1 instance AFTER uploading your DB wallet
###############################################################################

set -e  # Exit on any error

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║     🖤 7-AGENT-1 ORACLE 26ai — AUTOMATED INSTALLATION 🖤              ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

###############################################################################
# CHECK PREREQUISITES
###############################################################################
echo -e "${BLUE}[STEP 0] Checking prerequisites...${NC}"

if [ "$EUID" -eq 0 ]; then 
   echo -e "${RED}❌ Please do NOT run as root. Use 'ubuntu' user.${NC}"
   exit 1
fi

if [ ! -f "$HOME/oracle_wallet/tnsnames.ora" ]; then
    echo -e "${YELLOW}⚠️  Database wallet not found at ~/oracle_wallet/${NC}"
    echo -e "${YELLOW}   Please upload your wallet first, then re-run.${NC}"
    echo ""
    echo "   From your LOCAL machine, run:"
    echo "   scp -i ~/.ssh/YOUR_KEY.pem ~/Downloads/Wallet_*.zip ubuntu@$PUBLIC_IP:~/oracle_wallet/"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites OK${NC}"

###############################################################################
# STEP 1: SYSTEM UPDATE
###############################################################################
echo ""
echo -e "${BLUE}[STEP 1] Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget unzip nano build-essential \
    software-properties-common apt-transport-https ca-certificates \
    gnupg lsb-release net-tools ufw fail2ban nginx python3 python3-pip \
    python3-venv nodejs npm libaio1
echo -e "${GREEN}✅ System updated${NC}"

###############################################################################
# STEP 2: FIREWALL
###############################################################################
echo ""
echo -e "${BLUE}[STEP 2] Configuring firewall...${NC}"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8000/tcp
sudo ufw allow 3000/tcp
sudo ufw --force enable
echo -e "${GREEN}✅ Firewall configured${NC}"

###############################################################################
# STEP 3: ORACLE INSTANT CLIENT
###############################################################################
echo ""
echo -e "${BLUE}[STEP 3] Installing Oracle Instant Client...${NC}"
if [ ! -d "/opt/oracle/instantclient_23_4" ]; then
    sudo mkdir -p /opt/oracle
    cd /opt/oracle
    sudo wget -q https://download.oracle.com/otn_software/linux/instantclient/2340000/instantclient-basic-linux.x64-23.4.0.24.05.zip
    sudo unzip -q instantclient-basic-linux.x64-23.4.0.24.05.zip
    sudo rm instantclient-basic-linux.x64-23.4.0.24.05.zip
fi

# Add to .bashrc if not already there
if ! grep -q "ORACLE_HOME" ~/.bashrc; then
    echo 'export ORACLE_HOME=/opt/oracle/instantclient_23_4' >> ~/.bashrc
    echo 'export PATH=$ORACLE_HOME:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH' >> ~/.bashrc
    echo 'export TNS_ADMIN=/home/ubuntu/oracle_wallet' >> ~/.bashrc
fi
source ~/.bashrc
echo -e "${GREEN}✅ Oracle Instant Client installed${NC}"

###############################################################################
# STEP 4: CLONE PROJECT
###############################################################################
echo ""
echo -e "${BLUE}[STEP 4] Cloning project from GitHub...${NC}"
cd ~
if [ -d "Oracle" ]; then
    echo -e "${YELLOW}⚠️  Oracle directory exists. Pulling latest changes...${NC}"
    cd Oracle && git pull
else
    git clone https://github.com/SeVin-DEV/Oracle.git
    cd Oracle
fi
echo -e "${GREEN}✅ Project cloned${NC}"

###############################################################################
# STEP 5: PYTHON ENVIRONMENT
###############################################################################
echo ""
echo -e "${BLUE}[STEP 5] Setting up Python environment...${NC}"
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip -q
pip install -r requirements.txt -q
pip install oracledb -q
echo -e "${GREEN}✅ Python environment ready${NC}"

###############################################################################
# STEP 6: DATABASE CONNECTION TEST
###############################################################################
echo ""
echo -e "${BLUE}[STEP 6] Testing database connection...${NC}"
echo -e "${YELLOW}⚠️  You need to set environment variables first!${NC}"
echo ""
echo "   Please run these commands (replace with your values):"
echo ""
echo "   export ORACLE_USER=ADMIN"
echo "   export ORACLE_PASSWORD=Your_DB_Password"
echo "   export ORACLE_DSN=yourdb_high"
echo ""
echo "   Then test with: python3 -c "import oracledb; conn = oracledb.connect(...); print('OK')""
echo ""

###############################################################################
# STEP 7: FRONTEND BUILD
###############################################################################
echo ""
echo -e "${BLUE}[STEP 7] Building React dashboard...${NC}"
cd ~/Oracle/front
npm install -q
npm run build -q
echo -e "${GREEN}✅ Dashboard built${NC}"

###############################################################################
# STEP 8: SYSTEMD SERVICE
###############################################################################
echo ""
echo -e "${BLUE}[STEP 8] Creating systemd service...${NC}"
sudo tee /etc/systemd/system/7-agent.service > /dev/null <<EOF
[Unit]
Description=7-Agent-1 Oracle Cognitive System
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/Oracle
Environment=PATH=/home/ubuntu/Oracle/venv/bin:/usr/local/bin:/usr/bin:/bin
Environment=PYTHONPATH=/home/ubuntu/Oracle
ExecStart=/home/ubuntu/Oracle/venv/bin/python3 /home/ubuntu/Oracle/main.py
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable 7-agent
echo -e "${GREEN}✅ Systemd service created${NC}"

###############################################################################
# STEP 9: NGINX CONFIG
###############################################################################
echo ""
echo -e "${BLUE}[STEP 9] Configuring Nginx...${NC}"
sudo rm -f /etc/nginx/sites-enabled/default

sudo tee /etc/nginx/sites-available/7-agent > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location / {
        root /home/ubuntu/Oracle/front/dist;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://localhost:8000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/7-agent /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx
echo -e "${GREEN}✅ Nginx configured${NC}"

###############################################################################
# DONE
###############################################################################
echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║              🖤 INSTALLATION COMPLETE! 🖤                              ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""
echo "NEXT STEPS:"
echo ""
echo "  1. Set your database credentials:"
echo "     export ORACLE_USER=ADMIN"
echo "     export ORACLE_PASSWORD=YourPassword"
echo "     export ORACLE_DSN=yourdb_high"
echo ""
echo "  2. Run the SQL files in your Oracle 26ai database (order: 01→07)"
echo "     See cheat sheet for exact commands"
echo ""
echo "  3. Enable scheduler jobs in the database"
echo ""
echo "  4. Update main.py to use bridge.engine_adapter"
echo ""
echo "  5. Start the service:"
echo "     sudo systemctl start 7-agent"
echo ""
echo "  6. Check status:"
echo "     sudo systemctl status 7-agent"
echo "     sudo journalctl -u 7-agent -f"
echo ""
echo "  Access your system at: http://$(curl -s ifconfig.me)"
echo ""

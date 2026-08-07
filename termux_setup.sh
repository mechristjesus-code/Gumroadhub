#!/bin/bash
# Gumroad Creator Hub - Termux Setup & Local Hosting Script
# This script installs Node.js / Python and hosts the web admin panel locally on your Android phone via Termux.

echo "================================================"
echo "  Gumroad Creator Hub - Termux Setup Utility"
echo "================================================"

# Step 1: Update and upgrade Termux packages
echo "[*] Updating Termux package lists..."
pkg update -y && pkg upgrade -y

# Step 2: Install dependencies (git, python, nodejs)
echo "[*] Installing required packages (git, python, nodejs)..."
pkg install -y git python nodejs

# Step 3: Check if python http.server or node http-server is available
echo "[*] Setting up local web server..."

# Create a convenient start script inside Termux
cat << 'EOF' > start_hub.sh
#!/bin/bash
echo "Starting Gumroad Creator Hub Local Server..."
echo "Access your admin panel at: http://localhost:8080/admin.html"
echo "Access your storefront at: http://localhost:8080/index.html"
echo "Press Ctrl+C to stop the server."
python3 -m http.server 8080
EOF

chmod +x start_hub.sh

echo "================================================"
echo "  Setup Complete Successfully!"
echo "================================================"
echo "To start your local server anytime, run:"
echo "  ./start_hub.sh"
echo "================================================"

# Gumroad Creator Hub: Termux & Admin Control Guide

## Overview
This document provides complete instructions on how to run **Gumroad Creator Hub** directly on your Android phone using **Termux**, manage your products, sales, and licenses through the local **Admin Control Panel**, and host the web app locally.

---

## Part 1: Running on Android via Termux

Termux is a powerful terminal emulator for Android that allows running Linux software locally on your device. Follow these steps to host Gumroad Creator Hub on your phone:

### 1. Installation Prerequisites
1. Download and install **Termux** (recommended from F-Droid or GitHub to ensure up-to-date packages; Google Play Store versions are deprecated).
2. Open Termux and grant storage permissions if prompted:
   ```bash
   termux-setup-storage
   ```

### 2. Automated Setup
You can use the provided setup script to automatically configure your Termux environment:
```bash
# Clone your repository (or pull latest changes)
git clone https://github.com/mechristjesus-code/Gumroadhub.git
cd Gumroadhub

# Make the setup script executable and run it
chmod +x termux_setup.sh
./termux_setup.sh
```

### 3. Starting the Local Server
Once setup is complete, start your local web server anytime with:
```bash
./start_hub.sh
```
Open your mobile browser (Chrome, Firefox, or Brave) and navigate to:
- **Admin Control Panel**: [http://localhost:8080/admin.html](http://localhost:8080/admin.html)
- **Storefront / User View**: [http://localhost:8080/index.html](http://localhost:8080/index.html)

---

## Part 2: Admin Control Panel Features

The built-in Admin Control Panel (`admin.html`) provides a comprehensive suite of management tools stored locally using browser `localStorage`:

| Section | Description | Key Capabilities |
| :--- | :--- | :--- |
| **📊 Dashboard** | High-level metrics | Total products, total sales, total revenue, active licenses count. |
| **📦 Products** | Product inventory management | Add new products with name, price, and description; view product table with edit/delete actions. |
| **💰 Sales** | Revenue & transaction tracking | View recent sales logs, timestamps, product names, amounts, and customer names. |
| **🔑 Licenses** | Software licensing & security | Generate custom license keys with expiration periods, copy keys to clipboard, and revoke active licenses. |
| **💾 Backup** | Data portability | Export all data as JSON or CSV backups; import JSON backups to restore state. |
| **⚙️ Settings** | Configuration & maintenance | Configure admin email, API base URL, toggle notifications, clear cache, or reset app data. |

---

## Part 3: Accessing from Other Devices on the Same Wi-Fi

If you want to access your phone-hosted Gumroad Creator Hub from another device (such as a laptop or tablet) connected to the same Wi-Fi network:

1. Find your phone's local IP address in Termux by running:
   ```bash
   ifconfig
   ```
   Look for `inet` under `wlan0` (e.g., `192.168.1.15`).
2. Start the server on all network interfaces:
   ```bash
   python3 -m http.server 8080 --bind 0.0.0.0
   ```
3. On your laptop browser, navigate to:
   - `http://<YOUR_PHONE_IP>:8080/admin.html`

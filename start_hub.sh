#!/bin/bash
echo "Starting Gumroad Creator Hub Local Server..."
echo "Access your admin panel at: http://localhost:8080/admin.html"
echo "Access your storefront at: http://localhost:8080/index.html"
echo "Press Ctrl+C to stop the server."
python3 -m http.server 8080

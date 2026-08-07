#!/usr/bin/env node
/**
 * Gumroad Creator Hub - Local Web Server
 * Serves the admin panel and storefront with optional API endpoints
 * Usage: node server.js [--port 3000] [--host 0.0.0.0]
 */

const express = require('express');
const path = require('path');
const fs = require('fs');
const cors = require('cors');

const app = express();

// Parse command-line arguments
const args = process.argv.slice(2);
let PORT = 3000;
let HOST = 'localhost';

for (let i = 0; i < args.length; i++) {
  if (args[i] === '--port' && args[i + 1]) {
    PORT = parseInt(args[i + 1]);
  }
  if (args[i] === '--host' && args[i + 1]) {
    HOST = args[i + 1];
  }
}

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname)));

// Serve static files
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'admin.html'));
});

// API Endpoints for Admin Panel

// Get all products
app.get('/api/products', (req, res) => {
  // In a real app, this would fetch from a database
  // For now, return empty array (client uses localStorage)
  res.json([]);
});

// Create product
app.post('/api/products', (req, res) => {
  const { name, price, description } = req.body;
  if (!name || !price || !description) {
    return res.status(400).json({ error: 'Missing required fields' });
  }
  const product = {
    id: 'prod_' + Date.now(),
    name,
    price,
    description,
    createdAt: new Date().toISOString()
  };
  res.status(201).json(product);
});

// Get all sales
app.get('/api/sales', (req, res) => {
  res.json([]);
});

// Get all licenses
app.get('/api/licenses', (req, res) => {
  res.json([]);
});

// Generate license
app.post('/api/licenses/generate', (req, res) => {
  const { type, expirationDays } = req.body;
  if (!type || !expirationDays) {
    return res.status(400).json({ error: 'Missing required fields' });
  }
  const licenseKey = 'LICENSE_' + type.toUpperCase() + '_' + generateRandomString(16);
  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + expirationDays);

  res.status(201).json({
    key: licenseKey,
    type,
    expiresAt: expiresAt.toISOString(),
    createdAt: new Date().toISOString()
  });
});

// Export data
app.get('/api/export/json', (req, res) => {
  const data = {
    products: [],
    sales: [],
    licenses: [],
    exportedAt: new Date().toISOString()
  };
  res.setHeader('Content-Disposition', `attachment; filename="gumroad_backup_${Date.now()}.json"`);
  res.json(data);
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error' });
});

// Utility function
function generateRandomString(length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let result = '';
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

// Start server
app.listen(PORT, HOST, () => {
  console.log('\n================================================');
  console.log('  Gumroad Creator Hub - Local Web Server');
  console.log('================================================');
  console.log(`\n✓ Server running on http://${HOST}:${PORT}`);
  console.log(`\n📊 Admin Panel:  http://${HOST}:${PORT}/admin.html`);
  console.log(`🛍️  Storefront:   http://${HOST}:${PORT}/index.html`);
  console.log(`\n💡 API Endpoints:`);
  console.log(`   GET  /api/products`);
  console.log(`   POST /api/products`);
  console.log(`   GET  /api/sales`);
  console.log(`   GET  /api/licenses`);
  console.log(`   POST /api/licenses/generate`);
  console.log(`   GET  /api/export/json`);
  console.log(`   GET  /api/health`);
  console.log(`\n⏹️  Press Ctrl+C to stop the server.\n`);
});

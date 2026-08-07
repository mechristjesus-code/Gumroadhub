// Admin Panel JavaScript - Local Storage Based
const API_BASE = localStorage.getItem('apiBaseUrl') || 'https://api.gumroad.com';

// Initialize Admin Panel
document.addEventListener('DOMContentLoaded', () => {
  initializeAdmin();
  loadDashboardData();
  setupEventListeners();
  loadSettings();
});

// Initialize Admin Data
function initializeAdmin() {
  if (!localStorage.getItem('adminInitialized')) {
    localStorage.setItem('adminInitialized', 'true');
    localStorage.setItem('products', JSON.stringify([]));
    localStorage.setItem('sales', JSON.stringify([]));
    localStorage.setItem('licenses', JSON.stringify([]));
    localStorage.setItem('backups', JSON.stringify([]));
  }
}

// Setup Event Listeners
function setupEventListeners() {
  // Navigation
  document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', () => {
      const section = item.getAttribute('data-section');
      switchSection(section);
    });
  });

  // Dashboard
  document.getElementById('refreshStatsBtn')?.addEventListener('click', loadDashboardData);

  // Products
  document.getElementById('addProductBtn')?.addEventListener('click', addProduct);

  // Licenses
  document.getElementById('generateLicenseBtn')?.addEventListener('click', generateLicense);
  document.getElementById('copyLicenseBtn')?.addEventListener('click', copyLicenseToClipboard);

  // Backup
  document.getElementById('exportJsonBtn')?.addEventListener('click', () => exportData('json'));
  document.getElementById('exportCsvBtn')?.addEventListener('click', () => exportData('csv'));
  document.getElementById('importJsonBtn')?.addEventListener('click', importData);

  // Settings
  document.getElementById('saveSettingsBtn')?.addEventListener('click', saveSettings);
  document.getElementById('clearCacheBtn')?.addEventListener('click', clearCache);
  document.getElementById('resetAdminBtn')?.addEventListener('click', resetAdmin);

  // Logout
  document.getElementById('logoutBtn')?.addEventListener('click', logout);
}

// Section Navigation
function switchSection(sectionId) {
  document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
  document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
  
  document.getElementById(sectionId).classList.add('active');
  document.querySelector(`[data-section="${sectionId}"]`).classList.add('active');

  // Load section-specific data
  if (sectionId === 'products') loadProductsList();
  if (sectionId === 'sales') loadSalesList();
  if (sectionId === 'licenses') loadLicensesList();
  if (sectionId === 'backup') loadBackupHistory();
}

// Dashboard Functions
function loadDashboardData() {
  const products = JSON.parse(localStorage.getItem('products') || '[]');
  const sales = JSON.parse(localStorage.getItem('sales') || '[]');
  const licenses = JSON.parse(localStorage.getItem('licenses') || '[]');

  const totalRevenue = sales.reduce((sum, sale) => sum + (sale.amount || 0), 0);

  document.getElementById('totalProducts').textContent = products.length;
  document.getElementById('totalSales').textContent = sales.length;
  document.getElementById('totalRevenue').textContent = '$' + totalRevenue.toFixed(2);
  document.getElementById('activeLicenses').textContent = licenses.filter(l => !l.expired).length;
  document.getElementById('lastUpdated').textContent = new Date().toLocaleString();

  showAlert('Dashboard updated successfully', 'success');
}

// Product Functions
function addProduct() {
  const name = document.getElementById('newProductName').value;
  const price = parseFloat(document.getElementById('newProductPrice').value);
  const description = document.getElementById('newProductDesc').value;

  if (!name || !price || !description) {
    showAlert('Please fill in all product fields', 'error');
    return;
  }

  const products = JSON.parse(localStorage.getItem('products') || '[]');
  const newProduct = {
    id: 'prod_' + Date.now(),
    name,
    price,
    description,
    createdAt: new Date().toISOString()
  };

  products.push(newProduct);
  localStorage.setItem('products', JSON.stringify(products));

  document.getElementById('newProductName').value = '';
  document.getElementById('newProductPrice').value = '';
  document.getElementById('newProductDesc').value = '';

  loadProductsList();
  showAlert('Product added successfully', 'success');
}

function loadProductsList() {
  const products = JSON.parse(localStorage.getItem('products') || '[]');
  const tbody = document.getElementById('productsTableBody');
  tbody.innerHTML = '';

  products.forEach(product => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${product.name}</td>
      <td>$${product.price.toFixed(2)}</td>
      <td>${product.description}</td>
      <td>
        <div class="action-buttons">
          <button onclick="editProduct('${product.id}')">Edit</button>
          <button onclick="deleteProduct('${product.id}')" class="danger">Delete</button>
        </div>
      </td>
    `;
    tbody.appendChild(row);
  });
}

function deleteProduct(productId) {
  if (!confirm('Are you sure you want to delete this product?')) return;

  let products = JSON.parse(localStorage.getItem('products') || '[]');
  products = products.filter(p => p.id !== productId);
  localStorage.setItem('products', JSON.stringify(products));

  loadProductsList();
  showAlert('Product deleted successfully', 'success');
}

function editProduct(productId) {
  const products = JSON.parse(localStorage.getItem('products') || '[]');
  const product = products.find(p => p.id === productId);
  if (!product) return;

  const newName = prompt('Enter new product name:', product.name);
  if (newName === null) return;
  const newPrice = parseFloat(prompt('Enter new product price:', product.price));
  if (isNaN(newPrice)) return;
  const newDesc = prompt('Enter new product description:', product.description);
  if (newDesc === null) return;

  product.name = newName;
  product.price = newPrice;
  product.description = newDesc;

  localStorage.setItem('products', JSON.stringify(products));
  loadProductsList();
  showAlert('Product updated successfully', 'success');
}

// License Functions
function generateLicense() {
  const type = document.getElementById('licenseType').value;
  const expirationDays = parseInt(document.getElementById('licenseExpiration').value);

  const licenseKey = 'LICENSE_' + type.toUpperCase() + '_' + generateRandomString(16);
  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + expirationDays);

  const licenses = JSON.parse(localStorage.getItem('licenses') || '[]');
  const newLicense = {
    key: licenseKey,
    type,
    createdAt: new Date().toISOString(),
    expiresAt: expiresAt.toISOString(),
    expired: false
  };

  licenses.push(newLicense);
  localStorage.setItem('licenses', JSON.stringify(licenses));

  document.getElementById('licenseKeyOutput').value = licenseKey;
  document.getElementById('generatedLicense').style.display = 'block';

  loadLicensesList();
  showAlert('License generated successfully', 'success');
}

function copyLicenseToClipboard() {
  const licenseKey = document.getElementById('licenseKeyOutput').value;
  navigator.clipboard.writeText(licenseKey).then(() => {
    showAlert('License key copied to clipboard', 'success');
  });
}

function loadLicensesList() {
  const licenses = JSON.parse(localStorage.getItem('licenses') || '[]');
  const tbody = document.getElementById('licensesTableBody');
  tbody.innerHTML = '';

  licenses.forEach(license => {
    const expiresAt = new Date(license.expiresAt);
    const isExpired = expiresAt < new Date();
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${license.key}</td>
      <td>${license.type}</td>
      <td>${expiresAt.toLocaleDateString()}</td>
      <td>${isExpired ? 'Expired' : 'Active'}</td>
      <td>
        <div class="action-buttons">
          <button onclick="revokeLicense('${license.key}')" class="danger">Revoke</button>
        </div>
      </td>
    `;
    tbody.appendChild(row);
  });
}

function revokeLicense(licenseKey) {
  if (!confirm('Are you sure you want to revoke this license?')) return;

  let licenses = JSON.parse(localStorage.getItem('licenses') || '[]');
  licenses = licenses.filter(l => l.key !== licenseKey);
  localStorage.setItem('licenses', JSON.stringify(licenses));

  loadLicensesList();
  showAlert('License revoked successfully', 'success');
}

function loadSalesList() {
  const sales = JSON.parse(localStorage.getItem('sales') || '[]');
  const tbody = document.getElementById('salesTableBody');
  tbody.innerHTML = '';

  if (sales.length === 0) {
    tbody.innerHTML = '<tr><td colspan="4">No sales data available</td></tr>';
    return;
  }

  sales.forEach(sale => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${new Date(sale.date).toLocaleDateString()}</td>
      <td>${sale.product}</td>
      <td>$${sale.amount.toFixed(2)}</td>
      <td>${sale.customer}</td>
    `;
    tbody.appendChild(row);
  });
}

// Backup Functions
function exportData(format) {
  const products = JSON.parse(localStorage.getItem('products') || '[]');
  const sales = JSON.parse(localStorage.getItem('sales') || '[]');
  const licenses = JSON.parse(localStorage.getItem('licenses') || '[]');

  const data = { products, sales, licenses, exportedAt: new Date().toISOString() };

  let content, filename, type;

  if (format === 'json') {
    content = JSON.stringify(data, null, 2);
    filename = `gumroad_backup_${Date.now()}.json`;
    type = 'application/json';
  } else if (format === 'csv') {
    content = convertToCSV(products);
    filename = `gumroad_products_${Date.now()}.csv`;
    type = 'text/csv';
  }

  downloadFile(content, filename, type);

  // Save backup history
  const backups = JSON.parse(localStorage.getItem('backups') || '[]');
  backups.push({
    timestamp: new Date().toISOString(),
    type: format,
    size: new Blob([content]).size
  });
  localStorage.setItem('backups', JSON.stringify(backups));

  showAlert(`Data exported as ${format.toUpperCase()}`, 'success');
}

function importData() {
  const file = document.getElementById('importFile').files[0];
  if (!file) {
    showAlert('Please select a file to import', 'error');
    return;
  }

  const reader = new FileReader();
  reader.onload = (e) => {
    try {
      const data = JSON.parse(e.target.result);
      localStorage.setItem('products', JSON.stringify(data.products || []));
      localStorage.setItem('sales', JSON.stringify(data.sales || []));
      localStorage.setItem('licenses', JSON.stringify(data.licenses || []));

      showAlert('Data imported successfully', 'success');
      loadDashboardData();
    } catch (error) {
      showAlert('Error importing file: ' + error.message, 'error');
    }
  };
  reader.readAsText(file);
}

function loadBackupHistory() {
  const backups = JSON.parse(localStorage.getItem('backups') || '[]');
  const tbody = document.getElementById('backupTableBody');
  tbody.innerHTML = '';

  if (backups.length === 0) {
    tbody.innerHTML = '<tr><td colspan="4">No backups yet</td></tr>';
    return;
  }

  backups.forEach(backup => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${new Date(backup.timestamp).toLocaleString()}</td>
      <td>${backup.type.toUpperCase()}</td>
      <td>${(backup.size / 1024).toFixed(2)} KB</td>
      <td><button onclick="downloadBackup('${backup.timestamp}')">Download</button></td>
    `;
    tbody.appendChild(row);
  });
}

// Settings Functions
function saveSettings() {
  const email = document.getElementById('adminEmail').value;
  const apiUrl = document.getElementById('apiBaseUrl').value;
  const notifications = document.getElementById('enableNotifications').checked;

  localStorage.setItem('adminEmail', email);
  localStorage.setItem('apiBaseUrl', apiUrl);
  localStorage.setItem('enableNotifications', notifications);

  showAlert('Settings saved successfully', 'success');
}

function loadSettings() {
  document.getElementById('adminEmail').value = localStorage.getItem('adminEmail') || '';
  document.getElementById('apiBaseUrl').value = localStorage.getItem('apiBaseUrl') || API_BASE;
  document.getElementById('enableNotifications').checked = localStorage.getItem('enableNotifications') !== 'false';
}

function clearCache() {
  if (!confirm('Are you sure? This will clear all local data.')) return;
  localStorage.clear();
  showAlert('Cache cleared. Reloading...', 'success');
  setTimeout(() => location.reload(), 1000);
}

function resetAdmin() {
  if (!confirm('Are you absolutely sure? This will reset the entire admin panel.')) return;
  localStorage.clear();
  location.href = 'index.html';
}

// Utility Functions
function generateRandomString(length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let result = '';
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

function downloadFile(content, filename, type) {
  const blob = new Blob([content], { type });
  const url = window.URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  window.URL.revokeObjectURL(url);
  document.body.removeChild(a);
}

function convertToCSV(products) {
  let csv = 'Name,Price,Description\n';
  products.forEach(product => {
    csv += `"${product.name}","${product.price}","${product.description}"\n`;
  });
  return csv;
}

function showAlert(message, type) {
  const alertDiv = document.createElement('div');
  alertDiv.className = `alert ${type}`;
  alertDiv.textContent = message;
  
  const mainContent = document.querySelector('.main-content');
  mainContent.insertBefore(alertDiv, mainContent.firstChild);

  setTimeout(() => alertDiv.remove(), 3000);
}

function logout() {
  if (confirm('Are you sure you want to logout?')) {
    localStorage.removeItem('adminLoggedIn');
    location.href = 'auth.html';
  }
}

function downloadBackup(timestamp) {
  const backups = JSON.parse(localStorage.getItem('backups') || '[]');
  const backup = backups.find(b => b.timestamp === timestamp);
  if (!backup) return;

  const products = JSON.parse(localStorage.getItem('products') || '[]');
  const sales = JSON.parse(localStorage.getItem('sales') || '[]');
  const licenses = JSON.parse(localStorage.getItem('licenses') || '[]');
  const data = { products, sales, licenses, exportedAt: backup.timestamp };
  
  const content = JSON.stringify(data, null, 2);
  const filename = `gumroad_backup_${new Date(timestamp).getTime()}.json`;
  downloadFile(content, filename, 'application/json');
  showAlert('Backup downloaded', 'success');
}

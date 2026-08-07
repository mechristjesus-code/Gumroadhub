const API_BASE = 'https://api.gumroad.com';

// License Verification
const verifyBtn = document.getElementById('verifyBtn');
const licenseKeyInput = document.getElementById('licenseKey');

verifyBtn.addEventListener('click', async () => {
  const licenseKey = licenseKeyInput.value;
  try {
    const response = await fetch(`${API_BASE}/licenses/verify`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ license_key: licenseKey })
    });
    const data = await response.json();
    console.log(data);
    alert('Verification result: ' + JSON.stringify(data));
  } catch (error) {
    console.error('Error:', error);
    alert('Error during verification: ' + error.message);
  }
});

// Product Creation
const createProductBtn = document.getElementById('createProductBtn');
const productNameInput = document.getElementById('productName');
const productPriceInput = document.getElementById('productPrice');
const productDescInput = document.getElementById('productDesc');

createProductBtn.addEventListener('click', () => {
  const productData = {
    name: productNameInput.value,
    price: productPriceInput.value,
    description: productDescInput.value
  };
  
  console.log('Product to be created:', productData);
  alert('Product "' + productData.name + '" created locally (Simulation).');
});

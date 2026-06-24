// --- GLOBAL VARIABLES ---
let currentCategory = 'phone';
let cart = [];
let items = []; 
let currentUser = null; 
let userRole = 'customer';
let isRegistering = false;

// --- MEMORY CHECK ON LOAD ---
window.addEventListener('DOMContentLoaded', () => {
    const savedUser = localStorage.getItem('diazcell_user');
    const savedRole = localStorage.getItem('diazcell_role');
    const hasStarted = localStorage.getItem('diazcell_started');
    
    // Clear any stuck theme data
    document.body.removeAttribute('data-theme');
    localStorage.removeItem('diazcell_theme');

    if (savedUser) {
        currentUser = savedUser;
        userRole = savedRole;
        
        document.getElementById('userDisplay').textContent = `Hello, ${currentUser}`;
        document.getElementById('loginToggleBtn').textContent = 'Logout';
        
        if (userRole === 'admin') {
            document.getElementById('adminToggleBtn').classList.remove('hidden');
        }
    }

    if (hasStarted === 'true') {
        document.getElementById('introPage').classList.add('hidden');
        document.getElementById('pageContent').classList.remove('hidden');
        loadProductsFromDatabase(); 
        updateCart();
    }
});

// --- DATABASE FETCH ---
async function loadProductsFromDatabase() {
    try {
        const response = await fetch('api.php?t=' + new Date().getTime());
        items = await response.json(); 
        displayPhones();
    } catch (error) {
        console.error("Failed to load products:", error);
        document.getElementById('catalogue').innerHTML = '<p>Error loading catalogue. Make sure Apache and MySQL are running!</p>';
    }
}

// --- NAVIGATION ---
function startShopping() {
    localStorage.setItem('diazcell_started', 'true'); 
    document.getElementById('introPage').classList.add('hidden');
    document.getElementById('pageContent').classList.remove('hidden');
    loadProductsFromDatabase(); 
    updateCart();
}

function goBackToIntro() {
    localStorage.removeItem('diazcell_started'); 
    document.getElementById('pageContent').classList.add('hidden');
    document.getElementById('introPage').classList.remove('hidden');
}

function filterByCategory(category, button) {
    currentCategory = category;
    document.querySelectorAll('.category-btn').forEach(btn => btn.classList.remove('active'));
    button.classList.add('active');
    displayPhones();
}

// --- CATALOGUE DISPLAY ---
function getStockStatus(stock) {
    if (stock === 0) return { class: "out-of-stock", text: "Out of Stock" };
    if (stock < 5) return { class: "low-stock", text: "Low Stock (" + stock + " left)" };
    return { class: "in-stock", text: "In Stock (" + stock + " available)" };
}

function displayPhones() {
    const catalogueDiv = document.getElementById('catalogue');
    catalogueDiv.innerHTML = '';
    
    const filtered = items.filter(phone => phone.category === currentCategory);
    
    filtered.forEach(phone => {
        const stockStatus = getStockStatus(phone.stock);
        const isOutOfStock = phone.stock === 0;
        const phoneCard = document.createElement('div');
        phoneCard.className = 'phone-card';
        
        phoneCard.innerHTML = `
            <img src="${phone.image}" alt="${phone.name}" class="phone-image">
            <div class="phone-name">${phone.name}</div>
            <div class="phone-price">$${phone.price.toFixed(2)}</div>
            <div class="phone-stock ${stockStatus.class}">${stockStatus.text}</div>
            <div class="card-actions">
                <button class="view-details-btn" onclick="showProductDetails('${phone.name}')">View Specs</button>
                <button class="add-to-cart-btn ${isOutOfStock ? 'disabled' : ''}" 
                        onclick="${isOutOfStock ? '' : `addToCart('${phone.name}')`}"
                        ${isOutOfStock ? 'disabled' : ''}>
                    ${isOutOfStock ? 'Item not available' : 'Add to Cart'}
                </button>
            </div>
        `;
        catalogueDiv.appendChild(phoneCard);
    });
}

// --- PRODUCT DETAILS MODAL ---
function showProductDetails(productName) {
    const product = items.find(item => item.name === productName);
    if (!product) return;

    document.getElementById('detailsImage').src = product.image;
    document.getElementById('detailsImage').alt = product.name;
    document.getElementById('detailsName').textContent = product.name;
    document.getElementById('detailsPrice').textContent = product.price.toFixed(2);
    document.getElementById('detailsStock').textContent = getStockStatus(product.stock).text;
    document.getElementById('detailsDescription').textContent = product.description;

    const detailsSpecsList = document.getElementById('detailsSpecsList');
    detailsSpecsList.innerHTML = product.specs.map(spec => `<li><strong>${spec.label}:</strong> ${spec.value}</li>`).join('');

    const addBtn = document.getElementById('detailsAddToCartBtn');
    addBtn.disabled = product.stock === 0;
    addBtn.textContent = product.stock === 0 ? 'Out of Stock' : 'Add to Cart';
    addBtn.setAttribute('data-product-name', product.name);

    document.getElementById('detailsOverlay').classList.remove('hidden');
}

function closeProductDetails() {
    document.getElementById('detailsOverlay').classList.add('hidden');
}

function detailsAddToCart() {
    addToCart(document.getElementById('detailsAddToCartBtn').getAttribute('data-product-name'));
}

// --- CART LOGIC ---
function showNotification(message) {
    const notification = document.getElementById('notification');
    document.getElementById('notificationText').textContent = message;
    notification.classList.add('show');
    setTimeout(() => notification.classList.remove('show'), 3000);
}

function addToCart(productName) {
    const product = items.find(p => p.name === productName);
    if (product) {
        const cartItem = cart.find(item => item.name === productName);
        if (cartItem) cartItem.quantity += 1;
        else cart.push({ ...product, quantity: 1 });
        
        updateCart();
        showNotification(`${productName} added to cart`);
    }
}

function updateCart() {
    const cartItemsDiv = document.getElementById('cartItems');
    const cartCountSpan = document.getElementById('cartCount');
    const subtotalSpan = document.getElementById('cartSubtotal');
    const taxSpan = document.getElementById('cartTax');
    const totalSpan = document.getElementById('cartTotal');
    
    cartCountSpan.textContent = cart.length > 0 ? cart.reduce((sum, item) => sum + item.quantity, 0) : 0;
    
    if (cart.length === 0) {
        cartItemsDiv.innerHTML = '<p class="empty-cart">Your cart is empty</p>';
        subtotalSpan.textContent = '0.00';
        taxSpan.textContent = '0.00';
        totalSpan.textContent = '0.00';
        return;
    }
    
    cartItemsDiv.innerHTML = cart.map((item, index) => `
        <div class="cart-item">
            <div class="cart-item-name">${item.name}</div>
            <div class="cart-item-price">$${item.price.toFixed(2)}</div>
            <div class="cart-item-quantity">
                <button onclick="decreaseQuantity(${index})">-</button>
                <span>${item.quantity}</span>
                <button onclick="increaseQuantity(${index})">+</button>
            </div>
            <div class="cart-item-total">Total: $${(item.price * item.quantity).toFixed(2)}</div>
            <button class="remove-item-btn" onclick="removeFromCart(${index})">Remove</button>
        </div>
    `).join('');
    
    const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const tax = subtotal * 0.11;
    const grandTotal = subtotal + tax;

    subtotalSpan.textContent = subtotal.toFixed(2);
    taxSpan.textContent = tax.toFixed(2);
    totalSpan.textContent = grandTotal.toFixed(2);
}

function increaseQuantity(index) { cart[index].quantity += 1; updateCart(); }
function decreaseQuantity(index) { if (cart[index].quantity > 1) cart[index].quantity -= 1; else removeFromCart(index); updateCart(); }
function removeFromCart(index) { cart.splice(index, 1); updateCart(); }
function clearCart() { cart = []; updateCart(); }
function toggleCart() { document.getElementById('cartSidebar').classList.toggle('open'); }

// --- CHECKOUT LOGIC ---
function checkout() {
    if (!currentUser) {
        showNotification('Please login to proceed to checkout!');
        openAuth();
        return;
    }
    if (cart.length === 0) {
        showNotification('Your cart is empty!');
        return;
    }
    document.getElementById('disclaimerModal').classList.remove('hidden');
}

function cancelCheckout() {
    document.getElementById('disclaimerModal').classList.add('hidden');
    document.getElementById('checkoutName').value = '';
    document.getElementById('checkoutPhone').value = '';
}

async function confirmCheckout() {
    const nameInput = document.getElementById('checkoutName').value.trim();
    const phoneInput = document.getElementById('checkoutPhone').value.trim();

    if (!nameInput || !phoneInput) {
        showNotification('Please fill in your Name and Phone Number.');
        return; 
    }

    document.getElementById('disclaimerModal').classList.add('hidden');
    showNotification('Processing order...');
    
    try {
        const response = await fetch('checkout.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                username: currentUser,
                role: userRole,
                cart: cart,
                customerName: nameInput,
                customerPhone: phoneInput
            })
        });
        
        const result = await response.json();

        if (result.success) {
            showNotification(`Order placed! We will contact you soon.`);
            clearCart();
            toggleCart();
            
            document.getElementById('checkoutName').value = '';
            document.getElementById('checkoutPhone').value = '';
            
            loadProductsFromDatabase(); 
        } else {
            showNotification(`Checkout failed: ${result.message}`);
        }
    } catch (error) {
        console.error("Checkout Error:", error);
        showNotification('Failed to connect to server.');
    }
}

// --- AUTHENTICATION ---
function handleAuthClick() {
    if (currentUser) {
        currentUser = null;
        userRole = 'customer';
        localStorage.removeItem('diazcell_user');
        localStorage.removeItem('diazcell_role');
        document.getElementById('userDisplay').textContent = 'Guest Mode';
        document.getElementById('loginToggleBtn').textContent = 'Login';
        document.getElementById('adminToggleBtn').classList.add('hidden'); 
        showNotification('Logged out successfully.');
    } else {
        openAuth();
    }
}

function openAuth() { document.getElementById('authOverlay').classList.remove('hidden'); }
function closeAuth() { 
    document.getElementById('authOverlay').classList.add('hidden'); 
    document.getElementById('authMessage').textContent = '';
    document.getElementById('authUsername').value = '';
    document.getElementById('authPassword').value = '';
}

function toggleAuthMode() {
    isRegistering = !isRegistering;
    document.getElementById('authTitle').textContent = isRegistering ? 'Create Account' : 'Login to DiazCell';
    document.getElementById('authSwitchText').textContent = isRegistering ? 'Already have an account?' : "Don't have an account?";
    document.getElementById('authMessage').textContent = '';
}

async function submitAuth() {
    const userVal = document.getElementById('authUsername').value.trim();
    const passVal = document.getElementById('authPassword').value;
    const msgBox = document.getElementById('authMessage');

    if (!userVal || !passVal) {
        msgBox.style.color = '#c5241b';
        msgBox.textContent = 'Please fill out all fields.';
        return;
    }

    if (isRegistering && passVal.length < 8) {
        msgBox.style.color = '#c5241b';
        msgBox.textContent = 'Password must be at least 8 characters.';
        return;
    }

    const actionType = isRegistering ? 'register' : 'login';

    try {
        const response = await fetch('auth.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: actionType, username: userVal, password: passVal })
        });
        const result = await response.json();

        if (result.success) {
            if (isRegistering) {
                msgBox.style.color = '#146c36';
                msgBox.textContent = result.message;
                setTimeout(() => { toggleAuthMode(); }, 1500);
            } else {
                currentUser = result.username;
                userRole = result.role; 
                localStorage.setItem('diazcell_user', currentUser);
                localStorage.setItem('diazcell_role', userRole);
                
                document.getElementById('userDisplay').textContent = `Hello, ${currentUser}`;
                document.getElementById('loginToggleBtn').textContent = 'Logout';
                if (userRole === 'admin') document.getElementById('adminToggleBtn').classList.remove('hidden');

                closeAuth();
                showNotification(`Welcome back, ${currentUser}!`);
            }
        } else {
            msgBox.style.color = '#c5241b';
            msgBox.textContent = result.message;
        }
    } catch (error) {
        console.error("Auth Error:", error);
        msgBox.style.color = '#c5241b';
        msgBox.textContent = 'Connection error to server.';
    }
}

// --- ADMIN PANEL ---
async function openAdminPanel() {
    if (userRole !== 'admin') return; 
    renderAdminTable();
    await fetchAdminOrders(); 
    document.getElementById('adminOverlay').classList.remove('hidden');
}

function closeAdminPanel() { document.getElementById('adminOverlay').classList.add('hidden'); }

function renderAdminTable() {
    const tbody = document.getElementById('adminTableBody');
    tbody.innerHTML = items.map(item => `
        <tr>
            <td style="font-weight: 600;">${item.name}</td>
            <td><input type="number" id="admin_price_${item.id}" value="${item.price}" class="admin-input" step="0.01"></td>
            <td><input type="number" id="admin_stock_${item.id}" value="${item.stock}" class="admin-input"></td>
            <td><textarea id="admin_desc_${item.id}" class="admin-input admin-textarea">${item.description}</textarea></td>
            <td><button onclick="saveAdminChanges(${item.id})" class="admin-save-btn">Save</button></td>
        </tr>
    `).join('');
}

async function fetchAdminOrders() {
    try {
        const response = await fetch('admin.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: 'get_orders' })
        });
        const data = await response.json();
        
        if (data.success) {
            const tbody = document.getElementById('adminOrdersBody');
            tbody.innerHTML = data.orders.map(order => `
                <tr>
                    <td style="font-size: 0.9rem; color: #666;">${new Date(order.created_at).toLocaleString()}</td>
                    <td style="font-weight: 600;">${order.customer_name || 'N/A'}</td>
                    <td><a href="https://wa.me/${order.customer_phone}" target="_blank" style="color: #146c36; text-decoration: none; font-weight: 500;">Chat: ${order.customer_phone || 'N/A'}</a></td>
                    <td style="font-size: 0.9rem;">${order.items || 'No items found'}</td>
                    <td style="font-weight: 600;">$${parseFloat(order.total_amount).toFixed(2)}</td>
                </tr>
            `).join('');
        }
    } catch (error) {
        console.error("Failed to load orders:", error);
    }
}

async function saveAdminChanges(id) {
    const newPrice = document.getElementById(`admin_price_${id}`).value;
    const newStock = document.getElementById(`admin_stock_${id}`).value;
    const newDesc = document.getElementById(`admin_desc_${id}`).value;

    try {
        const response = await fetch('admin.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: 'update_product', id: id, price: newPrice, stock: newStock, description: newDesc })
        });
        const result = await response.json();
        
        if (result.success) {
            showNotification(result.message);
            loadProductsFromDatabase(); 
        } else {
            alert('Error: ' + result.message);
        }
    } catch (error) {
        console.error("Admin save error:", error);
        alert("Failed to connect to the server.");
    }
}
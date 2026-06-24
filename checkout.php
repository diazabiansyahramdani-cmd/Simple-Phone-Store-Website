<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json');

$conn = new mysqli('localhost', 'root', '', 'product');

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Database connection failed: " . $conn->connect_error]));
}

$data = json_decode(file_get_contents("php://input"), true);

if (!$data || empty($data['cart'])) {
    die(json_encode(["success" => false, "message" => "Invalid checkout request."]));
}

$username = $conn->real_escape_string($data['username']);
$role = $data['role'];
$cart = $data['cart'];
$customerName = $conn->real_escape_string($data['customerName']);
$customerPhone = $conn->real_escape_string($data['customerPhone']);

// 1. Calculate Totals
$subtotal = 0;
foreach ($cart as $item) {
    $subtotal += ((float)$item['price'] * (int)$item['quantity']);
}
$tax = $subtotal * 0.11; 
$grandTotal = $subtotal + $tax;

// 2. Save Order with Name and Phone
$sql = "INSERT INTO orders (total_amount, customer_email, customer_name, customer_phone) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);

// CRITICAL FIX: If the SQL fails (like missing columns), stop gracefully and tell the user!
if (!$stmt) {
    die(json_encode(["success" => false, "message" => "SQL Error: " . $conn->error]));
}

$stmt->bind_param("dsss", $grandTotal, $username, $customerName, $customerPhone);
$stmt->execute();
$order_id = $stmt->insert_id;
$stmt->close();

// 3. Process Items & Update Stock
foreach ($cart as $item) {
    $pid = (int)$item['id'];
    $qty = (int)$item['quantity'];
    $price = (float)$item['price'];

    $conn->query("INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES ($order_id, $pid, $qty, $price)");

    // Deduct stock if the user is NOT an admin
    if ($role !== 'admin') {
        $conn->query("UPDATE products SET stock = stock - $qty WHERE id = $pid AND stock >= $qty");
    }
}

// 4. Return standard success confirmation
echo json_encode([
    "success" => true, 
    "message" => "Order placed successfully! We will contact you soon."
]);

$conn->close();
?>
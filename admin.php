<?php
// admin.php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json');

$conn = new mysqli('localhost', 'root', '', 'product');

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Database connection failed."]));
}

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['action']) && $data['action'] === 'update_product') {
    // ... (Keep your existing update_product code exactly as it is) ...
    $id = (int)$data['id'];
    $price = (float)$data['price'];
    $stock = (int)$data['stock'];
    $description = $conn->real_escape_string($data['description']);

    $sql = "UPDATE products SET price=$price, stock=$stock, description='$description' WHERE id=$id";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["success" => true, "message" => "Product updated successfully!"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error updating product: " . $conn->error]);
    }

// NEW SECTION: Fetch orders for the Admin Panel
} elseif (isset($data['action']) && $data['action'] === 'get_orders') {
    // This SQL query grabs the order, the customer details, and stitches all the purchased items together!
    $sql = "SELECT o.id, o.customer_name, o.customer_phone, o.total_amount, o.created_at, 
            GROUP_CONCAT(CONCAT(oi.quantity, 'x ', p.name) SEPARATOR ', ') as items 
            FROM orders o 
            LEFT JOIN order_items oi ON o.id = oi.order_id 
            LEFT JOIN products p ON oi.product_id = p.id 
            GROUP BY o.id 
            ORDER BY o.created_at DESC";
            
    $result = $conn->query($sql);
    $orders = [];
    
    if ($result) {
        while($row = $result->fetch_assoc()) {
            $orders[] = $row;
        }
        echo json_encode(["success" => true, "orders" => $orders]);
    } else {
        echo json_encode(["success" => false, "message" => "Failed to fetch orders."]);
    }

} else {
    echo json_encode(["success" => false, "message" => "Invalid request."]);
}

$conn->close();
?>
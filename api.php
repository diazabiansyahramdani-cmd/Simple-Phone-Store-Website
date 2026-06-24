<?php
// 1. Force PHP to show us any hidden errors
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Tell the browser we are sending JSON
header('Content-Type: application/json');

$host = 'localhost';
$user = 'root';
$pass = ''; 
$dbname = 'product'; // Your updated database name

$conn = new mysqli($host, $user, $pass, $dbname);

// 2. Check if the database connection fails
if ($conn->connect_error) {
    die(json_encode(["error" => "CRITICAL: Cannot connect to MySQL. " . $conn->connect_error]));
}

// 3. Check if the table exists and the query works
$sql = "SELECT * FROM products";
$result = $conn->query($sql);

if (!$result) {
    // If the query fails, print the exact MySQL error
    die(json_encode(["error" => "CRITICAL: SQL Query Failed. " . $conn->error]));
}

$items = [];

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $productId = $row['id'];
        
        $row['price'] = (float)$row['price'];
        $row['stock'] = (int)$row['stock'];
        $row['image'] = $row['image_url']; 
        
        $specSql = "SELECT label, value FROM product_specs WHERE product_id = $productId";
        $specResult = $conn->query($specSql);
        
        $specs = [];
        // Add a check to ensure the specs query didn't fail
        if ($specResult) {
            if ($specResult->num_rows > 0) {
                while($specRow = $specResult->fetch_assoc()) {
                    $specs[] = $specRow;
                }
            }
        } else {
             die(json_encode(["error" => "CRITICAL: Spec SQL Query Failed. " . $conn->error]));
        }
        
        $row['specs'] = $specs;
        $items[] = $row;
    }
}

echo json_encode($items);
$conn->close();
?>
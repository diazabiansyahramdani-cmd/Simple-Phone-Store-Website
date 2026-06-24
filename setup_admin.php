<?php
// setup_admin.php
$conn = new mysqli('localhost', 'root', '', 'product');

$username = 'Admin1';
$password = '12345678';
$hashed_password = password_hash($password, PASSWORD_DEFAULT);
$role = 'admin';

// Check if admin already exists
$check = $conn->query("SELECT id FROM users WHERE username = 'Admin1'");
if ($check->num_rows > 0) {
    die("Admin1 already exists in the database!");
}

$sql = "INSERT INTO users (username, password, role) VALUES ('$username', '$hashed_password', '$role')";

if ($conn->query($sql) === TRUE) {
    echo "✅ Admin1 successfully created! You can now delete this file.";
} else {
    echo "Error: " . $conn->error;
}
$conn->close();
?>
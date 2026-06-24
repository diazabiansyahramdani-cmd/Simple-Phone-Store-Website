<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: application/json');

$host = 'localhost';
$user = 'root';
$pass = '';
$dbname = 'product';

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Database connection failed."]));
}

// Get the JSON data sent from JavaScript
$data = json_decode(file_get_contents("php://input"), true);
$action = $data['action'] ?? '';

if ($action === 'register') {
    $username = $conn->real_escape_string($data['username']);
    $password = $data['password'];

    // Enforce 8 character minimum on the backend
    if (strlen($password) < 8) {
        echo json_encode(["success" => false, "message" => "Password must be at least 8 characters."]);
        exit;
    }

    // Check if the username is already taken
    $check = $conn->query("SELECT id FROM users WHERE username = '$username'");
    if ($check->num_rows > 0) {
        echo json_encode(["success" => false, "message" => "Username is already taken."]);
        exit;
    }

    // Securely hash the password
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    $sql = "INSERT INTO users (username, password) VALUES ('$username', '$hashed_password')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["success" => true, "message" => "Account created! You can now log in."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error creating account."]);
    }

} elseif ($action === 'login') {
    $username = $conn->real_escape_string($data['username']);
    $password = $data['password'];

    // Select the role as well
    $result = $conn->query("SELECT username, password, role FROM users WHERE username = '$username'");
    
    if ($result->num_rows > 0) {
        $userRow = $result->fetch_assoc();
        if (password_verify($password, $userRow['password'])) {
            // Send the role back to the frontend
            echo json_encode([
                "success" => true, 
                "username" => $userRow['username'],
                "role" => $userRow['role']
            ]);
        } else {
            echo json_encode(["success" => false, "message" => "Incorrect password."]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "User not found."]);
    }
}

$conn->close();
?>
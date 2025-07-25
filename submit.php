<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Database connection details
    $servername = getenv('DB_HOST');
    $username = getenv('DB_USER');
    $password = getenv('DB_PASS');
    $dbname = getenv('DB_NAME');
    $port = getenv('DB_PORT') ?: 3306; // Use default MySQL port if not set

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname, $port);

    // Check connection
    if ($conn->connect_error) {
        die("<div style='color: red; font-weight: bold;'>Connection failed: " . htmlspecialchars($conn->connect_error) . "</div>");
    }

    // Function to sanitize user input
    function clean_input($data) {
        return htmlspecialchars(stripslashes(trim($data)));
    }

    // Get and sanitize form data
    $name = clean_input($_POST["name"] ?? '');
    $email = clean_input($_POST["email"] ?? '');
    $website = clean_input($_POST["website"] ?? '');
    $comment = clean_input($_POST["comment"] ?? '');
    $gender = clean_input($_POST["gender"] ?? '');

    // Validate required fields
    if (empty($name) || empty($email) || empty($gender)) {
        die("<div style='color: red; font-weight: bold;'>Error: Name, Email, and Gender are required.</div>");
    }

    // Validate email format
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        die("<div style='color: red; font-weight: bold;'>Error: Invalid email format.</div>");
    }

    // Validate URL format (if provided)
    if (!empty($website) && !filter_var($website, FILTER_VALIDATE_URL)) {
        die("<div style='color: red; font-weight: bold;'>Error: Invalid website URL.</div>");
    }

    // Prepare and bind SQL query to prevent SQL injection
    $stmt = $conn->prepare("INSERT INTO users (name, email, website, comments, gender) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("sssss", $name, $email, $website, $comment, $gender);

    // Execute query and provide feedback
    if ($stmt->execute()) {
        echo "<div style='color: green; font-weight: bold; font-size: 30px'>New record created successfully.</div>";

        // Display submitted data
        echo "<h3>User Details:</h3>";
        echo "<div style='border: 1px solid #ddd; padding: 10px; width: 50%; background: #f9f9f9;'>";
        echo "<strong>Name:</strong> " . htmlspecialchars($name) . "<br>";
        echo "<strong>Email:</strong> " . htmlspecialchars($email) . "<br>";
        echo "<strong>Website:</strong> " . (!empty($website) ? htmlspecialchars($website) : "N/A") . "<br>";
        echo "<strong>Comment:</strong> " . (!empty($comment) ? htmlspecialchars($comment) : "N/A") . "<br>";
        echo "<strong>Gender:</strong> " . htmlspecialchars($gender) . "<br>";
        echo "</div>";
    } else {
        echo "<div style='color: red; font-weight: bold;'>Error: " . htmlspecialchars($stmt->error) . "</div>";
    }

    // Close statement & connection
    $stmt->close();
    $conn->close();
} else {
    echo "<div style='color: red; font-weight: bold;'>Error: Invalid Request</div>";
}
?>

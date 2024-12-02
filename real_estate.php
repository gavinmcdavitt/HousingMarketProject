<?php
// Database connection settings
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "real_estate_3"; // Replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Function to execute a custom query and display results
function runQuery($query) {
    global $conn;
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
        // Output data of each row
        echo "<table border='1'><tr>";
        // Fetch column names for table headers
        $fields = $result->fetch_fields();
        foreach ($fields as $field) {
            echo "<th>" . $field->name . "</th>";
        }
        echo "</tr>";

        // Fetch and display the rows
        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            foreach ($row as $key => $value) {
                echo "<td>" . $value . "</td>";
            }
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "0 results";
    }
}

// Handle user query input
if (isset($_POST['query'])) {
    $userQuery = $_POST['query'];
    echo "<h3>Results for Query: " . htmlspecialchars($userQuery) . "</h3>";
    runQuery($userQuery);
    exit;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Real Estate Listings</title>
</head>
<body>
<h1>Real Estate Listings</h1>

<!-- Display Houses and Business Properties -->
<h2>All Listings</h2>
<h3>Houses</h3>
<?php
$sqlHouses = "SELECT p.address, p.ownerName, p.price, h.bedrooms, h.bathrooms FROM Property p JOIN House h ON p.address = h.address";
runQuery($sqlHouses);
?>

<h3>Business Properties</h3>
<?php
$sqlBusinessProperties = "SELECT p.address, p.ownerName, p.price, bp.type, bp.size FROM Property p JOIN BusinessProperty bp ON p.address = bp.address";
runQuery($sqlBusinessProperties);
?>

<!-- Search Houses -->
<h2>Search Houses</h2>
<form method="POST" action="">
    <label for="minPrice">Min Price:</label>
    <input type="number" name="minPrice" id="minPrice" value="0">
    <label for="maxPrice">Max Price:</label>
    <input type="number" name="maxPrice" id="maxPrice" value="1000000">
    <br>
    <label for="bedrooms">Bedrooms:</label>
    <input type="number" name="bedrooms" id="bedrooms" value="1">
    <label for="bathrooms">Bathrooms:</label>
    <input type="number" name="bathrooms" id="bathrooms" value="1">
    <br>
    <input type="submit" name="searchHouses" value="Search Houses">
</form>

<?php
if (isset($_POST['searchHouses'])) {
    $minPrice = $_POST['minPrice'];
    $maxPrice = $_POST['maxPrice'];
    $bedrooms = $_POST['bedrooms'];
    $bathrooms = $_POST['bathrooms'];

    $sqlSearchHouses = "SELECT p.address, p.ownerName, p.price, h.bedrooms, h.bathrooms FROM Property p JOIN House h ON p.address = h.address WHERE p.price BETWEEN $minPrice AND $maxPrice AND h.bedrooms = $bedrooms AND h.bathrooms = $bathrooms";
    runQuery($sqlSearchHouses);
}
?>

<!-- Search Business Properties -->
<h2>Search Business Properties</h2>
<form method="POST" action="">
    <label for="minPriceBP">Min Price:</label>
    <input type="number" name="minPriceBP" id="minPriceBP" value="0">
    <label for="maxPriceBP">Max Price:</label>
    <input type="number" name="maxPriceBP" id="maxPriceBP" value="1000000">
    <br>
    <label for="minSize">Min Size (sq ft):</label>
    <input type="number" name="minSize" id="minSize" value="0">
    <label for="maxSize">Max Size (sq ft):</label>
    <input type="number" name="maxSize" id="maxSize" value="1000000">
    <br>
    <input type="submit" name="searchBusiness" value="Search Business Properties">
</form>

<?php
if (isset($_POST['searchBusiness'])) {
    $minPriceBP = $_POST['minPriceBP'];
    $maxPriceBP = $_POST['maxPriceBP'];
    $minSize = $_POST['minSize'];
    $maxSize = $_POST['maxSize'];

    $sqlSearchBusiness = "SELECT p.address, p.ownerName, p.price, bp.type, bp.size FROM Property p JOIN BusinessProperty bp ON p.address = bp.address WHERE p.price BETWEEN $minPriceBP AND $maxPriceBP AND bp.size BETWEEN $minSize AND $maxSize";
    runQuery($sqlSearchBusiness);
}
?>

<!-- Display Agents -->
<h2>All Agents</h2>
<?php
$sqlAgents = "SELECT a.agentId, a.name, a.phone, f.name AS firmName, a.dateStarted FROM Agent a JOIN Firm f ON a.firmId = f.id";
runQuery($sqlAgents);
?>

<!-- Display Buyers -->
<h2>All Buyers</h2>
<?php
$sqlBuyers = "SELECT b.id, b.name, b.phone, b.propertyType, b.bedrooms, b.bathrooms, b.businessPropertyType, b.minimumPreferredPrice, b.maximumPreferredPrice FROM Buyer b";
runQuery($sqlBuyers);
?>

<!-- Allow user to enter custom query -->
<h2>Execute Custom Query</h2>
<form method="POST" action="">
    <textarea name="query" rows="4" cols="50"></textarea>
    <br>
    <input type="submit" value="Run Query">
</form>

</body>
</html>

<?php
// Close connection
$conn->close();
?>

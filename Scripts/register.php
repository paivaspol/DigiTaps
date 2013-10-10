<?php
# connect to database
$mysqli_connection = new MySQLi('vergil.u.washington.edu', 'root', 'Themag1e', 'digitap', 10005);

if ($mysqli_connection->connect_error) {
   echo "Not connected, error: ".$mysqli_connection->connect_error;
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $result = $mysqli_connection->query("SELECT count(*) FROM user");
  $row = $result->fetch_array(MYSQLI_NUM);
  $insert_query = "INSERT INTO user VALUES(?)";
  $prepared_insert = $mysqli_connection->prepare($insert_query);
  $result = $row[0] + 1;
  $prepared_insert->bind_param("i", $result);
  $prepared_insert->execute();
  print $result;
} else if ($_SERVER["REQUEST_METHOD"] == "GET") {
  print 'i\'m a get';
}

$mysqli_connection->close();
?>
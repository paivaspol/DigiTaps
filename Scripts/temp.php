<?php
# connect to database
$mysqli_connection = new MySQLi('vergil.u.washington.edu', 'root', 'Themag1e', 'temp', 10005);

if ($mysqli_connection->connect_error) {
   echo "Not connected, error: ".$mysqli_connection->connect_error;
}

$insert_query = "INSERT INTO a VALUES(1, 2)";

if ($_SERVER["REQUEST_METHOD"] == "GET") {
  echo("I'm a GET");
} else if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $mysqli_connection->query($insert_query);
  echo("hello world!");
}
?>
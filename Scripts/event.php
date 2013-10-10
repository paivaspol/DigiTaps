<?php
# connect to database
$mysqli_connection = new MySQLi('vergil.u.washington.edu', 'root', 'Themag1e', 'digitap', 10005);

if ($mysqli_connection->connect_error) {
   echo "Not connected, error: ".$mysqli_connection->connect_error;
}

if ($_SERVER["REQUEST_METHOD"] == "GET") {
  echo("I'm a GET");
} else if ($_SERVER["REQUEST_METHOD"] == "POST") {
  if (!isset($_POST["eventId"]) || !isset($_POST["eventType"]) || !isset($_POST["gameId"])
    || !isset($_POST["params"]) || !isset($_POST["playerId"]) || !isset($_POST["taskId"])
    || !isset($_POST["timestamp"])) {
      header("HTTP/1.1 400 Bad Request");
      die("Incomplete Arguments");
  }
  # deserialize the arguements and input them to the database
  if ($insert_query = $mysqli_connection->prepare("INSERT INTO event VALUES(?,?,?,?,?,?,?)")) {
    $insert_query->bind_param("isisiii", $_POST["eventId"], 
                                        $_POST["eventType"], 
                                        $_POST["gameId"], 
                                        $_POST["params"], 
                                        $_POST["playerId"], 
                                        $_POST["taskId"], 
                                        $_POST["timestamp"]);
    $insert_query->execute();
    print 'inserted values: ' . $_POST["eventId"];
  }
}
?>
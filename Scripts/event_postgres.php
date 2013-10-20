<?php
# dummy file for implementing Postgres connection through php
if ($_SERVER["REQUEST_METHOD"] == "GET") {
  header("HTTP/1.1 400 Bad Request");
  die("GET Not Supported");
} else if ($_SERVER["REQUEST_METHOD"] == "POST") {
  if (!isset($_POST["eventId"]) || !isset($_POST["eventType"]) || !isset($_POST["gameId"])
    || !isset($_POST["params"]) || !isset($_POST["playerId"]) || !isset($_POST["taskId"])
    || !isset($_POST["timestamp"])) {
      header("HTTP/1.1 400 Bad Request");
      die("Incomplete Arguments");
  }
  $conn_string = "host=localhost dbname=digitap user=digitap password=yy7Mek!1I";
  $dbconn = pg_connect($conn_string);
  if (!$dbconn) {
    header("HTTP/1.1 500 Internal Server Error");
    die(pg_last_error() . "failed to establish a connection");
  }
  
  $values = array($_POST["eventId"], 
                  $_POST["eventType"], 
                  $_POST["gameId"], 
                  $_POST["params"], 
                  $_POST["playerId"], 
                  $_POST["taskId"], 
                  $_POST["timestamp"]);
  $result = pg_query_params('INSERT INTO event VALUES ($1, $2, $3, $4, $5, $6, $7)', $values);
}
?>
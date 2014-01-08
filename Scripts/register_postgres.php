<?php
# dummy file for implementing Postgres connection through php
if ($_SERVER["REQUEST_METHOD"] == "GET") {
  header("HTTP/1.1 400 Bad Request");
  die("GET Not Supported");
} else if ($_SERVER["REQUEST_METHOD"] == "POST") {
  if (!isset($_POST["age"]) || !isset($_POST["gender"]) || !isset($_POST["possession"])
  || !isset($_POST["identity"]) || !isset($_POST["usage"])) {
      header("HTTP/1.1 400 Bad Request");
      die("Incomplete Arguments");
  }
  $conn_string = "host=localhost dbname=digitap user=digitap password=yy7Mek!1I";
  $dbconn = pg_connect($conn_string);
  if (!$dbconn) {
    header("HTTP/1.1 500 Internal Server Error");
    die(pg_last_error() . "failed to establish a connection");
  }
  $result = pg_query($dbconn, "SELECT count(*) FROM players");
  if (!$result) {
    header("HTTP/1.1 500 Internal Server Error");
    die("Error executing the query!" . pg_last_error($dbconn));
  }
  $row = pg_fetch_row($result);
  $player_id = $row[0] + 1;
  $values = array($player_id, 
                  $_POST["age"], 
                  $_POST["gender"], 
                  $_POST["possession"], 
                  $_POST["identity"], 
                  $_POST["usage"]);
  $result = pg_query_params('INSERT INTO players VALUES ($1, $2, $3, $4, $5, $6)', $values);
  if (!result) {
    header("HTTP/1.1 500 Internal Server Error");
    die("Error executing the query!" . pg_last_error($dbconn));
  } else {
    echo ($player_id);
  }
}
?>
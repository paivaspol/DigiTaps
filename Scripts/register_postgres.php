<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
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
  $insert_result = pg_query_params('INSERT INTO players VALUES ($1)', array($player_id));
  echo($player_id);
} else if ($_SERVER["REQUEST_METHOD"] == "GET") {
  header("HTTP/1.1 400 Bad Request");
  die("GET not supported");
}
?>

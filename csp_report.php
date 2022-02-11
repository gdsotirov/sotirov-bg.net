<?php
  include '../csp.php.inc';

  if ( !$conn = mysqli_connect($db_host, $db_user, $db_pass) ) {
    $error = CANNOT_CONNECT;
  }
  if ( !mysqli_select_db($conn, $db_db) ) {
    $error = CANNOT_SEL_DB;
  }

  if ( ! isset($error) ) {
    $report = trim(file_get_contents('php://input'));

    $query  = "INSERT INTO csp_reports (report) VALUES ('";
    $query .= mysqli_real_escape_string($report) . "')";

    mysqli_query($query, $conn);
  }
?>


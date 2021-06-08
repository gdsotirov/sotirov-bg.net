<?php
  include '../csp.php.inc';

  if ( !$conn = mysql_connect($db_host, $db_user, $db_pass) ) {
    $error = CANNOT_CONNECT;
  }
  if ( !mysql_select_db($db_db, $conn) ) {
    $error = CANNOT_SEL_DB;
  }

  if ( ! isset($error) ) {
    $report = trim(file_get_contents('php://input'));

    $query  = "INSERT INTO csp_reports (report) VALUES ('";
    $query .= mysql_real_escape_string($report) . "')";

    mysql_query($query, $conn);
  }
?>


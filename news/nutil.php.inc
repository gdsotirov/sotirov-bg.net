<?php
  /**
   * Function which will mark in color tokens in (X)HTML text
   * @param $tokens List of tokens to be marked
   * @param &$text The text to be marked
   */
  function mark_text($tokens, &$text) {
    while ( list($idx, $token) = each($tokens) ) {
      $token_num = $idx + 1;
      $text = preg_replace("/(>[^><]*)($token)([^<]*<)/i", "$1<span class=\"token$token_num\">$2</span>$3", $text);
    }
  }
?>

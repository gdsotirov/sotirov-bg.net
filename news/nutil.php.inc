<?php
  /**
   * Function which will mark in color tokens in (X)HTML text
   * @param $tokens List of tokens to be marked
   * @param &$text The text to be marked
   */
  function mark_text($tokens, &$text) {
    while ( list($idx, $token) = each($tokens) ) {
      $safe_token = preg_replace(array('/\./', '/\-/'), array('\.', '\-'), $token);
      $text = preg_replace("/(>[^><]*)($safe_token)([^<]*<)/mui", "$1<span class=\"token".++$idx."\">$2</span>$3", $text);
    }
  }

  /**
   * Function for tokenization of search string
   * @param $str String that should be tokenized
   * @param $count Extract count tokens from the string. Defaulting to 5
   * @return Array with tokens extracted from the string
   */
   function tokenize($str, $count = 5) {
     $str = strip_tags($str);
     return preg_split("/[^_a-zA-Z0-9\-\.]+/", $str, $count);
   }
?>

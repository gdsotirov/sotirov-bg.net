<?php
  /**
   * Function which will mark in color tokens in (X)HTML text
   * @param $tokens List of tokens to be marked
   * @param &$text The text to be marked
   */
  function mark_text($tokens, &$text) {
    $cnt = 0;
    $token_list = "[";
    while ( $token = each($tokens) ) {
      if ( $cnt > 1 )
        $token_list .= "|".$token;
      else
        $token_list .= $token;
      $cnt++;
    }
    $token_list .= "]";
    $text = preg_replace("/(>[^><]*)($token_list)([^<]*<)/i", '$1<span class="mark">$2</span>$3', $text);
  }
?>

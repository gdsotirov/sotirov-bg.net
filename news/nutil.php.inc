<?php
  function mark_text($query, &$text) {
    if ( isset($query) )
      $text = preg_replace("/($query)/", '<span class="mark">$1</span>', $text);
  }
?>
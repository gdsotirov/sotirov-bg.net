<?php
  function mark_text($query, &$text) {
    if ( isset($query) )
      $text = preg_replace("/(>[^><]*)($query)([^<]*<)/", '$1<span class="mark">$2</span>$3', $text);

  }
?>
<?php
  /**
   * Marks passed tokens in the text provided as second argument
   * @param array $tokens An array with tokens
   * @param string $text A string where to replace tokens in (by reference)
   */
  function mark_token_text($tokens, &$text) {
    foreach ($tokens as $idx => $token) {
      $safe_token = preg_replace(array('/\./', '/\-/'), array('\.', '\-'), $token);
      $text = preg_replace("/($safe_token)/ui",
                           "<span class=\"token".++$idx."\">$1</span>",
                           $text);
    }
  }

  /**
   * Marks passed tokens in HTML code
   * @param array $tokens An array with tokens
   * @param string $text HTML code to replace tokens in (by reference)
   */
  function mark_token_html($tokens, &$text) {
    $text = preg_replace_callback("/>([^<]+?)</", /* text between tags */
                                  function ($matches) use($tokens) {
                                    mark_token_text($tokens, $matches[1]);
                                    return ">".$matches[1]."<";
                                  },
                                  $text);
  }

  /**
   * Split the provided string into as much tokens as given by second argument
   * @param string str String that should be tokenized
   * @param integer count Extract count tokens from the string (5 by default)
   * @return array Array with tokens extracted from the string
   */
   function tokenize($str, $count = 5) {
     $str = strip_tags($str);
     return preg_split("/[^_a-zA-Zа-яА-Я0-9\-\.]+/u", $str, $count);
   }
?>

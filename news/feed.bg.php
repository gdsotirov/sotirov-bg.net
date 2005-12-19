<?php
  header("Content-type: application/xml");
  include("feedcreator.class.php");

  $rss = new UniversalFeedCreator();
  $rss->title = "Sotirov.net Новини";
  $rss->description = "Новини от Sotirov.net";
  $rss->link = "http://gsotirov79.ddns.homelan.bg/news";
  $rss->syndicationURL = "http://gsotirov79.ddns.homelan.bg".$_SERVER['PHP_SELF'];

  if ( $news_c = mysql_connect($db_host, $db_user, $db_pass) ) {
    if ( mysql_select_db("sotirov_net", $news_c) ) {
      $query = "SELECT news_bg.id, news_bg.title, news_bg.body, news_bg.author, news_bg.posted,";
      $query .= " users.name, users.first_name, users.email";
      $query .= " FROM news_bg, users";
      $query .= " WHERE news_bg.author = users.id";
      $query .= " ORDER BY news_bg.posted DESC";
      $res = mysql_query($query, $news_c);
      if ( mysql_num_rows($res) > 0 ) {
        while ($data = mysql_fetch_object($res)) {
          $item = new FeedItem();
          $item->title = $data->title;
          $item->link = "http://gsotirov79.ddns.homelan.bg/news#newsid_".$data->id;
          $item->description = $data->body;
          $item->date = strtotime($data->posted);
          $item->source = "http://gsotirov79.ddns.homelan.bg/news";
          $item->author = $data->email." (".$data->first_name." ".$data->name.")";
          $item->authorEmail = $data->email;

          $rss->addItem($item);
        }
      }
      else
        print("Новините не са достъпни в момента.\n");
      mysql_free_result($res);
    }
    else
      print("Новините не са достъпни в момента.\n");
    mysql_close($news_c);
  }
  else
    print("Новините не са достъпни в момента.\n");

  switch ( $_REQUEST['f'] ) {
    case "HTML" :
    case "html" : $feedFormat = "HTML";
                  break;
    case "ATOM" :
    case "atom" : $feedFormat = "ATOM";
                  break;
    default     : $feedFormat = "RSS";
  }

  if ( isset($_REQUEST['v']) )
    $version = $_REQUEST['v'];
  elseif ( isset($_REQUEST['ver']) )
    $version = $_REQUEST['ver'];
  else
    $version = "";

  switch ( $feedFormat ) {
    case "RSS"  : switch ( $version ) {
                    case "0.91" :
                    case "1.0"  : $formatVersion = $version;
                                  break;
                    default     : $formatVersion = "2.0";
                  };

                  if ($version <> "1.0")
                    $mimetype = "application/rss+xml";
                  else
                    $mimetype = "application/rdf+xml";
                  break;
    case "ATOM" : $formatVersion = "0.3";
                  $mimetype="application/atom+xml";
                  break;
    default     : $formatVersion = "";
  }

  echo $rss->createFeed($feedFormat.$formatVersion);
?>

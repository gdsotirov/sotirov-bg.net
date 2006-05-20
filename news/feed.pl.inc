# This script is intended to gnerate the news feeds of Sotirov-BG.Net
# Written by Georgi D. Sotirov <gdsotirov@dir.bg>
#
# $Id: feed.pl.inc,v 1.6 2006/05/20 22:35:47 gsotirov Exp $
#

use strict;
use CGI;
use DBI;
use Date::Parse;
use Date::Language;
use Date::Format;
use XML::Twig;
use XML::RSS;
use XML::Atom::Syndication::Feed;
use XML::Atom::Syndication::Link;
use XML::Atom::Syndication::Entry;
use XML::Atom::Syndication::Text;
use XML::Atom::Syndication::Content;
use XML::Atom::Syndication::Person;

my $q = new CGI;
my $format = lc $q->param('f');
print $q->header('application/xml');

# Function    : fetch_data
# Description : Fetch the data for the feed
sub fetch_data {
  my $dsn = "DBI:mysql:database=sotirov_net;host=localhost;port=3306";
  my $dbh = DBI->connect($dsn, $news_user, $news_pass, {'RaiseError' => 1});

  my $query  = "SELECT nws.id, nws.title, nws.body, nws.author, nws.posted,";
  $query .= " nws.updated, usr.name, usr.first_name, usr.email";
  $query .= " FROM ".$news_db." AS nws, users AS usr";
  $query .= " WHERE nws.author = usr.id";
  $query .= " ORDER BY nws.posted DESC";
  $query .= " LIMIT 10";
  my $sth = $dbh->prepare ($query);
  if ( !$sth ) {
    die "Error:".$dbh->errstr."\n";
  }
  if ( !$sth->execute ) {
    die "Error:".$sth->errstr."\n";
  }

  # No problem fetching all the rows here since we get only 10 as maximum
  my @res = ($sth->rows, $sth->fetchall_arrayref({}));
  $dbh->disconnect;

  return @res;
}

my $lang = Date::Language->new('English');

#
# Generate Atom feeds
#
if ( $format eq "atom" ) {
  (my $row_count, my $res) = fetch_data;

  my $atom = XML::Atom::Syndication::Feed->new;
  $atom->title($feed_title);
  my $link = XML::Atom::Syndication::Link->new;
  $link->href($feed_link);
  $link->rel("alternate");
  $link->type("text/html");
  $atom->link($link);
  #my $slf = XML::Atom::Syndication::Link->new;
  #$slf->href($feed_self."?f=".$format);
  #$slf->rel("self");
  #$slf->type("application/atom+xml");
  #$atom->elem($slf);
  $atom->id;
  $atom->updated ($lang->time2str("%Y-%m-%ST%TZ", str2time($res->[0]->{'updated'}), "GMT"));
  my $author = XML::Atom::Syndication::Person->new(Name => 'author');
  $author->name($feed_author_name);
  $author->uri($feed_author_uri);
  $author->email($feed_author_email);
  $atom->author($author);

  for ( my $i = 0; $i < $row_count; ++$i ) {
    my $entry = XML::Atom::Syndication::Entry->new;
    my $title = XML::Atom::Syndication::Text->new(Name => 'title');
    $title->body($res->[$i]->{'title'});
    $entry->title($title);
    my $link = XML::Atom::Syndication::Link->new;
    $link->href($feed_entry_base.$res->[$i]->{'id'});
    $link->rel("alternate");
    $link->type("text/html");
    $entry->link($link);
    my $author = XML::Atom::Syndication::Person->new(Name => 'author');
    $author->name($res->[$i]->{'first_name'}." ".$res->[$i]->{'name'});
    $author->email($res->[$i]->{'email'});
    $entry->author($author);
    my $content = XML::Atom::Syndication::Content->new($res->[$i]->{'body'});
    $content->type("text/html");
    $entry->content($content);
    $entry->updated($lang->time2str("%Y-%m-%ST%TZ", str2time($res->[$i]->{'updated'}), "GMT"));
    $atom->add_entry($entry);
  }

  my $twig = new XML::Twig;
  $twig->set_indent(" "x2);
  $twig->parse($atom->as_xml);
  $twig->add_stylesheet(css => "/style/atom.css");
  $twig->set_pretty_print('indented');
  print $twig->sprint;
}
#
# Generate RSS 0.9, 0.91, 1.0 and 2.0 feeds
#
elsif ( $format eq "rss" ) {
  my $version = $q->param('v');

  my ($row_count, $res) = fetch_data;

  my $rss = new XML::RSS (version => $version, encoding => 'utf-8');

  # Build the chanel
  $rss->channel(title          => $feed_title,
                link           => $feed_link,
                language       => $feed_lang_id,
                description    => $feed_desc,
                copyright      => $feed_copy,
                pubDate        => $lang->time2str("%a, %d %h %Y %T %Z", str2time($res->[0]->{'posted'}), "GMT"),
                lastBuildDate  => $lang->time2str("%a, %d %h %Y %T %Z", str2time($res->[0]->{'updated'}), "GMT"),
                generator      => "Perl $]",
                managingEditor => $feed_editor_email." (".$feed_editor_name.")",
                webMaster      => $feed_master_email." (".$feed_master_name.")",
                dc => {
                  date         => $lang->time2str("%Y-%m-%ST%T%z", str2time($res->[0]->{'updated'}), "GMT"),
                  publisher    => $feed_editor_name." (".$feed_editor_email.")",
                  creator      => $feed_master_name." (".$feed_master_email.")"
                },
                syn => {
                  updatePeriod     => "daily",
                  updateFrequency  => "1",
                  updateBase       => "2004-12-01T00:00+00:00"
                });
  $rss->image(
    title  => "Sotirov-BG.Net",
    url    => "http://sotirov-bg.net/img/sotirov_net",
    link   => "http://sotirov-bg.net/",
    dc => {
      creator  => "Georgi D. Sotirov <gdsotirov\@dir.bg>",
    });

  # Build entires
  for ( my $i = 0; $i < $row_count; ++$i ) {
    $rss->add_item(title       => $res->[$i]->{'title'},
                   content     => "application/xhtml+xml",
                   description => $res->[$i]->{'body'},
                   author      => $res->[$i]->{'email'}." (".$res->[$i]->{'first_name'}." ".$res->[$i]->{'name'}.")",
                   pubDate     => $lang->time2str("%a, %d %h %Y %T %Z", str2time($res->[$i]->{'posted'}), "GMT"),
                   dc => {
                     format   => "text/html",
                     date     => $lang->time2str("%Y-%m-%ST%T%z", str2time($res->[$i]->{'posted'}), "GMT"),
                     source   => $feed_link,
                     creator  => $res->[$i]->{'first_name'}." ".$res->[$i]->{'name'}." (".$res->[$i]->{'email'}.")"
                   });
  }

  my $twig = new XML::Twig;
  $twig->set_indent(" "x2);
  $twig->set_pretty_print('indented');
  $twig->parse($rss->as_string);
  if ( $version eq "0.91" or $version eq "2.0" ) {
    $twig->add_stylesheet(xsl => "/style/rss.".$feed_lang_id.".xsl");
    $twig->add_stylesheet(css => "/style/rss.css");
  }
  print $twig->sprint;
}
else {
  print $q->header(-location => '/news');
}

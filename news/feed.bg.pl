#!/usr/bin/perl
# This script is intended to localize the news feeds of Sotirov-BG.Net
# Written by Georgi D. Sotirov <gdsotirov@dir.bg>
#
# $Id: feed.bg.pl,v 1.1 2006/05/20 18:02:40 gsotirov Exp $
#

use strict;
use Filter::Include;

include "../../news.pl.inc";

my $news_db = "news_bg";
my $feed_lang_id = "bg";
my $feed_title = "Sotirov-BG.Net Новини";
my $feed_desc = "Новини от Sotirov-BG.Net";
my $feed_link = "http://sotirov-bg.net/news";
my $feed_copy = "Copyright &copy; 2004-2006 Георги Д. Сотиров";
my $feed_author_name = "Георги Д. Сотиров";
my $feed_author_uri = "http://gsotirov79.ddns.homelan.bg/~gsotirov/";
my $feed_author_email = 'gsotirov@dir.bg';
my $feed_editor_name = 'Георги Д. Сотиров';
my $feed_editor_email = 'gsotirov@dir.bg';
my $feed_master_name = 'Георги Д. Сотиров';
my $feed_master_email = 'gsotirov@dir.bg';
# The URL to prpend to each entry link
my $feed_entry_base = "$feed_link#newsid_";

include "feed.pl.inc";


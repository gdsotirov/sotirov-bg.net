#!/usr/bin/perl
# This script is intended to localize the news feeds of Sotirov-BG.Net
# Written by Georgi D. Sotirov <gdsotirov@dir.bg>
#
# $Id: feed.en.pl,v 1.5 2006/05/24 16:47:17 gsotirov Exp $
#

use strict;
use Filter::Include;

include "../../news.pl.inc";

my $news_db = "news";
my $feed_lang_id = "en";
my $feed_title = "Sotirov-BG.Net News";
my $feed_desc = "News from Sotirov-BG.Net";
my $feed_link = "http://gsotirov79.ddns.homelan.bg/news/";
my $feed_self = "http://gsotirov79.ddns.homelan.bg/news/feed";
my $feed_icon = "http://gsotirov79.ddns.homelan.bg/img/sotirov_net";
my $feed_copy = "Copyright (c) 2004-2006 Georgi D. Sotirov";
my $feed_author_name = "Georgi D. Sotirov";
my $feed_author_uri = "http://sotirov-bg.net/~gsotirov/";
my $feed_author_email = 'gsotirov@dir.bg';
my $feed_editor_name = 'Georgi D. Sotirov';
my $feed_editor_email = 'gsotirov@dir.bg';
my $feed_master_name = 'Georgi D. Sotirov';
my $feed_master_email = 'gsotirov@dir.bg';
# The URL to prpend to each entry link
my $feed_entry_base = "$feed_link?id=";

include "feed.pl.inc";


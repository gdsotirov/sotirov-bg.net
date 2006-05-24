#!/usr/bin/perl
# This script is intended to localize the news feeds of Sotirov-BG.Net
# Written by Georgi D. Sotirov <gdsotirov@dir.bg>
#
# $Id: feed.bg.pl,v 1.4 2006/05/24 14:04:40 gsotirov Exp $
#

use strict;
use Filter::Include;

include "../../news.pl.inc";

my $news_db = "news_bg";
my $feed_lang_id = "bg";
my $feed_title = "Sotirov-BG.Net Новини";
my $feed_desc = "Новини от Sotirov-BG.Net";
my $feed_link = "http://sotirov-bg.net/news/";
my $feed_self = "http://sotirov-bg.net/news/feed";
my $feed_icon = "http://sotirov-bg.net/img/sotirov_net";
my $feed_copy = "Copyright (c) 2004-2006 Георги Д. Сотиров";
my $feed_author_name = "Георги Д. Сотиров";
my $feed_author_uri = "http://sotirov-bg.net/~gsotirov/";
my $feed_author_email = 'gsotirov@dir.bg';
my $feed_editor_name = 'Георги Д. Сотиров';
my $feed_editor_email = 'gsotirov@dir.bg';
my $feed_master_name = 'Георги Д. Сотиров';
my $feed_master_email = 'gsotirov@dir.bg';
# The URL to prpend to each entry link
my $feed_entry_base = "$feed_link?id=";

include "feed.pl.inc";


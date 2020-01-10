#!/usr/bin/perl
# This script is intended to localize the news feeds of Sotirov-BG.Net
# Written by Georgi D. Sotirov <gdsotirov@dir.bg>
#

use strict;
use Filter::Include;

include "../../news.pl.inc";

my $news_db = "news";
my $feed_lang_id = "en";
my $feed_title = "Sotirov-BG.Net News";
my $feed_desc = "News from Sotirov-BG.Net";
my $feed_link = "https://".$ENV{SERVER_NAME}."/news/";
my $feed_self = "https://".$ENV{SERVER_NAME}."/news/feed";
my $feed_icon = "https://".$ENV{SERVER_NAME}."/img/sotirov_net";
my $feed_copy = "Copyright (c) 2004-2020 Georgi D. Sotirov";
my $feed_author_name = "Georgi D. Sotirov";
my $feed_author_uri = "https://".$ENV{SERVER_NAME}."/~gsotirov/";
my $feed_author_email = 'gsotirov@dir.bg';
my $feed_editor_name = 'Georgi D. Sotirov';
my $feed_editor_email = 'gsotirov@dir.bg';
my $feed_master_name = 'Georgi D. Sotirov';
my $feed_master_email = 'gsotirov@dir.bg';
# The URL to prpend to each entry link
my $feed_entry_base = "$feed_link?id=";
my $item_author_name_field = 'name';
my $item_author_fname_field = 'firstname';

include "feed.pl.inc";


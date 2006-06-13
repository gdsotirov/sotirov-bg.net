`sotirov_net`.CREATE DATABASE `sotirov_net` /*!40100 DEFAULT CHARACTER SET utf8 */;

DROP TABLE IF EXISTS `sotirov_net`.`news`;
CREATE TABLE  `sotirov_net`.`news` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `body` text NOT NULL,
  `author` int(10) unsigned NOT NULL,
  `posted` timestamp NOT NULL default '0000-00-00 00:00:00',
  `created` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`,`author`),
  KEY `author_key` (`author`),
  KEY `title_idx` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='News archive';

DROP TABLE IF EXISTS `sotirov_net`.`news_bg`;
CREATE TABLE  `sotirov_net`.`news_bg` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `body` text NOT NULL,
  `author` int(10) unsigned NOT NULL,
  `posted` timestamp NOT NULL default '0000-00-00 00:00:00',
  `created` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`,`author`),
  KEY `author_key` (`author`),
  KEY `title_idx` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='News archive in Bulgarian';

DROP TABLE IF EXISTS `sotirov_net`.`slackpack`;
CREATE TABLE  `sotirov_net`.`slackpack` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(128) NOT NULL,
  `version` varchar(20) NOT NULL,
  `arch` varchar(8) NOT NULL,
  `build` varchar(10) NOT NULL,
  `filename` varchar(256) NOT NULL default '',
  `url` varchar(256) NOT NULL default '',
  `author` int(10) unsigned NOT NULL,
  `md5` char(32) NOT NULL default '',
  `sign` text NOT NULL,
  `size` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`,`author`),
  KEY `author_key` (`author`),
  KEY `name_idx` (`name`),
  KEY `version_idx` (`version`),
  KEY `arch_idx` (`arch`),
  KEY `build_idx` (`build`),
  CONSTRAINT `author_key` FOREIGN KEY (`author`) REFERENCES `news` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Slackwrare Packages Register';

DROP TABLE IF EXISTS `sotirov_net`.`users`;
CREATE TABLE  `sotirov_net`.`users` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `firstname` varchar(60) NOT NULL default '',
  `email` varchar(256) NOT NULL default '',
  `registered` timestamp NOT NULL default '0000-00-00 00:00:00',
  `nickname` varchar(30) default NULL,
  `picture` blob,
  `phone` varchar(64) default '',
  `posts` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `name_idx` (`name`),
  KEY `fname_idx` (`firstname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Users table';

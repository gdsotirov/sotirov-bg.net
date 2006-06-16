-- MySQL dump 10.10
--
-- Host: localhost    Database: sotirov_net
-- ------------------------------------------------------
-- Server version	5.0.22-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `licenses`
--

DROP TABLE IF EXISTS `licenses`;
CREATE TABLE `licenses` (
  `id` char(8) collate latin1_general_ci NOT NULL default '',
  `name` varchar(8) character set latin1 NOT NULL default '',
  `desc` text character set latin1,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='Package licenses catalog';

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
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

/*!50003 SET @OLD_SQL_MODE=@@SQL_MODE*/;
DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `update_posts_count` AFTER INSERT ON `news` FOR EACH ROW BEGIN UPDATE sotirov_net.users SET posts = posts + 1 WHERE id = NEW.author; END */;;

DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;

--
-- Table structure for table `news_bg`
--

DROP TABLE IF EXISTS `news_bg`;
CREATE TABLE `news_bg` (
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

--
-- Table structure for table `slackarch`
--

DROP TABLE IF EXISTS `slackarch`;
CREATE TABLE `slackarch` (
  `id` char(8) character set latin1 collate latin1_general_ci NOT NULL default '',
  `name` varchar(40) character set latin1 NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `slackpack`
--

DROP TABLE IF EXISTS `slackpack`;
CREATE TABLE `slackpack` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(128) NOT NULL,
  `version` varchar(20) NOT NULL,
  `arch` char(8) character set latin1 collate latin1_general_ci NOT NULL default '',
  `build` varchar(10) default NULL,
  `filename` varchar(256) NOT NULL default '',
  `url` varchar(1024) NOT NULL default '',
  `author` int(10) unsigned NOT NULL,
  `md5` char(32) NOT NULL default '',
  `sign` text,
  `size` int(10) unsigned NOT NULL default '0',
  `date` date default NULL,
  `time` time default NULL,
  `slackver` char(8) character set latin1 collate latin1_general_ci NOT NULL default '',
  `desc` text,
  `license` char(8) character set latin1 collate latin1_general_ci NOT NULL default '',
  PRIMARY KEY  (`id`,`author`),
  KEY `author_key` (`author`),
  KEY `name_idx` (`name`),
  KEY `version_idx` (`version`),
  KEY `arch_idx` (`arch`),
  KEY `slackver_idx` (`slackver`),
  KEY `lic_key` (`license`),
  CONSTRAINT `lic_key` FOREIGN KEY (`license`) REFERENCES `licenses` (`id`),
  CONSTRAINT `arch_key` FOREIGN KEY (`arch`) REFERENCES `slackarch` (`id`),
  CONSTRAINT `author_key` FOREIGN KEY (`author`) REFERENCES `news` (`id`),
  CONSTRAINT `slackver_key` FOREIGN KEY (`slackver`) REFERENCES `slackver` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Slackwrare Packages Register';

--
-- Table structure for table `slackver`
--

DROP TABLE IF EXISTS `slackver`;
CREATE TABLE `slackver` (
  `id` char(8) character set latin1 collate latin1_general_ci NOT NULL default '',
  `name` varchar(60) NOT NULL default '',
  `released` date default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `name_bg` varchar(60) NOT NULL default '',
  `firstname` varchar(60) NOT NULL default '',
  `firstname_bg` varchar(60) NOT NULL default '',
  `email` varchar(256) NOT NULL default '',
  `registered` timestamp NOT NULL default '0000-00-00 00:00:00',
  `nickname` varchar(30) default NULL,
  `picture` blob,
  `phone` varchar(64) default '',
  `posts` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `name_idx` (`name`),
  KEY `fname_idx` (`firstname`),
  KEY `name_bg_idx` (`name_bg`),
  KEY `firstname_bg_idx` (`firstname_bg`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Users table';
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


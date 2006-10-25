-- MySQL dump 10.10
--
-- Host: localhost    Database: sotirov_net
-- ------------------------------------------------------
-- Server version	5.0.26-log

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
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(100) NOT NULL default '',
  `body` text NOT NULL,
  `author` int(10) unsigned NOT NULL,
  `posted` timestamp NOT NULL default '0000-00-00 00:00:00',
  `created` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`,`author`),
  KEY `author_key` (`author`),
  KEY `title_idx` (`title`),
  KEY `time_idx` (`posted`,`created`,`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='News archive';

--
-- Definition of trigger `news_insbf`
--

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER  `sotirov_net`.`news_insbf` BEFORE INSERT ON `news` FOR EACH ROW BEGIN
  SET NEW.created = NOW();

  UPDATE users
     SET posts = posts + 1
   WHERE id = NEW.author;
END $$

DELIMITER ;

--
-- Definition of trigger `news_updbf`
--

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER  `sotirov_net`.`news_updbf` BEFORE UPDATE ON `news` FOR EACH ROW BEGIN
  SET NEW.updated = NOW();

  IF OLD.author <> NEW.author THEN
    UPDATE users
       SET posts = posts + 1
     WHERE id = NEW.author;

    UPDATE users
       SET posts = posts - 1
     WHERE id = OLD.author;
  END IF;
END $$

DELIMITER ;

--
-- Table structure for table `news`
--
DROP TABLE IF EXISTS `news_bg`;
CREATE TABLE `news_bg` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(100) NOT NULL default '',
  `body` text NOT NULL,
  `author` int(10) unsigned NOT NULL,
  `posted` timestamp NOT NULL default '0000-00-00 00:00:00',
  `created` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`,`author`),
  KEY `author_key` (`author`),
  KEY `title_idx` (`title`),
  KEY `time_idx` (`posted`,`created`,`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='News archive in Bulgarian';

--
-- Definition of trigger `news_bg_insbf`
--

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER  `sotirov_net`.`news_bg_insbf` BEFORE INSERT ON `news_bg` FOR EACH ROW BEGIN
  SET NEW.created = NOW();
END $$

DELIMITER ;

--
-- Definition of trigger `news_bg_updbf`
--

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER  `sotirov_net`.`news_bg_updbf` BEFORE UPDATE ON `news_bg` FOR EACH ROW BEGIN
  SET NEW.updated = NOW();
END $$

DELIMITER ;

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

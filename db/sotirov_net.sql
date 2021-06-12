-- MySQL dump 10.13  Distrib 5.7.34, for Linux (x86_64)
--
-- Host: localhost    Database: sotirov_net
-- ------------------------------------------------------
-- Server version	5.7.34-log

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
-- Table structure for table `csp_reports`
--

DROP TABLE IF EXISTS `csp_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `csp_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report` json NOT NULL COMMENT 'Raw CSP report in JSON format.\nTODO: Make invisible in 8.0',
  `received` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `blocked_uri` varchar(512) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."blocked-uri"'))) VIRTUAL COMMENT 'The URI of the resource that was blocked from loading by the Content Security Policy.',
  `column_number` int(11) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."column-number"'))) VIRTUAL COMMENT 'The column number in source-file on which the violation occurred.',
  `disposition` varchar(8) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."disposition"'))) VIRTUAL COMMENT 'Either "enforce" or "report" depending on whether the Content-Security-Policy header or the Content-Security-Policy-Report-Only header is used.',
  `document_uri` varchar(512) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."document-uri"'))) VIRTUAL COMMENT 'The URI of the document in which the violation occurred.',
  `effective_directive` varchar(64) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."effective-directive"'))) VIRTUAL COMMENT 'The directive whose enforcement caused the violation.',
  `line_number` int(11) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."line-number"'))) VIRTUAL COMMENT 'The line number in source-file on which the violation occurred.',
  `original_policy` varchar(512) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."original-policy"'))) VIRTUAL COMMENT 'The original policy as specified by the Content-Security-Policy-Report-Only HTTP header.',
  `referrer` varchar(512) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."referrer"'))) VIRTUAL COMMENT 'The referrer of the document in which the violation occurred.',
  `script_sample` varchar(64) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."script-sample"'))) VIRTUAL COMMENT 'The first 40 characters of the inline script, event handler, or style that caused the violation.',
  `source_file` varchar(512) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."source-file"'))) VIRTUAL COMMENT 'The URL of the resource where the violation occurred, stripped for reporting.',
  `status_code` int(11) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."status-code"'))) VIRTUAL COMMENT 'The HTTP status code of the resource on which the global object was instantiated.',
  `violated_directive` varchar(128) GENERATED ALWAYS AS (json_unquote(json_extract(`report`,'$."csp-report"."violated-directive"'))) VIRTUAL COMMENT 'The policy directive that was violated, as it appears in the policy.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Content Security Policy (CSP) violation reports';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `author` int(10) unsigned NOT NULL,
  `posted` timestamp NULL DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`,`author`),
  KEY `author_key` (`author`),
  KEY `title_idx` (`title`),
  KEY `time_idx` (`posted`,`created`,`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='News archive';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER  `sotirov_net`.`news_insbf` BEFORE INSERT ON `news` FOR EACH ROW BEGIN
  SET NEW.created = NOW();

  UPDATE users
     SET posts = posts + 1
   WHERE id = NEW.author;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER  `sotirov_net`.`news_updbf` BEFORE UPDATE ON `news` FOR EACH ROW BEGIN
  SET NEW.updated = NOW();

  IF OLD.author <> NEW.author THEN
    UPDATE users
       SET posts = posts + 1
     WHERE id = NEW.author;

    UPDATE users
       SET posts = posts - 1
     WHERE id = OLD.author;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `news_bg`
--

DROP TABLE IF EXISTS `news_bg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_bg` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `author` int(10) unsigned NOT NULL,
  `posted` timestamp NULL DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`,`author`),
  KEY `author_key` (`author`),
  KEY `title_idx` (`title`),
  KEY `time_idx` (`posted`,`created`,`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='News archive in Bulgarian';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER  `sotirov_net`.`news_bg_insbf` BEFORE INSERT ON `news_bg` FOR EACH ROW BEGIN
  SET NEW.created = NOW();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sotirov_net`.`news_bg_updbf` BEFORE UPDATE ON `news_bg` FOR EACH ROW BEGIN
  SET NEW.updated = NOW();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `name_bg` varchar(60) NOT NULL DEFAULT '',
  `firstname` varchar(60) NOT NULL DEFAULT '',
  `firstname_bg` varchar(60) NOT NULL DEFAULT '',
  `email` varchar(256) NOT NULL DEFAULT '',
  `registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `nickname` varchar(30) DEFAULT NULL,
  `picture` blob,
  `phone` varchar(64) DEFAULT '',
  `posts` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name_idx` (`name`),
  KEY `fname_idx` (`firstname`),
  KEY `name_bg_idx` (`name_bg`),
  KEY `firstname_bg_idx` (`firstname_bg`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Users table';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-12 14:41:34

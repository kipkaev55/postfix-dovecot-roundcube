-- MySQL dump 10.13  Distrib 5.5.47, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mail
-- ------------------------------------------------------
-- Server version       5.5.47-0ubuntu0.14.04.1

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
-- Table structure for table `admin`
--
CREATE DATABASE `mail` /*!40100 DEFAULT CHARACTER SET latin1 */;
GRANT ALL ON mail.* TO mail@localhost IDENTIFIED BY 'mail';
USE mail;

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
	  `username` varchar(255) NOT NULL,
	  `password` varchar(255) NOT NULL,
	  `superadmin` tinyint(1) NOT NULL DEFAULT '0',
	  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `active` tinyint(1) NOT NULL DEFAULT '1',
	  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Admins';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alias`
--

DROP TABLE IF EXISTS `alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias` (
	  `address` varchar(255) NOT NULL,
	  `goto` text NOT NULL,
	  `domain` varchar(255) NOT NULL,
	  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `active` tinyint(1) NOT NULL DEFAULT '1',
	  PRIMARY KEY (`address`),
	  KEY `domain` (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Aliases';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alias_domain`
--

DROP TABLE IF EXISTS `alias_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias_domain` (
	  `alias_domain` varchar(255) NOT NULL,
	  `target_domain` varchar(255) NOT NULL,
	  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `active` tinyint(1) NOT NULL DEFAULT '1',
	  PRIMARY KEY (`alias_domain`),
	  KEY `active` (`active`),
	  KEY `target_domain` (`target_domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Domain Aliases';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `name` varchar(20) NOT NULL DEFAULT '',
	  `value` varchar(20) NOT NULL DEFAULT '',
	  PRIMARY KEY (`id`),
	  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='PostfixAdmin settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `domain`
--

DROP TABLE IF EXISTS `domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain` (
	  `domain` varchar(255) NOT NULL,
	  `description` varchar(255) CHARACTER SET utf8 NOT NULL,
	  `aliases` int(10) NOT NULL DEFAULT '0',
	  `mailboxes` int(10) NOT NULL DEFAULT '0',
	  `maxquota` bigint(20) NOT NULL DEFAULT '0',
	  `quota` bigint(20) NOT NULL DEFAULT '0',
	  `transport` varchar(255) NOT NULL,
	  `backupmx` tinyint(1) NOT NULL DEFAULT '0',
	  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `active` tinyint(1) NOT NULL DEFAULT '1',
	  PRIMARY KEY (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Domains';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `domain_admins`
--

DROP TABLE IF EXISTS `domain_admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain_admins` (
	  `username` varchar(255) NOT NULL,
	  `domain` varchar(255) NOT NULL,
	  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `active` tinyint(1) NOT NULL DEFAULT '1',
	  KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Domain Admins';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `domain_admins` WRITE;
/*!40000 ALTER TABLE `domain_admins` DISABLE KEYS */;
INSERT INTO `domain_admins` VALUES ('admin@pntr.io','ALL','2016-03-06 16:10:41',1);
/*!40000 ALTER TABLE `domain_admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fetchmail`
--

DROP TABLE IF EXISTS `fetchmail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fetchmail` (
	  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
	  `domain` varchar(255) DEFAULT '',
	  `mailbox` varchar(255) NOT NULL,
	  `src_server` varchar(255) NOT NULL,
	  `src_auth` enum('password','kerberos_v5','kerberos','kerberos_v4','gssapi','cram-md5','otp','ntlm','msn','ssh','any') DEFAULT NULL,
	  `src_user` varchar(255) NOT NULL,
	  `src_password` varchar(255) NOT NULL,
	  `src_folder` varchar(255) NOT NULL,
	  `poll_time` int(11) unsigned NOT NULL DEFAULT '10',
	  `fetchall` tinyint(1) unsigned NOT NULL DEFAULT '0',
	  `keep` tinyint(1) unsigned NOT NULL DEFAULT '0',
	  `protocol` enum('POP3','IMAP','POP2','ETRN','AUTO') DEFAULT NULL,
	  `usessl` tinyint(1) unsigned NOT NULL DEFAULT '0',
	  `sslcertck` tinyint(1) NOT NULL DEFAULT '0',
	  `sslcertpath` varchar(255) CHARACTER SET utf8 DEFAULT '',
	  `sslfingerprint` varchar(255) DEFAULT '',
	  `extra_options` text,
	  `returned_text` text,
	  `mda` varchar(255) NOT NULL,
	  `date` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
	  `created` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
	  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	  `active` tinyint(1) NOT NULL DEFAULT '0',
	  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
	  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `username` varchar(255) NOT NULL,
	  `domain` varchar(255) NOT NULL,
	  `action` varchar(255) NOT NULL,
	  `data` text NOT NULL,
	  KEY `timestamp` (`timestamp`),
	  KEY `domain_timestamp` (`domain`,`timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mailbox`
--

DROP TABLE IF EXISTS `mailbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailbox` (
	  `username` varchar(255) NOT NULL,
	  `password` varchar(255) NOT NULL,
	  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
	  `maildir` varchar(255) NOT NULL,
	  `quota` bigint(20) NOT NULL DEFAULT '0',
	  `local_part` varchar(255) NOT NULL,
	  `domain` varchar(255) NOT NULL,
	  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `active` tinyint(1) NOT NULL DEFAULT '1',
	  PRIMARY KEY (`username`),
	  KEY `domain` (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Mailboxes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quota`
--

DROP TABLE IF EXISTS `quota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quota` (
	  `username` varchar(255) NOT NULL,
	  `path` varchar(100) NOT NULL,
	  `current` bigint(20) DEFAULT NULL,
	  PRIMARY KEY (`username`,`path`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quota2`
--

DROP TABLE IF EXISTS `quota2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quota2` (
	  `username` varchar(100) NOT NULL,
	  `bytes` bigint(20) NOT NULL DEFAULT '0',
	  `messages` int(11) NOT NULL DEFAULT '0',
	  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vacation`
--

DROP TABLE IF EXISTS `vacation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vacation` (
	  `email` varchar(255) NOT NULL,
	  `subject` varchar(255) CHARACTER SET utf8 NOT NULL,
	  `body` text CHARACTER SET utf8 NOT NULL,
	  `activefrom` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
	  `activeuntil` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
	  `cache` text NOT NULL,
	  `domain` varchar(255) NOT NULL,
	  `interval_time` int(11) NOT NULL DEFAULT '0',
	  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
	  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	  `active` tinyint(1) NOT NULL DEFAULT '1',
	  PRIMARY KEY (`email`),
	  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Vacation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vacation_notification`
--

DROP TABLE IF EXISTS `vacation_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vacation_notification` (
	  `on_vacation` varchar(255) CHARACTER SET latin1 NOT NULL,
	  `notified` varchar(255) CHARACTER SET latin1 NOT NULL,
	  `notified_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	  PRIMARY KEY (`on_vacation`,`notified`),
	  CONSTRAINT `vacation_notification_pkey` FOREIGN KEY (`on_vacation`) REFERENCES `vacation` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Postfix Admin - Virtual Vacation Notifications';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

CREATE DATABASE `roundcube` /*!40100 DEFAULT CHARACTER SET latin1 */;
GRANT ALL ON roundcube.* TO roundcube@localhost IDENTIFIED BY 'roundcube';
USE roundcube;
-- MySQL dump 10.13  Distrib 5.5.47, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: roundcube
-- ------------------------------------------------------
-- Server version       5.5.47-0ubuntu0.14.04.1

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
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache` (
	  `user_id` int(10) unsigned NOT NULL,
	  `cache_key` varchar(128) CHARACTER SET ascii NOT NULL,
	  `created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	  `expires` datetime DEFAULT NULL,
	  `data` longtext NOT NULL,
	  KEY `expires_index` (`expires`),
	  KEY `user_cache_index` (`user_id`,`cache_key`),
	  CONSTRAINT `user_id_fk_cache` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cache_index`
--

DROP TABLE IF EXISTS `cache_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_index` (
	  `user_id` int(10) unsigned NOT NULL,
	  `mailbox` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
	  `expires` datetime DEFAULT NULL,
	  `valid` tinyint(1) NOT NULL DEFAULT '0',
	  `data` longtext NOT NULL,
	  PRIMARY KEY (`user_id`,`mailbox`),
	  KEY `expires_index` (`expires`),
	  CONSTRAINT `user_id_fk_cache_index` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cache_messages`
--

DROP TABLE IF EXISTS `cache_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_messages` (
	  `user_id` int(10) unsigned NOT NULL,
	  `mailbox` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
	  `uid` int(11) unsigned NOT NULL DEFAULT '0',
	  `expires` datetime DEFAULT NULL,
	  `data` longtext NOT NULL,
	  `flags` int(11) NOT NULL DEFAULT '0',
	  PRIMARY KEY (`user_id`,`mailbox`,`uid`),
	  KEY `expires_index` (`expires`),
	  CONSTRAINT `user_id_fk_cache_messages` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cache_shared`
--

DROP TABLE IF EXISTS `cache_shared`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_shared` (
	  `cache_key` varchar(255) CHARACTER SET ascii NOT NULL,
	  `created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	  `expires` datetime DEFAULT NULL,
	  `data` longtext NOT NULL,
	  KEY `expires_index` (`expires`),
	  KEY `cache_key_index` (`cache_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cache_thread`
--

DROP TABLE IF EXISTS `cache_thread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_thread` (
	  `user_id` int(10) unsigned NOT NULL,
	  `mailbox` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
	  `expires` datetime DEFAULT NULL,
	  `data` longtext NOT NULL,
	  PRIMARY KEY (`user_id`,`mailbox`),
	  KEY `expires_index` (`expires`),
	  CONSTRAINT `user_id_fk_cache_thread` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contactgroupmembers`
--

DROP TABLE IF EXISTS `contactgroupmembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contactgroupmembers` (
	  `contactgroup_id` int(10) unsigned NOT NULL,
	  `contact_id` int(10) unsigned NOT NULL,
	  `created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	  PRIMARY KEY (`contactgroup_id`,`contact_id`),
	  KEY `contactgroupmembers_contact_index` (`contact_id`),
	  CONSTRAINT `contactgroup_id_fk_contactgroups` FOREIGN KEY (`contactgroup_id`) REFERENCES `contactgroups` (`contactgroup_id`) ON DELETE CASCADE ON UPDATE CASCADE,
	  CONSTRAINT `contact_id_fk_contacts` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`contact_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contactgroups`
--

DROP TABLE IF EXISTS `contactgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contactgroups` (
	  `contactgroup_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	  `user_id` int(10) unsigned NOT NULL,
	  `changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	  `del` tinyint(1) NOT NULL DEFAULT '0',
	  `name` varchar(128) NOT NULL DEFAULT '',
	  PRIMARY KEY (`contactgroup_id`),
	  KEY `contactgroups_user_index` (`user_id`,`del`),
	  CONSTRAINT `user_id_fk_contactgroups` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts` (
	  `contact_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	  `changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	  `del` tinyint(1) NOT NULL DEFAULT '0',
	  `name` varchar(128) NOT NULL DEFAULT '',
	  `email` text NOT NULL,
	  `firstname` varchar(128) NOT NULL DEFAULT '',
	  `surname` varchar(128) NOT NULL DEFAULT '',
	  `vcard` longtext,
	  `words` text,
	  `user_id` int(10) unsigned NOT NULL,
	  PRIMARY KEY (`contact_id`),
	  KEY `user_contacts_index` (`user_id`,`del`),
	  CONSTRAINT `user_id_fk_contacts` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dictionary`
--

DROP TABLE IF EXISTS `dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dictionary` (
	  `user_id` int(10) unsigned DEFAULT NULL,
	  `language` varchar(5) NOT NULL,
	  `data` longtext NOT NULL,
	  UNIQUE KEY `uniqueness` (`user_id`,`language`),
	  CONSTRAINT `user_id_fk_dictionary` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `identities`
--

DROP TABLE IF EXISTS `identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `identities` (
	  `identity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	  `user_id` int(10) unsigned NOT NULL,
	  `changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	  `del` tinyint(1) NOT NULL DEFAULT '0',
	  `standard` tinyint(1) NOT NULL DEFAULT '0',
	  `name` varchar(128) NOT NULL,
	  `organization` varchar(128) NOT NULL DEFAULT '',
	  `email` varchar(128) NOT NULL,
	  `reply-to` varchar(128) NOT NULL DEFAULT '',
	  `bcc` varchar(128) NOT NULL DEFAULT '',
	  `signature` longtext,
	  `html_signature` tinyint(1) NOT NULL DEFAULT '0',
	  PRIMARY KEY (`identity_id`),
	  KEY `user_identities_index` (`user_id`,`del`),
	  KEY `email_identities_index` (`email`,`del`),
	  CONSTRAINT `user_id_fk_identities` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `searches`
--

DROP TABLE IF EXISTS `searches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `searches` (
	  `search_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	  `user_id` int(10) unsigned NOT NULL,
	  `type` int(3) NOT NULL DEFAULT '0',
	  `name` varchar(128) NOT NULL,
	  `data` text,
	  PRIMARY KEY (`search_id`),
	  UNIQUE KEY `uniqueness` (`user_id`,`type`,`name`),
	  CONSTRAINT `user_id_fk_searches` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
	  `sess_id` varchar(128) NOT NULL,
	  `created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	  `changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	  `ip` varchar(40) NOT NULL,
	  `vars` mediumtext NOT NULL,
	  PRIMARY KEY (`sess_id`),
	  KEY `changed_index` (`changed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system`
--

DROP TABLE IF EXISTS `system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system` (
	  `name` varchar(64) NOT NULL,
	  `value` mediumtext,
	  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
	  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	  `username` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
	  `mail_host` varchar(128) NOT NULL,
	  `created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
	  `last_login` datetime DEFAULT NULL,
	  `language` varchar(5) DEFAULT NULL,
	  `preferences` longtext,
	  PRIMARY KEY (`user_id`),
	  UNIQUE KEY `username` (`username`,`mail_host`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

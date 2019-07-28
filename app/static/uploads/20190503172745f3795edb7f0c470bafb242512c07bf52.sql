-- MySQL dump 10.13  Distrib 5.7.26, for macos10.14 (x86_64)
--
-- Host: localhost    Database: bishe
-- ------------------------------------------------------
-- Server version	5.7.26

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

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `is_super` smallint(6) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE,
  KEY `ix_admin_addtime` (`addtime`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'smart','123456',NULL,NULL),(3,'admin','pbkdf2:sha256:50000$JpV3QWs0$06e31e9aa775fcc746439f3292b2120be06d70949535496342e1dd8222e138b1',1,'2019-04-29 21:57:30');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adminlog`
--

DROP TABLE IF EXISTS `adminlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `admin_id` (`admin_id`) USING BTREE,
  KEY `ix_adminlog_addtime` (`addtime`) USING BTREE,
  CONSTRAINT `adminlog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminlog`
--

LOCK TABLES `adminlog` WRITE;
/*!40000 ALTER TABLE `adminlog` DISABLE KEYS */;
INSERT INTO `adminlog` VALUES (27,1,'127.0.0.1','2019-04-29 21:51:21'),(28,3,'127.0.0.1','2019-04-29 21:58:34'),(29,3,'127.0.0.1','2019-04-30 09:42:02');
/*!40000 ALTER TABLE `adminlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `advertise`
--

DROP TABLE IF EXISTS `advertise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `advertise` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `info` text,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `image` (`image`) USING BTREE,
  UNIQUE KEY `image_2` (`image`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `advertise`
--

LOCK TABLES `advertise` WRITE;
/*!40000 ALTER TABLE `advertise` DISABLE KEYS */;
/*!40000 ALTER TABLE `advertise` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `movie_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `movie_id` (`movie_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `ix_comment_addtime` (`addtime`) USING BTREE,
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `info` text,
  `logo` varchar(255) DEFAULT NULL,
  `star` smallint(6) DEFAULT NULL,
  `playnum` bigint(20) DEFAULT NULL,
  `commentnum` bigint(20) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `area` varchar(255) DEFAULT NULL,
  `release_time` date DEFAULT NULL,
  `length` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `title` (`title`) USING BTREE,
  UNIQUE KEY `url` (`url`) USING BTREE,
  UNIQUE KEY `logo` (`logo`) USING BTREE,
  KEY `tag_id` (`tag_id`) USING BTREE,
  KEY `ix_movie_addtime` (`addtime`) USING BTREE,
  CONSTRAINT `movie_ibfk_1` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
INSERT INTO `movie` VALUES (8,'今日说法','20181214100240c0724bba1d2d4f73a2781b59ee9c4a40.mp4','发哈发哈设计开发哈萨克就发哈就发哈时间hash理解哈是几号放假啊号放假咯静安寺的绿卡含量可达负能量咖啡机离开\r\nask的拉克丝发哪里看烦了访问拉克丝烦死了分年龄可适当分担烦恼就是来得及啊可能就阿三哪里看自己flak发家史分厘卡机费JFK多方力量','20181214100240431d0213ccae48ba9ff93ce1c3b3b6b0.jpg',5,85,3,14,'南京南','2018-12-18','655','2018-12-14 10:02:41'),(9,'无敌原始人','201812190022035eb31ecea96547078f4ceb4aabf9063e.mp4','\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------','20181219002203978481c62dc14c0fb6fce415ae8f36e8.jpg',1,36,7,3,'南京','2018-12-17','345','2018-12-19 00:22:03'),(29,'dqwsdasdasdsadsad','20190401085130a894510f98eb4d01a791e330baeae755.mp4','qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq','20190401085130c4ec65fe51bc40d3b7f9cad9e45d0866.mp4',2,3,0,1,'31','2019-04-24','3','2019-04-01 08:51:39'),(30,'dqwsdasdasdsadsadweqewqdsa','2019040111474118b9b09d1826407fb6233af2d9294753.mp4','vfssssssssssssssssssssssssssssssss','20190401114741c8058bfe5ffa41f7bc0222937b0706c0.png',3,1,0,3,'wqe','2019-04-30','3','2019-04-01 11:47:44');
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moviecol`
--

DROP TABLE IF EXISTS `moviecol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `moviecol` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `movie_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `movie_id` (`movie_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `ix_moviecol_addtime` (`addtime`) USING BTREE,
  CONSTRAINT `moviecol_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`),
  CONSTRAINT `moviecol_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moviecol`
--

LOCK TABLES `moviecol` WRITE;
/*!40000 ALTER TABLE `moviecol` DISABLE KEYS */;
INSERT INTO `moviecol` VALUES (1,NULL,36,'2018-12-10 10:15:13'),(4,NULL,37,'2018-12-10 10:16:06'),(5,NULL,38,'2018-12-10 10:16:06'),(13,8,45,'2018-12-17 10:25:18'),(14,8,1,'2018-12-18 22:51:56'),(15,9,45,'2019-02-05 18:26:50');
/*!40000 ALTER TABLE `moviecol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oplog`
--

DROP TABLE IF EXISTS `oplog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oplog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `reason` varchar(600) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `admin_id` (`admin_id`) USING BTREE,
  KEY `ix_oplog_addtime` (`addtime`) USING BTREE,
  CONSTRAINT `oplog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oplog`
--

LOCK TABLES `oplog` WRITE;
/*!40000 ALTER TABLE `oplog` DISABLE KEYS */;
INSERT INTO `oplog` VALUES (10,3,'127.0.0.1','删除标签换壳','2019-04-29 22:23:34'),(11,3,'127.0.0.1','删除标签科幻1','2019-04-29 22:23:37'),(12,3,'127.0.0.1','删除标签爱情2','2019-04-29 22:23:38'),(13,3,'127.0.0.1','添加标签历史','2019-04-30 12:43:55');
/*!40000 ALTER TABLE `oplog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preview`
--

DROP TABLE IF EXISTS `preview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `preview` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `logo` (`logo`) USING BTREE,
  UNIQUE KEY `title` (`title`) USING BTREE,
  KEY `ix_preview_addtime` (`addtime`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preview`
--

LOCK TABLES `preview` WRITE;
/*!40000 ALTER TABLE `preview` DISABLE KEYS */;
INSERT INTO `preview` VALUES (24,'大江大河','20181217124312f135ba65a02145c78f81f59d306f7917.jpg','2018-12-17 12:43:12'),(25,'后会无期','20181217125047abc86a1604f0494ead24c315ba20498c.jpg','2018-12-17 12:50:47'),(26,'fhfg ','20181217130221e6eb34af0b824245b3183aec3ce0e3e5.jpg','2018-12-17 13:02:21'),(27,'juab','201812182249431276169000cd4646a41c8292fef5ad90.jpg','2018-12-18 22:49:43');
/*!40000 ALTER TABLE `preview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE,
  KEY `ix_tag_addtime` (`addtime`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (1,'小清新','2018-12-18 22:44:17'),(2,'动作','2018-12-18 22:44:28'),(3,'校园爱情','2018-12-18 22:44:45'),(14,'搞笑','2018-12-09 22:32:41'),(15,'科学','2018-12-09 22:43:59'),(16,'人文','2018-12-09 22:44:48'),(17,'历史','2019-04-30 12:43:55');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `info` text,
  `face` varchar(255) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  UNIQUE KEY `face` (`face`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE,
  UNIQUE KEY `phone` (`phone`) USING BTREE,
  UNIQUE KEY `uuid` (`uuid`) USING BTREE,
  KEY `ix_user_addtime` (`addtime`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (36,'猪','123456','1123@13.com','12345678998','猪',NULL,'2018-12-10 09:02:41','95c8438c-af81-467a-88e7-780153a09853'),(37,'牛','123456','1124@13.com','12345678994','牛',NULL,'2018-12-10 09:02:41','95c8438c-af81-467a-88e7-780153a09857'),(38,'马','123456','1125@13.com','12345678995','马',NULL,'2018-12-10 09:02:41','95c8438c-af81-467a-88e7-780153a09856'),(39,'驴','123456','1126@13.com','12345678996','驴',NULL,'2018-12-10 09:02:41','95c8438c-af81-467a-88e7-780153a09855'),(40,'鼠','123456','1127@13.com','12345678997','鼠',NULL,'2018-12-10 09:02:41','95c8438c-af81-467a-88e7-780153a09854'),(41,'龙','123456','1128@13.com','12345678990','龙',NULL,'2018-12-10 09:02:41','95c8438c-af81-467a-88e7-780153a09852'),(42,'羊','123456','1129@13.com','12345678999','羊',NULL,'2018-12-10 09:02:43','95c8438c-af81-467a-88e7-780153a09851'),(43,'smart998','147258369','1053522308@qq.com','18734422941','爱德华',NULL,'2018-12-11 10:25:43','e340d49778c84fa09fadd99728a25cc4'),(44,'smart99','147258369','1053522308@163.com','14725836999',NULL,NULL,'2018-12-11 15:55:30','7728818f00404e4d865f7ae123803c80'),(45,'smart','pbkdf2:sha256:50000$EUTCrIyA$ac5984345395247f50a76c2db4472a7af5773c077554ddfd9df12fc626a27e8b','1053522301@qq.com','14725836111',NULL,NULL,'2018-12-11 16:11:33','c281df5e3b4e4bd8bdea7645f2ccce72'),(46,'smart2','pbkdf2:sha256:50000$QdJp9dxs$1ee70cb1cd6d39dbed13c472e68cdf93421e8ff2855ee344e7916ef062b815e6','10535223087@qq.com','18734422942',NULL,NULL,'2019-01-29 15:40:07','a1d2e8f2881649d1ad1ff5b5aea268fa');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userlog`
--

DROP TABLE IF EXISTS `userlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `ix_userlog_addtime` (`addtime`) USING BTREE,
  CONSTRAINT `userlog_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userlog`
--

LOCK TABLES `userlog` WRITE;
/*!40000 ALTER TABLE `userlog` DISABLE KEYS */;
INSERT INTO `userlog` VALUES (1,43,'127.0.0.1','2018-12-11 14:10:36'),(2,43,'127.0.0.1','2018-12-11 14:18:48'),(3,43,'127.0.0.1','2018-12-11 14:33:47'),(4,43,'127.0.0.1','2018-12-11 14:34:42'),(5,44,'127.0.0.1','2018-12-11 16:04:14'),(6,45,'127.0.0.1','2018-12-11 16:11:42'),(7,45,'127.0.0.1','2018-12-11 16:11:58'),(8,45,'127.0.0.1','2018-12-13 10:12:06'),(9,45,'127.0.0.1','2018-12-13 10:12:38'),(10,45,'127.0.0.1','2018-12-13 14:09:26'),(11,45,'127.0.0.1','2018-12-13 14:13:13'),(12,45,'127.0.0.1','2018-12-13 14:14:07'),(13,45,'127.0.0.1','2018-12-13 14:29:30'),(14,45,'127.0.0.1','2018-12-13 14:29:58'),(15,45,'127.0.0.1','2018-12-13 14:34:17'),(16,45,'127.0.0.1','2018-12-13 15:04:00'),(17,45,'127.0.0.1','2018-12-13 16:51:15'),(18,45,'127.0.0.1','2018-12-13 17:44:02'),(19,45,'127.0.0.1','2018-12-13 21:24:21'),(20,45,'127.0.0.1','2018-12-13 22:35:59'),(21,45,'127.0.0.1','2018-12-14 09:45:09'),(22,45,'127.0.0.1','2018-12-14 10:03:30'),(23,45,'127.0.0.1','2018-12-14 10:04:57'),(24,45,'127.0.0.1','2018-12-14 10:08:33'),(25,45,'127.0.0.1','2018-12-17 09:20:13'),(26,45,'127.0.0.1','2018-12-19 09:29:43'),(27,45,'127.0.0.1','2018-12-25 16:56:14'),(28,45,'127.0.0.1','2018-12-25 18:21:40'),(29,45,'127.0.0.1','2018-12-25 20:16:27'),(30,45,'127.0.0.1','2018-12-26 13:37:20'),(31,45,'127.0.0.1','2019-01-11 17:52:35'),(32,45,'127.0.0.1','2019-01-11 21:16:15'),(33,45,'127.0.0.1','2019-01-11 21:19:57'),(34,45,'127.0.0.1','2019-01-11 21:26:15'),(35,45,'127.0.0.1','2019-01-28 13:41:17'),(36,45,'127.0.0.1','2019-01-28 13:49:35'),(37,45,'127.0.0.1','2019-01-28 15:24:39'),(38,45,'127.0.0.1','2019-01-28 15:26:54'),(39,45,'127.0.0.1','2019-01-28 15:27:12'),(40,45,'127.0.0.1','2019-01-28 16:36:46'),(41,45,'127.0.0.1','2019-01-28 17:12:14'),(42,45,'127.0.0.1','2019-01-28 17:17:12'),(43,45,'127.0.0.1','2019-01-28 17:19:19'),(44,45,'127.0.0.1','2019-01-28 17:21:51'),(45,45,'127.0.0.1','2019-01-29 14:45:41'),(46,46,'127.0.0.1','2019-01-29 15:40:29'),(47,46,'127.0.0.1','2019-01-29 19:17:58'),(48,46,'127.0.0.1','2019-01-29 19:20:37'),(49,46,'127.0.0.1','2019-01-29 19:58:02'),(50,46,'127.0.0.1','2019-01-30 15:15:46'),(51,46,'127.0.0.1','2019-01-30 16:38:14'),(52,46,'127.0.0.1','2019-01-30 21:30:35'),(53,46,'127.0.0.1','2019-01-31 20:05:57'),(54,46,'127.0.0.1','2019-02-01 16:53:19'),(55,45,'127.0.0.1','2019-02-01 16:56:38'),(56,45,'127.0.0.1','2019-02-03 20:27:04'),(57,45,'127.0.0.1','2019-02-05 18:12:02'),(58,45,'127.0.0.1','2019-02-05 18:24:19'),(59,45,'127.0.0.1','2019-02-06 12:23:46'),(60,45,'127.0.0.1','2019-03-20 08:37:08'),(61,45,'127.0.0.1','2019-04-29 13:42:44'),(62,45,'121.237.70.210','2019-04-29 14:20:46'),(63,47,'112.21.224.141','2019-04-29 18:07:09'),(64,47,'112.21.224.141','2019-04-29 18:17:38');
/*!40000 ALTER TABLE `userlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userrecommend`
--

DROP TABLE IF EXISTS `userrecommend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userrecommend` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `protagonist` varchar(255) DEFAULT NULL,
  `info` text,
  `area` varchar(255) DEFAULT NULL,
  `release_time` date DEFAULT NULL,
  `addtime` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `title` (`title`) USING BTREE,
  UNIQUE KEY `title_2` (`title`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `ix_userrecommend_addtime` (`addtime`) USING BTREE,
  CONSTRAINT `userrecommend_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userrecommend`
--

LOCK TABLES `userrecommend` WRITE;
/*!40000 ALTER TABLE `userrecommend` DISABLE KEYS */;
/*!40000 ALTER TABLE `userrecommend` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-04-30 13:30:57

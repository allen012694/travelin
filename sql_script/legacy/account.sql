-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: travelin
-- ------------------------------------------------------
-- Server version	5.7.10-log

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
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES (1,'su@travelin.com','travelin','User','Super','superuser',NULL,'2016-04-18 22:56:00','2016-04-18 22:56:00',1,3,NULL,NULL,'2016-01-01 00:00:00',NULL,NULL,NULL,0),(2,'admin@travelin.com','travelin','Admin','','Adminstrator',NULL,'2016-04-18 23:14:24','2016-04-18 23:26:00',1,3,NULL,NULL,'1993-04-08 00:00:00',NULL,NULL,NULL,0),(3,'editor1@travelin.com','travelin','Editor 1','','Editor_1',NULL,'2016-04-18 23:16:02','2016-04-18 23:26:11',1,2,NULL,NULL,'2011-01-01 00:00:00',NULL,NULL,NULL,0),(4,'editor2@travelin.com','travelin','Editor 2','','Editor_2',NULL,'2016-04-18 23:16:47','2016-04-18 23:26:15',1,2,NULL,NULL,'2011-01-01 00:00:00',NULL,NULL,NULL,0),(5,'editor3@travelin.com','travelin','Editor 3','','Editor_3',NULL,'2016-04-18 23:18:23','2016-04-18 23:26:20',1,2,NULL,NULL,'2011-01-01 00:00:00',NULL,NULL,NULL,0),(6,'collaborator1@travelin.com','travelin','Collaborator 1','','Collaborator_1',NULL,'2016-04-18 23:20:40','2016-04-18 23:26:24',1,1,NULL,NULL,'2011-01-01 00:00:00',NULL,NULL,NULL,0),(7,'collaborator2@travelin.com','travelin','Collaborator 2','','Collaborator_2',NULL,'2016-04-18 23:21:15','2016-04-18 23:26:28',1,1,NULL,NULL,'2011-01-01 00:00:00',NULL,NULL,NULL,0),(8,'collaborator3@travelin.com','travelin','Collaborator 3','','Collaborator_3',NULL,'2016-04-18 23:21:48','2016-04-18 23:26:31',1,1,NULL,NULL,'2011-01-01 00:00:00',NULL,NULL,NULL,0),(9,'user1@travelin.com','travelin','User 1','','User_1',NULL,'2016-04-18 23:22:26','2016-04-18 23:22:26',1,0,NULL,NULL,'2012-02-02 00:00:00',NULL,NULL,NULL,0),(10,'user2@travelin.com','travelin','User 2','','User_2',NULL,'2016-04-18 23:23:15','2016-04-18 23:23:15',1,0,NULL,NULL,'2012-02-02 00:00:00',NULL,NULL,NULL,0),(11,'user3@travelin.com','travelin','User 3','','User_3',NULL,'2016-04-18 23:23:42','2016-04-18 23:23:42',1,0,NULL,NULL,'1985-09-16 00:00:00',NULL,NULL,NULL,0),(12,'user4@travelin.com','travelin','User 4','','User_4',NULL,'2016-04-18 23:24:08','2016-04-18 23:24:08',1,0,NULL,NULL,'1984-01-15 00:00:00',NULL,NULL,NULL,0),(13,'user5@travelin.com','travelin','User 5','','User_5',NULL,'2016-04-18 23:24:40','2016-04-18 23:24:40',1,0,NULL,NULL,'2001-07-13 00:00:00',NULL,NULL,NULL,0),(14,'user6@travelin.com','travelin','User 6','','User_6',NULL,'2016-04-18 23:25:22','2016-04-18 23:25:22',1,0,NULL,NULL,'1995-08-11 00:00:00',NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `area`
--

LOCK TABLES `area` WRITE;
/*!40000 ALTER TABLE `area` DISABLE KEYS */;
/*!40000 ALTER TABLE `area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `article`
--

LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `articletag`
--

LOCK TABLES `articletag` WRITE;
/*!40000 ALTER TABLE `articletag` DISABLE KEYS */;
/*!40000 ALTER TABLE `articletag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `conversation`
--

LOCK TABLES `conversation` WRITE;
/*!40000 ALTER TABLE `conversation` DISABLE KEYS */;
/*!40000 ALTER TABLE `conversation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `favorite`
--

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `journal`
--

LOCK TABLES `journal` WRITE;
/*!40000 ALTER TABLE `journal` DISABLE KEYS */;
/*!40000 ALTER TABLE `journal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `journalplace`
--

LOCK TABLES `journalplace` WRITE;
/*!40000 ALTER TABLE `journalplace` DISABLE KEYS */;
/*!40000 ALTER TABLE `journalplace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `journaltag`
--

LOCK TABLES `journaltag` WRITE;
/*!40000 ALTER TABLE `journaltag` DISABLE KEYS */;
/*!40000 ALTER TABLE `journaltag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `liking`
--

LOCK TABLES `liking` WRITE;
/*!40000 ALTER TABLE `liking` DISABLE KEYS */;
/*!40000 ALTER TABLE `liking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `message`
--

LOCK TABLES `message` WRITE;
/*!40000 ALTER TABLE `message` DISABLE KEYS */;
/*!40000 ALTER TABLE `message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `notificationobject`
--

LOCK TABLES `notificationobject` WRITE;
/*!40000 ALTER TABLE `notificationobject` DISABLE KEYS */;
INSERT INTO `notificationobject` VALUES (1,1,'journal'),(2,1,'message'),(3,1,'relationship'),(4,1,'place'),(5,1,'feedback'),(6,1,'article'),(7,1,'account'),(8,2,'journal'),(9,2,'message'),(10,2,'relationship'),(11,2,'place'),(12,2,'feedback'),(13,2,'article'),(14,2,'account'),(15,3,'journal'),(16,3,'message'),(17,3,'relationship'),(18,3,'place'),(19,3,'feedback'),(20,3,'article'),(21,3,'account'),(22,4,'journal'),(23,4,'message'),(24,4,'relationship'),(25,4,'place'),(26,4,'feedback'),(27,4,'article'),(28,4,'account'),(29,5,'journal'),(30,5,'message'),(31,5,'relationship'),(32,5,'place'),(33,5,'feedback'),(34,5,'article'),(35,5,'account'),(36,6,'journal'),(37,6,'message'),(38,6,'relationship'),(39,6,'place'),(40,6,'feedback'),(41,6,'article'),(42,6,'account'),(43,7,'journal'),(44,7,'message'),(45,7,'relationship'),(46,7,'place'),(47,7,'feedback'),(48,7,'article'),(49,7,'account'),(50,8,'journal'),(51,8,'message'),(52,8,'relationship'),(53,8,'place'),(54,8,'feedback'),(55,8,'article'),(56,8,'account'),(57,9,'journal'),(58,9,'message'),(59,9,'relationship'),(60,9,'place'),(61,9,'feedback'),(62,9,'article'),(63,9,'account'),(64,10,'journal'),(65,10,'message'),(66,10,'relationship'),(67,10,'place'),(68,10,'feedback'),(69,10,'article'),(70,10,'account'),(71,11,'journal'),(72,11,'message'),(73,11,'relationship'),(74,11,'place'),(75,11,'feedback'),(76,11,'article'),(77,11,'account'),(78,12,'journal'),(79,12,'message'),(80,12,'relationship'),(81,12,'place'),(82,12,'feedback'),(83,12,'article'),(84,12,'account'),(85,13,'journal'),(86,13,'message'),(87,13,'relationship'),(88,13,'place'),(89,13,'feedback'),(90,13,'article'),(91,13,'account'),(92,14,'journal'),(93,14,'message'),(94,14,'relationship'),(95,14,'place'),(96,14,'feedback'),(97,14,'article'),(98,14,'account');
/*!40000 ALTER TABLE `notificationobject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `place`
--

LOCK TABLES `place` WRITE;
/*!40000 ALTER TABLE `place` DISABLE KEYS */;
/*!40000 ALTER TABLE `place` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `placetag`
--

LOCK TABLES `placetag` WRITE;
/*!40000 ALTER TABLE `placetag` DISABLE KEYS */;
/*!40000 ALTER TABLE `placetag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `relationship`
--

LOCK TABLES `relationship` WRITE;
/*!40000 ALTER TABLE `relationship` DISABLE KEYS */;
/*!40000 ALTER TABLE `relationship` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `suggestion`
--

LOCK TABLES `suggestion` WRITE;
/*!40000 ALTER TABLE `suggestion` DISABLE KEYS */;
/*!40000 ALTER TABLE `suggestion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-04-18 23:28:48

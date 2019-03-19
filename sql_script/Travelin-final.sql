CREATE SCHEMA IF NOT EXISTS `travelin` DEFAULT CHARACTER SET utf8 ;
USE `travelin` ;

CREATE TABLE IF NOT EXISTS `travelin`.`account` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `Firstname` varchar(50) DEFAULT NULL,
  `Lastname` varchar(50) DEFAULT NULL,
  `Username` varchar(50) NOT NULL,
  `Quote` varchar(1500) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DataStatus` int(11) NOT NULL DEFAULT '1',
  `Role` int(11) NOT NULL DEFAULT '0',
  `Phone` varchar(50) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Birthdate` datetime DEFAULT NULL,
  `Description` varchar(2000) DEFAULT NULL,
  `Facebook` varchar(255) DEFAULT NULL,
  `CurrentCityId` int(11) DEFAULT NULL,
  `Gender` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Username` (`Username`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`area` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(150) NOT NULL,
  `Description` varchar(2000) DEFAULT NULL,
  `ParentAreaId` int(11) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CreatedAccountId` int(11) DEFAULT NULL,
  `UpdatedAccountId` int(11) DEFAULT NULL,
  `DataStatus` int(11) NOT NULL DEFAULT '1',
  `Priority` int(11) DEFAULT '0',
  `Longtitude` float(10,6) DEFAULT NULL,
  `Latitude` float(10,6) DEFAULT NULL,
  `Type` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Area_ParentArea` FOREIGN KEY (`ParentAreaId`) REFERENCES `travelin`.`area` (`Id`),
  CONSTRAINT `FK_Location_Account1` FOREIGN KEY (`CreatedAccountId`) REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Location_Account2` FOREIGN KEY (`UpdatedAccountId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`place` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Description` varchar(2000) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `AreaId` int(11) DEFAULT NULL,
  `Longtitude` float(10,6) DEFAULT NULL,
  `Latitude` float(10,6) DEFAULT NULL,
  `DataStatus` int(11) NOT NULL DEFAULT '1',
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CreatedAccountId` int(11) DEFAULT NULL,
  `UpdatedAccountId` int(11) DEFAULT NULL,
  `Priority` int(11) DEFAULT '0',
  `Type` int(11) NOT NULL,
  `WorkingTime` varchar(50) DEFAULT NULL,
  `Price` varchar(100) DEFAULT NULL,
  `Website` varchar(255) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Place_Account1` FOREIGN KEY (`CreatedAccountId`) REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Place_Account2` FOREIGN KEY (`UpdatedAccountId`) REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Place_Location` FOREIGN KEY (`AreaId`) REFERENCES `travelin`.`area` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`article` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `Description` varchar(300) DEFAULT NULL,
  `Content` text NOT NULL,
  `DataStatus` int(11) NOT NULL DEFAULT '1',
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `AuthorId` int(11) DEFAULT NULL,
  `Priority` int(11) DEFAULT '1',
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Article_Account` FOREIGN KEY (`AuthorId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`journal` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `AuthorId` int(11) DEFAULT NULL,
  `Content` text,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DataStatus` int(11) NOT NULL DEFAULT '1',
  `Priority` int(11) DEFAULT '0',
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Journal_Account` FOREIGN KEY (`AuthorId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`tag` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `SearchCount` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`articletag` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `ArticleId` int(11) NOT NULL,
  `TagId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `ArtTagId` (`ArticleId`,`TagId`),
  CONSTRAINT `FK_ArtTag_Article` FOREIGN KEY (`ArticleId`) REFERENCES `travelin`.`article` (`Id`),
  CONSTRAINT `FK_ArtTag_Tag` FOREIGN KEY (`TagId`) REFERENCES `travelin`.`tag` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`comment` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `TargetType` varchar(12) NOT NULL,
  `AccountId` int(11) NOT NULL,
  `TargetId` int(11) NOT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Content` varchar(300) NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Comment_Account` FOREIGN KEY (`AccountId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`conversation` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountFirstId` int(11) NOT NULL,
  `AccountSecondId` int(11) NOT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DataStatus` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Conversation_Account1` FOREIGN KEY (`AccountFirstId`) REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Conversation_Account2` FOREIGN KEY (`AccountSecondId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`favorite` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) NOT NULL,
  `TargetType` varchar(12) NOT NULL,
  `TargetId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Favorite_Account` FOREIGN KEY (`AccountId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`feedback` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Content` varchar(300) DEFAULT NULL,
  `DataStatus` int(11) NOT NULL DEFAULT '1',
  `UpdatedAccountId` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Feedback_Account1` FOREIGN KEY (`AccountId`) REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Feedback_Account2` FOREIGN KEY (`UpdatedAccountId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`journalplace` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `JournalId` int(11) NOT NULL,
  `PlaceId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `JouPlaId` (`JournalId`,`PlaceId`),
  CONSTRAINT `FK_JouPla_Journal` FOREIGN KEY (`JournalId`) REFERENCES `travelin`.`journal` (`Id`),
  CONSTRAINT `FK_JouPla_Place` FOREIGN KEY (`PlaceId`) REFERENCES `travelin`.`place` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`journaltag` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `JournalId` int(11) NOT NULL,
  `TagId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `JourTagId` (`JournalId`,`TagId`),
  CONSTRAINT `FK_JourTag_Journal` FOREIGN KEY (`JournalId`) REFERENCES `travelin`.`journal` (`Id`),
  CONSTRAINT `FK_JourTag_Tag` FOREIGN KEY (`TagId`) REFERENCES `travelin`.`tag` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`liking` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) NOT NULL,
  `TargetType` varchar(12) NOT NULL,
  `TargetId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Like_Account` FOREIGN KEY (`AccountId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`message` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `ConversationId` int(11) NOT NULL,
  `FromAccountId` int(11) NOT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `Content` text NOT NULL,
  `IsRead` tinyint(1) NOT NULL DEFAULT '0',
  `DataStatus` int(11) NOT NULL DEFAULT '3',
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Message_Account` FOREIGN KEY (`FromAccountId`) REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Message_Conversation` FOREIGN KEY (`ConversationId`) REFERENCES `travelin`.`conversation` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`notificationobject` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) NOT NULL,
  `ObjectType` varchar(12) NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Notification_Account` FOREIGN KEY (`AccountId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`notification` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `ObjectId` int(11) NOT NULL,
  `Action` varchar(50) NOT NULL,
  `ActorId` int(11) NOT NULL,
  `DetailObjectId` int(11) DEFAULT NULL,
  `Status` int(11) NOT NULL DEFAULT '1',
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Notification_Actor` FOREIGN KEY (`ActorId`) REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Notification_Object` FOREIGN KEY (`ObjectId`) REFERENCES `travelin`.`notificationobject` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`placetag` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `PlaceId` int(11) NOT NULL,
  `TagId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `PlaTagId` (`PlaceId`,`TagId`),
  CONSTRAINT `FK_PlaTag_Place` FOREIGN KEY (`PlaceId`) REFERENCES `travelin`.`place` (`Id`),
  CONSTRAINT `FK_PlaTag_Tag` FOREIGN KEY (`TagId`) REFERENCES `travelin`.`tag` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`relationship` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountFirstId` int(11) NOT NULL,
  `AccountSecondId` int(11) NOT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `RelationshipId` (`AccountFirstId`,`AccountSecondId`),
  CONSTRAINT `FK_AccountFirst_Account` FOREIGN KEY (`AccountFirstId`) REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_FriendSecond_Account` FOREIGN KEY (`AccountSecondId`) REFERENCES `travelin`.`account` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`suggestion` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AuthorId` int(11) DEFAULT NULL,
  `PlaceId` int(11) DEFAULT NULL,
  `Content` varchar(1000) DEFAULT NULL,
  `DataStatus` int(11) NOT NULL DEFAULT '1',
  `Recommend` int(11) NOT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Suggestion_Account` FOREIGN KEY (`AuthorId`) REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Suggestion_Place` FOREIGN KEY (`PlaceId`) REFERENCES `travelin`.`place` (`Id`)
);

CREATE TABLE IF NOT EXISTS `travelin`.`subscriber` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(45) NOT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Email` (`Email`)
);
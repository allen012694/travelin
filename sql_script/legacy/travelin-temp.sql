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

CREATE TABLE IF NOT EXISTS `travelin`.`article` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `Description` varchar(300) DEFAULT NULL,
  `Content` text NOT NULL,
  `DataStatus` int(11) NOT NULL DEFAULT '1',
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ThemePicture` varchar(200) DEFAULT NULL,
  `AuthorId` int(11) DEFAULT NULL,
  `Priority` int(11) DEFAULT '1',
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Article_Account` FOREIGN KEY (`AuthorId`) REFERENCES `travelin`.`account` (`Id`)
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
)



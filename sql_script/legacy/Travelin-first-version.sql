-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema travelin
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `travelin` DEFAULT CHARACTER SET utf8 ;
USE `travelin` ;

-- -----------------------------------------------------
-- Table `travelin`.`account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`account` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Email` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `Firstname` VARCHAR(50) CHARACTER SET 'utf8' NULL,
  `Lastname` VARCHAR(50) CHARACTER SET 'utf8' NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  `Role` INT(11) DEFAULT 0 NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY (`Email`));

-- -----------------------------------------------------
-- Table `travelin`.`article`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`article` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(255) CHARACTER SET 'utf8' NOT NULL,
  `Content` VARCHAR(4000) CHARACTER SET 'utf8' NOT NULL,
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `ThemePicture` VARCHAR(200) NULL DEFAULT NULL,
  `AuthorId` INT(11) NULL DEFAULT NULL,
  `Priority` INT(11) DEFAULT 1,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Article_Account`
    FOREIGN KEY (`AuthorId`)
    REFERENCES `travelin`.`account` (`Id`));

-- -----------------------------------------------------
-- Table `travelin`.`comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`comment` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `ArticleId` INT(11) NULL DEFAULT NULL,
  `AccountId` INT(11) NULL DEFAULT NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `Content` VARCHAR(1000) CHARACTER SET 'utf8' NULL,
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Comment_Account`
    FOREIGN KEY (`AccountId`)
    REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Comment_Article`
    FOREIGN KEY (`ArticleId`)
    REFERENCES `travelin`.`article` (`Id`));

-- -----------------------------------------------------
-- Table `travelin`.`feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`feedback` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `AccountId` INT(11) NULL DEFAULT NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `Content` VARCHAR(300) CHARACTER SET 'utf8' NULL,
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  `UpdatedAccountId` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Feedback_Account1`
    FOREIGN KEY (`AccountId`)
    REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Feedback_Account2`
    FOREIGN KEY (`UpdatedAccountId`)
    REFERENCES `travelin`.`account` (`Id`)  );

-- -----------------------------------------------------
-- Table `travelin`.`journal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`journal` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `AuthorId` INT(11) NULL DEFAULT NULL,
  `ThemePicture` VARCHAR(200) NULL DEFAULT NULL,
  `Content` VARCHAR(1000) CHARACTER SET 'utf8' NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  `Priority` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Journal_Account`
    FOREIGN KEY (`AuthorId`)
    REFERENCES `travelin`.`account` (`Id`));

-- -----------------------------------------------------
-- Table `travelin`.`place`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`place` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(200) NOT NULL,
  `Description` VARCHAR(2000) CHARACTER SET 'utf8' NULL,
  `LocationId` INT(11) NULL DEFAULT NULL,
  `Longtitude` FLOAT(10,6) NULL DEFAULT NULL,
  `Latitude` FLOAT(10,6) NULL DEFAULT NULL,
  `Pictures` VARCHAR(150) NULL DEFAULT NULL,
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `CreatedAccountId` INT(11) NULL DEFAULT NULL,
  `UpdatedAccountId` INT(11) NULL DEFAULT NULL,
  `Priority` INT(11) DEFAULT 0,
  `Type` INT(11) NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Place_Location`
    FOREIGN KEY (`LocationId`)
    REFERENCES `travelin`.`location` (`Id`),
  CONSTRAINT `FK_Place_Account1`
    FOREIGN KEY (`CreatedAccountId`)
    REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Place_Account2`
    FOREIGN KEY (`UpdatedAccountId`)
    REFERENCES `travelin`.`account` (`Id`));

-- -----------------------------------------------------
-- Table `travelin`.`journalplace`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`journalplace` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `JournalId` INT(11) NOT NULL,
  `PlaceId` INT(11) NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_JouPla_Journal`
    FOREIGN KEY (`JournalId`)
    REFERENCES `travelin`.`journal` (`Id`),
  CONSTRAINT `FK_JouPla_Place`
    FOREIGN KEY (`PlaceId`)
    REFERENCES `travelin`.`place` (`Id`),
  UNIQUE KEY `JouPlaId` (`JournalId`, `PlaceId`));

-- -----------------------------------------------------
-- Table `travelin`.`location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`location` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(150) NOT NULL,
  `Description` VARCHAR(2000) CHARACTER SET 'utf8' NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `CreatedAccountId` INT(11) NULL DEFAULT NULL,
  `UpdatedAccountId` INT(11) NULL DEFAULT NULL,
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  `Priority` INT(11) DEFAULT 0,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Location_Account1`
    FOREIGN KEY (`CreatedAccountId`)
    REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Location_Account2`
    FOREIGN KEY (`UpdatedAccountId`)
    REFERENCES `travelin`.`account` (`Id`));


-- -----------------------------------------------------
-- Table `travelin`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`message` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `FromId` INT(11) NULL DEFAULT NULL,
  `ToId` INT(11) NULL DEFAULT NULL,
  `Title` VARCHAR(100) NOT NULL,
  `Content` VARCHAR(2000) CHARACTER SET 'utf8' NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Message_Account1`
    FOREIGN KEY (`FromId`)
    REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Message_Account2`
    FOREIGN KEY (`ToId`)
    REFERENCES `travelin`.`account` (`Id`)  );


-- -----------------------------------------------------
-- Table `travelin`.`suggestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `travelin`.`suggestion` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `AuthorId` INT(11) NULL DEFAULT NULL,
  `PlaceId` INT(11) NULL DEFAULT NULL,
  `Content` VARCHAR(1000) CHARACTER SET 'utf8' NULL,
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  `Recommend` INT(11) NOT NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Suggestion_Account`
    FOREIGN KEY (`AuthorId`)
    REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Suggestion_Place`
    FOREIGN KEY (`PlaceId`)
    REFERENCES `travelin`.`place` (`Id`));


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

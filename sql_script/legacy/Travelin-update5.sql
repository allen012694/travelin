USE `travelin`;

ALTER TABLE `travelin`.`journal`
	CHANGE COLUMN `Priority` `Priority` INT(11) DEFAULT 0 NULL;

ALTER TABLE `travelin`.`account`
	CHANGE COLUMN `Birthdate` `Birthdate` DATETIME NULL,
	CHANGE COLUMN `Gender` `Gender` TINYINT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS `travelin`.`notificationobject`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`AccountId` INT(11) NOT NULL,
	`ObjectType` VARCHAR(12) NOT NULL,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_Notification_Account`
	    FOREIGN KEY (`AccountId`)
	    REFERENCES `travelin`.`account` (`Id`));

CREATE TABLE IF NOT EXISTS `travelin`.`notification`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`ObjectId` INT(11) NOT NULL,
	`Action` VARCHAR(50) NOT NULL,
	`ActorId` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_Notification_Object`
		FOREIGN KEY (`ObjectId`)
		REFERENCES `travelin`.`notificationobject`(`Id`),
	CONSTRAINT `FK_Notification_Actor`
		FOREIGN KEY (`ActorId`)
		REFERENCES `travelin`.`account` (`Id`));

CREATE TABLE IF NOT EXISTS `travelin`.`favorite`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`AccountId` INT(11) NOT NULL,
	`TargetType` VARCHAR(12) NOT NULL,
	`TargetId` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_Favorite_Account`
		FOREIGN KEY (`AccountId`)
		REFERENCES `travelin`.`account` (`Id`));

CREATE TABLE IF NOT EXISTS `travelin`.`comment`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`TargetType` VARCHAR(12) NOT NULL,
	`AccountId` INT(11) NOT NULL,
	`TargetId` INT(11) NOT NULL,
	`CreatedDate` DATETIME NULL DEFAULT NOW(),
  	`UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  	`Content` VARCHAR(300) CHARACTER SET 'utf8' NOT NULL,
  	PRIMARY KEY (`Id`),
  	CONSTRAINT `FK_Comment_Account`
  		FOREIGN KEY (`AccountId`)
  		REFERENCES `travelin`.`account` (`Id`));

DROP TABLE `travelin`.`journalcomment`;
DROP TABLE `travelin`.`articlecomment`;
DROP TABLE `travelin`.`favoriteplace`;
DROP TABLE `travelin`.`favoritejournal`;

CREATE TABLE IF NOT EXISTS `travelin`.`like`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`AccountId` INT(11) NOT NULL,
	`TargetType` VARCHAR(12) NOT NULL,
	`TargetId` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_Like_Account`
		FOREIGN KEY (`AccountId`)
		REFERENCES `travelin`.`account` (`Id`));

DROP TABLE `travelin`.`friendship`;

CREATE TABLE IF NOT EXISTS `travelin`.`relationship`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`AccountFirstId` INT(11) NOT NULL,
	`AccountSecondId` INT(11) NOT NULL,
	`CreatedDate` DATETIME NULL DEFAULT NOW(),
	`UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
	`Status` INT(11) NOT NULL DEFAULT 0,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_AccountFirst_Account`
		FOREIGN KEY (`AccountFirstId`)
		REFERENCES `travelin`.`account` (`Id`),
	CONSTRAINT `FK_FriendSecond_Account`
		FOREIGN KEY (`AccountSecondId`)
		REFERENCES `travelin`.`account` (`Id`),
	UNIQUE KEY `RelationshipId` (`AccountFirstId`, `AccountSecondId`));

RENAME TABLE `travelin`.`like` TO `travelin`.`liking`;

ALTER TABLE `travelin`.`notification`
	ADD COLUMN `Status` INT(11) NOT NULL DEFAULT 1,
	ADD COLUMN `DetailObjectId` INT(11)
	AFTER `ActorId`;
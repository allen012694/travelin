USE `travelin`;

ALTER TABLE `travelin`.`account`
	ADD COLUMN `Phone` VARCHAR(50) NULL,
	ADD COLUMN `Address` VARCHAR(255) CHARACTER SET 'utf8' NULL,
	ADD COLUMN `Birthdate` DATETIME NOT NULL,
	ADD COLUMN `Description` VARCHAR(2000) CHARACTER SET 'utf8' NULL,
	ADD COLUMN `Facebook` VARCHAR(255) NULL,
	ADD COLUMN `CurrentCityId` INT NULL,
	ADD COLUMN `Gender` TINYINT NOT NULL,
	ADD COLUMN `Quote` VARCHAR(1500) CHARACTER SET 'utf8' NULL
	AFTER `Username`;

ALTER TABLE `travelin`.`tag`
	ADD COLUMN `SearchCount` INT NOT NULL DEFAULT 0
	AFTER `Name`;

ALTER TABLE `travelin`.`article`
	ADD COLUMN `ViewCount` INT NOT NULL DEFAULT 0
	AFTER `AuthorId`;

ALTER TABLE `travelin`.`comment`
	DROP FOREIGN KEY FK_Comment_Account,
	DROP FOREIGN KEY FK_Comment_Article;

RENAME TABLE `travelin`.`comment` to `travelin`.`articlecomment`;

ALTER TABLE `travelin`.`articlecomment`
	ADD CONSTRAINT FK_ArticleComment_Account FOREIGN KEY (`AccountId`) REFERENCES `travelin`.`account` (`Id`),
	ADD CONSTRAINT FK_ArticleComment_Article FOREIGN KEY (`ArticleId`) REFERENCES `travelin`.`article` (`Id`);

CREATE TABLE IF NOT EXISTS `travelin`.`journalcomment` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `JournalId` INT(11) NULL DEFAULT NULL,
  `AccountId` INT(11) NULL DEFAULT NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `Content` VARCHAR(1000) CHARACTER SET 'utf8' NULL,
  `DataStatus` INT(11) DEFAULT 1 NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_JournalComment_Account`
    FOREIGN KEY (`AccountId`)
    REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_JournalComment_Journal`
    FOREIGN KEY (`JournalId`)
    REFERENCES `travelin`.`journal` (`Id`));

CREATE TABLE IF NOT EXISTS `travelin`.`friendship`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`FriendOneId` INT(11) NOT NULL,
	`FriendTwoId` INT(11) NOT NULL,
	`CreatedDate` DATETIME NULL DEFAULT NOW(),
	`UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
	`Status` INT(11) NOT NULL DEFAULT 0,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_FriendOne_Account`
		FOREIGN KEY (`FriendOneId`)
		REFERENCES `travelin`.`account` (`Id`),
	CONSTRAINT `FK_FriendTwo_Account`
		FOREIGN KEY (`FriendTwoId`)
		REFERENCES `travelin`.`account` (`Id`),
	UNIQUE KEY `FriendShipId` (`FriendOneId`, `FriendTwoId`));

ALTER TABLE `travelin`.`journal`
	CHANGE COLUMN `Content` `Content` TEXT CHARACTER SET 'utf8' NULL; 
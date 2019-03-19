USE `travelin`;

ALTER TABLE `travelin`.`journal`
	ADD COLUMN `Title` VARCHAR(255) CHARACTER SET 'utf8' NOT NULL
	AFTER `Id`;

ALTER TABLE `travelin`.`article`
	ADD COLUMN `Description` VARCHAR(300) CHARACTER SET 'utf8' NULL
	AFTER `Title`;
	
/*Be sure username of existed items must already be filled*/
ALTER TABLE `travelin`.`account`
	CHANGE `Username` `Username` VARCHAR(50) NOT NULL;

ALTER TABLE `travelin`.`account`
	ADD UNIQUE KEY(`Username`);

CREATE TABLE IF NOT EXISTS `travelin`.`favoritejournal` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`AccountId` INT(11) NOT NULL,
	`JournalId` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_FavJour_Account`
	  FOREIGN KEY (`AccountId`)
	  REFERENCES `travelin`.`account` (`Id`),
	CONSTRAINT `FK_FavJour_Journal`
	  FOREIGN KEY (`JournalId`)
	  REFERENCES `travelin`.`journal` (`Id`),
	UNIQUE KEY `FavJourId` (`AccountId`, `JournalId`));

CREATE TABLE IF NOT EXISTS `travelin`.`favoriteplace` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`AccountId` INT(11) NOT NULL,
	`PlaceId` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_FavPlace_Account`
	  FOREIGN KEY (`AccountId`)
	  REFERENCES `travelin`.`account` (`Id`),
	CONSTRAINT `FK_FavPlace_Place`
	  FOREIGN KEY (`PlaceId`)
	  REFERENCES `travelin`.`place` (`Id`),
	UNIQUE KEY `FavPlaceId` (`AccountId`, `PlaceId`));

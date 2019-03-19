USE `travelin`;

ALTER TABLE `travelin`.`place`
	ADD COLUMN `Price` VARCHAR(100) CHARACTER SET 'utf8' NULL
	AFTER `WorkingTime`;

ALTER TABLE `travelin`.`area`
	CHANGE `Description` `Description` TEXT CHARACTER SET 'utf8' NULL;

ALTER TABLE `travelin`.`place`
	CHANGE `Description` `Description` TEXT CHARACTER SET 'utf8' NULL;

CREATE TABLE IF NOT EXISTS `travelin`.`journaltag`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`JournalId` INT(11) NOT NULL,
	`TagId` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_JourTag_Journal`
	  FOREIGN KEY (`JournalId`)
	  REFERENCES `travelin`.`journal` (`Id`),
	CONSTRAINT `FK_JourTag_Tag`
	  FOREIGN KEY (`TagId`)
	  REFERENCES `travelin`.`tag` (`Id`),
	UNIQUE KEY `JourTagId` (`JournalId`, `TagId`));


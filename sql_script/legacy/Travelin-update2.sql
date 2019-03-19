USE `travelin`;

ALTER TABLE `travelin`.`article`
	DROP `TagIds`;

ALTER TABLE `travelin`.`tag`
	DROP `CreatedDate`,
	DROP `UpdatedDate`,
	DROP `DataStatus`;

ALTER TABLE `travelin`.`tag`
	CHANGE `Name` `Name` VARCHAR(255) NOT NULL;

CREATE TABLE IF NOT EXISTS `travelin`.`articletag`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`ArticleId` INT(11) NOT NULL,
	`TagId` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_ArtTag_Article`
	  FOREIGN KEY (`ArticleId`)
	  REFERENCES `travelin`.`article` (`Id`),
	CONSTRAINT `FK_ArtTag_Tag`
	  FOREIGN KEY (`TagId`)
	  REFERENCES `travelin`.`tag` (`Id`),
	UNIQUE KEY `ArtTagId` (`ArticleId`, `TagId`));
 
CREATE TABLE IF NOT EXISTS `travelin`.`placetag`(
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`PlaceId` INT(11) NOT NULL,
	`TagId` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	CONSTRAINT `FK_PlaTag_Place`
	  FOREIGN KEY (`PlaceId`)
	  REFERENCES `travelin`.`place` (`Id`),
	CONSTRAINT `FK_PlaTag_Tag`
	  FOREIGN KEY (`TagId`)
	  REFERENCES `travelin`.`tag` (`Id`),
	UNIQUE KEY `PlaTagId` (`PlaceId`, `TagId`));

ALTER TABLE `travelin`.`article`
	CHANGE `Content` `Content` TEXT CHARACTER SET 'utf8' NOT NULL;
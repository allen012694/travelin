USE `travelin`;

CREATE TABLE IF NOT EXISTS `travelin`.`tag` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Name` VARCHAR(50) CHARACTER SET 'utf8' NOT NULL,
	`CreatedDate` DATETIME NULL DEFAULT NOW(),
	`UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
	`DataStatus` INT(11) DEFAULT 1 NOT NULL,
	PRIMARY KEY (`Id`)
);

RENAME TABLE `travelin`.`location` to `travelin`.`area`;

ALTER TABLE `travelin`.`area`
	ADD COLUMN `Longtitude` FLOAT(10,6) NULL DEFAULT NULL,
  	ADD COLUMN`Latitude` FLOAT(10,6) NULL DEFAULT NULL,
	ADD COLUMN `Type` INT(11) NULL,
	ADD COLUMN `ParentAreaId` INT(11) NULL 
	AFTER `Description`;

ALTER TABLE `travelin`.`area`
	ADD CONSTRAINT `FK_Area_ParentArea`
	FOREIGN KEY (`ParentAreaId`)
	REFERENCES `travelin`.`area` (`Id`);

ALTER TABLE `travelin`.`place`
	CHANGE `LocationId` `AreaId` INT(11) NULL DEFAULT NULL;

ALTER TABLE `travelin`.`place`
	ADD COLUMN `TagIds` VARCHAR(50) NULL,
	ADD COLUMN `WorkingTime` VARCHAR(50) CHARACTER SET 'utf8' NULL,
	ADD COLUMN `Website` VARCHAR(255) NULL,
	ADD COLUMN `Phone` VARCHAR(20) NULL,
	ADD COLUMN `Address` VARCHAR(255) CHARACTER SET 'utf8' NULL
	AFTER `Description`;

ALTER TABLE `travelin`.`article`
	ADD COLUMN `TagIds` VARCHAR(50) NULL
	AFTER `Content`;

ALTER TABLE `travelin`.`account`
	ADD COLUMN `Username` VARCHAR(50) CHARACTER SET 'utf8' NULL
	AFTER `Lastname`;

ALTER TABLE `travelin`.`tag` 
	ADD UNIQUE KEY(`Name`);

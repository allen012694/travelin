USE `travelin`;

ALTER TABLE `travelin`.`feedback`
	ADD COLUMN `ReasonId` INT(11)
	AFTER `AccountId`;

ALTER TABLE `travelin`.`notification`
	ADD COLUMN `CreatedDate` DATETIME NULL DEFAULT NOW(),
  ADD COLUMN `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW()
  AFTER `Status`;

DROP TABLE `travelin`.`message`;

CREATE TABLE IF NOT EXISTS `travelin`.`conversation` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `AccountFirstId` INT(11) NOT NULL,
  `AccountSecondId` INT(11) NOT NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `UpdatedDate` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `DataStatus` INT(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Conversation_Account1`
    FOREIGN KEY (`AccountFirstId`)
    REFERENCES `travelin`.`account` (`Id`),
  CONSTRAINT `FK_Conversation_Account2`
    FOREIGN KEY (`AccountSecondId`)
    REFERENCES `travelin`.`account` (`Id`));

CREATE TABLE IF NOT EXISTS `travelin`.`message` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `ConversationId` INT(11) NOT NULL,
  `FromAccountId` INT(11) NOT NULL,
  `CreatedDate` DATETIME NULL DEFAULT NOW(),
  `Content` TEXT CHARACTER SET 'utf8' NOT NULL,
  `Read` BIT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  CONSTRAINT `FK_Message_Conversation`
    FOREIGN KEY (`ConversationId`)
    REFERENCES `travelin`.`conversation` (`Id`),
  CONSTRAINT `FK_Message_Account`
    FOREIGN KEY (`FromAccountId`)
    REFERENCES `travelin`.`account` (`Id`));

ALTER TABLE `travelin`.`message`
  DROP COLUMN `Read`;
ALTER TABLE `travelin`.`message`
  ADD COLUMN `IsRead` TINYINT(1) NOT NULL DEFAULT 0,
  ADD COLUMN `DataStatus` INT(11) NOT NULL DEFAULT 3
  AFTER `Content`;

ALTER TABLE `travelin`.`article`
  DROP `ViewCount`;
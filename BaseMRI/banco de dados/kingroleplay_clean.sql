-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.32-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para mri_kingroleplay_v2
CREATE DATABASE IF NOT EXISTS `mri_kingroleplay_v2` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `mri_kingroleplay_v2`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.apartments
CREATE TABLE IF NOT EXISTS `apartments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `citizenid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.apartments: ~0 rows (aproximadamente)
DELETE FROM `apartments`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.bank_accounts_new
CREATE TABLE IF NOT EXISTS `bank_accounts_new` (
  `id` varchar(50) NOT NULL,
  `amount` int(11) DEFAULT 0,
  `transactions` longtext DEFAULT NULL,
  `auth` longtext DEFAULT NULL,
  `isFrozen` int(11) DEFAULT 0,
  `creator` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.bank_accounts_new: ~11 rows (aproximadamente)
DELETE FROM `bank_accounts_new`;
INSERT INTO `bank_accounts_new` (`id`, `amount`, `transactions`, `auth`, `isFrozen`, `creator`) VALUES
	('ambulance', 0, '[]', '[]', 0, NULL),
	('ballas', 0, '[]', '[]', 0, NULL),
	('cardealer', 0, '[]', '[]', 0, NULL),
	('cartel', 0, '[]', '[]', 0, NULL),
	('families', 0, '[]', '[]', 0, NULL),
	('lostmc', 0, '[]', '[]', 0, NULL),
	('mechanic', 0, '[]', '[]', 0, NULL),
	('police', 0, '[]', '[]', 0, NULL),
	('realestate', 0, '[]', '[]', 0, NULL),
	('triads', 0, '[]', '[]', 0, NULL),
	('vagos', 0, '[]', '[]', 0, NULL);

-- Copiando estrutura para tabela mri_kingroleplay_v2.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'LeBanhammer',
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.bans: ~0 rows (aproximadamente)
DELETE FROM `bans`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.computers_mail_accounts
CREATE TABLE IF NOT EXISTS `computers_mail_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(40) NOT NULL,
  `username` varchar(16) NOT NULL,
  `password` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Copiando dados para a tabela mri_kingroleplay_v2.computers_mail_accounts: ~0 rows (aproximadamente)
DELETE FROM `computers_mail_accounts`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.computers_mail_mails
CREATE TABLE IF NOT EXISTS `computers_mail_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(16) NOT NULL,
  `to` varchar(16) NOT NULL,
  `object` varchar(32) DEFAULT NULL,
  `text` varchar(4096) DEFAULT NULL,
  `answer_to` int(11) DEFAULT NULL,
  `timestamp` int(11) DEFAULT unix_timestamp(),
  `read` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Copiando dados para a tabela mri_kingroleplay_v2.computers_mail_mails: ~0 rows (aproximadamente)
DELETE FROM `computers_mail_mails`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.computers_market
CREATE TABLE IF NOT EXISTS `computers_market` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seller` varchar(40) NOT NULL,
  `title` varchar(16) NOT NULL,
  `description` varchar(512) DEFAULT NULL,
  `timestamp` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Copiando dados para a tabela mri_kingroleplay_v2.computers_market: ~0 rows (aproximadamente)
DELETE FROM `computers_market`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.dealers
CREATE TABLE IF NOT EXISTS `dealers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.dealers: ~0 rows (aproximadamente)
DELETE FROM `dealers`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.drug_plants
CREATE TABLE IF NOT EXISTS `drug_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` longtext DEFAULT NULL,
  `coords` longtext NOT NULL,
  `time` int(255) NOT NULL,
  `type` varchar(100) NOT NULL,
  `health` double NOT NULL DEFAULT 100,
  `fertilizer` double NOT NULL DEFAULT 0,
  `water` double NOT NULL DEFAULT 0,
  `growtime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.drug_plants: ~0 rows (aproximadamente)
DELETE FROM `drug_plants`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.drug_processing
CREATE TABLE IF NOT EXISTS `drug_processing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext NOT NULL,
  `rotation` double NOT NULL,
  `type` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.drug_processing: ~0 rows (aproximadamente)
DELETE FROM `drug_processing`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.export_xp
CREATE TABLE IF NOT EXISTS `export_xp` (
  `cid` varchar(255) NOT NULL,
  `xp` int(11) DEFAULT 0,
  `completed` int(11) DEFAULT 0,
  `failed` int(11) DEFAULT 0,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.export_xp: ~0 rows (aproximadamente)
DELETE FROM `export_xp`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.fuel_stations
CREATE TABLE IF NOT EXISTS `fuel_stations` (
  `location` int(11) NOT NULL,
  `owned` int(11) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT NULL,
  `fuelprice` int(11) DEFAULT NULL,
  `balance` int(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.fuel_stations: ~27 rows (aproximadamente)
DELETE FROM `fuel_stations`;
INSERT INTO `fuel_stations` (`location`, `owned`, `owner`, `fuel`, `fuelprice`, `balance`, `label`) VALUES
	(1, 0, '0', 100000, 3, 0, 'Davis Avenue Ron'),
	(2, 0, '0', 100000, 3, 0, 'Grove Street LTD'),
	(3, 0, '0', 100000, 3, 0, 'Dutch London Xero'),
	(4, 0, '0', 100000, 3, 0, 'Little Seoul LTD'),
	(5, 0, '0', 100000, 3, 0, 'Strawberry Ave Xero'),
	(6, 0, '0', 100000, 3, 0, 'Popular Street Ron'),
	(7, 0, '0', 100000, 3, 0, 'Capital Blvd Ron'),
	(8, 0, '0', 100000, 3, 0, 'Mirror Park LTD'),
	(9, 0, '0', 100000, 3, 0, 'Clinton Ave Globe Oil'),
	(10, 0, '0', 100000, 3, 0, 'North Rockford Ron'),
	(11, 0, '0', 100000, 3, 0, 'Great Ocean Xero'),
	(12, 0, '0', 100000, 3, 0, 'Paleto Blvd Xero'),
	(13, 0, '0', 100000, 3, 0, 'Paleto Ron'),
	(14, 0, '0', 100000, 3, 0, 'Paleto Globe Oil'),
	(15, 0, '0', 100000, 3, 0, 'Grapeseed LTD'),
	(16, 0, '0', 100000, 3, 0, 'Sandy Shores Xero'),
	(17, 0, '0', 100000, 3, 0, 'Sandy Shores Globe Oil'),
	(18, 0, '0', 100000, 3, 0, 'Senora Freeway Xero'),
	(19, 0, '0', 100000, 3, 0, 'Harmony Globe Oil'),
	(20, 0, '0', 100000, 3, 0, 'Route 68 Globe Oil'),
	(21, 0, '0', 100000, 3, 0, 'Route 68 Workshop Globe O'),
	(22, 0, '0', 100000, 3, 0, 'Route 68 Xero'),
	(23, 0, '0', 100000, 3, 0, 'Route 68 Ron'),
	(24, 0, '0', 100000, 3, 0, 'Rex\'s Diner Globe Oil'),
	(25, 0, '0', 100000, 3, 0, 'Palmino Freeway Ron'),
	(26, 0, '0', 100000, 3, 0, 'North Rockford LTD'),
	(27, 0, '0', 100000, 3, 0, 'Alta Street Globe Oil');

-- Copiando estrutura para tabela mri_kingroleplay_v2.houselocations
CREATE TABLE IF NOT EXISTS `houselocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `owned` tinyint(1) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` tinyint(4) DEFAULT NULL,
  `garage` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.houselocations: ~0 rows (aproximadamente)
DELETE FROM `houselocations`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.house_plants
CREATE TABLE IF NOT EXISTS `house_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `building` varchar(30) NOT NULL,
  `stage` varchar(11) NOT NULL DEFAULT 'stage1',
  `sort` varchar(30) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `food` tinyint(4) NOT NULL DEFAULT 100,
  `health` tinyint(4) NOT NULL DEFAULT 100,
  `progress` tinyint(4) NOT NULL DEFAULT 0,
  `coords` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `building` (`building`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.house_plants: ~0 rows (aproximadamente)
DELETE FROM `house_plants`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.lapraces
CREATE TABLE IF NOT EXISTS `lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raceid` (`raceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.lapraces: ~0 rows (aproximadamente)
DELETE FROM `lapraces`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.management_funds
CREATE TABLE IF NOT EXISTS `management_funds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) NOT NULL,
  `amount` int(100) NOT NULL,
  `type` enum('boss','gang') NOT NULL DEFAULT 'boss',
  PRIMARY KEY (`id`),
  UNIQUE KEY `job_name` (`job_name`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.management_funds: ~12 rows (aproximadamente)
DELETE FROM `management_funds`;
INSERT INTO `management_funds` (`id`, `job_name`, `amount`, `type`) VALUES
	(1, 'police', 0, 'boss'),
	(2, 'ambulance', 0, 'boss'),
	(3, 'realestate', 0, 'boss'),
	(4, 'taxi', 0, 'boss'),
	(5, 'cardealer', 0, 'boss'),
	(6, 'mechanic', 0, 'boss'),
	(7, 'lostmc', 0, 'gang'),
	(8, 'ballas', 0, 'gang'),
	(9, 'vagos', 0, 'gang'),
	(10, 'cartel', 0, 'gang'),
	(11, 'families', 0, 'gang'),
	(12, 'triads', 0, 'gang');

-- Copiando estrutura para tabela mri_kingroleplay_v2.management_outfits
CREATE TABLE IF NOT EXISTS `management_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `minrank` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT 'Cool Outfit',
  `gender` varchar(50) NOT NULL DEFAULT 'male',
  `model` varchar(50) DEFAULT NULL,
  `props` text DEFAULT NULL,
  `components` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.management_outfits: ~0 rows (aproximadamente)
DELETE FROM `management_outfits`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_bolos
CREATE TABLE IF NOT EXISTS `mdt_bolos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `individual` varchar(50) DEFAULT NULL,
  `detail` text DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `gallery` text DEFAULT NULL,
  `officersinvolved` text DEFAULT NULL,
  `time` varchar(20) DEFAULT NULL,
  `jobtype` varchar(25) NOT NULL DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_bolos: ~0 rows (aproximadamente)
DELETE FROM `mdt_bolos`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_bulletin
CREATE TABLE IF NOT EXISTS `mdt_bulletin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `desc` text NOT NULL,
  `author` varchar(50) NOT NULL,
  `time` varchar(20) NOT NULL,
  `jobtype` varchar(25) DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_bulletin: ~0 rows (aproximadamente)
DELETE FROM `mdt_bulletin`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_clocking
CREATE TABLE IF NOT EXISTS `mdt_clocking` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) NOT NULL DEFAULT '',
  `firstname` varchar(255) NOT NULL DEFAULT '',
  `lastname` varchar(255) NOT NULL DEFAULT '',
  `clock_in_time` varchar(255) NOT NULL DEFAULT '',
  `clock_out_time` varchar(50) DEFAULT NULL,
  `total_time` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_clocking: ~0 rows (aproximadamente)
DELETE FROM `mdt_clocking`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_convictions
CREATE TABLE IF NOT EXISTS `mdt_convictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` varchar(50) DEFAULT NULL,
  `linkedincident` int(11) NOT NULL DEFAULT 0,
  `warrant` varchar(50) DEFAULT NULL,
  `guilty` varchar(50) DEFAULT NULL,
  `processed` varchar(50) DEFAULT NULL,
  `associated` varchar(50) DEFAULT '0',
  `charges` text DEFAULT NULL,
  `fine` int(11) DEFAULT 0,
  `sentence` int(11) DEFAULT 0,
  `recfine` int(11) DEFAULT 0,
  `recsentence` int(11) DEFAULT 0,
  `time` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_convictions: ~0 rows (aproximadamente)
DELETE FROM `mdt_convictions`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_data
CREATE TABLE IF NOT EXISTS `mdt_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) NOT NULL,
  `information` mediumtext DEFAULT NULL,
  `tags` text NOT NULL,
  `gallery` text NOT NULL,
  `jobtype` varchar(25) DEFAULT 'police',
  `pfp` text DEFAULT NULL,
  `fingerprint` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cid`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_data: ~0 rows (aproximadamente)
DELETE FROM `mdt_data`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_impound
CREATE TABLE IF NOT EXISTS `mdt_impound` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicleid` int(11) NOT NULL,
  `linkedreport` int(11) NOT NULL,
  `fee` int(11) DEFAULT NULL,
  `time` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_impound: ~0 rows (aproximadamente)
DELETE FROM `mdt_impound`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_incidents
CREATE TABLE IF NOT EXISTS `mdt_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(50) NOT NULL DEFAULT '0',
  `details` longtext NOT NULL,
  `tags` text NOT NULL,
  `officersinvolved` text NOT NULL,
  `civsinvolved` text NOT NULL,
  `evidence` text NOT NULL,
  `time` varchar(20) DEFAULT NULL,
  `jobtype` varchar(25) NOT NULL DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_incidents: ~0 rows (aproximadamente)
DELETE FROM `mdt_incidents`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_logs
CREATE TABLE IF NOT EXISTS `mdt_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `time` varchar(20) DEFAULT NULL,
  `jobtype` varchar(25) DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_logs: ~0 rows (aproximadamente)
DELETE FROM `mdt_logs`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_reports
CREATE TABLE IF NOT EXISTS `mdt_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `officersinvolved` text DEFAULT NULL,
  `civsinvolved` text DEFAULT NULL,
  `gallery` text DEFAULT NULL,
  `time` varchar(20) DEFAULT NULL,
  `jobtype` varchar(25) DEFAULT 'police',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_reports: ~0 rows (aproximadamente)
DELETE FROM `mdt_reports`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_vehicleinfo
CREATE TABLE IF NOT EXISTS `mdt_vehicleinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(50) DEFAULT NULL,
  `information` text NOT NULL DEFAULT '',
  `stolen` tinyint(1) NOT NULL DEFAULT 0,
  `code5` tinyint(1) NOT NULL DEFAULT 0,
  `image` text NOT NULL DEFAULT '',
  `points` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_vehicleinfo: ~0 rows (aproximadamente)
DELETE FROM `mdt_vehicleinfo`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mdt_weaponinfo
CREATE TABLE IF NOT EXISTS `mdt_weaponinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial` varchar(50) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `information` text NOT NULL DEFAULT '',
  `weapClass` varchar(50) DEFAULT NULL,
  `weapModel` varchar(50) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mdt_weaponinfo: ~0 rows (aproximadamente)
DELETE FROM `mdt_weaponinfo`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mri_qblips
CREATE TABLE IF NOT EXISTS `mri_qblips` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=511 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mri_qblips: ~41 rows (aproximadamente)
DELETE FROM `mri_qblips`;
INSERT INTO `mri_qblips` (`id`, `name`, `data`) VALUES
	(1, 'YouTool', '{"coords":{"x":343.0681457519531,"y":-1298.2021484375,"z":32.4981689453125},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":544,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_pickup_repair.png","scImg":""}'),
	(2, 'YouTool', '{"coords":{"x":2747.393310546875,"y":3473.208740234375,"z":55.6666259765625},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":544,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_pickup_repair.png","scImg":""}'),
	(11, 'Loja de Pesca', '{"coords":{"x":-1492.945068359375,"y":-939.7318725585938,"z":10.205810546875},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":356,"SpriteImg":"https://docs.fivem.net/blips/radar_dock.png","sRange":true,"colors":0,"scImg":"rgb(254, 254, 254)"}'),
	(12, 'Loja de Pesca', '{"coords":{"x":-2081.393310546875,"y":2614.31201171875,"z":3.078369140625},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":356,"SpriteImg":"https://docs.fivem.net/blips/radar_dock.png","sRange":true,"colors":0,"scImg":"rgb(254, 254, 254)"}'),
	(51, 'Central de Trabalhos', '{"coords":{"x":-261.0989074707031,"y":-971.8417358398438,"z":31.217529296875},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":408,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_capture_the_flag.png","scImg":""}'),
	(101, 'Loja de Conveniência', '{"coords":{"x":25.70000076293945,"y":-1347.300048828125,"z":29.48999977111816},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(102, 'Loja de Conveniência', '{"coords":{"x":-3038.7099609375,"y":585.9000244140625,"z":7.90000009536743},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(103, 'Loja de Conveniência', '{"coords":{"x":-3241.469970703125,"y":1001.1400146484375,"z":12.82999992370605},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(104, 'Loja de Conveniência', '{"coords":{"x":1728.6600341796876,"y":6414.16015625,"z":35.02999877929687},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(105, 'Loja de Conveniência', '{"coords":{"x":1697.989990234375,"y":4924.39990234375,"z":42.06000137329101},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(106, 'Loja de Conveniência', '{"coords":{"x":1961.47998046875,"y":3739.9599609375,"z":32.34000015258789},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(107, 'Loja de Conveniência', '{"coords":{"x":547.7899780273438,"y":2671.7900390625,"z":42.1500015258789},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(108, 'Loja de Conveniência', '{"coords":{"x":2679.25,"y":3280.1201171875,"z":55.2400016784668},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(109, 'Loja de Conveniência', '{"coords":{"x":2557.93994140625,"y":382.04998779296877,"z":108.62000274658203},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(110, 'Loja de Conveniência', '{"coords":{"x":373.54998779296877,"y":325.55999755859377,"z":103.55999755859375},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":52,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_crim_holdups.png","scImg":""}'),
	(201, 'Loja de Bebidas', '{"coords":{"x":1135.8079833984376,"y":-982.281005859375,"z":46.41500091552734},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":93,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_bar.png","scImg":""}'),
	(202, 'Loja de Bebidas', '{"coords":{"x":-1222.9150390625,"y":-906.9829711914063,"z":12.32600021362304},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":93,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_bar.png","scImg":""}'),
	(203, 'Loja de Bebidas', '{"coords":{"x":-1487.552978515625,"y":-379.10699462890627,"z":40.16299819946289},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":93,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_bar.png","scImg":""}'),
	(204, 'Loja de Bebidas', '{"coords":{"x":-2968.242919921875,"y":390.9100036621094,"z":15.04300022125244},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":93,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_bar.png","scImg":""}'),
	(205, 'Loja de Bebidas', '{"coords":{"x":1166.0240478515626,"y":2708.929931640625,"z":38.15700149536133},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":93,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_bar.png","scImg":""}'),
	(206, 'Loja de Bebidas', '{"coords":{"x":1392.56201171875,"y":3604.68408203125,"z":34.97999954223633},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":93,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_bar.png","scImg":""}'),
	(207, 'Loja de Bebidas', '{"coords":{"x":-1393.4090576171876,"y":-606.6240234375,"z":30.31900024414062},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":93,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_bar.png","scImg":""}'),
	(250, 'Petshop', '{"coords":{"x":412.1538391113281,"y":314.967041015625,"z":103.132568359375},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":273,"sColor":2,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_chop.png","scImg":"rgb(113, 203, 113)"}'),
	(300, 'Loja de Armas', '{"coords":{"x":-662.1799926757813,"y":-934.9609985351563,"z":21.82900047302246},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":76,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_armenian_family.png","scImg":""}'),
	(301, 'Loja de Armas', '{"coords":{"x":810.25,"y":-2157.60009765625,"z":29.6200008392334},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":76,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_armenian_family.png","scImg":""}'),
	(302, 'Loja de Armas', '{"coords":{"x":1693.43994140625,"y":3760.159912109375,"z":34.70999908447265},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":76,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_armenian_family.png","scImg":""}'),
	(303, 'Loja de Armas', '{"coords":{"x":-330.239990234375,"y":6083.8798828125,"z":31.45000076293945},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":76,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_armenian_family.png","scImg":""}'),
	(304, 'Loja de Armas', '{"coords":{"x":252.6300048828125,"y":-50.0,"z":69.94000244140625},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":76,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_armenian_family.png","scImg":""}'),
	(305, 'Loja de Armas', '{"coords":{"x":22.55999946594238,"y":-1109.8900146484376,"z":29.79999923706054},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":76,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_armenian_family.png","scImg":""}'),
	(306, 'Loja de Armas', '{"coords":{"x":2567.68994140625,"y":294.3800048828125,"z":108.7300033569336},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":76,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_armenian_family.png","scImg":""}'),
	(307, 'Loja de Armas', '{"coords":{"x":-1117.5799560546876,"y":2698.610107421875,"z":18.54999923706054},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":76,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_armenian_family.png","scImg":""}'),
	(308, 'Loja de Armas', '{"coords":{"x":842.4400024414063,"y":-1033.4200439453126,"z":28.19000053405761},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":76,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_armenian_family.png","scImg":""}'),
	(400, 'Coleta Seletiva', '{"coords":{"x":757.0599975585938,"y":-1399.6800537109376,"z":26.56999969482422},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":47,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_snitch.png","scImg":""}'),
	(401, 'Coleta Seletiva', '{"coords":{"x":84.01000213623047,"y":-220.32000732421876,"z":54.63999938964844},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":47,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_snitch.png","scImg":""}'),
	(402, 'Coleta Seletiva', '{"coords":{"x":31.8799991607666,"y":-1315.5799560546876,"z":29.52000045776367},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":47,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_snitch.png","scImg":""}'),
	(403, 'Coleta Seletiva', '{"coords":{"x":29.07999992370605,"y":-1769.989990234375,"z":29.61000061035156},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":47,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_snitch.png","scImg":""}'),
	(404, 'Coleta Seletiva', '{"coords":{"x":394.0799865722656,"y":-877.47998046875,"z":29.35000038146972},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":47,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_snitch.png","scImg":""}'),
	(405, 'Coleta Seletiva', '{"coords":{"x":-1267.969970703125,"y":-812.0800170898438,"z":17.11000061035156},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":6,"ftimer":50000,"Sprite":47,"sColor":0,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_snitch.png","scImg":""}'),
	(406, 'Centro de Reciclagem', '{"coords":{"x":745.2791137695313,"y":-1401.7318115234376,"z":26.5501708984375},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":467,"sColor":2,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_pickup_swap.png","scImg":"rgb(113, 203, 113)"}'),
	(407, 'Centro de Reciclagem', '{"coords":{"x":59.76263809204101,"y":6474.85693359375,"z":31.4197998046875},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":1,"ftimer":50000,"Sprite":0,"sColor":0,"sRange":false,"colors":0,"SpriteImg":"","scImg":""}'),
	(408, 'Centro de Reciclagem', '{"coords":{"x":59.76263809204101,"y":6474.85693359375,"z":31.4197998046875},"alpha":255,"bflash":false,"items":0,"tickb":false,"hideb":false,"outline":false,"scale":7,"ftimer":50000,"Sprite":467,"sColor":2,"sRange":true,"colors":0,"SpriteImg":"https://docs.fivem.net/blips/radar_pickup_swap.png","scImg":"rgb(113, 203, 113)"}');

-- Copiando estrutura para tabela mri_kingroleplay_v2.mri_qfarm
CREATE TABLE IF NOT EXISTS `mri_qfarm` (
  `farmId` bigint(20) NOT NULL AUTO_INCREMENT,
  `farmName` varchar(100) NOT NULL,
  `farmConfig` longtext DEFAULT NULL,
  `farmGroup` longtext DEFAULT NULL,
  PRIMARY KEY (`farmId`),
  UNIQUE KEY `farmName` (`farmName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mri_qfarm: ~0 rows (aproximadamente)
DELETE FROM `mri_qfarm`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mri_qjobsystem
CREATE TABLE IF NOT EXISTS `mri_qjobsystem` (
  `jobs` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mri_qjobsystem: ~1 rows (aproximadamente)
DELETE FROM `mri_qjobsystem`;
INSERT INTO `mri_qjobsystem` (`jobs`) VALUES
	('[{"stashes":[{"job":true,"id":"police0_9123","weight":500000,"label":"Baú da Polícia","slots":50,"coords":{"z":30.63170433044433,"y":-972.8811645507813,"x":452.0380554199219}}],"balance":2001,"label":"Polícia","alarm":{"z":29.49523544311523,"y":-1036.444091796875,"x":148.6542510986328},"bossmenu":{"z":30.43862152099609,"y":-974.0276489257813,"x":447.3981018066406},"job":"police","duty":{"z":30.10904884338379,"y":-976.2214965820313,"x":452.6276550292969},"type":"job","craftings":[],"grades":{"2":{"payment":500,"name":"Tenente"},"1":{"payment":200,"name":"Soldado"},"0":{"payment":500,"name":"Recruta"},"3":{"payment":555,"isboss":true,"bankAuth":true,"name":"Chefe"}},"jobtype":"leo","coords":{"z":30.68960189819336,"y":-979.2796020507813,"x":447.1144104003906}},{"stashes":[],"label":"Hospital","typejob":"","job":"ambulance","type":"job","grades":{"2":{"name":"Diretor","isboss":true,"payment":300,"bankAuth":true},"1":{"payment":200,"name":"Médico"},"0":{"payment":100,"name":"Paramédico"}},"craftings":[],"jobtype":"ems","coords":{"z":29.46170234680175,"y":-967.9647827148438,"x":413.5118713378906}},{"stashes":[],"label":"Los Customs","typejob":"","job":"mechanic","type":"job","grades":{"2":{"name":"Gerente","isboss":true,"payment":300,"bankAuth":true},"1":{"payment":200,"name":"Mecânico"},"0":{"payment":100,"name":"Aprendiz de Mecãnico"}},"craftings":[],"jobtype":"mechanic","coords":{"z":29.46170234680175,"y":-967.9647827148438,"x":413.5118713378906}},{"stashes":[],"label":"Ballas","typejob":"","job":"ballas","type":"gang","grades":{"2":{"name":"Líder","isboss":true,"bankAuth":true},"1":{"name":"Membro"},"0":{"name":"Recruta"}},"craftings":[],"jobtype":"mechanic","coords":{"z":29.46170234680175,"y":-967.9647827148438,"x":413.5118713378906}},{"stashes":[],"label":"Vaggos","typejob":"","job":"vaggos","type":"gang","grades":{"2":{"name":"Líder","isboss":true,"bankAuth":true},"1":{"name":"Membro"},"0":{"name":"Recruta"}},"craftings":[],"jobtype":"mechanic","coords":{"z":29.46170234680175,"y":-967.9647827148438,"x":413.5118713378906}},{"stashes":[],"label":"Imobiliária","typejob":"","job":"realestate","type":"job","craftings":[],"grades":{"2":{"payment":300,"isboss":true,"bankAuth":true,"name":"Dono"},"1":{"payment":200,"name":"Gerente"},"0":{"payment":100,"isboss":true,"bankAuth":true,"name":"Corretor de Imóveis"}},"jobtype":"realestate","coords":{"z":29.46170234680175,"y":-967.9647827148438,"x":413.5118713378906}}]');

-- Copiando estrutura para tabela mri_kingroleplay_v2.mri_qplaylists
CREATE TABLE IF NOT EXISTS `mri_qplaylists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `owner` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mri_qplaylists: ~0 rows (aproximadamente)
DELETE FROM `mri_qplaylists`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mri_qplaylists_users
CREATE TABLE IF NOT EXISTS `mri_qplaylists_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(255) NOT NULL DEFAULT '',
  `playlist` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `FK__mri_qplaylists_users` (`playlist`),
  CONSTRAINT `FK__mri_qplaylists_users` FOREIGN KEY (`playlist`) REFERENCES `mri_qplaylists` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mri_qplaylists_users: ~0 rows (aproximadamente)
DELETE FROM `mri_qplaylists_users`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mri_qplaylist_songs
CREATE TABLE IF NOT EXISTS `mri_qplaylist_songs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playlist` int(11) NOT NULL DEFAULT 0,
  `song` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `FK__mri_qplaylists` (`playlist`),
  KEY `FK__mri_qsongs` (`song`),
  CONSTRAINT `FK__mri_qplaylists` FOREIGN KEY (`playlist`) REFERENCES `mri_qplaylists` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK__mri_qsongs` FOREIGN KEY (`song`) REFERENCES `mri_qsongs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mri_qplaylist_songs: ~0 rows (aproximadamente)
DELETE FROM `mri_qplaylist_songs`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mri_qsongs
CREATE TABLE IF NOT EXISTS `mri_qsongs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(50) NOT NULL DEFAULT '0',
  `name` varchar(150) NOT NULL DEFAULT '0',
  `author` varchar(50) NOT NULL DEFAULT '0',
  `maxDuration` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mri_qsongs: ~0 rows (aproximadamente)
DELETE FROM `mri_qsongs`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mri_qwhitelist
CREATE TABLE IF NOT EXISTS `mri_qwhitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizen` (`citizen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mri_qwhitelist: ~0 rows (aproximadamente)
DELETE FROM `mri_qwhitelist`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.mri_qwhitelistcfg
CREATE TABLE IF NOT EXISTS `mri_qwhitelistcfg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `config` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.mri_qwhitelistcfg: ~0 rows (aproximadamente)
DELETE FROM `mri_qwhitelistcfg`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_calls
CREATE TABLE IF NOT EXISTS `npwd_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transmitter` varchar(255) NOT NULL,
  `receiver` varchar(255) NOT NULL,
  `is_accepted` tinyint(4) DEFAULT 0,
  `isAnonymous` tinyint(4) NOT NULL DEFAULT 0,
  `start` varchar(255) DEFAULT NULL,
  `end` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_calls: ~0 rows (aproximadamente)
DELETE FROM `npwd_calls`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_darkchat_channels
CREATE TABLE IF NOT EXISTS `npwd_darkchat_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_identifier` varchar(191) NOT NULL,
  `label` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `darkchat_channels_channel_identifier_uindex` (`channel_identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_darkchat_channels: ~0 rows (aproximadamente)
DELETE FROM `npwd_darkchat_channels`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_darkchat_channel_members
CREATE TABLE IF NOT EXISTS `npwd_darkchat_channel_members` (
  `channel_id` int(11) NOT NULL,
  `user_identifier` varchar(255) NOT NULL,
  `is_owner` tinyint(4) NOT NULL DEFAULT 0,
  KEY `npwd_darkchat_channel_members_npwd_darkchat_channels_id_fk` (`channel_id`) USING BTREE,
  CONSTRAINT `npwd_darkchat_channel_members_npwd_darkchat_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `npwd_darkchat_channels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_darkchat_channel_members: ~0 rows (aproximadamente)
DELETE FROM `npwd_darkchat_channel_members`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_darkchat_messages
CREATE TABLE IF NOT EXISTS `npwd_darkchat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `user_identifier` varchar(255) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_image` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `darkchat_messages_darkchat_channels_id_fk` (`channel_id`) USING BTREE,
  CONSTRAINT `darkchat_messages_darkchat_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `npwd_darkchat_channels` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_darkchat_messages: ~0 rows (aproximadamente)
DELETE FROM `npwd_darkchat_messages`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_marketplace_listings
CREATE TABLE IF NOT EXISTS `npwd_marketplace_listings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `reported` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_marketplace_listings: ~0 rows (aproximadamente)
DELETE FROM `npwd_marketplace_listings`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_match_profiles
CREATE TABLE IF NOT EXISTS `npwd_match_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(90) NOT NULL,
  `image` varchar(255) NOT NULL,
  `bio` varchar(512) DEFAULT NULL,
  `location` varchar(45) DEFAULT NULL,
  `job` varchar(45) DEFAULT NULL,
  `tags` varchar(255) NOT NULL DEFAULT '',
  `voiceMessage` varchar(512) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_UNIQUE` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_match_profiles: ~0 rows (aproximadamente)
DELETE FROM `npwd_match_profiles`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_match_views
CREATE TABLE IF NOT EXISTS `npwd_match_views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `profile` int(11) NOT NULL,
  `liked` tinyint(4) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `match_profile_idx` (`profile`),
  KEY `identifier` (`identifier`),
  CONSTRAINT `match_profile` FOREIGN KEY (`profile`) REFERENCES `npwd_match_profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_match_views: ~0 rows (aproximadamente)
DELETE FROM `npwd_match_views`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_messages
CREATE TABLE IF NOT EXISTS `npwd_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `conversation_id` varchar(512) NOT NULL,
  `isRead` tinyint(4) NOT NULL DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `visible` tinyint(4) NOT NULL DEFAULT 1,
  `author` varchar(255) NOT NULL,
  `is_embed` tinyint(4) NOT NULL DEFAULT 0,
  `embed` varchar(512) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_identifier` (`user_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_messages: ~0 rows (aproximadamente)
DELETE FROM `npwd_messages`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_messages_conversations
CREATE TABLE IF NOT EXISTS `npwd_messages_conversations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_list` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_message_id` int(11) DEFAULT NULL,
  `is_group_chat` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_messages_conversations: ~0 rows (aproximadamente)
DELETE FROM `npwd_messages_conversations`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_messages_participants
CREATE TABLE IF NOT EXISTS `npwd_messages_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` int(11) NOT NULL,
  `participant` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `unread_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `message_participants_npwd_messages_conversations_id_fk` (`conversation_id`) USING BTREE,
  CONSTRAINT `message_participants_npwd_messages_conversations_id_fk` FOREIGN KEY (`conversation_id`) REFERENCES `npwd_messages_conversations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_messages_participants: ~0 rows (aproximadamente)
DELETE FROM `npwd_messages_participants`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_notes
CREATE TABLE IF NOT EXISTS `npwd_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_notes: ~0 rows (aproximadamente)
DELETE FROM `npwd_notes`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_phone_contacts
CREATE TABLE IF NOT EXISTS `npwd_phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `number` varchar(20) DEFAULT NULL,
  `display` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_phone_contacts: ~0 rows (aproximadamente)
DELETE FROM `npwd_phone_contacts`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_phone_gallery
CREATE TABLE IF NOT EXISTS `npwd_phone_gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_phone_gallery: ~0 rows (aproximadamente)
DELETE FROM `npwd_phone_gallery`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_twitter_likes
CREATE TABLE IF NOT EXISTS `npwd_twitter_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_combination` (`profile_id`,`tweet_id`),
  KEY `profile_idx` (`profile_id`),
  KEY `tweet_idx` (`tweet_id`),
  CONSTRAINT `profile` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`),
  CONSTRAINT `tweet` FOREIGN KEY (`tweet_id`) REFERENCES `npwd_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_twitter_likes: ~0 rows (aproximadamente)
DELETE FROM `npwd_twitter_likes`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_twitter_profiles
CREATE TABLE IF NOT EXISTS `npwd_twitter_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_name` varchar(90) NOT NULL,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `avatar_url` varchar(255) DEFAULT 'https://i.fivemanage.com/images/3ClWwmpwkFhL.png',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile_name_UNIQUE` (`profile_name`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_twitter_profiles: ~0 rows (aproximadamente)
DELETE FROM `npwd_twitter_profiles`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_twitter_reports
CREATE TABLE IF NOT EXISTS `npwd_twitter_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_combination` (`profile_id`,`tweet_id`),
  KEY `profile_idx` (`profile_id`),
  KEY `tweet_idx` (`tweet_id`),
  CONSTRAINT `report_profile` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`),
  CONSTRAINT `report_tweet` FOREIGN KEY (`tweet_id`) REFERENCES `npwd_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_twitter_reports: ~0 rows (aproximadamente)
DELETE FROM `npwd_twitter_reports`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.npwd_twitter_tweets
CREATE TABLE IF NOT EXISTS `npwd_twitter_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `visible` tinyint(4) NOT NULL DEFAULT 1,
  `images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `retweet` int(11) DEFAULT NULL,
  `profile_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `npwd_twitter_tweets_npwd_twitter_profiles_id_fk` (`profile_id`) USING BTREE,
  CONSTRAINT `npwd_twitter_tweets_npwd_twitter_profiles_id_fk` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.npwd_twitter_tweets: ~0 rows (aproximadamente)
DELETE FROM `npwd_twitter_tweets`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.occasion_vehicles
CREATE TABLE IF NOT EXISTS `occasion_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `occasionId` (`occasionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.occasion_vehicles: ~0 rows (aproximadamente)
DELETE FROM `occasion_vehicles`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.ox_doorlock
CREATE TABLE IF NOT EXISTS `ox_doorlock` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.ox_doorlock: ~1 rows (aproximadamente)
DELETE FROM `ox_doorlock`;
INSERT INTO `ox_doorlock` (`id`, `name`, `data`) VALUES
	(1, 'vangelico_jewellery', '{"maxDistance":2,"groups":{"police":0},"doors":[{"model":1425919976,"coords":{"x":-631.9553833007813,"y":-236.33326721191407,"z":38.2065315246582},"heading":306},{"model":9467943,"coords":{"x":-630.426513671875,"y":-238.4375457763672,"z":38.2065315246582},"heading":306}],"state":1,"coords":{"x":-631.19091796875,"y":-237.38540649414063,"z":38.2065315246582},"hideUi":true}');

-- Copiando estrutura para tabela mri_kingroleplay_v2.ox_inventory
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.ox_inventory: ~0 rows (aproximadamente)
DELETE FROM `ox_inventory`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.pickle_prisons
CREATE TABLE IF NOT EXISTS `pickle_prisons` (
  `identifier` varchar(46) NOT NULL,
  `prison` varchar(50) DEFAULT 'default',
  `time` int(11) NOT NULL DEFAULT 0,
  `inventory` longtext NOT NULL,
  `sentence_date` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.pickle_prisons: ~0 rows (aproximadamente)
DELETE FROM `pickle_prisons`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.players
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(10) unsigned DEFAULT NULL,
  `citizenid` varchar(50) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `gang` text DEFAULT NULL,
  `position` text NOT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_logged_out` timestamp NULL DEFAULT NULL,
  `skills` longtext DEFAULT NULL,
  PRIMARY KEY (`citizenid`),
  KEY `id` (`id`),
  KEY `last_updated` (`last_updated`),
  KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.players: ~0 rows (aproximadamente)
DELETE FROM `players`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.playerskins
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.playerskins: ~0 rows (aproximadamente)
DELETE FROM `playerskins`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.player_groups
CREATE TABLE IF NOT EXISTS `player_groups` (
  `citizenid` varchar(50) NOT NULL,
  `group` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `grade` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`citizenid`,`type`,`group`),
  CONSTRAINT `fk_citizenid` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.player_groups: ~0 rows (aproximadamente)
DELETE FROM `player_groups`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.player_houses
CREATE TABLE IF NOT EXISTS `player_houses` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `house` varchar(50) NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `keyholders` text DEFAULT NULL,
  `decorations` text DEFAULT NULL,
  `stash` text DEFAULT NULL,
  `outfit` text DEFAULT NULL,
  `logout` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `house` (`house`),
  KEY `citizenid` (`citizenid`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.player_houses: ~0 rows (aproximadamente)
DELETE FROM `player_houses`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.player_mails
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.player_mails: ~0 rows (aproximadamente)
DELETE FROM `player_mails`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.player_outfits
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL DEFAULT '0',
  `model` varchar(50) DEFAULT NULL,
  `props` text DEFAULT NULL,
  `components` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid_outfitname_model` (`citizenid`,`outfitname`,`model`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.player_outfits: ~0 rows (aproximadamente)
DELETE FROM `player_outfits`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.player_outfit_codes
CREATE TABLE IF NOT EXISTS `player_outfit_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `outfitid` int(11) NOT NULL,
  `code` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_player_outfit_codes_player_outfits` (`outfitid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.player_outfit_codes: ~0 rows (aproximadamente)
DELETE FROM `player_outfit_codes`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.player_transactions
CREATE TABLE IF NOT EXISTS `player_transactions` (
  `id` varchar(50) NOT NULL,
  `isFrozen` int(11) DEFAULT 0,
  `transactions` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.player_transactions: ~0 rows (aproximadamente)
DELETE FROM `player_transactions`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.player_vehicles
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `vehicle_name` longtext DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext DEFAULT NULL,
  `plate` varchar(50) NOT NULL,
  `fakeplate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `deformation` longtext DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL DEFAULT 0,
  `drivingdistance` int(50) DEFAULT NULL,
  `status` text DEFAULT NULL,
  `financetime` int(11) NOT NULL DEFAULT 0,
  `balance` int(11) NOT NULL DEFAULT 0,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  `paymentamount` int(11) NOT NULL DEFAULT 0,
  `paymentsleft` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `plate` (`plate`),
  KEY `citizenid` (`citizenid`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.player_vehicles: ~0 rows (aproximadamente)
DELETE FROM `player_vehicles`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.player_warns
CREATE TABLE IF NOT EXISTS `player_warns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `senderIdentifier` varchar(50) DEFAULT NULL,
  `targetIdentifier` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `warnId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.player_warns: ~0 rows (aproximadamente)
DELETE FROM `player_warns`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.police_impound
CREATE TABLE IF NOT EXISTS `police_impound` (
  `citizenid` varchar(50) NOT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `vehicle` longtext DEFAULT NULL,
  `props` longtext DEFAULT NULL,
  `owner` longtext DEFAULT NULL,
  `officer` longtext DEFAULT NULL,
  `date` longtext NOT NULL,
  `fine` bigint(20) DEFAULT 0,
  `paid` tinyint(4) DEFAULT 0,
  `garage` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.police_impound: ~0 rows (aproximadamente)
DELETE FROM `police_impound`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.properties
CREATE TABLE IF NOT EXISTS `properties` (
  `property_id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_citizenid` varchar(50) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `has_access` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT json_array() CHECK (json_valid(`has_access`)),
  `extra_imgs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT json_array() CHECK (json_valid(`extra_imgs`)),
  `furnitures` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT json_array() CHECK (json_valid(`furnitures`)),
  `for_sale` tinyint(1) NOT NULL DEFAULT 1,
  `price` int(11) NOT NULL DEFAULT 0,
  `shell` varchar(50) NOT NULL,
  `apartment` varchar(50) DEFAULT NULL,
  `door_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`door_data`)),
  `garage_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`garage_data`)),
  `zone_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`zone_data`)),
  PRIMARY KEY (`property_id`),
  UNIQUE KEY `UQ_owner_apartment` (`owner_citizenid`,`apartment`),
  CONSTRAINT `FK_owner_citizenid` FOREIGN KEY (`owner_citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.properties: ~0 rows (aproximadamente)
DELETE FROM `properties`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.ps_banking_accounts
CREATE TABLE IF NOT EXISTS `ps_banking_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `balance` bigint(20) NOT NULL,
  `holder` varchar(255) NOT NULL,
  `cardNumber` varchar(255) NOT NULL,
  `users` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`users`)),
  `owner` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`owner`)),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.ps_banking_accounts: ~0 rows (aproximadamente)
DELETE FROM `ps_banking_accounts`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.ps_banking_bills
CREATE TABLE IF NOT EXISTS `ps_banking_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `type` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `date` date NOT NULL,
  `isPaid` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.ps_banking_bills: ~0 rows (aproximadamente)
DELETE FROM `ps_banking_bills`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.ps_banking_transactions
CREATE TABLE IF NOT EXISTS `ps_banking_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `type` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `date` date NOT NULL,
  `isIncome` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.ps_banking_transactions: ~0 rows (aproximadamente)
DELETE FROM `ps_banking_transactions`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.qt-crafting
CREATE TABLE IF NOT EXISTS `qt-crafting` (
  `craft_id` int(11) NOT NULL AUTO_INCREMENT,
  `craft_name` varchar(50) DEFAULT NULL,
  `crafting` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`crafting`)),
  `blipdata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blipdata`)),
  `jobs` longtext DEFAULT NULL,
  PRIMARY KEY (`craft_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.qt-crafting: ~0 rows (aproximadamente)
DELETE FROM `qt-crafting`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.qt-crafting-items
CREATE TABLE IF NOT EXISTS `qt-crafting-items` (
  `craft_id` int(11) DEFAULT NULL,
  `item` varchar(50) DEFAULT NULL,
  `item_label` varchar(50) DEFAULT NULL,
  `recipe` longtext DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `model` longtext DEFAULT NULL,
  `anim` longtext DEFAULT NULL,
  `level` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.qt-crafting-items: ~0 rows (aproximadamente)
DELETE FROM `qt-crafting-items`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.racer_names
CREATE TABLE IF NOT EXISTS `racer_names` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` text NOT NULL,
  `racername` text NOT NULL,
  `lasttouched` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `races` int(11) NOT NULL DEFAULT 0,
  `wins` int(11) NOT NULL DEFAULT 0,
  `tracks` int(11) NOT NULL DEFAULT 0,
  `auth` varchar(50) DEFAULT 'racer',
  `crew` varchar(50) DEFAULT NULL,
  `createdby` varchar(50) DEFAULT NULL,
  `revoked` tinyint(4) DEFAULT 0,
  `ranking` int(11) DEFAULT 0,
  `active` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.racer_names: ~0 rows (aproximadamente)
DELETE FROM `racer_names`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.race_tracks
CREATE TABLE IF NOT EXISTS `race_tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `metadata` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creatorid` varchar(50) DEFAULT NULL,
  `creatorname` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  `access` text DEFAULT NULL,
  `curated` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `raceid` (`raceid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.race_tracks: ~0 rows (aproximadamente)
DELETE FROM `race_tracks`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.racing_crews
CREATE TABLE IF NOT EXISTS `racing_crews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `crew_name` text DEFAULT NULL,
  `members` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `wins` int(11) DEFAULT NULL,
  `races` int(11) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  `founder_name` text DEFAULT NULL,
  `founder_citizenid` text DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `members` CHECK (json_valid(`members`))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.racing_crews: ~0 rows (aproximadamente)
DELETE FROM `racing_crews`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.rnotes
CREATE TABLE IF NOT EXISTS `rnotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `noteid` varchar(50) NOT NULL DEFAULT '0',
  `citizenid` varchar(100) NOT NULL DEFAULT '0',
  `notes` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.rnotes: ~0 rows (aproximadamente)
DELETE FROM `rnotes`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.synced_objects
CREATE TABLE IF NOT EXISTS `synced_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(50) NOT NULL,
  `x` varchar(50) NOT NULL,
  `y` varchar(50) NOT NULL,
  `z` varchar(50) NOT NULL,
  `rx` varchar(50) NOT NULL,
  `ry` varchar(50) NOT NULL,
  `rz` varchar(50) NOT NULL,
  `heading` int(11) NOT NULL,
  `sceneid` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_objects_scene` (`sceneid`) USING BTREE,
  CONSTRAINT `FK_objects_scene` FOREIGN KEY (`sceneid`) REFERENCES `synced_objects_scenes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.synced_objects: ~0 rows (aproximadamente)
DELETE FROM `synced_objects`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.synced_objects_scenes
CREATE TABLE IF NOT EXISTS `synced_objects_scenes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.synced_objects_scenes: ~0 rows (aproximadamente)
DELETE FROM `synced_objects_scenes`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.tcd_starterpack
CREATE TABLE IF NOT EXISTS `tcd_starterpack` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `received` tinyint(1) NOT NULL,
  `date_received` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.tcd_starterpack: ~0 rows (aproximadamente)
DELETE FROM `tcd_starterpack`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.users
CREATE TABLE IF NOT EXISTS `users` (
  `userId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `license2` varchar(50) DEFAULT NULL,
  `fivem` varchar(20) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.users: ~0 rows (aproximadamente)
DELETE FROM `users`;

-- Copiando estrutura para tabela mri_kingroleplay_v2.vehicle_financing
CREATE TABLE IF NOT EXISTS `vehicle_financing` (
  `vehicleId` int(11) NOT NULL,
  `balance` int(11) DEFAULT NULL,
  `paymentamount` int(11) DEFAULT NULL,
  `paymentsleft` tinyint(4) DEFAULT NULL,
  `financetime` int(11) DEFAULT NULL,
  PRIMARY KEY (`vehicleId`),
  CONSTRAINT `vehicleId` FOREIGN KEY (`vehicleId`) REFERENCES `player_vehicles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Copiando dados para a tabela mri_kingroleplay_v2.vehicle_financing: ~0 rows (aproximadamente)
DELETE FROM `vehicle_financing`;

-- Copiando estrutura para trigger mri_kingroleplay_v2.rhd_garage_delete_from_impound
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER rhd_garage_delete_from_impound
AFTER DELETE ON player_vehicles
FOR EACH ROW
BEGIN
    DELETE FROM police_impound
    WHERE plate = OLD.plate;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger mri_kingroleplay_v2.rhd_garage_state_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER rhd_garage_state_update
AFTER UPDATE ON player_vehicles
FOR EACH ROW
BEGIN
    IF NEW.state <> 2 THEN
        DELETE FROM police_impound
        WHERE plate = OLD.plate;
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger mri_kingroleplay_v2.rhd_garage_update_impound_plate
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER rhd_garage_update_impound_plate
AFTER UPDATE ON player_vehicles
FOR EACH ROW
BEGIN
    UPDATE police_impound
    SET plate = NEW.plate
    WHERE plate = OLD.plate;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

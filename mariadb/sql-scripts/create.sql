-- -----------------------------------------------------
-- Schema vmail
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS vmail CHARACTER SET 'utf8';
USE vmail;

-- -----------------------------------------------------
-- Create user
-- -----------------------------------------------------
GRANT SELECT ON vmail.* TO 'vmail'@'%' IDENTIFIED BY 'GL7ah59G';

-- -----------------------------------------------------
-- Table `vmail`.`domains`
-- -----------------------------------------------------
CREATE TABLE `domains` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `domain` varchar(255) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY (`domain`)
);

-- -----------------------------------------------------
-- Table `vmail`.`accounts`
-- -----------------------------------------------------
CREATE TABLE `accounts` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `username` varchar(64) NOT NULL,
    `domain` varchar(255) NOT NULL,
    `password` varchar(255) NOT NULL,
    `quota` int unsigned DEFAULT '0',
    `enabled` boolean DEFAULT '0',
    `sendonly` boolean DEFAULT '0',
    PRIMARY KEY (id),
    UNIQUE KEY (`username`, `domain`),
    FOREIGN KEY (`domain`) REFERENCES `domains` (`domain`)
);

-- -----------------------------------------------------
-- Table `vmail`.`aliases`
-- -----------------------------------------------------
CREATE TABLE `aliases` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `source_username` varchar(64) NOT NULL,
    `source_domain` varchar(255) NOT NULL,
    `destination_username` varchar(64) NOT NULL,
    `destination_domain` varchar(255) NOT NULL,
    `enabled` boolean DEFAULT '0',
    PRIMARY KEY (`id`),
    UNIQUE KEY (`source_username`, `source_domain`, `destination_username`, `destination_domain`),
    FOREIGN KEY (`source_domain`) REFERENCES `domains` (`domain`)
);

-- -----------------------------------------------------
-- Table `vmail`.`tlspolicies`
-- -----------------------------------------------------
CREATE TABLE `tlspolicies` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `domain` varchar(255) NOT NULL,
    `policy` enum('none', 'may', 'encrypt', 'dane', 'dane-only', 'fingerprint', 'verify', 'secure') NOT NULL,
    `params` varchar(255),
    PRIMARY KEY (`id`),
    UNIQUE KEY (`domain`)
);

insert into domains (domain) values ('mylesmcsweeney.dev');
insert into accounts (username, domain, password, quota, enabled, sendonly) values ('test', 'mylesmcsweeney.dev', '{SHA512-CRYPT}$6$fgi/VUM0EbnuWSBy$22E7R14E6dfUFeK82sHZuUmoLLatE9Xyzwl2C6IzMIII1Qkb8jT3f0fELxIgQ1MgG0O3oaBIXG9Lw8ix967IW/', 2048, true, false);
insert into tlspolicies (domain, policy) values ('mylesmcsweeney.dev', 'may');
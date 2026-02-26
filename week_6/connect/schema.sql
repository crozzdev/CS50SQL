CREATE TABLE IF NOT EXISTS `users` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `username` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `schools` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `type` VARCHAR(100) NOT NULL,
    `location` VARCHAR(255) NOT NULL,
    `foundation_year` SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `companies` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `industry` VARCHAR(100) NOT NULL,
    `location` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `students` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED,
    `school_id` INT UNSIGNED,
    `start_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `end_date` DATETIME,
    `degree` VARCHAR(255),
    CHECK (
        `end_date` IS NULL
        OR `end_date` >= `start_date`
    ),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `followings` (
    `user1_id` INT UNSIGNED,
    `user2_id` INT UNSIGNED,
    PRIMARY KEY (`user1_id`, `user2_id`),
    FOREIGN KEY (`user1_id`) REFERENCES `users` (`id`),
    FOREIGN KEY (`user2_id`) REFERENCES `users` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `employees` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED,
    `company_id` INT UNSIGNED,
    `start_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `end_date` DATETIME,
    `title` VARCHAR(255) NOT NULL,
    CHECK (
        `end_date` IS NULL
        OR `end_date` >= `start_date`
    ),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE = InnoDB;
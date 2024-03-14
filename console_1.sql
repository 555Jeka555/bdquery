DROP DATABASE IF EXISTS computer_equipment;
CREATE DATABASE IF NOT EXISTS computer_equipment;
USE computer_equipment;

DROP TABLE IF EXISTS buyer;
CREATE TABLE buyer
(
    buyer_id    BINARY(16)   NOT NULL UNIQUE,
    first_name  VARCHAR(255) NOT NULL,
    second_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255) DEFAULT NULL,
    email       VARCHAR(255) DEFAULT NULL,
    created_at  DATETIME     NOT NULL,
    updated_at  DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  DATETIME     DEFAULT NULL,
    PRIMARY KEY (buyer_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS os;
CREATE TABLE os
(
    os_id              BINARY(16)   NOT NULL UNIQUE,
    name               VARCHAR(255) NOT NULL,
    vendor_name        VARCHAR(255) NOT NULL,
    license            TEXT         NOT NULL,
    date_certification DATETIME     NOT NULL,
    created_at         DATETIME     NOT NULL,
    updated_at         DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at         DATETIME DEFAULT NULL,
    PRIMARY KEY (os_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS assembler;
CREATE TABLE assembler
(
    assembler_id BINARY(16)   NOT NULL UNIQUE,
    first_name   VARCHAR(255) NOT NULL,
    second_name  VARCHAR(255) NOT NULL,
    middle_name  VARCHAR(255) DEFAULT NULL,
    created_at   DATETIME     NOT NULL,
    updated_at   DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at   DATETIME     DEFAULT NULL,
    PRIMARY KEY (assembler_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS configuration;
CREATE TABLE configuration
(
    configuration_id BINARY(16)   NOT NULL UNIQUE,
    name             VARCHAR(255) NOT NULL,
    description      VARCHAR(255) NOT NULL,
    created_at       DATETIME     NOT NULL,
    updated_at       DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at       DATETIME DEFAULT NULL,
    PRIMARY KEY (configuration_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS computer;
CREATE TABLE computer
(
    computer_id      BINARY(16) NOT NULL UNIQUE,
    os_id            BINARY(16) NOT NULL UNIQUE,
    configuration_id BINARY(16) NOT NULL UNIQUE,
    assembler_id     BINARY(16) NOT NULL UNIQUE,
    build_date       DATETIME   NOT NULL,
    created_at       DATETIME   NOT NULL,
    updated_at       DATETIME   NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at       DATETIME DEFAULT NULL,
    FOREIGN KEY (os_id) REFERENCES os (os_id),
    FOREIGN KEY (configuration_id) REFERENCES configuration (configuration_id),
    FOREIGN KEY (assembler_id) REFERENCES assembler (assembler_id),
    PRIMARY KEY (computer_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`
(
    order_id          BINARY(16) NOT NULL UNIQUE,
    buyer_id          BINARY(16) NOT NULL,
    computer_id       BINARY(16) NOT NULL UNIQUE,
    cost              FLOAT      NOT NULL,
    state             INt        NOT NULL,
    date_registration DATETIME   NOT NULL,
    created_at        DATETIME   NOT NULL,
    updated_at        DATETIME   NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at        DATETIME DEFAULT NULL,
    FOREIGN KEY (buyer_id) REFERENCES buyer (buyer_id),
    FOREIGN KEY (computer_id) REFERENCES computer (computer_id),
    PRIMARY KEY (order_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS hardware;
CREATE TABLE hardware
(
    hardware_id          BINARY(16)   NOT NULL UNIQUE,
    name        VARCHAR(255) NOT NULL,
    description TEXT         NOT NULL,
    created_at  DATETIME     NOT NULL,
    updated_at  DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  DATETIME DEFAULT NULL,
    PRIMARY KEY (hardware_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS configuration_has_hardware;
CREATE TABLE configuration_has_hardware
(
    configuration_id BINARY(16) NOT NULL,
    hardware_id      BINARY(16) NOT NULL,
    created_at       DATETIME   NOT NULL,
    deleted_at       DATETIME DEFAULT NULL,
    FOREIGN KEY (configuration_id) REFERENCES configuration (configuration_id),
    FOREIGN KEY (hardware_id) REFERENCES hardware (hardware_id),
    PRIMARY KEY (configuration_id, hardware_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

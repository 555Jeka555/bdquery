DROP DATABASE IF EXISTS pharmaceuticals;
CREATE DATABASE IF NOT EXISTS pharmaceuticals;
USE pharmaceuticals;

DROP TABLE IF EXISTS address;
CREATE TABLE address
(
    address_id BINARY(16)   NOT NULL UNIQUE,
    country    VARCHAR(100) NOT NULL,
    area       VARCHAR(100) DEFAULT NULL,
    city       VARCHAR(100) NOT NULL,
    street     VARCHAR(255) NOT NULL,
    building   VARCHAR(100) NOT NULL,
    created_at DATETIME     NOT NULL,
    updated_at DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (address_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;


DROP TABLE IF EXISTS pharmacy;
CREATE TABLE pharmacy
(
    pharmacy_id BINARY(16)   NOT NULL UNIQUE,
    title       VARCHAR(255) NOT NULL,
    address_id  BINARY(16)   NOT NULL UNIQUE,
    phone       VARCHAR(20)  NOT NULL UNIQUE,
    created_at  DATETIME     NOT NULL,
    updated_at  DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  DATETIME DEFAULT NULL,
    FOREIGN KEY (address_id) REFERENCES address (address_id),
    PRIMARY KEY (pharmacy_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS backup_pharmacy;
CREATE TABLE backup_pharmacy
(
    backup_pharmacy_id BINARY(16)   NOT NULL UNIQUE,
    title              VARCHAR(255) NOT NULL,
    address_id         BINARY(16)   NOT NULL UNIQUE,
    phone              VARCHAR(20)  NOT NULL UNIQUE,
    created_at         DATETIME     NOT NULL,
    updated_at         DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at         DATETIME DEFAULT NULL,
    FOREIGN KEY (address_id) REFERENCES address (address_id),
    PRIMARY KEY (backup_pharmacy_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS vendor;
CREATE TABLE vendor
(
    vendor_id  BINARY(16)   NOT NULL UNIQUE,
    name       VARCHAR(255) NOT NULL,
    phone      VARCHAR(20)  NOT NULL UNIQUE,
    email      VARCHAR(255) DEFAULT NULL,
    created_at DATETIME     NOT NULL,
    updated_at DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (vendor_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS medicine;
CREATE TABLE medicine
(
    medicine_id        BINARY(16)     NOT NULL UNIQUE,
    vendor_id          BINARY(16)     NOT NULL,
    title              VARCHAR(255)   NOT NULL,
    manual             TEXT           NOT NULL,
    cost_of_one        DECIMAL(15, 2) NOT NULL,
    is_by_prescription BIT            NOT NULL,
    amount             INT            NOT NULL,
    created_at         DATETIME       NOT NULL,
    updated_at         DATETIME       NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at         DATETIME DEFAULT NULL,
    FOREIGN KEY (vendor_id) REFERENCES vendor (vendor_id),
    PRIMARY KEY (medicine_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS employee;
CREATE TABLE employee
(
    employee_id BINARY(16)   NOT NULL UNIQUE,
    pharmacy_id BINARY(16)   NOT NULL,
    first_name  VARCHAR(255) NOT NULL,
    second_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255) DEFAULT NULL,
    phone       VARCHAR(20)  NOT NULL UNIQUE,
    created_at  DATETIME     NOT NULL,
    updated_at  DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  DATETIME     DEFAULT NULL,
    FOREIGN KEY (pharmacy_id) REFERENCES pharmacy (pharmacy_id),
    PRIMARY KEY (employee_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS sale;
CREATE TABLE sale
(
    sale_id      BINARY(16) NOT NULL UNIQUE,
    pharmacy_id  BINARY(16) NOT NULL,
    employee_id  BINARY(16) NOT NULL,
    discount     DECIMAL(15, 2) DEFAULT NULL,
    date_of_sale DATETIME   NOT NULL,
    date_return  DATETIME       DEFAULT NULL,
    created_at   DATETIME   NOT NULL,
    updated_at   DATETIME   NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    FOREIGN KEY (pharmacy_id) REFERENCES pharmacy (pharmacy_id),
    PRIMARY KEY (sale_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS catalog;
CREATE TABLE catalog
(
    catalog_id  BINARY(16)   NOT NULL UNIQUE,
    pharmacy_id BINARY(16)   NOT NULL,
    medicine_id BINARY(16)   NOT NULL UNIQUE,
    name        VARCHAR(255) NOT NULL,
    created_at  DATETIME     NOT NULL,
    updated_at  DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  DATETIME DEFAULT NULL,
    FOREIGN KEY (pharmacy_id) REFERENCES pharmacy (pharmacy_id),
    FOREIGN KEY (medicine_id) REFERENCES medicine (medicine_id),
    PRIMARY KEY (catalog_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

DROP TABLE IF EXISTS sale_has_medicine;
CREATE TABLE sale_has_medicine
(
    sale_id     BINARY(16) NOT NULL,
    medicine_id BINARY(16) NOT NULL,
    amount      INT        NOT NULL,
    created_at  DATETIME   NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES sale (sale_id),
    FOREIGN KEY (medicine_id) REFERENCES medicine (medicine_id),
    PRIMARY KEY (sale_id, medicine_id)
)
    DEFAULT CHARACTER SET utf8mb4
    COLLATE `utf8mb4_unicode_ci`
    ENGINE = InnoDB;

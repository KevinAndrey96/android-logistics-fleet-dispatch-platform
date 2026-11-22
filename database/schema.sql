-- =============================================================================
-- Logistics Fleet Dispatch Platform - Relational Database Schema
-- Compatible with MySQL 5.7, 8.0+ and MariaDB
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `Servicios`;
DROP TABLE IF EXISTS `Mensajeros`;
DROP TABLE IF EXISTS `Clientes`;
DROP TABLE IF EXISTS `Administradores`;
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------------------------
-- 1. Administradores (Backoffice Dispatch Operators & Supervisors)
-- -----------------------------------------------------------------------------
CREATE TABLE `Administradores` (
    `IdAdministrador` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Documento` VARCHAR(50) NOT NULL UNIQUE,
    `Nombres` VARCHAR(100) NOT NULL,
    `Apellidos` VARCHAR(100) NOT NULL,
    `Telefono` VARCHAR(50) DEFAULT NULL,
    `Direccion` VARCHAR(255) DEFAULT NULL,
    `Email` VARCHAR(150) NOT NULL UNIQUE,
    `Contrasena` VARCHAR(255) NOT NULL,
    `Foto` VARCHAR(255) DEFAULT 'default.png',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 2. Clientes (Business & Retail Shippers / Senders)
-- -----------------------------------------------------------------------------
CREATE TABLE `Clientes` (
    `IdCliente` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Documento` VARCHAR(50) DEFAULT NULL,
    `Nombres` VARCHAR(100) NOT NULL,
    `Apellidos` VARCHAR(100) NOT NULL,
    `Email` VARCHAR(150) NOT NULL UNIQUE,
    `Ciudad` VARCHAR(100) NOT NULL DEFAULT 'Bogotá',
    `Telefono` VARCHAR(50) NOT NULL,
    `Direccion` VARCHAR(255) NOT NULL,
    `Contrasena` VARCHAR(255) NOT NULL,
    `Foto` VARCHAR(255) DEFAULT 'default.png',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 3. Mensajeros (Couriers, Drivers & Fleet Operators)
-- -----------------------------------------------------------------------------
CREATE TABLE `Mensajeros` (
    `IdMensajero` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Documento` VARCHAR(50) NOT NULL UNIQUE,
    `Nombres` VARCHAR(100) NOT NULL,
    `Apellidos` VARCHAR(100) NOT NULL,
    `Contrasena` VARCHAR(255) NOT NULL,
    `Telefono` VARCHAR(50) NOT NULL,
    `Direccion` VARCHAR(255) NOT NULL,
    `Email` VARCHAR(150) NOT NULL,
    `Credito` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    `Ubicacion` VARCHAR(255) NOT NULL DEFAULT '4.6097,-74.0817',
    `Foto` VARCHAR(255) DEFAULT 'default.png',
    `Estado` VARCHAR(50) NOT NULL DEFAULT 'Disponible',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 4. Servicios (Delivery Shipments, Freight Requests & Dispatch Lifecycle)
-- -----------------------------------------------------------------------------
CREATE TABLE `Servicios` (
    `IdServicio` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `Cliente` VARCHAR(150) NOT NULL,
    `Tipo` VARCHAR(50) NOT NULL DEFAULT 'Normal',
    `Km` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    `CoordenadasOrigen` VARCHAR(100) DEFAULT NULL,
    `CoordenadasDestino` VARCHAR(100) DEFAULT NULL,
    `DireccionOrigen` VARCHAR(255) NOT NULL,
    `DireccionDestino` VARCHAR(255) NOT NULL,
    `Descripcion` TEXT DEFAULT NULL,
    `Valor` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    `Mensajero` VARCHAR(100) NOT NULL DEFAULT '0',
    `Estado` VARCHAR(50) NOT NULL DEFAULT 'Espera',
    `FotoEntrega` VARCHAR(255) DEFAULT NULL,
    `Firma` VARCHAR(255) DEFAULT NULL,
    `FechaSolicitud` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `FechaEntrega` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_servicios_estado` (`Estado`),
    INDEX `idx_servicios_cliente` (`Cliente`),
    INDEX `idx_servicios_mensajero` (`Mensajero`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

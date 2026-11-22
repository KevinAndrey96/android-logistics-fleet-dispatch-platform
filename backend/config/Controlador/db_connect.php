<?php
// =============================================================================
// Logistics Fleet Dispatch Platform - Legacy DB_CONNECT class wrapper
// =============================================================================

require_once __DIR__ . '/../../controlador/conexion.php';
require_once __DIR__ . '/db_config.php';

class DB_CONNECT {
    function __construct() {
        $this->connect();
    }

    function __destruct() {
        $this->close();
    }

    function connect() {
        return GlobalDbConnection::getPdo();
    }

    function close() {
        return true;
    }
}
?>
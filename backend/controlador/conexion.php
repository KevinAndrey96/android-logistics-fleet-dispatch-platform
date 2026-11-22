<?php
// =============================================================================
// Logistics Fleet Dispatch Platform - Database Connection & Compatibility Layer
// Provides transparent backwards compatibility with legacy mysql_* functions
// powered by PDO under PHP 7.x, 8.x+
// =============================================================================

if (!defined('MYSQL_ASSOC')) define('MYSQL_ASSOC', 1);
if (!defined('MYSQL_NUM'))   define('MYSQL_NUM', 2);
if (!defined('MYSQL_BOTH'))  define('MYSQL_BOTH', 3);

class GlobalDbConnection {
    private static $pdo = null;
    private static $lastError = '';

    public static function getPdo() {
        if (self::$pdo === null) {
            $host = getenv('DB_HOST') ? getenv('DB_HOST') : '127.0.0.1';
            $port = getenv('DB_PORT') ? getenv('DB_PORT') : '3306';
            $dbName = getenv('DB_DATABASE') ? getenv('DB_DATABASE') : 'logistics_db';
            $user = getenv('DB_USERNAME') ? getenv('DB_USERNAME') : 'logistics_user';
            $pass = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : '';

            $dsn = "mysql:host={$host};port={$port};dbname={$dbName};charset=utf8mb4";
            $options = array(
                PDO::ATTR_ERRMODE => PDO::ERRMODE_SILENT,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
            );

            try {
                self::$pdo = new PDO($dsn, $user, $pass, $options);
            } catch (PDOException $e) {
                self::$lastError = $e->getMessage();
            }
        }
        return self::$pdo;
    }

    public static function setLastError($error) {
        self::$lastError = $error;
    }

    public static function getLastError() {
        return self::$lastError;
    }
}

if (!class_exists('LegacyQueryResult')) {
    class LegacyQueryResult {
        private $rows = array();
        private $pointer = 0;

        public function __construct($rows) {
            $this->rows = is_array($rows) ? $rows : array();
        }

        public function fetch($result_type = MYSQL_BOTH) {
            if (!isset($this->rows[$this->pointer])) {
                return false;
            }
            $row = $this->rows[$this->pointer++];
            if ($result_type === MYSQL_ASSOC) {
                return $row;
            }
            if ($result_type === MYSQL_NUM) {
                return array_values($row);
            }
            $both = $row;
            $i = 0;
            foreach ($row as $val) {
                $both[$i++] = $val;
            }
            return $both;
        }

        public function count() {
            return count($this->rows);
        }
    }
}

// Polyfill legacy mysql_* functions
if (!function_exists('mysql_connect')) {
    function mysql_connect($server = 'localhost', $username = '', $password = '', $new_link = false, $client_flags = 0) {
        return GlobalDbConnection::getPdo();
    }
}

if (!function_exists('mysql_select_db')) {
    function mysql_select_db($database_name, $link_identifier = null) {
        return true;
    }
}

if (!function_exists('mysql_query')) {
    function mysql_query($query, $link_identifier = null) {
        $pdo = GlobalDbConnection::getPdo();
        if (!$pdo) {
            GlobalDbConnection::setLastError("No active database connection");
            return false;
        }
        try {
            $stmt = $pdo->query($query);
            if ($stmt === false) {
                $errorInfo = $pdo->errorInfo();
                GlobalDbConnection::setLastError(isset($errorInfo[2]) ? $errorInfo[2] : 'Query failed');
                return false;
            }
            if ($stmt->columnCount() > 0) {
                return new LegacyQueryResult($stmt->fetchAll(PDO::FETCH_ASSOC));
            }
            return true;
        } catch (Exception $e) {
            GlobalDbConnection::setLastError($e->getMessage());
            return false;
        }
    }
}

if (!function_exists('mysql_fetch_array')) {
    function mysql_fetch_array($result, $result_type = MYSQL_BOTH) {
        if ($result instanceof LegacyQueryResult) {
            return $result->fetch($result_type);
        }
        return false;
    }
}

if (!function_exists('mysql_fetch_assoc')) {
    function mysql_fetch_assoc($result) {
        return mysql_fetch_array($result, MYSQL_ASSOC);
    }
}

if (!function_exists('mysql_num_rows')) {
    function mysql_num_rows($result) {
        if ($result instanceof LegacyQueryResult) {
            return $result->count();
        }
        return 0;
    }
}

if (!function_exists('mysql_real_escape_string')) {
    function mysql_real_escape_string($unescaped_string, $link_identifier = null) {
        $pdo = GlobalDbConnection::getPdo();
        if ($pdo) {
            $quoted = $pdo->quote((string)$unescaped_string);
            return substr($quoted, 1, -1);
        }
        return addslashes((string)$unescaped_string);
    }
}

if (!function_exists('mysql_error')) {
    function mysql_error($link_identifier = null) {
        return GlobalDbConnection::getLastError();
    }
}

if (!function_exists('mysql_close')) {
    function mysql_close($link_identifier = null) {
        return true;
    }
}

class Basededatos {
    private static $conexion = null;

    public function __construct() {
    }

    public static function conectarbd() {
        return GlobalDbConnection::getPdo();
    }

    public static function desconectarbd() {
        self::$conexion = null;
    }
}

$con = GlobalDbConnection::getPdo();

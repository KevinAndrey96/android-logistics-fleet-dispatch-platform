<?php 
// =============================================================================
// Logistics Fleet Dispatch Platform - PDO Mobile API Database Connection
// =============================================================================

require_once __DIR__ . '/../../controlador/conexion.php';

$dbname = getenv('DB_DATABASE') ? getenv('DB_DATABASE') : 'logistics_db';
$host = getenv('DB_HOST') ? getenv('DB_HOST') : '127.0.0.1';
$port = getenv('DB_PORT') ? getenv('DB_PORT') : '3306';
$username = getenv('DB_USERNAME') ? getenv('DB_USERNAME') : 'logistics_user';
$password = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : '';

$options = array(
    PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8mb4',
    PDO::ATTR_ERRMODE => PDO::ERRMODE_SILENT,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
); 
 
try { 
    $db = new PDO("mysql:host={$host};port={$port};dbname={$dbname};charset=utf8mb4", $username, $password, $options); 
} catch(PDOException $ex) { 
    $db = GlobalDbConnection::getPdo();
} 

if ($db) {
    $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC); 
}

header('Content-Type: text/html; charset=utf-8'); 
if (session_status() === PHP_SESSION_NONE && !headers_sent()) {
    session_start(); 
}
?>
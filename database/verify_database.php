<?php
// =============================================================================
// Logistics Fleet Dispatch Platform - Automated Database Verification Script
// =============================================================================

echo "--> Testing Database Connection & Schema Integrity...\n";

require_once __DIR__ . '/../backend/controlador/conexion.php';

$pdo = GlobalDbConnection::getPdo();
if (!$pdo) {
    echo "ERROR: Failed to establish PDO connection.\n";
    exit(1);
}

// 1. Verify Tables Exist
$tables = ['Administradores', 'Clientes', 'Mensajeros', 'Servicios'];
foreach ($tables as $table) {
    $stmt = $pdo->query("SELECT COUNT(*) AS total FROM `{$table}`");
    if ($stmt === false) {
        echo "ERROR: Table `{$table}` does not exist or failed query.\n";
        exit(1);
    }
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "  [OK] Table `{$table}` verified with {$row['total']} records.\n";
}

// 2. Test Polyfill Legacy Queries
echo "--> Testing Legacy mysql_* Compatibility Layer...\n";

$res = mysql_query("SELECT Documento, Nombres, Apellidos, Estado FROM Mensajeros WHERE Estado='Disponible'");
if (!$res) {
    echo "ERROR: Legacy mysql_query failed: " . mysql_error() . "\n";
    exit(1);
}

$count = mysql_num_rows($res);
echo "  [OK] mysql_num_rows returned {$count} available couriers.\n";

while ($courier = mysql_fetch_assoc($res)) {
    echo "  [OK] Courier: {$courier['Nombres']} {$courier['Apellidos']} (Doc: {$courier['Documento']}) - Status: {$courier['Estado']}\n";
}

// 3. Test Service Dispatch Retrieval
$resServices = mysql_query("SELECT IdServicio, Cliente, Tipo, Valor, Estado FROM Servicios");
$serviceCount = mysql_num_rows($resServices);
echo "  [OK] Retrieved {$serviceCount} active/completed dispatch services.\n";

echo "--> All Database & Polyfill Integrity Checks Passed Successfully!\n";
exit(0);

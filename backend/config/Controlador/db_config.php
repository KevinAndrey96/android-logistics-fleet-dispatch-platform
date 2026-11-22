<?php
// =============================================================================
// Logistics Fleet Dispatch Platform - Database Constants
// =============================================================================

if (!defined('DB_USER'))     define('DB_USER', getenv('DB_USERNAME') ? getenv('DB_USERNAME') : 'logistics_user');
if (!defined('DB_PASSWORD')) define('DB_PASSWORD', getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : '');
if (!defined('DB_DATABASE')) define('DB_DATABASE', getenv('DB_DATABASE') ? getenv('DB_DATABASE') : 'logistics_db'); 
if (!defined('DB_SERVER'))   define('DB_SERVER', getenv('DB_HOST') ? getenv('DB_HOST') : '127.0.0.1'); 
if (!defined('DB_PORT'))     define('DB_PORT', getenv('DB_PORT') ? getenv('DB_PORT') : '3306');
?>
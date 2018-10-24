<?php
class Basededatos
{
    private static $basedatos = 'logistics_db';
    private static $servidor = 'localhost';
    private static $usuario = 'logistics_user';
    private static $clave = 'REDACTED_DB_PASS';
     
    private static $conexion  = null;
     
    public function __construct() {
        die('No se pudo inicializar la función constructora');
    }
     
    public static function conectarbd()
    {
       // Conexion para toda la aplicación
       if ( null == self::$conexion )
       {     
        try
        {
          self::$conexion =  new PDO( "mysql:host=".self::$servidor.";"."dbname=".self::$basedatos, self::$usuario, self::$clave); 
        }
        catch(PDOException $e)
        {
          die($e->getMessage()); 
        }
       }
       return self::$conexion;
    }
     
    public static function desconectarbd()
    {
        self::$conexion = null;
    }
}

$con = mysql_connect('localhost', 'logistics_user', 'REDACTED_DB_PASS') ;
//$con = mysql_connect('localhost', 'root', '') ;
if (!$con)
{
  echo "No se pudo realizar la Conexion con la Base de Datos" . "\n";
  exit ;
}

mysql_select_db('logistics_db');

?>
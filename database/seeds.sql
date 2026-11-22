-- =============================================================================
-- Logistics Fleet Dispatch Platform - Seed Data
-- =============================================================================

-- 1. Default Admin Operator (User: 1018456789 / Pass: AdminLogistics2026!)
-- Legacy system uses sha1 hash for authentication
INSERT INTO `Administradores` (`IdAdministrador`, `Documento`, `Nombres`, `Apellidos`, `Telefono`, `Direccion`, `Email`, `Contrasena`, `Foto`)
VALUES (
    1,
    '1018456789',
    'Admin',
    'Logistics Supervisor',
    '+57 310 555 0101',
    'Calle 100 # 15-20, Bogotá',
    'admin@logistics-platform.com',
    'd83161c967fb441f40aaae50b86866ec885c3db6', -- sha1('AdminLogistics2026!')
    'default.png'
);

-- 2. Sample Commercial Clients
INSERT INTO `Clientes` (`IdCliente`, `Documento`, `Nombres`, `Apellidos`, `Email`, `Ciudad`, `Telefono`, `Direccion`, `Contrasena`, `Foto`)
VALUES
(1, '900123456', 'Distribuidora Médica', 'Nacional', 'pedidos@dismedica.com', 'Bogotá', '+57 300 123 4567', 'Carrera 7 # 72-41', 'd83161c967fb441f40aaae50b86866ec885c3db6', 'default.png'),
(2, '900789123', 'Ferretería Industrial', 'del Norte', 'logistica@ferreindustrial.com', 'Bogotá', '+57 311 987 6543', 'Calle 134 # 45-12', 'd83161c967fb441f40aaae50b86866ec885c3db6', 'default.png'),
(3, '1020304050', 'Carlos Andrés', 'Martínez', 'carlos.martinez@gmail.com', 'Bogotá', '+57 315 222 3344', 'Calle 63 # 10-85', 'd83161c967fb441f40aaae50b86866ec885c3db6', 'default.png');

-- 3. Couriers / Drivers with live coordinates across Bogotá
INSERT INTO `Mensajeros` (`IdMensajero`, `Documento`, `Nombres`, `Apellidos`, `Contrasena`, `Telefono`, `Direccion`, `Email`, `Credito`, `Ubicacion`, `Foto`, `Estado`)
VALUES
(1, '1014123456', 'Jhonatan', 'Gómez Rincón', 'd83161c967fb441f40aaae50b86866ec885c3db6', '+57 318 400 1122', 'Calle 80 # 68-30', 'jhonatan.mensajero@logistics.com', 45000.00, '4.6782,-74.0573', 'default.png', 'Disponible'),
(2, '1022334455', 'Brayan David', 'López Castro', 'd83161c967fb441f40aaae50b86866ec885c3db6', '+57 316 777 8899', 'Carrera 30 # 45-03', 'brayan.mensajero@logistics.com', 28500.00, '4.6369,-74.0841', 'default.png', 'En Servicio'),
(3, '1033445566', 'Alexander', 'Pérez Moreno', 'd83161c967fb441f40aaae50b86866ec885c3db6', '+57 320 888 9900', 'Calle 26 # 69-76', 'alexander.mensajero@logistics.com', 12000.00, '4.6584,-74.1089', 'default.png', 'Disponible');

-- 4. Sample Delivery Shipments / Dispatch Requests
INSERT INTO `Servicios` (`IdServicio`, `Cliente`, `Tipo`, `Km`, `CoordenadasOrigen`, `CoordenadasDestino`, `DireccionOrigen`, `DireccionDestino`, `Descripcion`, `Valor`, `Mensajero`, `Estado`, `FechaSolicitud`, `FechaEntrega`)
VALUES
(
    1,
    'pedidos@dismedica.com',
    'Especial',
    8.40,
    '4.6582,-74.0621',
    '4.7112,-74.0321',
    'Carrera 7 # 72-41, Chapinero',
    'Autopista Norte # 127-10, Clínica Reina Sofía',
    'Entrega urgente de insumos quirúrgicos y pruebas de laboratorio en cadena de frío',
    35000.00,
    '1022334455',
    'Asignado',
    DATE_SUB(NOW(), INTERVAL 2 HOUR),
    NULL
),
(
    2,
    'logistica@ferreindustrial.com',
    'Normal',
    12.60,
    '4.7215,-74.0489',
    '4.6120,-74.1205',
    'Calle 134 # 45-12, Suba',
    'Carrera 68D # 13-40, Zona Industrial Montevideo',
    'Envío de catálogo técnico y repuestos hidráulicos para válvulas de presión',
    22000.00,
    '0',
    'Espera',
    DATE_SUB(NOW(), INTERVAL 45 MINUTE),
    NULL
),
(
    3,
    'carlos.martinez@gmail.com',
    'Normal',
    4.20,
    '4.6510,-74.0650',
    '4.6320,-74.0780',
    'Calle 63 # 10-85, Lourdes',
    'Carrera 15 # 39-20, Teusaquillo',
    'Documentos notariales autenticados para entrega en oficina de radicación',
    14000.00,
    '1014123456',
    'Entregado',
    DATE_SUB(NOW(), INTERVAL 1 DAY),
    DATE_SUB(NOW(), INTERVAL 23 HOUR)
);

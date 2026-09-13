/*==============================================================
  SCRIPT DML - DATOS DE PRUEBA
  BASE DE DATOS: db_ParqueoPrivadosGT
  MOTOR: PostgreSQL
==============================================================*/

INSERT INTO Tbl_Sedes
(
    NombreSede, Direccion, Municipio, Departamento, Telefono, HoraApertura, HoraCierre, CapacidadTotal, Estado
)
VALUES
('Sede Zona 10 Guatemala', '6a. Avenida 8-32, Zona 10, Ciudad de Guatemala', 'Guatemala', 'Guatemala', '2422-1001', '06:00:00', '22:00:00', 120, 'Activa'),
('Sede Mixco Centro', '5a. Calle 3-20, Zona 1, Mixco', 'Mixco', 'Guatemala', '2422-1002', '06:00:00', '21:00:00', 80, 'Activa'),
('Sede Escuintla', '4a. Calle 6-20, Zona 1, Escuintla', 'Escuintla', 'Escuintla', '7889-1003', '05:30:00', '20:00:00', 60, 'Activa'),
('Sede Quetzaltenango', '12 Avenida 5-60, Zona 3, Quetzaltenango', 'Quetzaltenango', 'Quetzaltenango', '7765-1004', '06:00:00', '21:00:00', 70, 'Activa'),
('Sede Antigua Guatemala', '3a. Calle Poniente 12, Antigua Guatemala', 'Antigua Guatemala', 'Sacatepéquez', '7832-1005', '07:00:00', '20:00:00', 50, 'Activa');

INSERT INTO Tbl_TiposVehiculos
(
    NombreTipoVehiculo, Descripcion, FactorTarifa, RequiereEspacioAmplio, Estado
)
VALUES
('Automóvil', 'Vehículo sedán o hatchback particular.', 1.0, FALSE, 'Activo'),
('Motocicleta', 'Motocicleta o scooter.', 0.5, FALSE, 'Activo'),
('Pickup', 'Camioneta pickup de uso particular o comercial.', 1.25, TRUE, 'Activo'),
('Camión liviano', 'Camión de carga liviana.', 1.75, TRUE, 'Activo'),
('SUV', 'Vehículo utilitario deportivo.', 1.15, FALSE, 'Activo');

INSERT INTO Tbl_Clientes
(
    TipoCliente, NombreCliente, NIT, DPI, Telefono, CorreoElectronico, Direccion, FechaRegistro, Estado
)
VALUES
('Particular', 'Juan Carlos Pérez López', NULL, '1987654320101', '5512-1001', 'juan.perez@gmail.com', 'Zona 7, Ciudad de Guatemala', '2024-01-15', 'Activo'),
('Particular', 'María José Hernández López', NULL, '2098765430601', '5512-1002', 'maria.hernandez@gmail.com', 'Cuilapa, Santa Rosa', '2024-02-20', 'Activo'),
('Empresarial', 'Transportes del Sur, S.A.', '5487963-1', NULL, '2422-2001', 'contacto@transportesdelsur.com.gt', 'Zona 12, Ciudad de Guatemala', '2023-11-05', 'Activo'),
('Particular', 'Carlos Ramírez García', NULL, '2209876540501', '5512-1004', 'carlos.ramirez@gmail.com', 'Escuintla, Escuintla', '2024-03-10', 'Activo'),
('Empresarial', 'Logística Guatemalteca, S.A.', '6798452-4', NULL, '2477-2002', 'info@logisticagt.com.gt', 'Zona 4, Quetzaltenango', '2023-09-18', 'Activo');

INSERT INTO Tbl_Vehiculos
(
    CodigoCliente, CodigoTipoVehiculo, Placa, Marca, Modelo, Color, AnioFabricacion, Estado
)
VALUES
(1, 1, 'P123ABC', 'Toyota', 'Corolla', 'Blanco', 2021, 'Activo'),
(2, 2, 'M456XYZ', 'Yamaha', 'FZ150', 'Rojo', 2022, 'Activo'),
(3, 4, 'C789LMN', 'Hino', '300', 'Azul', 2019, 'Activo'),
(4, 1, 'P321QRS', 'Mazda', '3', 'Gris', 2020, 'Activo'),
(5, 3, 'PU654TUV', 'Ford', 'Ranger', 'Negro', 2023, 'Activo');

INSERT INTO Tbl_Tarifas
(
    CodigoSede, CodigoTipoVehiculo, NombreTarifa, PrecioHora, PrecioDia, PrecioMensual, FechaVigenciaInicio, Estado
)
VALUES
(1, 1, 'Tarifa Automóvil Zona 10', 15.0, 100.0, 850.0, '2026-01-01', 'Activa'),
(1, 2, 'Tarifa Motocicleta Zona 10', 8.0, 50.0, 400.0, '2026-01-01', 'Activa'),
(2, 1, 'Tarifa Automóvil Mixco', 12.0, 80.0, 700.0, '2026-01-01', 'Activa'),
(3, 3, 'Tarifa Pickup Escuintla', 14.0, 90.0, NULL, '2026-01-01', 'Activa'),
(4, 4, 'Tarifa Camión Quetzaltenango', 18.0, 120.0, NULL, '2026-01-01', 'Activa');

INSERT INTO Tbl_Espacios
(
    CodigoSede, CodigoTipoVehiculo, NumeroEspacio, Nivel, Zona, Estado, Observaciones
)
VALUES
(1, 1, 'A-01', 'Nivel 1', 'Zona A', 'Disponible', NULL),
(1, 2, 'A-02', 'Nivel 1', 'Zona A', 'Disponible', 'Espacio reducido para motocicletas.'),
(2, 1, 'B-01', 'Nivel 1', 'Zona B', 'Disponible', NULL),
(3, 3, 'C-01', 'Nivel 1', 'Zona C', 'Disponible', 'Espacio amplio para pickup.'),
(4, 4, 'D-01', 'Nivel 1', 'Zona D', 'Disponible', 'Espacio amplio para camión liviano.');

INSERT INTO Tbl_Empleados
(
    CodigoSede, Nombres, Apellidos, DPI, Puesto, Telefono, CorreoElectronico, FechaContratacion, NombreUsuario, ClaveAcceso, Estado
)
VALUES
(1, 'Andrea Lucía', 'Morales Pérez', '2567890140101', 'Supervisor de Sede', '5550-1001', 'andrea.morales@parqueoprivadogt.com', '2022-01-10', 'amorales', 'Hash_Empleado_001', 'Activo'),
(1, 'Carlos Roberto', 'Méndez López', '2689451200101', 'Operador de Caseta', '5550-1002', 'carlos.mendez@parqueoprivadogt.com', '2022-03-15', 'cmendez', 'Hash_Empleado_002', 'Activo'),
(2, 'María Fernanda', 'García Hernández', '2798456100601', 'Operador de Caseta', '5550-1003', 'maria.garcia@parqueoprivadogt.com', '2023-02-01', 'mgarcia', 'Hash_Empleado_003', 'Activo'),
(3, 'José Alejandro', 'Ramírez Castillo', '3012456700501', 'Operador de Caseta', '5550-1004', 'jose.ramirez@parqueoprivadogt.com', '2023-06-20', 'jramirez', 'Hash_Empleado_004', 'Activo'),
(4, 'Sofía Isabel', 'Cabrera de León', '3123456700901', 'Supervisor de Sede', '5550-1005', 'sofia.cabrera@parqueoprivadogt.com', '2022-08-05', 'scabrera', 'Hash_Empleado_005', 'Activo');

INSERT INTO Tbl_Turnos
(
    CodigoEmpleado, CodigoSede, FechaTurno, HoraInicio, HoraFin, TipoTurno, Estado
)
VALUES
(1, 1, '2026-09-01', '06:00:00', '14:00:00', 'Matutino', 'Activo'),
(2, 1, '2026-09-01', '14:00:00', '22:00:00', 'Vespertino', 'Activo'),
(3, 2, '2026-09-01', '06:00:00', '13:00:00', 'Matutino', 'Activo'),
(4, 3, '2026-09-01', '22:00:00', '05:30:00', 'Nocturno', 'Activo'),
(5, 4, '2026-09-01', '06:00:00', '14:00:00', 'Matutino', 'Activo');

INSERT INTO Tbl_Reservaciones
(
    CodigoCliente, CodigoVehiculo, CodigoSede, CodigoEspacio, FechaHoraReservacion, FechaHoraInicio, FechaHoraFin, Observaciones, Estado
)
VALUES
(1, 1, 1, 1, '2026-09-05T08:00:00', '2026-09-06T08:00:00', '2026-09-06T18:00:00', NULL, 'Confirmada'),
(2, 2, 1, 2, '2026-09-05T09:00:00', '2026-09-06T09:00:00', '2026-09-06T12:00:00', NULL, 'Confirmada'),
(3, 3, 2, 3, '2026-09-04T10:00:00', '2026-09-07T07:00:00', '2026-09-07T17:00:00', 'Vehículo de carga.', 'Confirmada'),
(4, 4, 3, 4, '2026-09-06T11:00:00', '2026-09-08T08:00:00', '2026-09-08T20:00:00', NULL, 'Confirmada'),
(5, 5, 4, 5, '2026-09-06T12:00:00', '2026-09-09T09:00:00', '2026-09-09T19:00:00', NULL, 'Confirmada');

INSERT INTO Tbl_Entradas
(
    CodigoVehiculo, CodigoEspacio, CodigoEmpleado, CodigoReservacion, FechaHoraEntrada, Observaciones, Estado
)
VALUES
(1, 1, 2, 1, '2026-09-06T08:05:00', NULL, 'Activa'),
(2, 2, 2, 2, '2026-09-06T09:10:00', NULL, 'Activa'),
(3, 3, 3, 3, '2026-09-07T07:05:00', NULL, 'Activa'),
(4, 4, 4, 4, '2026-09-08T08:02:00', NULL, 'Activa'),
(5, 5, 5, 5, '2026-09-09T09:00:00', NULL, 'Activa');

INSERT INTO Tbl_Salidas
(
    CodigoEntrada, CodigoEmpleado, FechaHoraSalida, TiempoTotalMinutos, Observaciones, Estado
)
VALUES
(1, 2, '2026-09-06T18:10:00', 605, NULL, 'Finalizada'),
(2, 2, '2026-09-06T12:05:00', 175, NULL, 'Finalizada'),
(3, 3, '2026-09-07T17:10:00', 605, NULL, 'Finalizada'),
(4, 4, '2026-09-08T20:05:00', 723, NULL, 'Finalizada'),
(5, 5, '2026-09-09T19:00:00', 600, NULL, 'Finalizada');

INSERT INTO Tbl_Pagos
(
    CodigoSalida, CodigoTarifa, CodigoCliente, MontoPago, FormaPago, ReferenciaPago, FechaHoraPago, Estado
)
VALUES
(1, 1, 1, 100.0, 'Tarjeta', 'POS-100001', '2026-09-06T18:12:00', 'Pagado'),
(2, 2, 2, 30.0, 'Efectivo', NULL, '2026-09-06T12:07:00', 'Pagado'),
(3, 4, 3, 90.0, 'Transferencia', 'TRX-20260907-03', '2026-09-07T17:15:00', 'Pagado'),
(4, 4, 4, 90.0, 'Tarjeta', 'POS-100004', '2026-09-08T20:08:00', 'Pagado'),
(5, 5, 5, 120.0, 'Efectivo', NULL, '2026-09-09T19:05:00', 'Pagado');

INSERT INTO Tbl_Incidencias
(
    CodigoSede, CodigoEmpleado, CodigoVehiculo, CodigoEspacio, TipoIncidencia, Descripcion, FechaHoraIncidencia, Estado
)
VALUES
(1, 1, 1, 1, 'Daño menor', 'Rayón leve detectado en la puerta del vehículo al momento del retiro.', '2026-09-06T18:00:00', 'Resuelta'),
(1, 2, NULL, NULL, 'Reclamo de cliente', 'Cliente reportó demora en la atención al momento del ingreso.', '2026-09-06T09:20:00', 'Resuelta'),
(2, 3, 3, 3, 'Rayón en vehículo', 'Se identificó un rayón en el lateral derecho del vehículo de carga.', '2026-09-07T16:00:00', 'En proceso'),
(3, 4, NULL, 4, 'Espacio ocupado indebidamente', 'Un vehículo no autorizado ocupó el espacio reservado para el cliente.', '2026-09-08T07:50:00', 'Resuelta'),
(4, 5, 5, NULL, 'Intento de acceso no autorizado', 'Se detectó un intento de ingreso sin reservación ni pago correspondiente.', '2026-09-09T08:45:00', 'Resuelta');

---   CONSULTAS DE VALIDACIÓN

SELECT 'Tbl_Sedes' AS Tabla, COUNT(*) AS Cantidad FROM Tbl_Sedes
UNION ALL SELECT 'Tbl_TiposVehiculos', COUNT(*) FROM Tbl_TiposVehiculos
UNION ALL SELECT 'Tbl_Clientes', COUNT(*) FROM Tbl_Clientes
UNION ALL SELECT 'Tbl_Vehiculos', COUNT(*) FROM Tbl_Vehiculos
UNION ALL SELECT 'Tbl_Tarifas', COUNT(*) FROM Tbl_Tarifas
UNION ALL SELECT 'Tbl_Espacios', COUNT(*) FROM Tbl_Espacios
UNION ALL SELECT 'Tbl_Empleados', COUNT(*) FROM Tbl_Empleados
UNION ALL SELECT 'Tbl_Turnos', COUNT(*) FROM Tbl_Turnos
UNION ALL SELECT 'Tbl_Reservaciones', COUNT(*) FROM Tbl_Reservaciones
UNION ALL SELECT 'Tbl_Entradas', COUNT(*) FROM Tbl_Entradas
UNION ALL SELECT 'Tbl_Salidas', COUNT(*) FROM Tbl_Salidas
UNION ALL SELECT 'Tbl_Pagos', COUNT(*) FROM Tbl_Pagos
UNION ALL SELECT 'Tbl_Incidencias', COUNT(*) FROM Tbl_Incidencias;
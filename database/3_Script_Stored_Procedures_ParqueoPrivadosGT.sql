/*==============================================================
  1. FUNCIONES CRUD DE TBL_SEDES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sedes_Agregar
(
    p_NombreSede VARCHAR(100),
    p_Direccion VARCHAR(200),
    p_Municipio VARCHAR(100),
    p_Departamento VARCHAR(100),
    p_Telefono VARCHAR(20),
    p_HoraApertura TIME,
    p_HoraCierre TIME,
    p_CapacidadTotal INT,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoSede INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Sedes AS t
    (
        NombreSede,
        Direccion,
        Municipio,
        Departamento,
        Telefono,
        HoraApertura,
        HoraCierre,
        CapacidadTotal,
        Estado
    )
    VALUES
    (
        p_NombreSede,
        p_Direccion,
        p_Municipio,
        p_Departamento,
        p_Telefono,
        p_HoraApertura,
        p_HoraCierre,
        p_CapacidadTotal,
        p_Estado
    )
    RETURNING t.CodigoSede INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sedes_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sedes_Editar
(
    p_CodigoSede INT,
    p_NombreSede VARCHAR(100),
    p_Direccion VARCHAR(200),
    p_Municipio VARCHAR(100),
    p_Departamento VARCHAR(100),
    p_Telefono VARCHAR(20),
    p_HoraApertura TIME,
    p_HoraCierre TIME,
    p_CapacidadTotal INT,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Sedes
    SET NombreSede = p_NombreSede,
        Direccion = p_Direccion,
        Municipio = p_Municipio,
        Departamento = p_Departamento,
        Telefono = p_Telefono,
        HoraApertura = p_HoraApertura,
        HoraCierre = p_HoraCierre,
        CapacidadTotal = p_CapacidadTotal,
        Estado = p_Estado
    WHERE CodigoSede = p_CodigoSede;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sedes_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sedes_Eliminar
(
    p_CodigoSede INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Sedes
    WHERE CodigoSede = p_CodigoSede;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sedes_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sedes_Consultar()
RETURNS TABLE
(
    CodigoSede INT,
    NombreSede VARCHAR(100),
    Direccion VARCHAR(200),
    Municipio VARCHAR(100),
    Departamento VARCHAR(100),
    Telefono VARCHAR(20),
    HoraApertura TIME,
    HoraCierre TIME,
    CapacidadTotal INT,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoSede,
        t.NombreSede,
        t.Direccion,
        t.Municipio,
        t.Departamento,
        t.Telefono,
        t.HoraApertura,
        t.HoraCierre,
        t.CapacidadTotal,
        t.Estado
    FROM Tbl_Sedes t
    ORDER BY t.CodigoSede;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sedes_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sedes_Buscar
(
    p_CodigoSede INT
)
RETURNS TABLE
(
    CodigoSede INT,
    NombreSede VARCHAR(100),
    Direccion VARCHAR(200),
    Municipio VARCHAR(100),
    Departamento VARCHAR(100),
    Telefono VARCHAR(20),
    HoraApertura TIME,
    HoraCierre TIME,
    CapacidadTotal INT,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Sedes t
        WHERE t.CodigoSede = p_CodigoSede
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoSede,
        t.NombreSede,
        t.Direccion,
        t.Municipio,
        t.Departamento,
        t.Telefono,
        t.HoraApertura,
        t.HoraCierre,
        t.CapacidadTotal,
        t.Estado
    FROM Tbl_Sedes t
    WHERE t.CodigoSede = p_CodigoSede;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sedes_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  2. FUNCIONES CRUD DE TBL_TIPOSVEHICULOS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_TiposVehiculos_Agregar
(
    p_NombreTipoVehiculo VARCHAR(60),
    p_Descripcion VARCHAR(250),
    p_FactorTarifa DECIMAL(5,2),
    p_RequiereEspacioAmplio BOOLEAN,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoTipoVehiculo INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_TiposVehiculos AS t
    (
        NombreTipoVehiculo,
        Descripcion,
        FactorTarifa,
        RequiereEspacioAmplio,
        Estado
    )
    VALUES
    (
        p_NombreTipoVehiculo,
        p_Descripcion,
        p_FactorTarifa,
        p_RequiereEspacioAmplio,
        p_Estado
    )
    RETURNING t.CodigoTipoVehiculo INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_TiposVehiculos_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_TiposVehiculos_Editar
(
    p_CodigoTipoVehiculo INT,
    p_NombreTipoVehiculo VARCHAR(60),
    p_Descripcion VARCHAR(250),
    p_FactorTarifa DECIMAL(5,2),
    p_RequiereEspacioAmplio BOOLEAN,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_TiposVehiculos
    SET NombreTipoVehiculo = p_NombreTipoVehiculo,
        Descripcion = p_Descripcion,
        FactorTarifa = p_FactorTarifa,
        RequiereEspacioAmplio = p_RequiereEspacioAmplio,
        Estado = p_Estado
    WHERE CodigoTipoVehiculo = p_CodigoTipoVehiculo;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_TiposVehiculos_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_TiposVehiculos_Eliminar
(
    p_CodigoTipoVehiculo INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_TiposVehiculos
    WHERE CodigoTipoVehiculo = p_CodigoTipoVehiculo;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_TiposVehiculos_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_TiposVehiculos_Consultar()
RETURNS TABLE
(
    CodigoTipoVehiculo INT,
    NombreTipoVehiculo VARCHAR(60),
    Descripcion VARCHAR(250),
    FactorTarifa DECIMAL(5,2),
    RequiereEspacioAmplio BOOLEAN,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoTipoVehiculo,
        t.NombreTipoVehiculo,
        t.Descripcion,
        t.FactorTarifa,
        t.RequiereEspacioAmplio,
        t.Estado
    FROM Tbl_TiposVehiculos t
    ORDER BY t.CodigoTipoVehiculo;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_TiposVehiculos_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_TiposVehiculos_Buscar
(
    p_CodigoTipoVehiculo INT
)
RETURNS TABLE
(
    CodigoTipoVehiculo INT,
    NombreTipoVehiculo VARCHAR(60),
    Descripcion VARCHAR(250),
    FactorTarifa DECIMAL(5,2),
    RequiereEspacioAmplio BOOLEAN,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_TiposVehiculos t
        WHERE t.CodigoTipoVehiculo = p_CodigoTipoVehiculo
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoTipoVehiculo,
        t.NombreTipoVehiculo,
        t.Descripcion,
        t.FactorTarifa,
        t.RequiereEspacioAmplio,
        t.Estado
    FROM Tbl_TiposVehiculos t
    WHERE t.CodigoTipoVehiculo = p_CodigoTipoVehiculo;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_TiposVehiculos_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  3. FUNCIONES CRUD DE TBL_CLIENTES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Clientes_Agregar
(
    p_TipoCliente VARCHAR(30),
    p_NombreCliente VARCHAR(150),
    p_NIT VARCHAR(20),
    p_DPI VARCHAR(20),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_Direccion VARCHAR(200),
    p_FechaRegistro DATE,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoCliente INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Clientes AS t
    (
        TipoCliente,
        NombreCliente,
        NIT,
        DPI,
        Telefono,
        CorreoElectronico,
        Direccion,
        FechaRegistro,
        Estado
    )
    VALUES
    (
        p_TipoCliente,
        p_NombreCliente,
        p_NIT,
        p_DPI,
        p_Telefono,
        p_CorreoElectronico,
        p_Direccion,
        p_FechaRegistro,
        p_Estado
    )
    RETURNING t.CodigoCliente INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Clientes_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Clientes_Editar
(
    p_CodigoCliente INT,
    p_TipoCliente VARCHAR(30),
    p_NombreCliente VARCHAR(150),
    p_NIT VARCHAR(20),
    p_DPI VARCHAR(20),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_Direccion VARCHAR(200),
    p_FechaRegistro DATE,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Clientes
    SET TipoCliente = p_TipoCliente,
        NombreCliente = p_NombreCliente,
        NIT = p_NIT,
        DPI = p_DPI,
        Telefono = p_Telefono,
        CorreoElectronico = p_CorreoElectronico,
        Direccion = p_Direccion,
        FechaRegistro = p_FechaRegistro,
        Estado = p_Estado
    WHERE CodigoCliente = p_CodigoCliente;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Clientes_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Clientes_Eliminar
(
    p_CodigoCliente INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Clientes
    WHERE CodigoCliente = p_CodigoCliente;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Clientes_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Clientes_Consultar()
RETURNS TABLE
(
    CodigoCliente INT,
    TipoCliente VARCHAR(30),
    NombreCliente VARCHAR(150),
    NIT VARCHAR(20),
    DPI VARCHAR(20),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    Direccion VARCHAR(200),
    FechaRegistro DATE,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoCliente,
        t.TipoCliente,
        t.NombreCliente,
        t.NIT,
        t.DPI,
        t.Telefono,
        t.CorreoElectronico,
        t.Direccion,
        t.FechaRegistro,
        t.Estado
    FROM Tbl_Clientes t
    ORDER BY t.CodigoCliente;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Clientes_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Clientes_Buscar
(
    p_CodigoCliente INT
)
RETURNS TABLE
(
    CodigoCliente INT,
    TipoCliente VARCHAR(30),
    NombreCliente VARCHAR(150),
    NIT VARCHAR(20),
    DPI VARCHAR(20),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    Direccion VARCHAR(200),
    FechaRegistro DATE,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Clientes t
        WHERE t.CodigoCliente = p_CodigoCliente
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoCliente,
        t.TipoCliente,
        t.NombreCliente,
        t.NIT,
        t.DPI,
        t.Telefono,
        t.CorreoElectronico,
        t.Direccion,
        t.FechaRegistro,
        t.Estado
    FROM Tbl_Clientes t
    WHERE t.CodigoCliente = p_CodigoCliente;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Clientes_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  4. FUNCIONES CRUD DE TBL_VEHICULOS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Vehiculos_Agregar
(
    p_CodigoCliente INT,
    p_CodigoTipoVehiculo INT,
    p_Placa VARCHAR(20),
    p_Marca VARCHAR(60),
    p_Modelo VARCHAR(60),
    p_Color VARCHAR(30),
    p_AnioFabricacion INT,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoVehiculo INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Vehiculos AS t
    (
        CodigoCliente,
        CodigoTipoVehiculo,
        Placa,
        Marca,
        Modelo,
        Color,
        AnioFabricacion,
        Estado
    )
    VALUES
    (
        p_CodigoCliente,
        p_CodigoTipoVehiculo,
        p_Placa,
        p_Marca,
        p_Modelo,
        p_Color,
        p_AnioFabricacion,
        p_Estado
    )
    RETURNING t.CodigoVehiculo INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Vehiculos_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Vehiculos_Editar
(
    p_CodigoVehiculo INT,
    p_CodigoCliente INT,
    p_CodigoTipoVehiculo INT,
    p_Placa VARCHAR(20),
    p_Marca VARCHAR(60),
    p_Modelo VARCHAR(60),
    p_Color VARCHAR(30),
    p_AnioFabricacion INT,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Vehiculos
    SET CodigoCliente = p_CodigoCliente,
        CodigoTipoVehiculo = p_CodigoTipoVehiculo,
        Placa = p_Placa,
        Marca = p_Marca,
        Modelo = p_Modelo,
        Color = p_Color,
        AnioFabricacion = p_AnioFabricacion,
        Estado = p_Estado
    WHERE CodigoVehiculo = p_CodigoVehiculo;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Vehiculos_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Vehiculos_Eliminar
(
    p_CodigoVehiculo INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Vehiculos
    WHERE CodigoVehiculo = p_CodigoVehiculo;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Vehiculos_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Vehiculos_Consultar()
RETURNS TABLE
(
    CodigoVehiculo INT,
    CodigoCliente INT,
    CodigoTipoVehiculo INT,
    Placa VARCHAR(20),
    Marca VARCHAR(60),
    Modelo VARCHAR(60),
    Color VARCHAR(30),
    AnioFabricacion INT,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoVehiculo,
        t.CodigoCliente,
        t.CodigoTipoVehiculo,
        t.Placa,
        t.Marca,
        t.Modelo,
        t.Color,
        t.AnioFabricacion,
        t.Estado
    FROM Tbl_Vehiculos t
    ORDER BY t.CodigoVehiculo;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Vehiculos_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Vehiculos_Buscar
(
    p_CodigoVehiculo INT
)
RETURNS TABLE
(
    CodigoVehiculo INT,
    CodigoCliente INT,
    CodigoTipoVehiculo INT,
    Placa VARCHAR(20),
    Marca VARCHAR(60),
    Modelo VARCHAR(60),
    Color VARCHAR(30),
    AnioFabricacion INT,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Vehiculos t
        WHERE t.CodigoVehiculo = p_CodigoVehiculo
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoVehiculo,
        t.CodigoCliente,
        t.CodigoTipoVehiculo,
        t.Placa,
        t.Marca,
        t.Modelo,
        t.Color,
        t.AnioFabricacion,
        t.Estado
    FROM Tbl_Vehiculos t
    WHERE t.CodigoVehiculo = p_CodigoVehiculo;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Vehiculos_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  5. FUNCIONES CRUD DE TBL_TARIFAS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Tarifas_Agregar
(
    p_CodigoSede INT,
    p_CodigoTipoVehiculo INT,
    p_NombreTarifa VARCHAR(100),
    p_PrecioHora DECIMAL(10,2),
    p_PrecioDia DECIMAL(10,2),
    p_PrecioMensual DECIMAL(10,2),
    p_FechaVigenciaInicio DATE,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoTarifa INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Tarifas AS t
    (
        CodigoSede,
        CodigoTipoVehiculo,
        NombreTarifa,
        PrecioHora,
        PrecioDia,
        PrecioMensual,
        FechaVigenciaInicio,
        Estado
    )
    VALUES
    (
        p_CodigoSede,
        p_CodigoTipoVehiculo,
        p_NombreTarifa,
        p_PrecioHora,
        p_PrecioDia,
        p_PrecioMensual,
        p_FechaVigenciaInicio,
        p_Estado
    )
    RETURNING t.CodigoTarifa INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Tarifas_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Tarifas_Editar
(
    p_CodigoTarifa INT,
    p_CodigoSede INT,
    p_CodigoTipoVehiculo INT,
    p_NombreTarifa VARCHAR(100),
    p_PrecioHora DECIMAL(10,2),
    p_PrecioDia DECIMAL(10,2),
    p_PrecioMensual DECIMAL(10,2),
    p_FechaVigenciaInicio DATE,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Tarifas
    SET CodigoSede = p_CodigoSede,
        CodigoTipoVehiculo = p_CodigoTipoVehiculo,
        NombreTarifa = p_NombreTarifa,
        PrecioHora = p_PrecioHora,
        PrecioDia = p_PrecioDia,
        PrecioMensual = p_PrecioMensual,
        FechaVigenciaInicio = p_FechaVigenciaInicio,
        Estado = p_Estado
    WHERE CodigoTarifa = p_CodigoTarifa;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Tarifas_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Tarifas_Eliminar
(
    p_CodigoTarifa INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Tarifas
    WHERE CodigoTarifa = p_CodigoTarifa;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Tarifas_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Tarifas_Consultar()
RETURNS TABLE
(
    CodigoTarifa INT,
    CodigoSede INT,
    CodigoTipoVehiculo INT,
    NombreTarifa VARCHAR(100),
    PrecioHora DECIMAL(10,2),
    PrecioDia DECIMAL(10,2),
    PrecioMensual DECIMAL(10,2),
    FechaVigenciaInicio DATE,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoTarifa,
        t.CodigoSede,
        t.CodigoTipoVehiculo,
        t.NombreTarifa,
        t.PrecioHora,
        t.PrecioDia,
        t.PrecioMensual,
        t.FechaVigenciaInicio,
        t.Estado
    FROM Tbl_Tarifas t
    ORDER BY t.CodigoTarifa;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Tarifas_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Tarifas_Buscar
(
    p_CodigoTarifa INT
)
RETURNS TABLE
(
    CodigoTarifa INT,
    CodigoSede INT,
    CodigoTipoVehiculo INT,
    NombreTarifa VARCHAR(100),
    PrecioHora DECIMAL(10,2),
    PrecioDia DECIMAL(10,2),
    PrecioMensual DECIMAL(10,2),
    FechaVigenciaInicio DATE,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Tarifas t
        WHERE t.CodigoTarifa = p_CodigoTarifa
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoTarifa,
        t.CodigoSede,
        t.CodigoTipoVehiculo,
        t.NombreTarifa,
        t.PrecioHora,
        t.PrecioDia,
        t.PrecioMensual,
        t.FechaVigenciaInicio,
        t.Estado
    FROM Tbl_Tarifas t
    WHERE t.CodigoTarifa = p_CodigoTarifa;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Tarifas_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  6. FUNCIONES CRUD DE TBL_ESPACIOS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Espacios_Agregar
(
    p_CodigoSede INT,
    p_CodigoTipoVehiculo INT,
    p_NumeroEspacio VARCHAR(20),
    p_Nivel VARCHAR(30),
    p_Zona VARCHAR(50),
    p_Estado VARCHAR(20),
    p_Observaciones VARCHAR(250)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoEspacio INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Espacios AS t
    (
        CodigoSede,
        CodigoTipoVehiculo,
        NumeroEspacio,
        Nivel,
        Zona,
        Estado,
        Observaciones
    )
    VALUES
    (
        p_CodigoSede,
        p_CodigoTipoVehiculo,
        p_NumeroEspacio,
        p_Nivel,
        p_Zona,
        p_Estado,
        p_Observaciones
    )
    RETURNING t.CodigoEspacio INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Espacios_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Espacios_Editar
(
    p_CodigoEspacio INT,
    p_CodigoSede INT,
    p_CodigoTipoVehiculo INT,
    p_NumeroEspacio VARCHAR(20),
    p_Nivel VARCHAR(30),
    p_Zona VARCHAR(50),
    p_Estado VARCHAR(20),
    p_Observaciones VARCHAR(250)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Espacios
    SET CodigoSede = p_CodigoSede,
        CodigoTipoVehiculo = p_CodigoTipoVehiculo,
        NumeroEspacio = p_NumeroEspacio,
        Nivel = p_Nivel,
        Zona = p_Zona,
        Estado = p_Estado,
        Observaciones = p_Observaciones
    WHERE CodigoEspacio = p_CodigoEspacio;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Espacios_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Espacios_Eliminar
(
    p_CodigoEspacio INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Espacios
    WHERE CodigoEspacio = p_CodigoEspacio;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Espacios_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Espacios_Consultar()
RETURNS TABLE
(
    CodigoEspacio INT,
    CodigoSede INT,
    CodigoTipoVehiculo INT,
    NumeroEspacio VARCHAR(20),
    Nivel VARCHAR(30),
    Zona VARCHAR(50),
    Estado VARCHAR(20),
    Observaciones VARCHAR(250)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoEspacio,
        t.CodigoSede,
        t.CodigoTipoVehiculo,
        t.NumeroEspacio,
        t.Nivel,
        t.Zona,
        t.Estado,
        t.Observaciones
    FROM Tbl_Espacios t
    ORDER BY t.CodigoEspacio;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Espacios_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Espacios_Buscar
(
    p_CodigoEspacio INT
)
RETURNS TABLE
(
    CodigoEspacio INT,
    CodigoSede INT,
    CodigoTipoVehiculo INT,
    NumeroEspacio VARCHAR(20),
    Nivel VARCHAR(30),
    Zona VARCHAR(50),
    Estado VARCHAR(20),
    Observaciones VARCHAR(250)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Espacios t
        WHERE t.CodigoEspacio = p_CodigoEspacio
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoEspacio,
        t.CodigoSede,
        t.CodigoTipoVehiculo,
        t.NumeroEspacio,
        t.Nivel,
        t.Zona,
        t.Estado,
        t.Observaciones
    FROM Tbl_Espacios t
    WHERE t.CodigoEspacio = p_CodigoEspacio;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Espacios_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  7. FUNCIONES CRUD DE TBL_EMPLEADOS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Empleados_Agregar
(
    p_CodigoSede INT,
    p_Nombres VARCHAR(100),
    p_Apellidos VARCHAR(100),
    p_DPI VARCHAR(20),
    p_Puesto VARCHAR(60),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_FechaContratacion DATE,
    p_NombreUsuario VARCHAR(80),
    p_ClaveAcceso VARCHAR(255),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoEmpleado INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Empleados AS t
    (
        CodigoSede,
        Nombres,
        Apellidos,
        DPI,
        Puesto,
        Telefono,
        CorreoElectronico,
        FechaContratacion,
        NombreUsuario,
        ClaveAcceso,
        Estado
    )
    VALUES
    (
        p_CodigoSede,
        p_Nombres,
        p_Apellidos,
        p_DPI,
        p_Puesto,
        p_Telefono,
        p_CorreoElectronico,
        p_FechaContratacion,
        p_NombreUsuario,
        p_ClaveAcceso,
        p_Estado
    )
    RETURNING t.CodigoEmpleado INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Empleados_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Empleados_Editar
(
    p_CodigoEmpleado INT,
    p_CodigoSede INT,
    p_Nombres VARCHAR(100),
    p_Apellidos VARCHAR(100),
    p_DPI VARCHAR(20),
    p_Puesto VARCHAR(60),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_FechaContratacion DATE,
    p_NombreUsuario VARCHAR(80),
    p_ClaveAcceso VARCHAR(255),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Empleados
    SET CodigoSede = p_CodigoSede,
        Nombres = p_Nombres,
        Apellidos = p_Apellidos,
        DPI = p_DPI,
        Puesto = p_Puesto,
        Telefono = p_Telefono,
        CorreoElectronico = p_CorreoElectronico,
        FechaContratacion = p_FechaContratacion,
        NombreUsuario = p_NombreUsuario,
        ClaveAcceso = p_ClaveAcceso,
        Estado = p_Estado
    WHERE CodigoEmpleado = p_CodigoEmpleado;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Empleados_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Empleados_Eliminar
(
    p_CodigoEmpleado INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Empleados
    WHERE CodigoEmpleado = p_CodigoEmpleado;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Empleados_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Empleados_Consultar()
RETURNS TABLE
(
    CodigoEmpleado INT,
    CodigoSede INT,
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    DPI VARCHAR(20),
    Puesto VARCHAR(60),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    FechaContratacion DATE,
    NombreUsuario VARCHAR(80),
    ClaveAcceso VARCHAR(255),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoEmpleado,
        t.CodigoSede,
        t.Nombres,
        t.Apellidos,
        t.DPI,
        t.Puesto,
        t.Telefono,
        t.CorreoElectronico,
        t.FechaContratacion,
        t.NombreUsuario,
        t.ClaveAcceso,
        t.Estado
    FROM Tbl_Empleados t
    ORDER BY t.CodigoEmpleado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Empleados_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Empleados_Buscar
(
    p_CodigoEmpleado INT
)
RETURNS TABLE
(
    CodigoEmpleado INT,
    CodigoSede INT,
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    DPI VARCHAR(20),
    Puesto VARCHAR(60),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    FechaContratacion DATE,
    NombreUsuario VARCHAR(80),
    ClaveAcceso VARCHAR(255),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Empleados t
        WHERE t.CodigoEmpleado = p_CodigoEmpleado
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoEmpleado,
        t.CodigoSede,
        t.Nombres,
        t.Apellidos,
        t.DPI,
        t.Puesto,
        t.Telefono,
        t.CorreoElectronico,
        t.FechaContratacion,
        t.NombreUsuario,
        t.ClaveAcceso,
        t.Estado
    FROM Tbl_Empleados t
    WHERE t.CodigoEmpleado = p_CodigoEmpleado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Empleados_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  8. FUNCIONES CRUD DE TBL_TURNOS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Turnos_Agregar
(
    p_CodigoEmpleado INT,
    p_CodigoSede INT,
    p_FechaTurno DATE,
    p_HoraInicio TIME,
    p_HoraFin TIME,
    p_TipoTurno VARCHAR(30),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoTurno INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Turnos AS t
    (
        CodigoEmpleado,
        CodigoSede,
        FechaTurno,
        HoraInicio,
        HoraFin,
        TipoTurno,
        Estado
    )
    VALUES
    (
        p_CodigoEmpleado,
        p_CodigoSede,
        p_FechaTurno,
        p_HoraInicio,
        p_HoraFin,
        p_TipoTurno,
        p_Estado
    )
    RETURNING t.CodigoTurno INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Turnos_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Turnos_Editar
(
    p_CodigoTurno INT,
    p_CodigoEmpleado INT,
    p_CodigoSede INT,
    p_FechaTurno DATE,
    p_HoraInicio TIME,
    p_HoraFin TIME,
    p_TipoTurno VARCHAR(30),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Turnos
    SET CodigoEmpleado = p_CodigoEmpleado,
        CodigoSede = p_CodigoSede,
        FechaTurno = p_FechaTurno,
        HoraInicio = p_HoraInicio,
        HoraFin = p_HoraFin,
        TipoTurno = p_TipoTurno,
        Estado = p_Estado
    WHERE CodigoTurno = p_CodigoTurno;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Turnos_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Turnos_Eliminar
(
    p_CodigoTurno INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Turnos
    WHERE CodigoTurno = p_CodigoTurno;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Turnos_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Turnos_Consultar()
RETURNS TABLE
(
    CodigoTurno INT,
    CodigoEmpleado INT,
    CodigoSede INT,
    FechaTurno DATE,
    HoraInicio TIME,
    HoraFin TIME,
    TipoTurno VARCHAR(30),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoTurno,
        t.CodigoEmpleado,
        t.CodigoSede,
        t.FechaTurno,
        t.HoraInicio,
        t.HoraFin,
        t.TipoTurno,
        t.Estado
    FROM Tbl_Turnos t
    ORDER BY t.CodigoTurno;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Turnos_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Turnos_Buscar
(
    p_CodigoTurno INT
)
RETURNS TABLE
(
    CodigoTurno INT,
    CodigoEmpleado INT,
    CodigoSede INT,
    FechaTurno DATE,
    HoraInicio TIME,
    HoraFin TIME,
    TipoTurno VARCHAR(30),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Turnos t
        WHERE t.CodigoTurno = p_CodigoTurno
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoTurno,
        t.CodigoEmpleado,
        t.CodigoSede,
        t.FechaTurno,
        t.HoraInicio,
        t.HoraFin,
        t.TipoTurno,
        t.Estado
    FROM Tbl_Turnos t
    WHERE t.CodigoTurno = p_CodigoTurno;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Turnos_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  9. FUNCIONES CRUD DE TBL_RESERVACIONES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Reservaciones_Agregar
(
    p_CodigoCliente INT,
    p_CodigoVehiculo INT,
    p_CodigoSede INT,
    p_CodigoEspacio INT,
    p_FechaHoraReservacion TIMESTAMP,
    p_FechaHoraInicio TIMESTAMP,
    p_FechaHoraFin TIMESTAMP,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoReservacion INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Reservaciones AS t
    (
        CodigoCliente,
        CodigoVehiculo,
        CodigoSede,
        CodigoEspacio,
        FechaHoraReservacion,
        FechaHoraInicio,
        FechaHoraFin,
        Observaciones,
        Estado
    )
    VALUES
    (
        p_CodigoCliente,
        p_CodigoVehiculo,
        p_CodigoSede,
        p_CodigoEspacio,
        p_FechaHoraReservacion,
        p_FechaHoraInicio,
        p_FechaHoraFin,
        p_Observaciones,
        p_Estado
    )
    RETURNING t.CodigoReservacion INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Reservaciones_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Reservaciones_Editar
(
    p_CodigoReservacion INT,
    p_CodigoCliente INT,
    p_CodigoVehiculo INT,
    p_CodigoSede INT,
    p_CodigoEspacio INT,
    p_FechaHoraReservacion TIMESTAMP,
    p_FechaHoraInicio TIMESTAMP,
    p_FechaHoraFin TIMESTAMP,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Reservaciones
    SET CodigoCliente = p_CodigoCliente,
        CodigoVehiculo = p_CodigoVehiculo,
        CodigoSede = p_CodigoSede,
        CodigoEspacio = p_CodigoEspacio,
        FechaHoraReservacion = p_FechaHoraReservacion,
        FechaHoraInicio = p_FechaHoraInicio,
        FechaHoraFin = p_FechaHoraFin,
        Observaciones = p_Observaciones,
        Estado = p_Estado
    WHERE CodigoReservacion = p_CodigoReservacion;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Reservaciones_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Reservaciones_Eliminar
(
    p_CodigoReservacion INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Reservaciones
    WHERE CodigoReservacion = p_CodigoReservacion;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Reservaciones_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Reservaciones_Consultar()
RETURNS TABLE
(
    CodigoReservacion INT,
    CodigoCliente INT,
    CodigoVehiculo INT,
    CodigoSede INT,
    CodigoEspacio INT,
    FechaHoraReservacion TIMESTAMP,
    FechaHoraInicio TIMESTAMP,
    FechaHoraFin TIMESTAMP,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoReservacion,
        t.CodigoCliente,
        t.CodigoVehiculo,
        t.CodigoSede,
        t.CodigoEspacio,
        t.FechaHoraReservacion,
        t.FechaHoraInicio,
        t.FechaHoraFin,
        t.Observaciones,
        t.Estado
    FROM Tbl_Reservaciones t
    ORDER BY t.CodigoReservacion;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Reservaciones_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Reservaciones_Buscar
(
    p_CodigoReservacion INT
)
RETURNS TABLE
(
    CodigoReservacion INT,
    CodigoCliente INT,
    CodigoVehiculo INT,
    CodigoSede INT,
    CodigoEspacio INT,
    FechaHoraReservacion TIMESTAMP,
    FechaHoraInicio TIMESTAMP,
    FechaHoraFin TIMESTAMP,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Reservaciones t
        WHERE t.CodigoReservacion = p_CodigoReservacion
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoReservacion,
        t.CodigoCliente,
        t.CodigoVehiculo,
        t.CodigoSede,
        t.CodigoEspacio,
        t.FechaHoraReservacion,
        t.FechaHoraInicio,
        t.FechaHoraFin,
        t.Observaciones,
        t.Estado
    FROM Tbl_Reservaciones t
    WHERE t.CodigoReservacion = p_CodigoReservacion;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Reservaciones_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  10. FUNCIONES CRUD DE TBL_ENTRADAS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Entradas_Agregar
(
    p_CodigoVehiculo INT,
    p_CodigoEspacio INT,
    p_CodigoEmpleado INT,
    p_CodigoReservacion INT,
    p_FechaHoraEntrada TIMESTAMP,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoEntrada INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Entradas AS t
    (
        CodigoVehiculo,
        CodigoEspacio,
        CodigoEmpleado,
        CodigoReservacion,
        FechaHoraEntrada,
        Observaciones,
        Estado
    )
    VALUES
    (
        p_CodigoVehiculo,
        p_CodigoEspacio,
        p_CodigoEmpleado,
        p_CodigoReservacion,
        p_FechaHoraEntrada,
        p_Observaciones,
        p_Estado
    )
    RETURNING t.CodigoEntrada INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Entradas_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Entradas_Editar
(
    p_CodigoEntrada INT,
    p_CodigoVehiculo INT,
    p_CodigoEspacio INT,
    p_CodigoEmpleado INT,
    p_CodigoReservacion INT,
    p_FechaHoraEntrada TIMESTAMP,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Entradas
    SET CodigoVehiculo = p_CodigoVehiculo,
        CodigoEspacio = p_CodigoEspacio,
        CodigoEmpleado = p_CodigoEmpleado,
        CodigoReservacion = p_CodigoReservacion,
        FechaHoraEntrada = p_FechaHoraEntrada,
        Observaciones = p_Observaciones,
        Estado = p_Estado
    WHERE CodigoEntrada = p_CodigoEntrada;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Entradas_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Entradas_Eliminar
(
    p_CodigoEntrada INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Entradas
    WHERE CodigoEntrada = p_CodigoEntrada;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Entradas_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Entradas_Consultar()
RETURNS TABLE
(
    CodigoEntrada INT,
    CodigoVehiculo INT,
    CodigoEspacio INT,
    CodigoEmpleado INT,
    CodigoReservacion INT,
    FechaHoraEntrada TIMESTAMP,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoEntrada,
        t.CodigoVehiculo,
        t.CodigoEspacio,
        t.CodigoEmpleado,
        t.CodigoReservacion,
        t.FechaHoraEntrada,
        t.Observaciones,
        t.Estado
    FROM Tbl_Entradas t
    ORDER BY t.CodigoEntrada;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Entradas_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Entradas_Buscar
(
    p_CodigoEntrada INT
)
RETURNS TABLE
(
    CodigoEntrada INT,
    CodigoVehiculo INT,
    CodigoEspacio INT,
    CodigoEmpleado INT,
    CodigoReservacion INT,
    FechaHoraEntrada TIMESTAMP,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Entradas t
        WHERE t.CodigoEntrada = p_CodigoEntrada
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoEntrada,
        t.CodigoVehiculo,
        t.CodigoEspacio,
        t.CodigoEmpleado,
        t.CodigoReservacion,
        t.FechaHoraEntrada,
        t.Observaciones,
        t.Estado
    FROM Tbl_Entradas t
    WHERE t.CodigoEntrada = p_CodigoEntrada;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Entradas_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  11. FUNCIONES CRUD DE TBL_SALIDAS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Salidas_Agregar
(
    p_CodigoEntrada INT,
    p_CodigoEmpleado INT,
    p_FechaHoraSalida TIMESTAMP,
    p_TiempoTotalMinutos INT,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoSalida INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Salidas AS t
    (
        CodigoEntrada,
        CodigoEmpleado,
        FechaHoraSalida,
        TiempoTotalMinutos,
        Observaciones,
        Estado
    )
    VALUES
    (
        p_CodigoEntrada,
        p_CodigoEmpleado,
        p_FechaHoraSalida,
        p_TiempoTotalMinutos,
        p_Observaciones,
        p_Estado
    )
    RETURNING t.CodigoSalida INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Salidas_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Salidas_Editar
(
    p_CodigoSalida INT,
    p_CodigoEntrada INT,
    p_CodigoEmpleado INT,
    p_FechaHoraSalida TIMESTAMP,
    p_TiempoTotalMinutos INT,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Salidas
    SET CodigoEntrada = p_CodigoEntrada,
        CodigoEmpleado = p_CodigoEmpleado,
        FechaHoraSalida = p_FechaHoraSalida,
        TiempoTotalMinutos = p_TiempoTotalMinutos,
        Observaciones = p_Observaciones,
        Estado = p_Estado
    WHERE CodigoSalida = p_CodigoSalida;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Salidas_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Salidas_Eliminar
(
    p_CodigoSalida INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Salidas
    WHERE CodigoSalida = p_CodigoSalida;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Salidas_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Salidas_Consultar()
RETURNS TABLE
(
    CodigoSalida INT,
    CodigoEntrada INT,
    CodigoEmpleado INT,
    FechaHoraSalida TIMESTAMP,
    TiempoTotalMinutos INT,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoSalida,
        t.CodigoEntrada,
        t.CodigoEmpleado,
        t.FechaHoraSalida,
        t.TiempoTotalMinutos,
        t.Observaciones,
        t.Estado
    FROM Tbl_Salidas t
    ORDER BY t.CodigoSalida;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Salidas_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Salidas_Buscar
(
    p_CodigoSalida INT
)
RETURNS TABLE
(
    CodigoSalida INT,
    CodigoEntrada INT,
    CodigoEmpleado INT,
    FechaHoraSalida TIMESTAMP,
    TiempoTotalMinutos INT,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Salidas t
        WHERE t.CodigoSalida = p_CodigoSalida
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoSalida,
        t.CodigoEntrada,
        t.CodigoEmpleado,
        t.FechaHoraSalida,
        t.TiempoTotalMinutos,
        t.Observaciones,
        t.Estado
    FROM Tbl_Salidas t
    WHERE t.CodigoSalida = p_CodigoSalida;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Salidas_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  12. FUNCIONES CRUD DE TBL_PAGOS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pagos_Agregar
(
    p_CodigoSalida INT,
    p_CodigoTarifa INT,
    p_CodigoCliente INT,
    p_MontoPago DECIMAL(10,2),
    p_FormaPago VARCHAR(50),
    p_ReferenciaPago VARCHAR(100),
    p_FechaHoraPago TIMESTAMP,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoPago INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Pagos AS t
    (
        CodigoSalida,
        CodigoTarifa,
        CodigoCliente,
        MontoPago,
        FormaPago,
        ReferenciaPago,
        FechaHoraPago,
        Estado
    )
    VALUES
    (
        p_CodigoSalida,
        p_CodigoTarifa,
        p_CodigoCliente,
        p_MontoPago,
        p_FormaPago,
        p_ReferenciaPago,
        p_FechaHoraPago,
        p_Estado
    )
    RETURNING t.CodigoPago INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pagos_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pagos_Editar
(
    p_CodigoPago INT,
    p_CodigoSalida INT,
    p_CodigoTarifa INT,
    p_CodigoCliente INT,
    p_MontoPago DECIMAL(10,2),
    p_FormaPago VARCHAR(50),
    p_ReferenciaPago VARCHAR(100),
    p_FechaHoraPago TIMESTAMP,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Pagos
    SET CodigoSalida = p_CodigoSalida,
        CodigoTarifa = p_CodigoTarifa,
        CodigoCliente = p_CodigoCliente,
        MontoPago = p_MontoPago,
        FormaPago = p_FormaPago,
        ReferenciaPago = p_ReferenciaPago,
        FechaHoraPago = p_FechaHoraPago,
        Estado = p_Estado
    WHERE CodigoPago = p_CodigoPago;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pagos_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pagos_Eliminar
(
    p_CodigoPago INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Pagos
    WHERE CodigoPago = p_CodigoPago;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pagos_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pagos_Consultar()
RETURNS TABLE
(
    CodigoPago INT,
    CodigoSalida INT,
    CodigoTarifa INT,
    CodigoCliente INT,
    MontoPago DECIMAL(10,2),
    FormaPago VARCHAR(50),
    ReferenciaPago VARCHAR(100),
    FechaHoraPago TIMESTAMP,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoPago,
        t.CodigoSalida,
        t.CodigoTarifa,
        t.CodigoCliente,
        t.MontoPago,
        t.FormaPago,
        t.ReferenciaPago,
        t.FechaHoraPago,
        t.Estado
    FROM Tbl_Pagos t
    ORDER BY t.CodigoPago;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pagos_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pagos_Buscar
(
    p_CodigoPago INT
)
RETURNS TABLE
(
    CodigoPago INT,
    CodigoSalida INT,
    CodigoTarifa INT,
    CodigoCliente INT,
    MontoPago DECIMAL(10,2),
    FormaPago VARCHAR(50),
    ReferenciaPago VARCHAR(100),
    FechaHoraPago TIMESTAMP,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Pagos t
        WHERE t.CodigoPago = p_CodigoPago
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoPago,
        t.CodigoSalida,
        t.CodigoTarifa,
        t.CodigoCliente,
        t.MontoPago,
        t.FormaPago,
        t.ReferenciaPago,
        t.FechaHoraPago,
        t.Estado
    FROM Tbl_Pagos t
    WHERE t.CodigoPago = p_CodigoPago;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pagos_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  13. FUNCIONES CRUD DE TBL_INCIDENCIAS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Incidencias_Agregar
(
    p_CodigoSede INT,
    p_CodigoEmpleado INT,
    p_CodigoVehiculo INT,
    p_CodigoEspacio INT,
    p_TipoIncidencia VARCHAR(60),
    p_Descripcion VARCHAR(500),
    p_FechaHoraIncidencia TIMESTAMP,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoIncidencia INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Incidencias AS t
    (
        CodigoSede,
        CodigoEmpleado,
        CodigoVehiculo,
        CodigoEspacio,
        TipoIncidencia,
        Descripcion,
        FechaHoraIncidencia,
        Estado
    )
    VALUES
    (
        p_CodigoSede,
        p_CodigoEmpleado,
        p_CodigoVehiculo,
        p_CodigoEspacio,
        p_TipoIncidencia,
        p_Descripcion,
        p_FechaHoraIncidencia,
        p_Estado
    )
    RETURNING t.CodigoIncidencia INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Incidencias_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Incidencias_Editar
(
    p_CodigoIncidencia INT,
    p_CodigoSede INT,
    p_CodigoEmpleado INT,
    p_CodigoVehiculo INT,
    p_CodigoEspacio INT,
    p_TipoIncidencia VARCHAR(60),
    p_Descripcion VARCHAR(500),
    p_FechaHoraIncidencia TIMESTAMP,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Incidencias
    SET CodigoSede = p_CodigoSede,
        CodigoEmpleado = p_CodigoEmpleado,
        CodigoVehiculo = p_CodigoVehiculo,
        CodigoEspacio = p_CodigoEspacio,
        TipoIncidencia = p_TipoIncidencia,
        Descripcion = p_Descripcion,
        FechaHoraIncidencia = p_FechaHoraIncidencia,
        Estado = p_Estado
    WHERE CodigoIncidencia = p_CodigoIncidencia;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Incidencias_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Incidencias_Eliminar
(
    p_CodigoIncidencia INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Incidencias
    WHERE CodigoIncidencia = p_CodigoIncidencia;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Incidencias_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Incidencias_Consultar()
RETURNS TABLE
(
    CodigoIncidencia INT,
    CodigoSede INT,
    CodigoEmpleado INT,
    CodigoVehiculo INT,
    CodigoEspacio INT,
    TipoIncidencia VARCHAR(60),
    Descripcion VARCHAR(500),
    FechaHoraIncidencia TIMESTAMP,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoIncidencia,
        t.CodigoSede,
        t.CodigoEmpleado,
        t.CodigoVehiculo,
        t.CodigoEspacio,
        t.TipoIncidencia,
        t.Descripcion,
        t.FechaHoraIncidencia,
        t.Estado
    FROM Tbl_Incidencias t
    ORDER BY t.CodigoIncidencia;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Incidencias_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Incidencias_Buscar
(
    p_CodigoIncidencia INT
)
RETURNS TABLE
(
    CodigoIncidencia INT,
    CodigoSede INT,
    CodigoEmpleado INT,
    CodigoVehiculo INT,
    CodigoEspacio INT,
    TipoIncidencia VARCHAR(60),
    Descripcion VARCHAR(500),
    FechaHoraIncidencia TIMESTAMP,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Incidencias t
        WHERE t.CodigoIncidencia = p_CodigoIncidencia
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoIncidencia,
        t.CodigoSede,
        t.CodigoEmpleado,
        t.CodigoVehiculo,
        t.CodigoEspacio,
        t.TipoIncidencia,
        t.Descripcion,
        t.FechaHoraIncidencia,
        t.Estado
    FROM Tbl_Incidencias t
    WHERE t.CodigoIncidencia = p_CodigoIncidencia;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Incidencias_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


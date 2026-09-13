# 🅿️ Parqueo Privados GT

Sistema de administración de parqueos privados desarrollado.

![NestJS](https://img.shields.io/badge/NestJS-12-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-6-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Postgres-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Swagger](https://img.shields.io/badge/Swagger-API%20Docs-85EA2D?style=for-the-badge&logo=swagger&logoColor=black)

---

## 📖 Descripción

**Parqueo Privados GT, S.A.** es una empresa que ofrece servicios de estacionamiento privado en distintas sedes del país. Este sistema administra sedes, clientes, vehículos, tipos de vehículo, tarifas, espacios disponibles, empleados, turnos, reservaciones, entradas, salidas, pagos e incidencias.

Toda la lógica de negocio está implementada mediante **stored procedures** en PostgreSQL, y consumida por una API REST construida en **NestJS**. Para esta entrega, el CRUD completo (Agregar, Editar, Eliminar, Consultar, Buscar) se implementó para la tabla **Sedes**.

---

## 🗂️ Estructura del repositorio

```
ParqueoPrivadosGT/
├── backend/            → API REST en NestJS + PostgreSQL
│   └── parqueo-privados-api/
├── database/           → Scripts SQL (base, datos de prueba, stored procedures)
├── frontend/           → Reservado para entregas futuras
└── docs/               → Reservado para entregas futuras
```

---

## 🧱 Modelo de base de datos

La base de datos `db_parqueoprivadosgt` está compuesta por **13 tablas** normalizadas, todas con el prefijo `Tbl_` y llave primaria `Codigo...`:

| Tabla | Descripción |
|---|---|
| `Tbl_Sedes` | Sedes o sucursales de la empresa |
| `Tbl_TiposVehiculos` | Catálogo de tipos de vehículo |
| `Tbl_Clientes` | Clientes particulares y empresariales |
| `Tbl_Vehiculos` | Vehículos registrados por cliente |
| `Tbl_Tarifas` | Tarifas por sede y tipo de vehículo |
| `Tbl_Espacios` | Espacios de parqueo disponibles por sede |
| `Tbl_Empleados` | Empleados asignados a cada sede |
| `Tbl_Turnos` | Turnos de trabajo del personal |
| `Tbl_Reservaciones` | Reservaciones de espacio realizadas por clientes |
| `Tbl_Entradas` | Registro de ingreso de vehículos |
| `Tbl_Salidas` | Registro de salida de vehículos |
| `Tbl_Pagos` | Pagos asociados a cada salida |
| `Tbl_Incidencias` | Incidencias reportadas en las sedes |

Toda la lógica de negocio (validaciones, inserciones, actualizaciones) se maneja mediante **65 stored procedures** (5 por cada tabla: `Usp_X_Agregar`, `Usp_X_Editar`, `Usp_X_Eliminar`, `Usp_X_Consultar`, `Usp_X_Buscar`) ubicados en `database/3_Script_Stored_Procedures_ParqueoPrivadosGT_PostgreSQL.sql`.

### Scripts (ejecutar en este orden en pgAdmin)

1. `1_Script_Base_Datos_ParqueoPrivadosGT_PostgreSQL.sql` — creación de las 13 tablas.
2. `2_Script_Datos_Prueba_ParqueoPrivadosGT_PostgreSQL.sql` — 5 registros de prueba por tabla.
3. `3_Script_Stored_Procedures_ParqueoPrivadosGT_PostgreSQL.sql` — funciones CRUD para las 13 tablas.

---

## ⚙️ Backend — Instalación y ejecución

### Requisitos previos

- Node.js 20+
- PostgreSQL 16 (en este proyecto corre en un contenedor Docker)
- npm

### Pasos

```bash
cd backend/parqueo-privados-api
npm install
```

Crea un archivo `.env` en la raíz de `parqueo-privados-api` con tus credenciales:

```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=tu_password
DB_NAME=db_parqueoprivadosgt
DB_POOL_MAX=10
```

Levanta el servidor en modo desarrollo:

```bash
npm run start:dev
```

La API queda disponible en `http://localhost:3000`.

### 📑 Documentación interactiva (Swagger)

```
http://localhost:3000/api/docs
```

Desde ahí se pueden probar todos los endpoints directamente en el navegador.

---

## 🔌 Endpoints disponibles

**Base URL:** `http://localhost:3000/api`

### Sedes

| Método | Endpoint | Descripción |
|---|---|---|
| `POST` | `/sedesAgregar` | Crea una nueva sede |
| `PUT` | `/sedesEditar/{codigoSede}` | Edita una sede existente |
| `DELETE` | `/sedesEliminar/{codigoSede}` | Elimina una sede |
| `GET` | `/sedesConsultar` | Lista todas las sedes |
| `GET` | `/sedesBuscar/{codigoSede}` | Busca una sede por código |

Todas las respuestas siguen el mismo formato:

```json
{
  "exito": 1,
  "mensaje": "Registro agregado correctamente.",
  "datos": { }
}
```

---

## 🧩 Stack tecnológico

- **Backend:** NestJS 12 (Node.js + TypeScript)
- **Base de datos:** PostgreSQL 16 (contenedor Docker)
- **Driver:** node-postgres (`pg`)
- **Documentación de API:** Swagger (`@nestjs/swagger`)
- **Testing:** Vitest

---

## 👤 Developer

**Fernando Guadalupe Fajardo Solórzano**

---

## 📄 Licencia
PRO

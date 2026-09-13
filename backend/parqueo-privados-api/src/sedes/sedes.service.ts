import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

@Injectable()
export class SedesService {
  constructor(private readonly databaseService: DatabaseService) {}

  // ============================================================
  // FUNCIONALIDAD: CONSULTAR SEDES
  // ============================================================
  async consultar() {
    try {
      const resultado = await this.databaseService.query(`
        SELECT
          codigosede      AS "codigoSede",
          nombresede      AS "nombreSede",
          direccion       AS "direccion",
          municipio       AS "municipio",
          departamento    AS "departamento",
          telefono        AS "telefono",
          horaapertura    AS "horaApertura",
          horacierre      AS "horaCierre",
          capacidadtotal  AS "capacidadTotal",
          estado          AS "estado"
        FROM Usp_Sedes_Consultar();
      `);

      return {
        exito: 1,
        mensaje: 'Sedes consultadas correctamente.',
        datos: resultado.rows,
      };
    } catch (error) {
      const mensaje =
        error instanceof Error ? error.message : 'Error desconocido al consultar las sedes.';
      throw new InternalServerErrorException({ exito: 0, mensaje: mensaje });
    }
  }

  // ============================================================
  // FUNCIONALIDAD: BUSCAR SEDE
  // ============================================================
  async buscar(codigoSede: number) {
    try {
      if (!Number.isInteger(codigoSede) || codigoSede <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código de sede debe ser un número entero mayor que cero.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT
          codigosede      AS "codigoSede",
          nombresede      AS "nombreSede",
          direccion       AS "direccion",
          municipio       AS "municipio",
          departamento    AS "departamento",
          telefono        AS "telefono",
          horaapertura    AS "horaApertura",
          horacierre      AS "horaCierre",
          capacidadtotal  AS "capacidadTotal",
          estado          AS "estado"
        FROM Usp_Sedes_Buscar($1);
      `,
        [codigoSede],
      );

      return {
        exito: 1,
        mensaje: 'Sede encontrada correctamente.',
        datos: resultado.rows,
      };
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      const mensajeCompleto =
        error instanceof Error ? error.message : 'Error desconocido al buscar la sede.';
      const mensaje = mensajeCompleto.includes('No se encontró el registro solicitado.')
        ? 'No se encontró el registro solicitado.'
        : mensajeCompleto;
      throw new InternalServerErrorException({ exito: 0, mensaje: mensaje });
    }
  }

  // ============================================================
  // FUNCIONALIDAD: AGREGAR SEDE
  // ============================================================
  async agregar(datos: {
    nombreSede: string;
    direccion: string;
    municipio: string;
    departamento: string;
    telefono: string;
    horaApertura: string;
    horaCierre: string;
    capacidadTotal: number;
    estado: string;
  }) {
    try {
      if (
        !datos.nombreSede ||
        !datos.direccion ||
        !datos.municipio ||
        !datos.departamento ||
        !datos.telefono ||
        !datos.horaApertura ||
        !datos.horaCierre ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios de la sede.',
        });
      }

      if (typeof datos.capacidadTotal !== 'number' || datos.capacidadTotal <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'La capacidad total debe ser un número mayor que cero.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT *
        FROM Usp_Sedes_Agregar($1, $2, $3, $4, $5, $6, $7, $8, $9);
      `,
        [
          datos.nombreSede,
          datos.direccion,
          datos.municipio,
          datos.departamento,
          datos.telefono,
          datos.horaApertura,
          datos.horaCierre,
          datos.capacidadTotal,
          datos.estado,
        ],
      );

      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
        codigoSede: resultado.rows[0].codigosede,
      };
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      const mensaje = error instanceof Error ? error.message : 'Error desconocido al agregar la sede.';
      throw new InternalServerErrorException({ exito: 0, mensaje: mensaje });
    }
  }

  // ============================================================
  // FUNCIONALIDAD: EDITAR SEDE
  // ============================================================
  async editar(
    codigoSede: number,
    datos: {
      nombreSede: string;
      direccion: string;
      municipio: string;
      departamento: string;
      telefono: string;
      horaApertura: string;
      horaCierre: string;
      capacidadTotal: number;
      estado: string;
    },
  ) {
    try {
      if (!Number.isInteger(codigoSede) || codigoSede <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código de sede debe ser un número entero mayor que cero.',
        });
      }

      if (typeof datos.capacidadTotal !== 'number' || datos.capacidadTotal <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'La capacidad total debe ser un número mayor que cero.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT *
        FROM Usp_Sedes_Editar($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
      `,
        [
          codigoSede,
          datos.nombreSede,
          datos.direccion,
          datos.municipio,
          datos.departamento,
          datos.telefono,
          datos.horaApertura,
          datos.horaCierre,
          datos.capacidadTotal,
          datos.estado,
        ],
      );

      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
      };
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      const mensaje = error instanceof Error ? error.message : 'Error desconocido al editar la sede.';
      throw new InternalServerErrorException({ exito: 0, mensaje: mensaje });
    }
  }

  // ============================================================
  // FUNCIONALIDAD: ELIMINAR SEDE
  // ============================================================
  async eliminar(codigoSede: number) {
    try {
      if (!Number.isInteger(codigoSede) || codigoSede <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código de sede debe ser un número entero mayor que cero.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT *
        FROM Usp_Sedes_Eliminar($1);
      `,
        [codigoSede],
      );

      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
      };
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      const mensaje = error instanceof Error ? error.message : 'Error desconocido al eliminar la sede.';
      throw new InternalServerErrorException({ exito: 0, mensaje: mensaje });
    }
  }
}
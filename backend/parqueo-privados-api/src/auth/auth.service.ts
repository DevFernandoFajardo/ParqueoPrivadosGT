import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { DatabaseService } from '../database/database.service.js';

@Injectable()
export class AuthService {
  constructor(
    private readonly databaseService: DatabaseService,
    private readonly jwtService: JwtService,
  ) {}

  async login(datos: { nombreUsuario: string; claveUsuario: string }) {
    try {
      if (!datos.nombreUsuario || !datos.claveUsuario) {
        throw new BadRequestException({ exito: 0, mensaje: 'Debe ingresar el nombre de usuario y la clave.' });
      }

      let resultado;
      try {
        resultado = await this.databaseService.query(`SELECT * FROM Usp_Usuarios_BuscarPorUsuario($1);`, [datos.nombreUsuario]);
      } catch (error) {
        throw new UnauthorizedException({ exito: 0, mensaje: 'Usuario o clave incorrectos.' });
      }

      const usuario = resultado.rows[0];
      const claveValida = await bcrypt.compare(datos.claveUsuario, usuario.claveusuario);
      if (!claveValida) {
        throw new UnauthorizedException({ exito: 0, mensaje: 'Usuario o clave incorrectos.' });
      }

      const versionResultado = await this.databaseService.query(
        `SELECT * FROM Usp_Usuarios_ObtenerVersionToken($1);`,
        [usuario.codigousuario],
      );
      const versionToken = versionResultado.rows[0]?.usp_usuarios_obtenerversiontoken ?? 0;

      const payload = {
        codigoUsuario: usuario.codigousuario,
        nombreUsuario: usuario.nombreusuario,
        tipoUsuario: usuario.tipousuario,
        versionToken,
      };

      const accessToken = this.jwtService.sign(payload, {
        secret: process.env.JWT_ACCESS_SECRET,
        expiresIn: process.env.JWT_ACCESS_EXPIRES_IN as any,
      });

      const refreshToken = this.jwtService.sign(payload, {
        secret: process.env.JWT_REFRESH_SECRET,
        expiresIn: process.env.JWT_REFRESH_EXPIRES_IN as any,
      });

      return {
        exito: 1,
        mensaje: 'Inicio de sesión exitoso.',
        datos: {
          accessToken,
          refreshToken,
          usuario: {
            codigoUsuario: payload.codigoUsuario,
            nombreUsuario: payload.nombreUsuario,
            tipoUsuario: payload.tipoUsuario,
          },
        },
      };
    } catch (error) {
      if (error instanceof BadRequestException || error instanceof UnauthorizedException) throw error;
      const mensaje = error instanceof Error ? error.message : 'Error desconocido al iniciar sesión.';
      throw new InternalServerErrorException({ exito: 0, mensaje: mensaje });
    }
  }

  async refrescarToken(datos: { refreshToken: string }) {
    try {
      if (!datos.refreshToken) {
        throw new BadRequestException({ exito: 0, mensaje: 'Debe proporcionar el refresh token.' });
      }

      let payload;
      try {
        payload = this.jwtService.verify(datos.refreshToken, { secret: process.env.JWT_REFRESH_SECRET });
      } catch (error) {
        throw new UnauthorizedException({
          exito: 0,
          mensaje: 'El refresh token es inválido o ha expirado. Debe iniciar sesión nuevamente.',
        });
      }

      const versionResultado = await this.databaseService.query(
        `SELECT * FROM Usp_Usuarios_ObtenerVersionToken($1);`,
        [payload.codigoUsuario],
      );
      const versionActual = versionResultado.rows[0]?.usp_usuarios_obtenerversiontoken;

      if (versionActual === undefined || Number(versionActual) !== Number(payload.versionToken)) {
        throw new UnauthorizedException({
          exito: 0,
          mensaje: 'La sesión fue cerrada. Debe iniciar sesión nuevamente.',
        });
      }

      const nuevoPayload = {
        codigoUsuario: payload.codigoUsuario,
        nombreUsuario: payload.nombreUsuario,
        tipoUsuario: payload.tipoUsuario,
        versionToken: payload.versionToken,
      };

      const nuevoAccessToken = this.jwtService.sign(nuevoPayload, {
        secret: process.env.JWT_ACCESS_SECRET,
        expiresIn: process.env.JWT_ACCESS_EXPIRES_IN as any,
      });

      return { exito: 1, mensaje: 'Token renovado correctamente.', datos: { accessToken: nuevoAccessToken } };
    } catch (error) {
      if (error instanceof BadRequestException || error instanceof UnauthorizedException) throw error;
      const mensaje = error instanceof Error ? error.message : 'Error desconocido al renovar el token.';
      throw new InternalServerErrorException({ exito: 0, mensaje: mensaje });
    }
  }

  async cerrarSesion(codigoUsuario: number) {
    try {
      await this.databaseService.query(`SELECT * FROM Usp_Usuarios_CerrarSesion($1);`, [codigoUsuario]);
      return { exito: 1, mensaje: 'Sesión cerrada correctamente. Los tokens anteriores ya no son válidos.' };
    } catch (error) {
      const mensaje = error instanceof Error ? error.message : 'Error desconocido al cerrar la sesión.';
      throw new InternalServerErrorException({ exito: 0, mensaje: mensaje });
    }
  }
}
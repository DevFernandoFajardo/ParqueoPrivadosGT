import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { DatabaseService } from '../database/database.service.js';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly jwtService: JwtService,
    private readonly databaseService: DatabaseService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers['authorization'];

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedException({ exito: 0, mensaje: 'Debe enviar un token de acceso válido.' });
    }

    const token = authHeader.substring('Bearer '.length);

    let payload;
    try {
      payload = this.jwtService.verify(token, { secret: process.env.JWT_ACCESS_SECRET });
    } catch (error) {
      throw new UnauthorizedException({ exito: 0, mensaje: 'El token de acceso es inválido o ha expirado.' });
    }

    // Aunque el token en sí sea válido y no haya expirado, revisamos que
    // el usuario no haya cerrado sesión después de que este token fue
    // emitido (eso sube la VersionToken en la base de datos y la deja
    // sin coincidir con la que trae este token).
    try {
      const resultado = await this.databaseService.query(
        `SELECT * FROM Usp_Usuarios_ObtenerVersionToken($1);`,
        [payload.codigoUsuario],
      );
      const versionActual = resultado.rows[0]?.usp_usuarios_obtenerversiontoken;
      if (versionActual === undefined || Number(versionActual) !== Number(payload.versionToken)) {
        throw new Error('version-invalida');
      }
    } catch (error) {
      throw new UnauthorizedException({
        exito: 0,
        mensaje: 'La sesión fue cerrada. Debe iniciar sesión nuevamente.',
      });
    }

    request.usuario = payload;
    return true;
  }
}
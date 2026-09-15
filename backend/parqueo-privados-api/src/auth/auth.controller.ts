import { Body, Controller, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiBody, ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service.js';
import { JwtAuthGuard } from './jwt-auth.guard.js';

@ApiTags('Auth')
@Controller('api')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @ApiBody({ schema: { example: { nombreUsuario: 'admin', claveUsuario: 'Admin123*' } } })
  login(@Body() body: any) {
    return this.authService.login(body);
  }

  @Post('refresh-token')
  @ApiBody({ schema: { example: { refreshToken: 'eyJhbGciOi...' } } })
  refrescarToken(@Body() body: any) {
    return this.authService.refrescarToken(body);
  }

  @Post('logout')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  logout(@Req() request: any) {
    return this.authService.cerrarSesion(request.usuario.codigoUsuario);
  }
}
import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';
import { ApiBody, ApiTags } from '@nestjs/swagger';
import { SedesService } from './sedes.service.js';
import { SedeSchema } from './sedes.schema.js';

@ApiTags('Sedes')
@Controller('api')
export class SedesController {
  constructor(private readonly sedesService: SedesService) {}

  @ApiBody({ type: SedeSchema })
  @Post('sedesAgregar')
  agregar(@Body() body: any) {
    return this.sedesService.agregar(body);
  }

  @ApiBody({ type: SedeSchema })
  @Put('sedesEditar/:codigoSede')
  editar(@Param('codigoSede', ParseIntPipe) codigoSede: number, @Body() body: any) {
    return this.sedesService.editar(codigoSede, body);
  }

  @Delete('sedesEliminar/:codigoSede')
  eliminar(@Param('codigoSede', ParseIntPipe) codigoSede: number) {
    return this.sedesService.eliminar(codigoSede);
  }

  @Get('sedesConsultar')
  consultar() {
    return this.sedesService.consultar();
  }

  @Get('sedesBuscar/:codigoSede')
  buscar(@Param('codigoSede', ParseIntPipe) codigoSede: number) {
    return this.sedesService.buscar(codigoSede);
  }
}
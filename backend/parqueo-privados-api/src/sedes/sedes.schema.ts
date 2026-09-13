import { ApiProperty } from '@nestjs/swagger';

export class SedeSchema {
  @ApiProperty() nombreSede: string;
  @ApiProperty() direccion: string;
  @ApiProperty() municipio: string;
  @ApiProperty() departamento: string;
  @ApiProperty() telefono: string;
  @ApiProperty({ example: '06:00:00' }) horaApertura: string;
  @ApiProperty({ example: '22:00:00' }) horaCierre: string;
  @ApiProperty() capacidadTotal: number;
  @ApiProperty() estado: string;
}
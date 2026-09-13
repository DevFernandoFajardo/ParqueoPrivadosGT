import { Module } from '@nestjs/common';
import { SedesController } from './sedes.controller.js';
import { SedesService } from './sedes.service.js';

@Module({
  controllers: [SedesController],
  providers: [SedesService],
})
export class SedesModule {}
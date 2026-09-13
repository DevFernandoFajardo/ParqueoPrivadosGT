import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module.js';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle('Parqueo Privados GT')
    .setDescription('API - CRUD de Sedes')
    .setVersion('1.0')
    .build();
  const documento = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, documento);

  await app.listen(3000);
}
bootstrap();
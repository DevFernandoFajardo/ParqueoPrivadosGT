import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { Pool, QueryResult } from 'pg';

@Injectable()
export class DatabaseService implements OnModuleDestroy {
  private readonly pool: Pool;

  constructor() {
    this.pool = new Pool({
      host: process.env.DB_HOST,
      port: Number(process.env.DB_PORT),
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      max: Number(process.env.DB_POOL_MAX) || 10,
    });
  }

  async query(sql: string, params: any[] = []): Promise<QueryResult> {
    return this.pool.query(sql, params);
  }

  async probarConexion() {
    return this.pool.query('SELECT NOW()');
  }

  async onModuleDestroy() {
    await this.pool.end();
  }
}
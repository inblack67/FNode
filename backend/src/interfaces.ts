import { PrismaClient, User } from '@prisma/client';
import { Session, SessionData } from 'express-session';
import { Redis } from 'ioredis';

export interface ISession extends Session, SessionData {
  username?: string;
  user_id?: string | number;
}

export interface ILocals {
  redis: Redis;
  prisma: PrismaClient;
  session: ISession;
}

export interface INativeSession {
  session_id: string | number;
  user: User;
}

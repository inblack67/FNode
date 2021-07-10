import { PrismaClient, User } from '@prisma/client';
import { Session, SessionData } from 'express-session';
import { Redis } from 'ioredis';
import { Server } from 'socket.io';

export interface ISession extends Session, SessionData {
  username?: string;
  user_id?: string | number;
}

export interface ILocals {
  redis: Redis;
  prisma: PrismaClient;
  session: ISession;
  socket: Server;
  current_user?: User;
  current_user_token?: string;
}

export interface INativeSession {
  user: User;
}

export interface IMessage {
  content: string;
  type?: string;
  userId: string | number;
}

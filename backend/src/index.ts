import http from 'http';
import express from 'express';
import { Server } from 'socket.io';
import morgan from 'morgan';
import cors from 'cors';
import Redis from 'ioredis';
import connectRedis from 'connect-redis';
import session from 'express-session';
import 'colors';
import { pongController } from './controllers/root.controller';
import { registerController } from './controllers/register.controller';
import { nativeNeglect, nativeProtect, populateLocals } from './middlewares';
import { getPrismaClient } from './prisma';
import { nativeLoginController } from './controllers/login.controller';
import { isProd } from './utils';
import { nativeGetMeController } from './controllers/getMe.controller';
import { nativeLogoutController } from './controllers/logout.controller';
import { addMessageController } from './controllers/addMessage.controller';
import { getMessagesController } from './controllers/getMessages.controller';

const main = async () => {
  const prisma = getPrismaClient();

  const RedisClient = new Redis();
  // await RedisClient.flushall();
  const RedisSessionStore = connectRedis(session);
  const store = new RedisSessionStore({ client: RedisClient });
  const app = express();
  const server = http.createServer(app);
  const io = new Server(server);

  io.on('connect', (socket) => {
    console.log('Socket connected'.blue.bold);
    socket.on('msg', (data) => {
      console.log(data);
    });
  });

  app.use(express.json());
  app.use(cors());
  app.use(morgan('dev'));

  app.use(
    session({
      store,
      secret: process.env.SESSION_SECRET,
      name: 'fnode-session',
      saveUninitialized: false,
      resave: false,
      proxy: isProd(),
      cookie: {
        httpOnly: true,
        sameSite: 'lax',
        maxAge: 1000 * 60 * 60 * 24,
        secure: isProd(),
        domain: process.env.COOKIE_DOMAIN,
      },
    }),
  );

  app.use(populateLocals({ prisma, redis: RedisClient, socket: io }));

  app.get('/api', pongController);
  app.post('/api/register', nativeNeglect, registerController);
  app.post('/api/login', nativeNeglect, nativeLoginController);
  app.get('/api/getMe', nativeProtect, nativeGetMeController);
  app.post('/api/logout', nativeProtect, nativeLogoutController);
  app.post('/api/message', nativeProtect, addMessageController);
  app.get('/api/messages', nativeProtect, getMessagesController);

  const PORT = process.env.PORT;
  server.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`.blue.bold);
  });
};

main().catch((err) => {
  console.error(err);
});

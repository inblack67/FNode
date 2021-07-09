import express from 'express';
import morgan from 'morgan';
import cors from 'cors';
import Redis from 'ioredis';
import connectRedis from 'connect-redis';
import session from 'express-session';
import 'colors';
import { pongController } from './controllers/root.controller';
import { registerController } from './controllers/register.controller';
import {
  nativeNeglect,
  nativeProtect,
  populateLocals,
} from './middlewares';
import { getPrismaClient } from './prisma';
import { nativeLoginController } from './controllers/login.controller';
import { isProd } from './utils';
import { nativeGetMeController } from './controllers/getMe.controller';
import { nativeLogoutController } from './controllers/logout.controller';

const main = async () => {
  const prisma = getPrismaClient();

  const RedisClient = new Redis();
  await RedisClient.flushall();
  const RedisSessionStore = connectRedis(session);
  const store = new RedisSessionStore({ client: RedisClient });
  const app = express();

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

  app.use(populateLocals({ prisma, redis: RedisClient }));

  app.get('/api', pongController);
  app.post('/api/register', nativeNeglect, registerController);
  app.post('/api/login', nativeNeglect, nativeLoginController);
  app.get('/api/getMe', nativeProtect, nativeGetMeController);
  app.post('/api/logout', nativeProtect, nativeLogoutController);

  const PORT = process.env.PORT;
  app.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`.blue.bold);
  });
};

main().catch((err) => {
  console.error(err);
});

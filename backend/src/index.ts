import express from 'express';
import morgan from 'morgan';
import cors from 'cors';
import Redis from 'ioredis';
import connectRedis from 'connect-redis';
import session from 'express-session';
import 'colors';
import { pongController } from './controllers/root.controller';
import { registerController } from './controllers/register.controller';
import { neglect, populateLocals, protect } from './middlewares';
import { getPrismaClient } from './prisma';
import { loginController } from './controllers/login.controller';
import { isProd } from './utils';
import { getMeController } from './controllers/getMe.controller';
import { logoutController } from './controllers/logout.controller';

const main = async () => {
  const prisma = getPrismaClient();

  const RedisClient = new Redis();
  // await RedisClient.flushall();
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
  app.post('/api/register', neglect, registerController);
  app.post('/api/login', neglect, loginController);
  app.get('/api/getMe', protect, getMeController);
  app.post('/api/logout', protect, logoutController);

  const PORT = process.env.PORT;
  app.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`.blue.bold);
  });
};

main().catch((err) => {
  console.error(err);
});

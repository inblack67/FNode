import express from 'express';
import morgan from 'morgan';
import cors from 'cors';
import 'colors';
import { pongController } from './controllers/root.controller';
import { registerController } from './controllers/register.controller';
import { populateLocals } from './middlewares';
import { getPrismaClient } from './prisma';

const main = async () => {
  const prisma = getPrismaClient();
  const app = express();

  app.use(express.json());
  app.use(cors());
  app.use(morgan('dev'));
  app.use(populateLocals({ prisma }));

  app.get('/api', pongController);
  app.post('/api/register', registerController);

  const PORT = process.env.PORT || 5000;
  app.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`.blue.bold);
  });
};

main().catch((err) => {
  console.error(err);
});

import express from 'express';
import morgan from 'morgan';
import cors from 'cors';
import 'colors';

const main = async () => {
  const app = express();

  app.use(cors());

  app.use(morgan('dev'));

  app.get('/', (_, res) => {
    res.status(200).json({ success: true, message: 'API up and running' });
  });

  const PORT = process.env.PORT || 5000;
  app.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`.blue.bold);
  });
};

main().catch((err) => {
  console.error(err);
});

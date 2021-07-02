import fastify from 'fastify';
import 'colors';

const main = async () => {
  const app = fastify();
  app.register(require('./routes'));

  const PORT = process.env.PORT || 5000;
  app.listen(PORT, () => {
    console.log(`Server started at port ${PORT}`.blue.bold);
  });
};

main().catch((err) => {
  console.error(err);
});

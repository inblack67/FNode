import {
  DoneFuncWithErrOrRes,
  FastifyInstance,
  RegisterOptions,
} from 'fastify';

const rootRoute = (
  app: FastifyInstance,
  _options: RegisterOptions,
  done: DoneFuncWithErrOrRes,
) => {
  app.get('/', (_req, res) => {
    res.send({ success: true, message: 'API up and running' });
  });
  done();
};

export default rootRoute;

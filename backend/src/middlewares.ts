import { Request, Response, NextFunction } from 'express';
import { NOT_AUTHENTICATED, NOT_AUTHORIZED } from './constants';
import { ILocals } from './interfaces';

export const populateLocals =
  ({ prisma, redis }: Omit<ILocals, 'session'>) =>
  (req: Request, res: Response<any, ILocals>, next: NextFunction) => {
    res.locals['prisma'] = prisma;
    res.locals['redis'] = redis;
    res.locals['session'] = req.session;
    next();
  };

export const protect = (
  _req: Request,
  res: Response<any, ILocals>,
  next: NextFunction,
) => {
  if (res.locals.session.username) {
    next();
  } else {
    res.status(400).json({ success: false, error: NOT_AUTHENTICATED });
  }
};

export const neglect = (
  _req: Request,
  res: Response<any, ILocals>,
  next: NextFunction,
) => {
  if (res.locals.session.username) {
    res.status(400).json({ success: false, error: NOT_AUTHORIZED });
  } else {
    next();
  }
};

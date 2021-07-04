import { Request, Response, NextFunction } from 'express';
import { ILocals } from './interfaces';

export const populateLocals =
  ({ prisma }: ILocals) =>
  (_req: Request, res: Response<any, ILocals>, next: NextFunction) => {
    res.locals['prisma'] = prisma;
    next();
  };

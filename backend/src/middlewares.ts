import { Request, Response, NextFunction } from 'express';
import { NOT_AUTHENTICATED, NOT_AUTHORIZED } from './constants';
import { decryptMe } from './encryption';
import { ILocals, INativeSession } from './interfaces';

export const populateLocals =
  ({ prisma, redis, socket }: Omit<ILocals, 'session'>) =>
  (req: Request, res: Response<any, ILocals>, next: NextFunction) => {
    res.locals['prisma'] = prisma;
    res.locals['redis'] = redis;
    res.locals['socket'] = socket;
    res.locals['session'] = req.session;
    next();
  };

export const nativeProtect = async (
  req: Request,
  res: Response<any, ILocals>,
  next: NextFunction,
) => {
  if (req.headers.authorization?.startsWith('Bearer')) {
    const token = req.headers.authorization.split(' ')[1];
    const ivString = await res.locals.redis.get(token);
    if (ivString) {
      const tokenPayload: INativeSession = JSON.parse(
        decryptMe(token, ivString),
      );
      if (tokenPayload.user) {
        res.locals['current_user'] = tokenPayload.user;
        res.locals['current_user_token'] = token;
        next();
        return;
      }
    }
  }
  res.status(400).json({ success: false, error: NOT_AUTHENTICATED });
};

export const nativeNeglect = async (
  req: Request,
  res: Response<any, ILocals>,
  next: NextFunction,
) => {
  if (req.headers.authorization?.startsWith('Bearer')) {
    const token = req.headers.authorization.split(' ')[1];
    const ivString = await res.locals.redis.get(token);
    if (ivString) {
      const tokenPayload: INativeSession = JSON.parse(
        decryptMe(token, ivString),
      );

      if (tokenPayload.user) {
        res.status(400).json({ success: false, error: NOT_AUTHORIZED });
        return;
      }
    }
  } else {
    next();
  }
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

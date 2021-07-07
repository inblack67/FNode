import { NextFunction, Response, Request } from 'express';
import { ILocals } from '../interfaces';

export const nativeGetMeController = (
  _req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  const data = {
    username: res.locals.current_user?.username,
  };
  res.status(200).json({ success: true, data });
};

export const getMeController = (
  _req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  const data = {
    username: res.locals.session.username,
  };
  res.status(200).json({ success: true, data });
};

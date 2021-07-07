import { NextFunction, Response, Request } from 'express';
import { INTERNAL_SERVER_ERROR, LOGOUT_SUCCESSFUL } from '../constants';
import { ILocals } from '../interfaces';

export const nativeLogoutController = async (
  _req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  if (res.locals.current_user_token) {
    await res.locals.redis.del(res.locals.current_user_token);
    res.status(200).json({ success: true, message: LOGOUT_SUCCESSFUL });
  } else {
    res.status(500).json({ success: false, message: INTERNAL_SERVER_ERROR });
  }
};

export const logoutController = (
  _req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  res.locals.session.destroy((err) => {
    if (err) {
      console.log(`Error destroying session`.red.bold);
      console.error(err);
      res.status(500).json({ success: false, message: INTERNAL_SERVER_ERROR });
    } else {
      res.status(200).json({ success: true, message: LOGOUT_SUCCESSFUL });
    }
  });
};

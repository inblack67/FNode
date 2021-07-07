import { Request, Response, NextFunction } from 'express';
import Argon from 'argon2';
import crypto from 'crypto';
import { loginSchema } from '../schema';
import { ValidationError } from 'yup';
import { ILocals, INativeSession } from '../interfaces';
import {
  INTERNAL_SERVER_ERROR,
  INVALID_CREDENTIALS,
  LOGIN_SUCCESSFUL,
} from '../constants';
import { encryptMe } from '../encryption';

export const nativeLoginController = async (
  req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  const body = req.body;
  try {
    const validationRes = await loginSchema.validate(body);

    const user = await res.locals.prisma.user.findUnique({
      where: {
        username: validationRes.username,
      },
    });

    if (!user) {
      res.status(400).json({ success: false, error: INVALID_CREDENTIALS });
      return;
    }

    const isCorrectPassword = await Argon.verify(
      user.password,
      validationRes.password,
    );

    if (!isCorrectPassword) {
      res.status(400).json({ success: false, error: INVALID_CREDENTIALS });
      return;
    }

    const iv = crypto.randomBytes(16);
    const ivString = iv.toString('hex').slice(0, 16);

    const tokenPayload: INativeSession = {
      user,
    };

    const tokenPayloadJSON = JSON.stringify(tokenPayload);

    const token = encryptMe(tokenPayloadJSON, ivString);

    await res.locals.redis.set(token, ivString, 'ex', 60 * 24); // expires after one hour

    res.status(200).json({
      success: true,
      message: LOGIN_SUCCESSFUL,
      data: {
        token,
      },
    });
  } catch (err: any) {
    const isValidationError = err instanceof ValidationError;
    if (isValidationError) {
      const validationErrors = err as ValidationError;
      res
        .status(400)
        .json({ success: false, error: { errors: validationErrors.errors } });
      return;
    } else {
      console.log(`Login Controller Crashed`.red.bold);
      console.error(err);
      res.status(500).json({ success: false, error: INTERNAL_SERVER_ERROR });
      return;
    }
  }
};

export const loginController = async (
  req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  const body = req.body;
  try {
    const validationRes = await loginSchema.validate(body);

    const user = await res.locals.prisma.user.findUnique({
      where: {
        username: validationRes.username,
      },
    });

    if (!user) {
      res.status(400).json({ success: false, error: INVALID_CREDENTIALS });
      return;
    }

    const isCorrectPassword = await Argon.verify(
      user.password,
      validationRes.password,
    );

    if (!isCorrectPassword) {
      res.status(400).json({ success: false, error: INVALID_CREDENTIALS });
      return;
    }

    res.locals.session['user_id'] = user.id;
    res.locals.session['username'] = user.username;

    res.status(200).json({ success: true, message: LOGIN_SUCCESSFUL });
  } catch (err: any) {
    const isValidationError = err instanceof ValidationError;
    if (isValidationError) {
      const validationErrors = err as ValidationError;
      res
        .status(400)
        .json({ success: false, error: { errors: validationErrors.errors } });
      return;
    } else {
      console.log(`Login Controller Crashed`.red.bold);
      console.error(err);
      res.status(500).json({ success: false, error: INTERNAL_SERVER_ERROR });
      return;
    }
  }
};

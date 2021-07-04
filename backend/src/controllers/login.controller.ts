import { Request, Response, NextFunction } from 'express';
import { loginSchema } from '../schema';
import { ValidationError } from 'yup';
import { ILocals } from '../interfaces';
import {
  INTERNAL_SERVER_ERROR,
  INVALID_CREDENTIALS,
  LOGIN_SUCCESSFUL,
} from '../constants';
import Argon from 'argon2';

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

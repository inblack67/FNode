import { Request, Response, NextFunction } from 'express';
import { registerSchema } from '../schema';
import { ValidationError } from 'yup';
import { ILocals } from '../interfaces';
import { INTERNAL_SERVER_ERROR, REGISTRATION_SUCCESSFUL } from '../constants';
import Argon from 'argon2';

export const registerController = async (
  req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  const body = req.body;
  try {
    const validationRes = await registerSchema.validate(body);

    const hashedPassword = await Argon.hash(validationRes.password);

    await res.locals.prisma.user.create({
      data: { ...validationRes, password: hashedPassword },
    });

    res.status(201).json({ success: true, message: REGISTRATION_SUCCESSFUL });
  } catch (err: any) {
    const isValidationError = err instanceof ValidationError;
    if (isValidationError) {
      const validationErrors = err as ValidationError;
      res
        .status(400)
        .json({ success: false, error: { errors: validationErrors.errors } });
      return;
    } else {
      console.log(`Register Controller Crashed`.red.bold);
      console.error(err);
      res.status(500).json({ success: false, error: INTERNAL_SERVER_ERROR });
    }
  }
};

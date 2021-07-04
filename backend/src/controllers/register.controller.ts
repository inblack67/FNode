import { Request, Response, NextFunction } from 'express';
import { registerSchema } from '../schema';
import { ValidationError } from 'yup';
import { ILocals } from '../interfaces';

export const registerController = async (
  req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  const body = req.body;
  try {
    const validationRes = await registerSchema.validate(body);
    const user = await res.locals.prisma.user.create({
      data: { ...validationRes },
    });
    res.status(201).json({ success: true, data: user });
  } catch (err: any) {
    const isValidationError = err instanceof ValidationError;
    if (isValidationError) {
      const validationErrors = err as ValidationError;
      res.status(400).json({ success: false, errors: validationErrors.errors });
      return;
    } else {
      console.log(`Register Controller Crashed`.red.bold);
      console.error(err);
    }
  }
};

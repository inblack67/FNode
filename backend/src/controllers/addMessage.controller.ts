import { MessageType } from '@prisma/client';
import { NextFunction, Response, Request } from 'express';
import { ValidationError } from 'yup';
import { INTERNAL_SERVER_ERROR } from '../constants';
import { ILocals, IMessage } from '../interfaces';
import { addMessageSchema } from '../schema';

export const addMessageController = async (
  req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  try {
    const validationRes = await addMessageSchema.validate(req.body);
    const newMessageData: IMessage = {
      userId: res.locals.current_user!.id,
      content: validationRes.content,
    };
    if (validationRes.type) {
      newMessageData['type'] = validationRes.type;
    }
    await res.locals.prisma.message.create({
      data: {
        userId: res.locals.current_user!.id,
        content: validationRes.content,
        type: (validationRes.type as MessageType) ?? 'text',
      },
    });
    res.status(201).json({ success: true });
  } catch (err: any) {
    const isValidationError = err instanceof ValidationError;
    if (isValidationError) {
      const validationErrors = err as ValidationError;
      res
        .status(400)
        .json({ success: false, error: { errors: validationErrors.errors } });
    } else {
      console.log(`Add Message Controller Crashed`.red.bold);
      console.error(err);
      res.status(500).json({ success: false, error: INTERNAL_SERVER_ERROR });
    }
  }
};

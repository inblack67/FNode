import { NextFunction, Response, Request } from 'express';
import { INTERNAL_SERVER_ERROR } from '../constants';
import { ILocals } from '../interfaces';

export const getMessagesController = async (
  _req: Request,
  res: Response<any, ILocals>,
  _next: NextFunction,
) => {
  try {
    const messages = await res.locals.prisma.message.findMany({
      select: {
        content: true,
        id: true,
        type: true,
        User: {
          select: {
            username: true,
            id: true,
          },
        },
      },
    });
    res.status(200).json({ success: true, data: { messages } });
  } catch (err) {
    console.log(`Get Messages Controller Crashed`.red.bold);
    console.error(err);
    res.status(500).json({ success: false, error: INTERNAL_SERVER_ERROR });
  }
};

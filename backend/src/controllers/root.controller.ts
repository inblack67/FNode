import { Request, Response, NextFunction } from 'express';

export const pongController = (_req: Request, res: Response, _next: NextFunction) => {
  res.status(200).json({ success: true, message: 'API up and running' });
};

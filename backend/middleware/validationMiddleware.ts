import { Request, Response, NextFunction } from 'express'
import { z, ZodError } from 'zod'

export function validateData(schema: z.ZodObject<any, any>) {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      schema.parse(req.body)
      next()
    } catch (error) {
      if (error instanceof ZodError) {
        res.status(400).json({ errors: error.errors })
      }
      next(error)
    }
  }
}

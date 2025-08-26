import { z } from 'zod'

export const userLoginSchema = z.object({
  name: z.string(),
  email: z.string().email(),
})

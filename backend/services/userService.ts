import { PrismaClient } from '@prisma/client'
import jwt from 'jsonwebtoken'

const prisma = new PrismaClient()
const SECRET_KEY = process.env.JWT_SECRET || 'luli'

interface User {
  id: string
  email: string
  name: string
  photoURL: string
}

export const getUser = async (userId: string): Promise<User | null> => {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      email: true,
      name: true,
      photoURL: true,
    },
  })

  return user
}

export const login = async (email: string, name: string, photoURL: string) => {
  let user = await prisma.user.findUnique({ where: { email } })

  if (!user) {
    user = await prisma.user.create({
      data: {
        name: name,
        email: email,
        photoURL: photoURL,
      },
    })
  }

  const token = jwt.sign({ id: user.id, email: user.email }, SECRET_KEY)

  return token
}

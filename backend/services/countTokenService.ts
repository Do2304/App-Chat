import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

export const countUseToken = async (userId: string, totalToken: number) => {
  try {
    await prisma.user.update({
      where: { id: userId },
      data: {
        token: {
          increment: totalToken,
        },
      },
    })
  } catch (error) {
    console.error('Error updating token:', error)
  }
}

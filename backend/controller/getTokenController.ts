import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export const getTotalToken = async (req, res) => {
  const { id } = req.params

  try {
    const user = await prisma.user.findUnique({
      where: { id: id },
      select: { token: true },
    })
    if (user) {
      const totalTokens = 5510
      const usedTokens = user.token || 0
      const remainingTokens = totalTokens - usedTokens

      return res.json({ used: usedTokens, remaining: remainingTokens })
    } else {
      return res.status(404).json({ error: 'User not found' })
    }
  } catch (error) {
    console.error(error)
    return res.status(500).json({ error: 'An error occurred' })
  }
}

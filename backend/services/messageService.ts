import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export const createUserMessage = async (
  conversationId: string,
  messages: string,
) => {
  await prisma.message.create({
    data: {
      conversationId: conversationId,
      content: messages,
      role: 'User',
    },
  })
}

export const createAssistantMessage = async (
  conversationId: string,
  fullMessage: string,
  citations: string[],
) => {
  await prisma.message.create({
    data: {
      conversationId: conversationId,
      content: fullMessage,
      citations: citations,
      role: 'Assistant',
    },
  })
}

export const getMessagesById = async (
  conversationId: string,
  userId: string,
): Promise<{ content: string; role: string }[]> => {
  const messages = await prisma.message.findMany({
    where: {
      conversationId: conversationId,
      conversation: {
        userId: userId,
      },
    },
    select: {
      content: true,
      role: true,
      citations: true,
    },
    orderBy: {
      createdAt: 'asc',
    },
  })

  if (messages.length === 0) {
    throw new Error('No messages found')
  }

  return messages
}

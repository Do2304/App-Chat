import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export const findConversation = async (conversationId: string) => {
  const conversation = await prisma.conversation.findUnique({
    where: {
      id: conversationId,
    },
  })

  return conversation
}

export const createNewConversation = async (
  conversationId: string,
  userId: string,
  message: string,
) => {
  await prisma.conversation.create({
    data: {
      id: conversationId,
      title: message.slice(0, 20) + '...' || 'New Chat',
      user: {
        connect: { id: userId },
      },
    },
  })
}

export const getListConversation = async (userId: string) => {
  const listConversationId = await prisma.conversation.findMany({
    where: {
      user: {
        id: userId,
      },
    },
    orderBy: {
      createdAt: 'desc',
    },
    select: {
      title: true,
      id: true,
    },
  })

  return listConversationId
}

export const renameConversationById = async (id: string, newTitle: string) => {
  const getConversationId = await prisma.conversation.findUnique({
    where: { id: id },
  })
  if (!getConversationId) {
    throw new Error('Conversation not found')
  }
  const updatedConversation = await prisma.conversation.update({
    where: { id: id },
    data: { title: newTitle },
  })

  return updatedConversation
}

export const deleteConversationById = async (id: string) => {
  const conversation = await prisma.conversation.findUnique({
    where: { id: id },
  })
  if (!conversation) {
    throw new Error('Conversation not found')
  }
  await prisma.message.deleteMany({
    where: { conversationId: id },
  })
  await prisma.conversation.delete({
    where: { id: id },
  })

  return { message: 'Conversation deleted successfully' }
}

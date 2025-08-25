import { v4 as uuidv4 } from 'uuid'
import * as conversationService from '../services/conversationService'
import * as messageService from '../services/messageService'
import * as countTokenService from '../services/countTokenService'
import { handleWebSearchAndCrawl } from '../utils/crawl'
import { getChatOpenAIResponse } from '../services/AIService.ts/openAIService'
import { getChatGoogleGenAIResponse } from '../services/AIService.ts/googleGenAIService'
import { getChatClaudeResponse } from '../services/AIService.ts/claudeService'

export const chatUser = async (req, res) => {
  const message = JSON.parse(req.query.messages || '[]')
  const conversationId = req.query.conversationId
  const userId = req.query.userId
  const selectedModels = req.query.model
  const isSearchWeb = req.query.isSearchWeb === 'true'
  let messageContent = ''
  let citations: string[]

  try {
    const conversationExists =
      await conversationService.findConversation(conversationId)
    if (!conversationExists) {
      await conversationService.createNewConversation(
        conversationId,
        userId,
        message,
      )
    }
    await messageService.createUserMessage(conversationId, message)
    // if (isSearchWeb) {
    //   messageContent = await handleWebSearch(message)
    //   citations = await handleWebCrawl(message)
    // }
    if (isSearchWeb) {
      const data = await handleWebSearchAndCrawl(message)
      messageContent = data.messageContent
      citations = data.citations
    }

    res.setHeader('Content-Type', 'text/event-stream')
    res.setHeader('Cache-Control', 'no-cache')
    res.setHeader('Connection', 'keep-alive')

    let fullMessage = ''
    let totalToken = 0
    switch (selectedModels) {
      case 'gemini-2.5-pro':
      case 'gemini-2.5-flash': {
        const resultChatGoogleGenAI = await getChatGoogleGenAIResponse(
          selectedModels,
          isSearchWeb ? messageContent : message,
          res,
          citations,
        )
        fullMessage = resultChatGoogleGenAI.fullMessage
        totalToken = resultChatGoogleGenAI.totalToken
        break
      }
      case 'claude-opus-4':
      case 'claude-sonnet-4':
      case 'claude-haiku-3.5':
      case 'claude-sonnet-3.7': {
        const resultChatClaude = await getChatClaudeResponse(
          selectedModels,
          isSearchWeb ? messageContent : message,
          res,
          citations,
        )
        fullMessage = resultChatClaude.fullMessage
        totalToken = resultChatClaude.totalToken
        break
      }

      case 'gpt-4.1':
      case 'gpt-4.1-nano':
      case 'gpt-4o':
      case 'o4-mini': {
        const resultChatOpenAIResponse = await getChatOpenAIResponse(
          selectedModels,
          isSearchWeb ? messageContent : message,
          res,
          citations,
        )
        fullMessage = resultChatOpenAIResponse.fullMessage
        totalToken = resultChatOpenAIResponse.totalToken
        break
      }
    }

    await messageService.createAssistantMessage(
      conversationId,
      fullMessage,
      citations,
    )
    await countTokenService.countUseToken(userId, totalToken)

    res.write(`event: end\n`)
    res.write(`data: done\n\n`)
    res.end()
  } catch (error) {
    console.error('Error fetching data from OpenAI:', error)
    res.status(500).send('Error fetching data')
  }
}

export const startConversation = async (req, res) => {
  const infoUser = req.user
  try {
    const conversationId = uuidv4()
    res.json({ conversationId, infoUser })
  } catch (error) {
    console.error('Error starting conversation:', error)
    res
      .status(500)
      .json({ error: 'An error occurred while starting the conversation.' })
  }
}

export const getMessagesByConversationId = async (req, res) => {
  const { conversationId } = req.params
  const infoUser = req.user
  try {
    const messages = await messageService.getMessagesById(
      conversationId,
      infoUser.id.toString(),
    )
    res.json({ messages, infoUser })
  } catch (error) {
    console.error('Error fetching messages:', error)
    res
      .status(500)
      .json({ error: 'An error occurred while fetching messages.' })
  }
}

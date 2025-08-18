import express, { Router } from 'express'
import {
  chatUser,
  getMessagesByConversationId,
  startConversation,
} from '../controller/chatController'
import { authenticateToken } from '../middleware/authen/authMiddleware'

const router = express.Router()

router.post('/chat', chatUser)
router.get('/chat/stream', chatUser)
router.post('/chat/start-conversation', authenticateToken, startConversation)
router.get(
  '/chat/:conversationId',
  authenticateToken,
  getMessagesByConversationId,
)

export const ChatRoutes: Router = router

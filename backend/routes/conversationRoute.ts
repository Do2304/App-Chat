import express, { Router } from 'express'
import { authenticateToken } from '../middleware/authen/authMiddleware'
import {
  deleteConversation,
  getListConversationId,
  renameConversation,
} from '../controller/conversationController'

const router = express.Router()

router.get('/conversation', authenticateToken, getListConversationId)
router.delete('/conversation/:id', authenticateToken, deleteConversation)
router.put('/rename-conversation', authenticateToken, renameConversation)

export const ConversationRoutes: Router = router

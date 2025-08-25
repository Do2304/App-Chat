import express, { Router } from 'express'
import { authenticateToken } from '../middleware/authen/authMiddleware'
import { getTotalToken } from '../controller/getTokenController'

const router = express.Router()

router.get('/token/:id', authenticateToken, getTotalToken)

export const TokenRoutes: Router = router

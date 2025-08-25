import express, { Router } from 'express'
import { authenticateToken } from '../middleware/authen/authMiddleware'
import { getModelsOpenRouter } from '../controller/getModelsController'

const router = express.Router()

router.get('/models', authenticateToken, getModelsOpenRouter)

export const modelRoutes: Router = router

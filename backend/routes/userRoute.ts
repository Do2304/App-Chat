import express, { Router } from 'express'
import { getUsers, loginUser } from '../controller/userController'
import { authenticateToken } from '../middleware/authen/authMiddleware'
import { validateData } from '../middleware/validationMiddleware'
import { userLoginSchema } from '../schema/userSchemas'


const router = express.Router()

router.get('/users/:id', authenticateToken, getUsers)
router.post('/login', validateData(userLoginSchema), loginUser)

export const UserRoutes: Router = router

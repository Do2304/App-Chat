// file authMiddleware.js
import jwt from 'jsonwebtoken'
import { getUser } from '../../services/userService'

const SECRET_KEY = process.env.JWT_SECRET || 'luli'

export const authenticateToken = (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1]
  if (!token) return res.sendStatus(401)

  jwt.verify(token, SECRET_KEY, async (err, decoded) => {
    if (err) return res.sendStatus(403)
    const userId = decoded.id
    const user = await getUser(userId)
    // console.log(user)

    if (!user) return res.sendStatus(403)
    req.user = user
    next()
  })
}

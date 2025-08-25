import * as userService from '../services/userService'

export const getUsers = async (req, res) => {
  try {
    const userId = req.user.id
    const user = await userService.getUser(userId)
    if (!user) return res.status(404).json({ error: 'User not found' })
    res.json(user)
  } catch (error) {
    console.error('Error fetching user', error)
    res.status(500).json({ error: 'Something went wrong' })
  }
}

export const loginUser = async (req, res) => {
  const { email, name, photoURL } = req.body
  try {
    const token = await userService.login(email, name, photoURL)
    res.json({ token })
  } catch (error) {
    console.error('Error logging in', error)
    res.status(500).json({ error: 'Something went wrong' })
  }
}

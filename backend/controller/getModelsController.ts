import { fetchAvailableModels } from '../services/AIService.ts/getModelsOpenRouter'

export const getModelsOpenRouter = async (req, res) => {
  try {
    const list = await fetchAvailableModels()
    // console.log('list', list)

    res.json({ models: list })
  } catch (error) {
    console.error(error)
    return res.status(500).json({ error: 'An error occurred' })
  }
}

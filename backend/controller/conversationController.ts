import * as conversationService from '../services/conversationService'

export const getListConversationId = async (req, res) => {
  const infoUser = req.user
  const info = infoUser.id.toString()

  try {
    const listConversationId =
      await conversationService.getListConversation(info)

    res.json({ listConversationId, infoUser })
  } catch (error) {
    console.error('Error fetching list conversationId:', error)
    res
      .status(500)
      .json({ error: 'An error occurred while fetching list conversationId.' })
  }
}

export const renameConversation = async (req, res) => {
  const { id, newTitle } = req.body

  try {
    const updatedConversation =
      await conversationService.renameConversationById(id, newTitle)
    res.json(updatedConversation)
  } catch (error) {
    console.error('Error updating conversation title:', error)
    res.status(500).json({
      error: 'An error occurred while updating the conversation title.',
    })
  }
}

export const deleteConversation = async (req, res) => {
  const { id } = req.params

  try {
    const result = await conversationService.deleteConversationById(id)
    res.status(200).json(result)
  } catch (error) {
    console.error('Error deleting conversation:', error)
    res
      .status(500)
      .json({ error: 'An error occurred while deleting the conversation.' })
  }
}

import { GoogleGenAI } from '@google/genai'
const GEMINI_API_KEY = process.env.GEMINI_API_KEY

const ai = new GoogleGenAI({ apiKey: GEMINI_API_KEY })

export const getChatGoogleGenAIResponse = async (
  selectedModel,
  messages,
  res,
  citations,
) => {
  let fullMessage = ''
  let totalToken = 0
  const responseGoogleAI = await ai.models.generateContentStream({
    model: selectedModel,
    contents: messages,
  })

  for await (const chunk of responseGoogleAI) {
    // console.log('--------:', chunk)
    // console.log('hiiiii:', chunk.text)
    const message = chunk.text
    if (message) {
      fullMessage += message
      totalToken = chunk.usageMetadata.totalTokenCount
      res.write(
        `data: ${JSON.stringify({
          message,
          citations,
        })}\n\n`,
      )
    }
  }

  return { fullMessage, totalToken }
}

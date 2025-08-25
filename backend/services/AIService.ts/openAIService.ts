import OpenAI from 'openai'

const client = new OpenAI({
  apiKey: process.env.API_TOKEN,
})

export const getChatOpenAIResponse = async (
  selectedModel,
  messages,
  res,
  citations,
) => {
  let fullMessage = ''
  let totalToken = 0

  const responseChatGPT = await client.responses.create({
    model: selectedModel,
    input: messages,
    stream: true,
  })

  for await (const event of responseChatGPT) {
    if (event.type === 'response.output_text.delta') {
      const message = event.delta
      if (message) {
        fullMessage += message
        // res.write(`data: ${message}\n\n`)
        res.write(
          `data: ${JSON.stringify({
            message,
            citations,
          })}\n\n`,
        )
      }
    }
    if (event.type === 'response.completed') {
      const usage = event.response.usage
      totalToken = usage.total_tokens
    }
  }

  return { fullMessage, totalToken }
}

import { Anthropic } from '@anthropic-ai/sdk'

const anthropic = new Anthropic({ apiKey: process.env.CLAUDE_API_KEY })

export const getChatClaudeResponse = async (
  selectedModel,
  messages,
  res,
  citations,
) => {
  let fullMessage = ''
  const totalToken = 0

  const responseClaude = await anthropic.messages.create({
    model: selectedModel,
    max_tokens: 1024,
    stream: true,
    messages: [{ role: 'user', content: messages }],
  })
  console.log('responseClaude', responseClaude)

  for await (const part of responseClaude) {
    console.log('part', part)

    // const message = part?.delta?.text || ''
    const message = ''
    if (message) {
      res.write(
        `data: ${JSON.stringify({
          message,
          citations,
        })}\n\n`,
      )
      fullMessage += message
    }
  }

  return { fullMessage, totalToken }
}

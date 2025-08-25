export const getChatOpenRouter = async (
  selectedModel,
  messages,
  res,
  citations,
) => {
  let fullMessage = ''
  const totalToken = 0

  const response = await fetch(
    'https://openrouter.ai/api/v1/chat/completions',
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
        'Content-Type': 'application/json',
        Accept: 'text/event-stream',
      },
      body: JSON.stringify({
        model: selectedModel,
        messages: [{ role: 'user', content: messages }],
        stream: true,
      }),
    },
  )
  const reader = response.body?.getReader()
  if (!reader) {
    throw new Error('Response body is not readable')
  }

  const decoder = new TextDecoder()
  let buffer = ''

  while (true) {
    const { done, value } = await reader.read()
    if (done) break

    buffer += decoder.decode(value, { stream: true })

    while (true) {
      const lineEnd = buffer.indexOf('\n')
      if (lineEnd === -1) break

      const line = buffer.slice(0, lineEnd).trim()
      buffer = buffer.slice(lineEnd + 1)

      if (line.startsWith('data: ')) {
        const data = line.slice(6)
        if (data === '[DONE]') {
          break
        }
        const parsed = JSON.parse(data)
        const message = parsed.choices[0].delta.content
        fullMessage += message
        // res.write(`data: ${content}\n\n`);
        res.write(
          `data: ${JSON.stringify({
            message,
            citations,
          })}\n\n`,
        )
      }
    }
  }
  return { fullMessage, totalToken }
}

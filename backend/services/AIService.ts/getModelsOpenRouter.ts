export async function fetchAvailableModels(): Promise<
  { id: string; name: string }[]
> {
  try {
    const openRouterResponse = await fetch(
      'https://openrouter.ai/api/v1/models',
      {
        headers: {
          Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
        },
      },
    )

    if (!openRouterResponse.ok) {
      throw new Error(`HTTP error: ${openRouterResponse.status}`)
    }

    const data = await openRouterResponse.json()
    // console.log('Fetched models:', data.data)
    return data.data as { id: string; name: string }[]
  } catch (error) {
    console.error('Failed to fetch models from OpenRouter:', error)
  }
}

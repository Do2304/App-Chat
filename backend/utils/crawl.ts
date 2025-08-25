import axios from 'axios'
import * as cheerio from 'cheerio'

const crawlWebData = async (query) => {
  const response = await axios.get(
    'https://www.googleapis.com/customsearch/v1',
    {
      params: {
        key: process.env.GOOGLE_API_KEY,
        cx: process.env.GOOGLE_SEARCH_ENGINE_ID,
        q: query,
      },
    },
  )
  return response.data.items.slice(0, 5)
}

const fetchAndCleanPage = async (url) => {
  const page = await axios.get(url)
  const $ = cheerio.load(page.data)

  $(
    'script, style, noscript, iframe, svg, canvas, meta, link, head, title, object, embed, picture, source, audio, video, track, map, area, base, param, template, menu, menuitem',
  ).remove()

  const text = $('body').text()
  return text.replace(/\s+/g, ' ').trim()
}

export const handleWebSearchAndCrawl = async (message) => {
  const crawlResult = await crawlWebData(message)
  const allContexts = []
  const allLinks = []
  const allTitles = []
  const citations = []

  for (const item of crawlResult) {
    const url = item.link
    const title = item.title
    const cleanText = await fetchAndCleanPage(url)

    allContexts.push(cleanText)
    allLinks.push(url)
    allTitles.push(title)

    citations.push({
      title: title,
      link: url,
      context: cleanText,
    })
  }

  const messageContent =
    `${message}\n\nHere is the context:\n\n` +
    allLinks
      .map(
        (link, index) =>
          `link: ${link}\n\n title: ${allTitles[index]}\n\n context: ${allContexts[index].substring(0, 900)}`,
      )
      .join('\n\n------------------\n\n')

  return { messageContent, citations }
}

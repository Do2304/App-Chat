import express, { Express } from 'express'
import dotenv from 'dotenv'
import main from './routes/indexRoutes'
import cors from 'cors'

dotenv.config()
const app: Express = express()
const port: number | string = process.env.PORT
// app.use(cors())
const corsOptions = {
  exposedHeaders: 'X-Conversation-Id',
}

app.use(cors(corsOptions))
app.use(express.json())

main(app)

app.listen(port, () => {
  console.log(`App listening on port ${port}`)
})

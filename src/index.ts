import * as cors from 'cors'
import * as dotenv from 'dotenv'
import * as express from 'express'

import { json, urlencoded } from 'body-parser'

import { router } from './routes'

dotenv.config()

const setup = async () => {
  const app = express()

  app.use(cors())

  app.use(json())
  app.use(urlencoded({ extended: true }))

  app.use('/api/', router)

  app.get('/', async (req, res) => {
    try {
      res.send(`
      <h3>Endpoints</h3>
      <ul>
        ${['login']
          .map((v) => `<li><a href="api/auth/${v}">/api/auth/${v}</a></li>`)
          .join('')}
        ${['events', 'project', 'issue', 'getissue', 'search']
          .map((v) => `<li><a href="api/jira/${v}">/api/jira/${v}</a></li>`)
          .join('')}
      </ul>
      `)
    } catch (error) {
      res.status(500).send(error)
    }
  })

  app.listen(process.env.PORT, () => {
    console.log(`Listening on port ${process.env.PORT}`)
  })
}

setup()

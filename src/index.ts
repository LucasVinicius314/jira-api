import * as cors from 'cors'
import * as dotenv from 'dotenv'
import * as express from 'express'

import { Jira } from './models/jira'

dotenv.config()

const setup = async () => {
  const app = express()

  app.use(cors())

  // app.use(json())
  // app.use(urlencoded({ extended: true }))
  // app.use('/api/', router)

  app.get('/events', async (req, res) => {
    const data = await Jira.events()

    res.json(data.data)
  })

  app.get('/issue', async (req, res) => {
    try {
      const data = await Jira.issue({ summary: 'marcelo' })

      res.json(data.data)
    } catch (error) {
      res.status(400).send(error)
    }
  })

  app.get('/getissue', async (req, res) => {
    try {
      const data = await Jira.getIssue({ id: 'LEZD-1' })

      res.json(data.data)
    } catch (error) {
      res.status(400).send(error)
    }
  })

  // https
  //   .createServer(
  //     {
  //       requestCert: true,
  //       rejectUnauthorized: true,
  //       key: fs.readFileSync('ssl/server-key.pem'),
  //       cert: fs.readFileSync('ssl/server-crt.pem'),
  //       ca: [fs.readFileSync('ssl/client-ca-crt.pem')],
  //     },
  //     app
  //   )
  //   .listen(process.env.PORT, () => {
  //     console.log(`Listening on port ${process.env.PORT}`)
  //   })

  app.listen(process.env.PORT, () => {
    console.log(`Listening on port ${process.env.PORT}`)
  })
}

setup()

import * as cors from 'cors'
import * as dotenv from 'dotenv'
import * as express from 'express'

import { json, urlencoded } from 'body-parser'

import { Jira } from './models/jira'

dotenv.config()

const setup = async () => {
  const app = express()

  app.use(cors())

  app.use(json())
  app.use(urlencoded({ extended: true }))
  // app.use('/api/', router)

  app.get('/', async (req, res) => {
    try {
      res.send(`
      <h3>Endpoints</h3>
      <ul>
        ${['events', 'project', 'issue', 'getissue', 'search']
          .map((v) => `<li><a href="/${v}">/${v}</a></li>`)
          .join('')}
      </ul>
      `)
    } catch (error) {
      res.status(500).send(error)
    }
  })

  app.get('/events', async (req, res) => {
    try {
      const data = await Jira.events()

      res.json(data.data)
    } catch (error) {
      res.status(500).send(error)
    }
  })

  app.get('/project', async (req, res) => {
    try {
      const data = await Jira.project()

      res.json(data.data)
    } catch (error) {
      res.status(500).send(error)
    }
  })

  app.get('/issue', async (req, res) => {
    try {
      const data = await Jira.issue({ summary: 'marcelo' })

      res.json(data.data)
    } catch (error) {
      res.status(500).send(error)
    }
  })

  app.get('/getissue', async (req, res) => {
    try {
      const projects = await Jira.project()

      const project = projects.data.find((v) => true)

      if (project === undefined) {
        throw 'Project not found.'
      }

      const data = await Jira.getIssue({ id: project.id })

      res.json(data.data)
    } catch (error) {
      res.status(400).send(error)
    }
  })

  app.get('/search', async (req, res) => {
    try {
      const data = await Jira.search()

      res.json(data.data)
    } catch (error) {
      res.status(400).send(error)
    }
  })

  app.listen(process.env.PORT, () => {
    console.log(`Listening on port ${process.env.PORT}`)
  })
}

setup()

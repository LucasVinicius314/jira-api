import { Jira } from '../../models/jira'
import { Router } from 'express'

export const jiraRouter = Router()

jiraRouter.get('/events', async (req, res) => {
  try {
    const data = await Jira.events()

    res.json(data.data)
  } catch (error) {
    res.status(500).send(error)
  }
})

jiraRouter.get('/project', async (req, res) => {
  try {
    const data = await Jira.project()

    res.json(data.data)
  } catch (error) {
    res.status(500).send(error)
  }
})

jiraRouter.get('/issue', async (req, res) => {
  try {
    const data = await Jira.issue({ summary: 'marcelo' })

    res.json(data.data)
  } catch (error) {
    res.status(500).send(error)
  }
})

jiraRouter.get('/getissue', async (req, res) => {
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

jiraRouter.get('/search', async (req, res) => {
  try {
    const data = await Jira.search()

    res.json(data.data)
  } catch (error) {
    res.status(400).send(error)
  }
})

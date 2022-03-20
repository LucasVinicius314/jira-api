import { HttpException } from '../../exceptions/httpexception'
import { Jira } from '../../models/jira'
import { Router } from 'express'

export const jiraRouter = Router()

jiraRouter.get('/events', async (req, res) => {
  try {
    const data = await Jira.events(req.user)

    res.json(data.data)
  } catch (error) {
    console.error(error)

    res.status(500).send(error)
  }
})

jiraRouter.get('/project', async (req, res) => {
  try {
    const user = req.user

    const data = await Jira.project(user)

    const projects = data.data

    const project = projects.find((v) => v.key === user.teamKey)

    if (project === undefined) {
      throw new HttpException(400, 'Project not found.')
    }

    res.json(project)
  } catch (error) {
    console.error(error)

    res.status(500).send(error)
  }
})

jiraRouter.get('/issue', async (req, res) => {
  try {
    const data = await Jira.issue({ summary: 'marcelo' })

    res.json(data.data)
  } catch (error) {
    console.error(error)

    res.status(500).send(error)
  }
})

jiraRouter.get('/getissue', async (req, res) => {
  try {
    const projects = await Jira.project(req.user)

    const project = projects.data.find((v) => v.key === req.user.teamKey)

    if (project === undefined) {
      throw new HttpException(400, 'Project not found.')
    }

    const data = await Jira.getIssue({ id: project.id })

    res.json(data.data)
  } catch (error) {
    console.error(error)

    res.status(400).send(error)
  }
})

jiraRouter.get('/search', async (req, res) => {
  try {
    const data = await Jira.search(req.user)

    res.json(data.data)
  } catch (error) {
    console.error(error)

    res.status(400).send(error)
  }
})

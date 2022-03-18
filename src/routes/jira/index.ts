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

jiraRouter.post('/profile', async (req, res, next) => {
  // const id = req.body.id
  // try {
  //   const user = await Models.User.findOne({
  //     attributes: {
  //       exclude: ['password', 'email'],
  //     },
  //     where: {
  //       id: id,
  //     },
  //   })
  //   res.json(user)
  // } catch (error) {
  //   next(new HttpException(400, 'Invalid data'))
  // }
})

jiraRouter.post('/validate', async (req, res, next) => {
  // try {
  //   const user = await Models.User.findOne({
  //     attributes: {
  //       exclude: ['password'],
  //     },
  //     where: {
  //       id: req.user.id,
  //     },
  //   })
  //   res.setHeader('authorization', sign(user.get()))
  //   res.json(user)
  // } catch (error) {
  //   next(new HttpException(400, 'Invalid data'))
  // }
})

jiraRouter.post('/update', async (req, res, next) => {
  // const username = req.body.username
  // const email = req.body.email
  // const password = req.body.password
  // try {
  //   const user = await Models.User.findOne({
  //     attributes: {
  //       exclude: ['password', 'email'],
  //     },
  //     where: {
  //       id: req.user.id,
  //     },
  //   })
  //   const updateObject = {
  //     username: username,
  //     email: email,
  //   }
  //   matches(username, 'string', 'Invalid username')
  //   matches(email, 'string', 'Invalid email')
  //   if (password !== undefined) {
  //     matches(password, 'string', 'Invalid password')
  //     Object.assign(updateObject, { password: sha256(password) })
  //   }
  //   const updatedUser = await user.update(updateObject)
  //   res.setHeader('authorization', sign(updatedUser.get()))
  //   res.json(user)
  // } catch (error) {
  //   next(new HttpException(400, 'Invalid data'))
  // }
})

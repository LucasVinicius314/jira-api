import * as cors from 'cors'
import * as dotenv from 'dotenv'
import * as express from 'express'

import { json, urlencoded } from 'body-parser'

import { router } from './routes'
import { sequelize } from './services/sequelize'

dotenv.config()

const setup = async () => {
  await sequelize
    .authenticate()
    .then(() => console.log('Database auth ok.'))
    .catch(console.log)

  await sequelize
    .sync({ alter: true, force: false, logging: false })
    .then(() => console.log('Database sync ok.'))
    .catch(console.log)

  const app = express()

  app.use(cors({ allowedHeaders: '*', exposedHeaders: '*' }))

  app.use(json())
  app.use(urlencoded({ extended: true }))

  app.use(express.static('public_html'))
  app.use(express.static('app/build/web'))

  app.use('/api/', router)

  const port = process.env.PORT

  if (port === undefined) throw 'Invalid port.'

  app.listen(port, () => {
    console.log(`Listening on port ${process.env.PORT}`)
  })
}

setup()

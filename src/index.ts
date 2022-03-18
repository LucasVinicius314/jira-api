import * as cors from 'cors'
import * as dotenv from 'dotenv'
import * as express from 'express'
import * as fs from 'fs'
import * as http from 'http'

import { axios } from './services/axios'

dotenv.config()

const setup = async () => {
  const url = ''

  const res = await axios.get(`${url}events`)

  ''.toLocaleLowerCase()

  // await sequelize
  //   .authenticate()
  //   .then(() => console.log('Database auth ok'))
  //   .catch(console.log)

  // await sequelize
  //   .sync({ alter: true, force: false, logging: false })
  //   .then(() => console.log('Database sync ok'))
  //   .catch(console.log)

  const app = express()

  app.use(cors())

  // app.use(json())
  // app.use(urlencoded({ extended: true }))
  // app.use('/api/', router)

  app.get('/', (req, res) => {
    res.send('aaaaa')
  })

  http
    .createServer(
      {
        // requestCert: true,
        // rejectUnauthorized: false,
        // key: fs.readFileSync('ssl/server_key.pem'),
        // cert: fs.readFileSync('ssl/server_cert.pem'),
        // ca: [fs.readFileSync('ssl/server_cert.pem')],
      },
      app
    )
    .listen(process.env.PORT, () => {
      console.log(`Listening on port ${process.env.PORT}`)
    })
}

setup()

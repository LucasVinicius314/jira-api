import { DBEntities } from '../../services/sequelize'
import { HttpException } from '../../exceptions/httpexception'
import { Op } from 'sequelize'
import { Router } from 'express'
import { sha256 } from '../../utils/crypto'
import { sign } from '../../middleware/jwt'

export const mainAuthRouter = Router()

mainAuthRouter.post('/login', async (req, res, next) => {
  const email = req.body.email
  const password = req.body.password

  try {
    const user = await DBEntities.User.findOne({
      attributes: {
        exclude: ['password', 'key'],
      },
      where: {
        [Op.and]: {
          email: email,
          password: sha256(password),
        },
      },
    })

    if (user) {
      res.setHeader('authorization', sign(user.get()))

      res.json(user)
    } else {
      next(new HttpException(400, 'User not found.'))
    }
  } catch (error) {
    next(new HttpException(400, 'Invalid login data.'))
  }
})

mainAuthRouter.post('/register', async (req, res, next) => {
  const email = req.body.email
  const password = req.body.password
  const username = req.body.username
  const key = req.body.key

  try {
    const masterKey = process.env['MASTER_KEY']

    if (masterKey === undefined || masterKey !== key) throw 'Invalid operation.'

    const user = await DBEntities.User.create({
      email: email,
      password: sha256(password),
      username: username,
    })

    res.setHeader('authorization', sign(user.get()))

    res.json(user)
  } catch (error) {
    console.log(error)
    next(new HttpException(400, 'Invalid data.'))
  }
})

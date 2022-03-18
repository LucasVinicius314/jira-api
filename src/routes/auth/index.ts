import { DBEntities } from '../../services/sequelize'
import { HttpException } from '../../exceptions/httpexception'
import { Op } from 'sequelize'
import { Router } from 'express'
import { sha256 } from '../../utils/crypto'
import { sign } from '../../middleware/jwt'

export const authRouter = Router()

authRouter.post('/login', async (req, res, next) => {
  const email = req.body.email
  const password = req.body.password

  try {
    const user = await DBEntities.User.findOne({
      attributes: {
        exclude: ['password'],
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
      next(new HttpException(400, 'User not found'))
    }
  } catch (error) {
    next(new HttpException(400, 'Invalid login data'))
  }
})

authRouter.post('/register', async (req, res, next) => {
  const email = req.body.email
  const password = req.body.password
  const username = req.body.username

  try {
    const user = await DBEntities.User.create({
      email: email,
      password: sha256(password),
      username: username,
    })

    res.setHeader('authorization', sign(user.get()))

    res.json(user)
  } catch (error) {
    console.log(error)
    next(new HttpException(400, 'Invalid data'))
  }
})

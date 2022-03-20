import { HttpException } from '../../exceptions/httpexception'
import { Router } from 'express'

export const secureAuthRouter = Router()

secureAuthRouter.get('/auth', async (req, res, next) => {
  try {
    const user = req.user

    res.json(user)
  } catch (error) {
    console.error(error)

    next(new HttpException(400, 'Invalid auth data.'))
  }
})

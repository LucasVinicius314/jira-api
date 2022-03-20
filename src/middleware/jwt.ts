import * as dotenv from 'dotenv'
import * as jwt from 'jsonwebtoken'

import { CommonEntities } from '../typescript/user'
import { HttpException } from '../exceptions/httpexception'
import { RequestHandler } from 'express'

dotenv.config()

export const validationHandler: RequestHandler = (req, res, next) => {
  try {
    const token = req.headers.authorization
    const secret = process.env.SECRET

    if (token === undefined) {
      throw new HttpException(401, 'Invalid access token.')
    }

    if (secret === undefined) {
      throw new HttpException(401, 'Invalid secret.')
    }

    const decoded = jwt.verify(
      token,
      secret
    ) as unknown as CommonEntities.UserAttributes

    req.user = decoded

    next()
  } catch (error) {
    if (error instanceof HttpException) {
      next(error)

      return
    }

    next(new HttpException(401, 'Invalid access token.'))
  }
}

export const sign = (user: CommonEntities.UserAttributes) => {
  try {
    const secret = process.env.SECRET

    if (secret === undefined) {
      throw new HttpException(401, 'Invalid secret.')
    }

    return jwt.sign(user, secret)
  } catch (error) {
    throw new HttpException(401, 'Invalid secret.')
  }
}

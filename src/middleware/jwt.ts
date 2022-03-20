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

    if (token === undefined) throw 'Invalid token.'
    if (secret === undefined) throw 'Invalid secret.'

    const decoded = jwt.verify(
      token,
      secret
    ) as unknown as CommonEntities.UserAttributes

    req.user = decoded

    next()
  } catch (error) {
    next(new HttpException(401, 'Invalid access token.'))
  }
}

export const sign = (user: CommonEntities.UserAttributes) => {
  const secret = process.env.SECRET

  if (secret === undefined) throw 'Invalid secret.'

  return jwt.sign(user, secret)
}

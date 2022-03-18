import { Router } from 'express'
import { errorHandler } from '../middleware/error'
import { jiraRouter } from './jira'
import { mainAuthRouter } from './mainauth'
import { secureAuthRouter } from './secureauth'
import { validationHandler } from '../middleware/jwt'

export const router = Router()

// open routes

router.use('/auth', mainAuthRouter)

// protected routes

router.use(validationHandler)

router.use('/auth', secureAuthRouter)

router.use('/jira', jiraRouter)

// error

router.use(errorHandler)

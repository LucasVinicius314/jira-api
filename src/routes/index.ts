import { Router } from 'express'
import { authRouter } from './auth'
import { errorHandler } from '../middleware/error'
import { jiraRouter } from './jira'
import { validationHandler } from '../middleware/jwt'

export const router = Router()

// open routes

router.use('/auth', authRouter)

// protected routes

router.use(validationHandler)

router.use('/jira', jiraRouter)

// error

router.use(errorHandler)

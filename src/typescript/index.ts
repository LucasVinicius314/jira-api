import { Entities } from './user'

declare global {
  namespace Express {
    interface Request {
      user: Entities.Common.UserAttributes
    }
  }

  namespace NodeJS {
    interface ProcessEnv {
      NODE_ENV: 'development' | 'production'
      PORT?: string
      JIRA_CREDENTIALS: string
      JIRA_URL: string
      DATABASE_URL: string
      SALT: string
    }
  }
}

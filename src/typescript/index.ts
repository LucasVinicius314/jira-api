import { CommonEntities } from './user'

declare global {
  namespace Express {
    interface Request {
      user: CommonEntities.UserAttributes
    }
  }

  namespace NodeJS {
    interface ProcessEnv {
      NODE_ENV: 'development' | 'production'
      PORT?: string
      DATABASE_URL: string
      SALT: string
    }
  }
}

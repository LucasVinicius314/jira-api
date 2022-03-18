declare global {
  namespace Express {
    interface Request {
      user: Models.User
    }
  }

  namespace NodeJS {
    interface ProcessEnv {
      NODE_ENV: 'development' | 'production'
      PORT?: string
      JIRA_CREDENTIALS: string
      JIRA_URL: string
    }
  }
}

export namespace Models {
  export type User = {
    id: number
    email: string
    password: string
    username: string
    updatedAt: Date
    createdAt: Date
  }
}

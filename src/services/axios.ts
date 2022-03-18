import * as dotenv from 'dotenv'

import Axios from 'axios'

dotenv.config()

export const axios = Axios

axios.interceptors.request.use((value) => {
  const credentials = process.env['JIRA_CREDENTIALS']

  value.headers = {
    Accept: 'application/json',
    Authorization: `Basic ${Buffer.from(credentials).toString('base64')}`,
  }

  return value
})

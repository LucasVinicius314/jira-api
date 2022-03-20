import * as dotenv from 'dotenv'

import Axios from 'axios'

dotenv.config()

export const axios = Axios

// axios.interceptors.request.use((value) => {

//   value.headers =

//   return value
// })

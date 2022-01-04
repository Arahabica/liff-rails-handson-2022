import ApiClient from '@/api/ApiClient'
import AuthMemoryStorage from '@/storage/AuthMemoryStorage'

// const baseURL = process.env.VUE_APP_API_BASE
const authStorage = new AuthMemoryStorage()
export default new ApiClient('/', authStorage)

import ApiClient from '@/api/ApiClient'
import AuthMemoryStorage from '@/storage/AuthMemoryStorage'

const authStorage = new AuthMemoryStorage()
export default new ApiClient('/', authStorage)

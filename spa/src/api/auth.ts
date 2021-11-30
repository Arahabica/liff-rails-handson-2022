import Client from '@/api/client'
import { User } from '@/types/user'
import {
  getAuthDataFromStorage,
  removeAuthDataFromStorage,
  setAuthDataFromResponse
} from '@/utils/auth-data'
import { AxiosResponse, AxiosError } from 'axios'
import { AuthHeaders } from '@/types/auth'

export const login = async (email: string, password: string): Promise<AxiosResponse<User>|undefined> => {
  return await Client.post<User>('/api/auth/sign_in', { email, password })
    .then((res: AxiosResponse<User>) => {
      const authHeaders = res.headers as AuthHeaders
      setAuthDataFromResponse(authHeaders)
      return res
    })
    .catch((err: AxiosError) => {
      return err.response
    })
}

export const logout = async ():Promise<void> => {
  const headers = getAuthDataFromStorage() as Record<string, string>
  return await Client.delete('/api/auth/sign_out', { headers })
    .then(() => {
      removeAuthDataFromStorage()
    })
}

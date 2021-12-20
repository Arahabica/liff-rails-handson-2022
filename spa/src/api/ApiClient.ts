import axios, { AxiosError, AxiosInstance, AxiosResponse } from 'axios'
import { AuthHeaders, AuthData, IAuthStorage } from '@/types/auth'
import { User } from '@/types/user'
import { Stamp } from '@/types/stamp'

export default class ApiClient {
  baseURL: string
  authStorage: IAuthStorage
  client: AxiosInstance

  constructor (baseURL: string, authStorage: IAuthStorage) {
    this.baseURL = baseURL
    this.authStorage = authStorage
    this.client = axios.create({ baseURL })
  }

  async login (email: string, password: string): Promise<AxiosResponse<User>|undefined> {
    return await this.client.post<User>('/api/auth/sign_in', { email, password })
      .then((res: AxiosResponse<User>) => {
        this.authStorage.set(res.headers as AuthData)
        return res
      })
      .catch((err: AxiosError) => {
        return err.response
      })
  }

  async logout (): Promise<void> {
    const headers = this._getRequestHeaders()
    await this.client.delete('/api/auth/sign_out', { headers })
    this.authStorage.clear()
  }

  async getStamps (): Promise<Array<Stamp>> {
    const headers = this._getRequestHeaders()
    const res = await this.client.get('/api/stamps', { headers })
    return res.data
  }

  async getNewStamp (stampId: number, activationKey: string): Promise<Stamp> {
    const headers = this._getRequestHeaders()
    const res = await this.client.get(`/api/stamps/${stampId}?act_key=${activationKey}`, { headers })
    return res.data
  }

  async pushStamp (stampId: number, activationKey: string): Promise<Array<Stamp>> {
    const headers = this._getRequestHeaders()
    const data = { stamp_id: stampId, activation_key: activationKey }
    const res = await this.client.post('/api/imprints', data, { headers })
    return res.data
  }

  // テスト用
  async clear (): Promise<Array<Stamp>> {
    const headers = this._getRequestHeaders()
    const res = await this.client.delete('/api/imprints', { headers })
    return res.data
  }

  _getRequestHeaders (): AuthHeaders {
    const headers = this.authStorage.get()
    if (!headers) {
      throw new Error('Not Authorized.')
    }
    return { ...headers, 'Content-Type': 'application/json' }
  }
}

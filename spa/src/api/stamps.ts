import Client from '@/api/client'
import { StampData } from '@/types/stamp'
import {
  getAuthDataFromStorage,
  removeAuthDataFromStorage,
  setAuthDataFromResponse
} from '@/utils/auth-data'
import { AxiosResponse, AxiosError } from 'axios'
import { AuthHeaders } from '@/types/auth'

export const getStamps = async (): Promise<Array<StampData>> => {
  const headers = getAuthDataFromStorage() as Record<string, string>
  const res = await Client.get('/api/stamps', { headers })
  return res.data
}

export const getNewStamp = async (stampId: number, activationKey: string): Promise<StampData> => {
  const headers = getAuthDataFromStorage() as Record<string, string>
  const res = await Client.get(`/api/stamps/${stampId}?act_key=${activationKey}`, { headers })
  return res.data
}

export const pushStamp = async (stampId: number, activationKey: string): Promise<Array<StampData>> => {
  const headers = getAuthDataFromStorage() as Record<string, string>
  const data = { stamp_id: stampId, activation_key: activationKey }
  const res = await Client.post('/api/imprints', data, { headers })
  return res.data
}

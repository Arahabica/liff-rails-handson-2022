import { AuthHeaders } from '@/types/auth'

export const getAuthDataFromStorage = (): AuthHeaders => {
  return {
    'access-token': localStorage.getItem('access-token'),
    client: localStorage.getItem('client'),
    expiry: localStorage.getItem('expiry'),
    uid: localStorage.getItem('uid'),
    'Content-Type': 'application/json'
  }
}

export const setAuthDataFromResponse = (authData: AuthHeaders): void => {
  if (authData['access-token'] && authData.client && authData.uid && authData.expiry) {
    localStorage.setItem('access-token', authData['access-token'])
    localStorage.setItem('client', authData.client)
    localStorage.setItem('uid', authData.uid)
    localStorage.setItem('expiry', authData.expiry)
  }
}

export const removeAuthDataFromStorage = (): void => {
  localStorage.removeItem('access-token')
  localStorage.removeItem('client')
  localStorage.removeItem('uid')
  localStorage.removeItem('expiry')
}

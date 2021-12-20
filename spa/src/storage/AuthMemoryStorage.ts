import { AuthData, IAuthStorage } from '@/types/auth'

export default class AuthMemoryStorage implements IAuthStorage {
  data: AuthData | null;

  constructor() {
    this.data = null
  }

  get(): AuthData | null {
    return this.data
  }

  set(headers: AuthData): void {
    this.data = headers
  }

  clear(): void {
    this.data = null
  }
}

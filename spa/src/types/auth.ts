export type AuthData = {
  'access-token': string;
  'uid': string;
  'client': string;
  'expiry': string;
}

export type AuthHeaders = {
  'access-token': string;
  'uid': string;
  'client': string;
  'expiry': string;
  'Content-Type': 'application/json';
}

export interface IAuthStorage {
  get: () => AuthData | null;
  set: (headers: AuthData) => void;
  clear: () => void;
}

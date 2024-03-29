export class LoginBySmsArgs {
  phone: string
  code: string
  clientUserType: string
  platformType: number
  version: string

  constructor(phone: string, code: string, clientUserType: string, platformType: number, version: string) {
    this.phone = phone
    this.code = code
    this.clientUserType = clientUserType
    this.platformType = platformType
    this.version = version

  }
}

// 定义SMS登录请求的响应数据格式
export default class LoginResponse{
  token:string
  paidMember:boolean

  constructor(token:string,
  paidMember:boolean) {
    this.token = token
    this.paidMember = paidMember
  }
}
// 用户数据

export class UserInfo {
  id: number
  nickname: string
  avatar: string
  phone: string
  childrenName: string

  constructor(id: number, nickname: string, avatar: string, phone: string, childrenName: string) {
    this.id = id
    this.nickname = nickname
    this.avatar = avatar
    this.phone = phone
    this.childrenName = childrenName

  }


}
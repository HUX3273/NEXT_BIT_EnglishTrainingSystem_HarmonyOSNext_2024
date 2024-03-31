export class Rank{
    id:number
    avatar:string
    childName:string
    duration:number
    rankNo:number
  // 本地
    isMe:boolean

  constructor(id:number,
  avatar:string,
  childName:string,
  duration:number,
  rankNo:number,
  isMe:boolean) {
    this.id = id
    this.avatar =avatar
    this.childName = childName
    this.duration = duration
    this.rankNo = rankNo
    this. isMe = isMe
  }


}
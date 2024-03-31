import { Rank } from './Rank'

export class RankList {
  currentRankNo: number
  id: number
  avatar: string
  childName: string
  currentDuration: number
  rankListList:Array<Rank>

  constructor(currentRankNo: number,
  id: number,
  avatar: string,
  childName: string,
  currentDuration: number,
  rankListList:Array<Rank>) {
    this.currentRankNo= currentRankNo
    this.id = id
    this.avatar = avatar
    this.childName = childName
    this.currentDuration = currentDuration
    this.rankListList = rankListList
  }


}
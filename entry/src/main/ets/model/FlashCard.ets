export class FlashCard {
  id: number
  word: string
  ttsUrl: string  // 发音的url链接
  phAm: string  // 美式发音
  phEn: string  // 英式发音
  cnDescription: string
  enDescription: string
  read: Boolean
  images: Array<string>
  enDescriptions: Array<string>
  cnDescriptions: Array<string>

  constructor(id: number,
  word: string,
  ttsUrl: string,  // 发音的url链接
  phAm: string , // 美式发音
  phEn: string,  // 英式发音
  cnDescription: string,
  enDescription: string,
  read: Boolean,
  images: Array<string>,
  enDescriptions: Array<string>,
  cnDescriptions: Array<string>) {
    this.id = id
    this.word = word
    this.ttsUrl =ttsUrl
    this.phAm = phAm
    this.phEn = phEn
    this.cnDescription = cnDescription
    this.enDescription = enDescription
    this.read = read
    this.images = images
    this.enDescriptions = enDescriptions
    this.cnDescriptions = cnDescriptions
  }
}
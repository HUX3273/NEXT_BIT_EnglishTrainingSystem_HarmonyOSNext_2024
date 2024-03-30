export class FlashCardConfig {
  maxNewCardPerDay:number
  maxOldCardPerDay:number
  layout:Layout

  constructor(maxNewCardPerDay:number,
  maxOldCardPerDay:number,
  layout:Layout) {
    this.maxNewCardPerDay = maxNewCardPerDay
    this.maxOldCardPerDay = maxOldCardPerDay
    this.layout = layout
  }


}


class Layout {
    showFrontWord:boolean
    showFrontTts:boolean
    showFrontCN:boolean
    showFrontPicture:boolean
    showFrontEN:boolean
    showBackWord:boolean
    showBackTts:boolean
    showBackCN:boolean
    showBackPicture:boolean
    showBackEN:boolean
    autoPlayTts:boolean

  constructor(showFrontWord:boolean,
  showFrontTts:boolean,
  showFrontCN:boolean,
  showFrontPicture:boolean,
  showFrontEN:boolean,
  showBackWord:boolean,
  showBackTts:boolean,
  showBackCN:boolean,
  showBackPicture:boolean,
  showBackEN:boolean,
  autoPlayTts:boolean) {
    this.showFrontWord = showFrontWord
    this.showFrontTts=showFrontTts
    this.showFrontCN = showFrontCN
    this.showFrontPicture = showFrontPicture
    this.showFrontEN = showFrontEN
    this.showBackWord = showBackWord
    this.showBackTts = showBackTts
    this.showBackCN = showBackCN
    this.showBackPicture =showBackPicture
    this.showBackEN = showBackEN
    this.autoPlayTts = autoPlayTts
  }

}
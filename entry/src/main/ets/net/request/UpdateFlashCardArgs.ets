export class UpdateFlashCardArgs {
  id: number
  imagesUrl: Array<string>
  reset: Boolean
  word: string

  constructor(id: number,
              imagesUrl: Array<string>,
              reset: Boolean,
              word: string) {
    this.id = id
    this.imagesUrl = imagesUrl
    this.reset = reset
    this.word = word
  }
}
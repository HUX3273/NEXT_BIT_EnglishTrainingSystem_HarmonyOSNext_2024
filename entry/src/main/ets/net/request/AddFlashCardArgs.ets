export class AddFlashCardArgs {
  word: string
  imagesUrl: Array<string>

  constructor(word: string, imagesUrl: Array<string>) {
    this.word = word
    this.imagesUrl = imagesUrl

  }
}
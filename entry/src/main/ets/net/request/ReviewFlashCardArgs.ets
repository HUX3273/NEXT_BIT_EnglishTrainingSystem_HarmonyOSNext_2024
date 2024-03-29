export class ReviewFlashCardArgs {
  id: number
  reviewResult: string

  constructor(id: number,
              reviewResult: string) {
    this.id = id
    this.reviewResult = reviewResult
  }
}
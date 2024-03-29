export class GetTrainingListArgs{
  contentType:string
  parentTreeCode:string

  constructor( contentType:string, parentTreeCode:string) {
    this.contentType = contentType
    this.parentTreeCode = parentTreeCode
  }
}
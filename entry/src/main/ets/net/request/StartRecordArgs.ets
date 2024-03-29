export class StartRecordArgs {
  resourceContentType: string
  resourceContentId: number
  studySessionNo: string

  constructor(resourceContentType: string,
              resourceContentId: number,
              studySessionNo: string) {
    this.resourceContentType = resourceContentType
    this.resourceContentId = resourceContentId
    this.studySessionNo = studySessionNo
  }
}
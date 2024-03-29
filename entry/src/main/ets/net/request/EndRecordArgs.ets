export class EndRecordArgs {
  id: number
  currentFrameTime: number

  constructor(id: number,
  currentFrameTime: number) {
    this.id = id
    this.currentFrameTime = currentFrameTime
  }
}
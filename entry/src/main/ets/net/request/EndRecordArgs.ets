export class EndRecordArgs {
  id: number
  currentFrameTime: number // 当前音/视频时间点，单位为秒，非必须

  constructor(id: number,
  currentFrameTime: number) {
    this.id = id
    this.currentFrameTime = currentFrameTime
  }
}
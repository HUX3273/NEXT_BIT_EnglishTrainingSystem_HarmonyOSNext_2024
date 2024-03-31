export class StartRecordArgs {
  resourceContentType: string // 视频 VIDEO ,音频 AUDIO ,绘本 PICTURE_BOOK ,闪卡 FLASH_CARD
  resourceContentId: number   // 内容id, 如果是文件就传文件id, 如果是闪卡就传闪卡id
  studySessionNo: string      // 学习编号，方便统计一个批次的学习记录的时长，建议使用uuid

  constructor(resourceContentType: string,
              resourceContentId: number,
              studySessionNo: string) {
    this.resourceContentType = resourceContentType
    this.resourceContentId = resourceContentId
    this.studySessionNo = studySessionNo
  }
}
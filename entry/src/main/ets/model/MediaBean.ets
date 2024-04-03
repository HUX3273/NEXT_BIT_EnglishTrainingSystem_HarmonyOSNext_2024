// 上传本地图片时使用
export class MediaBean {
  /**
   * 文件名称
   */
  public fileName: string
  /**
   * 文件大小
   */
  public fileSize: number
  /**
   * 文件类型
   */
  public fileType: string
  /**
   * 本地存储地址
   */
  public localUrl: string

  constructor(   fileName: string,
  /**
   * 文件大小
   */
   fileSize: number,
  /**
   * 文件类型
   */
   fileType: string,
  /**
   * 本地存储地址
   */
   localUrl: string,
  ) {
    this.fileName = fileName
    this.fileSize = fileSize
    this.fileType = fileType
    this.localUrl = localUrl
  }
}
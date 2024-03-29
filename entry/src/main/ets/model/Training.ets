// 练习资源数据

export class Training {
  id: number
  contentType: string
  clientUser: ClientUser
  clientUserResourceFile: ClientUserResourceFile
  fileCount: number
  isWatching: boolean
  currentFrameTime: number
  coverOssPath: string

  constructor(id: number,
              contentType: string,
              clientUser: ClientUser,
              clientUserResourceFile: ClientUserResourceFile,
              fileCount: number,
              isWatching: boolean,
              currentFrameTime: number,
              coverOssPath: string) {
    this.id = id
    this.contentType = contentType
    this.clientUser = clientUser
    this.clientUserResourceFile = clientUserResourceFile
    this.fileCount = fileCount
    this.isWatching = isWatching
    this.currentFrameTime = currentFrameTime
    this.coverOssPath = coverOssPath

  }
}

export class ClientUser {
  id: number
  loginId: string
  nickname: string
  avatar: string

  constructor(id: number,
              loginId: string,
              nickname: string,
              avatar: string) {
    this.id = id
    this.loginId = loginId
    this.nickname = nickname
    this.avatar = avatar
  }
}

export class ClientUserResourceFile {
  id: number
  fileName: string
  treeCode: string
  parentTreeCode: string
  fileType: string
  contentType: string
  isShareable: boolean
  ossPath: string
  fileExt: string
  dir: boolean
  file: boolean
  duration: number
  fileNameWithoutExt: string

  constructor(id: number,
              fileName: string,
              treeCode: string,
              parentTreeCode: string,
              fileType: string,
              contentType: string,
              isShareable: boolean,
              ossPath: string,
              fileExt: string,
              dir: boolean,
              file: boolean,
              duration: number,
              fileNameWithoutExt: string
  ) {
    this.id = id
    this.fileName = fileName
    this.treeCode = treeCode
    this.parentTreeCode = parentTreeCode
    this.fileType = fileType
    this.contentType = contentType
    this.isShareable = isShareable
    this.ossPath = ossPath
    this.fileExt = fileExt
    this.dir = dir
    this.file = file
    this.duration = duration
    this.fileNameWithoutExt = fileNameWithoutExt
  }
}


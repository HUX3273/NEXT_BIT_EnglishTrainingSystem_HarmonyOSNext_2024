import { HORIZONTAL_AUDIOS, HORIZONTAL_VIDEOS } from '../viewmodel/MultiMediaData';
import { HorizontalMultiMediaItem } from '../viewmodel/HorizontalMultiMediaItem';
import router from '@ohos.router';
import { Training } from '../model/Training';
import PreferencesUtil from '../common/database/PreferencesUtil';
import CommonConstants from '../common/constants/CommonConstants';
import http from '@ohos.net.http';
import util from '@ohos.util';
import buffer from '@ohos.buffer';


// 视频与音频
@Component
export struct MultiMediaModule {
  private moduleName: string = '';
  public token: string = '';
  @Consume training: Array<Training>;

  async aboutToAppear() {
    await PreferencesUtil.getToken().then((value) => {
      this.token = value
    });
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row }) {
        Text(this.moduleName)
          .fontSize(18)
          .fontWeight(FontWeight.Bolder)
      }
      .margin({
        left: '3.3%',
        bottom: 12,
        top: 12
      })


      Grid() {
        ForEach(this.training, (item: Training) => {
          GridItem() {
            HorizontalItem({
              imageSrc: item.coverOssPath,
              mediaSrc: item.clientUserResourceFile.ossPath,
              mediaName: item.clientUserResourceFile.fileName,
              mediaType: this.moduleName,
              mediaId: item.clientUserResourceFile.id,
              token: this.token,
            })
              .margin({ left: 8, right: 8, bottom: 10 })
              .backgroundColor("#ffffff")
              .borderRadius(24)
          }

        }, (item: HorizontalMultiMediaItem) => JSON.stringify(item))
      }
    }
    .margin({
      left: '3.3%',
      right: '3.3%'
    })
    .width('93.3%')
    .justifyContent(FlexAlign.Center)
    .borderRadius(24)
    .borderStyle(BorderStyle.Solid)
    .borderColor(Color.White)
    .backgroundColor('#ffef9494')
  }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@Component
struct HorizontalItem {
  private imageSrc: string = '';
  private mediaSrc: string = '';
  private mediaName: string = '';
  private mediaType: string = '';
  private mediaId: number = -1;
  private token: string = '';
  private subtitleText: string = '';
  private subtitleUrl: string = '';
  @State isPageLoading: Boolean = true

  aboutToAppear() {
    this.getSubtitle_HTTP()
  }

  build() {
    Column() {

      if(this.isPageLoading == true){

        Flex() {
          LoadingProgress()
            .width(150)
            .height(104)
            .margin({ left: 8, right: 5 })

          Text()
            .margin({
              top: 12,
              bottom: 12
            })
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
        }


      } else {
        Flex() {
          Image(this.imageSrc)
            .width(150)
            .height(104)
            .margin({ left: 8, right: 5 })
            .borderRadius(24)
            .backgroundColor("#ffaeabab")
          Text(this.mediaName)
            .margin({
              top: 12,
              bottom: 12
            })
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
        }


      }
    }
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: 10, top: 10 })
    .onClick(() => {
      // 点击后播放对应影片
      router.pushUrl({
        url: 'pages/SimpleMediaPlay',
        params: {
          mediaSrc: this.mediaSrc,
          mediaName: this.mediaName,
          mediaType: this.mediaType,
          mediaId: this.mediaId,
          token: this.token,
          subtitleText: this.subtitleText
        } });
    })

  }


  getSubtitle_HTTP() {
    console.info('==== 获取该视频/音频字幕文件URL')
    console.info('==== token:' + this.token)
    let url = CommonConstants.API_HOST + "client/api/userFile/subtitle/" + this.mediaId

    let httpRequest_getSubtitle = http.createHttp();
    httpRequest_getSubtitle.request(
      // 请求url地址
      url,
      {
        // 请求方式
        method: http.RequestMethod.GET,

        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Cookie': 'SESSION_ID=' + this.token,
          'Content-Type': 'application/json'
        },

      }, (err, data) => {
      if (err) {
        //请求失嫩
        console.info("==== getSubtitle_HTTP error code:" + err.code)
        console.info("==== getSubtitle_HTTP error message:" + err.message)
      } else {

        //清求成功
        let json_string = JSON.stringify(data.result)


        this.subtitleUrl = JSON.parse(json_string)

        console.info("==== 取字幕url的结果：" + this.subtitleUrl)


        this.downloadFile_HTTP()


      }


    })


  }

  downloadFile_HTTP() {
    // 根据这个  this.subtitleUrl 链接把字幕文件下载到本地
    console.info('==== 通过URL下载字幕文件')
    let url_download = this.subtitleUrl
    let httpRequest_download = http.createHttp();
    httpRequest_download.request(
      // 请求url地址
      url_download,
      {
        // 请求方式
        method: http.RequestMethod.GET,

        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段


      }, (err, data) => {
      if (err) {
        //请求失嫩
        console.info("==== downloadFile_HTTP error code:" + err.code)
        console.info("==== downloadFile_HTTP error message:" + err.message)


      } else {


        // 根据返回值的类型把下载的数据读出来
        console.info('==== 返回结果类型：'+ data.resultType)

        // string类型
        if(data.resultType == 0){
          this.subtitleText = data.result.toString()
          if (this.subtitleText != '')
            console.info('==== 字幕：' + this.subtitleText.substring(0, 100))
        }

        // arrayBuffer类型
        if(data.resultType == 2){

          let textDecoder = new util.TextDecoder("utf-8"); //解决中文乱码的问题，文件是什么编码格式括号里就写什么格式
          this.subtitleText = textDecoder.decodeWithStream(new Uint8Array(data.result as ArrayBuffer))



          if (this.subtitleText != '')
            console.info('==== 字幕：' + this.subtitleText.substring(0, 100))
        }

      }
    })

    this.isPageLoading = false

  }
}


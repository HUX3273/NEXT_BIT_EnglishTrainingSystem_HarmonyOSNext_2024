import router from '@ohos.router';
import { VideoPlayer } from './MediaPlayer';
import { TextReader } from './TextReader';
import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants';
import { SearchMyWordDialog } from './SearchMyWordDialog';
import { StudyRecord } from '../model/StudyRecord';
import { StartRecordArgs } from '../net/request/StartRecordArgs';
import { EndRecordArgs } from '../net/request/EndRecordArgs';
import GlobalProxyServer from '../common/proxy/GlobalProxyServer';
import { HttpPlayer } from './HttpsPlayer';


@Entry
@Component
struct Play {
  private mediaSrc: string = (router.getParams() as Record<string, Object>).mediaSrc as string;
  private mediaName: string = (router.getParams() as Record<string, Object>).mediaName as string;
  private mediaType: string = (router.getParams() as Record<string, Object>).mediaType as string;
  private mediaId: number = (router.getParams() as Record<string, Object>).mediaId as number;
  private subtitleText: string = (router.getParams() as Record<string, Object>).subtitleText as string;
  // private subtitleUrl: string = '';
  private startIconResource: Resource = $r('app.media.ic_play');
  // private backIconResource: Resource = $r('app.media.ic_back');
  private textFullScreen: Boolean = true;
  @State mediaPlayerHeight: string = '0%';
  @State textReaderHeight: string = '0%';
  @State exchangeFullScreenIcon: Resource = $r('app.media.up')
  controller: VideoController = new VideoController();
  @Provide isPlay: boolean = false;
  @Provide isOpacity: boolean = false;
  @Provide isLoading: boolean = false;
  @Provide progressVal: number = 0;
  @Provide flag: boolean = false;
  dialogController_searchMyWord: CustomDialogController = new CustomDialogController({
    builder: SearchMyWordDialog({}),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  private token: string = (router.getParams() as Record<string, Object>).token as string;
  private srcId: number = (router.getParams() as Record<string, Object>).mediaId as number;
  private recordId: number = -1
  studyRecord: StudyRecord = new StudyRecord(-1)


  private radio:number = 1.3

  async aboutToAppear() {
    if (this.mediaType == '我的视频') {
      this.textFullScreen = false
    } else if (this.mediaType == '我的音频') {
      this.textFullScreen = true
    }
    this.exchangeShowMode();

    this.startRecord_HTTP()

  }

  aboutToDisappear() {

    this.endRecord_HTTP()

  }

  onPageHide() {
    this.controller.pause();
    // TODO 同步该视频的播放进度到后台

  }

  build() {
    Column() {
      // 顶栏
      Row() {
        // 返回上一页
        Row() {
          Image($r('app.media.ic_back'))
            .width(30)
            .height(30)
            .margin({ left: 10 })
            .onClick(() => {
              // 页面跳转
              router.back();
            })
        }
        .width('10%')
        .height(40)

        // 展示视频标题
        Row() {
          Text(this.mediaName)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontWeight(FontWeight.Medium)
            .maxLines(1)

        }
        .height(40)
        .width('80%')
        .justifyContent(FlexAlign.Center)

        Row() {
          Image($r('app.media.search'))
            .width(26)
            .height(26)
            .margin({ right: 20 })

        }
        .height(40)
        .width('10%')
        .onClick(() => {
          // 点击右上角加号自己搜词
          this.dialogController_searchMyWord.open()

        })

        //.justifyContent(FlexAlign.Center)

      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .height("5%")

      // 视频区
      // 视频缓存播放
      Stack() {

        // if (this.mediaType == '我的视频') {
        //   if (!this.isPlay && !this.isLoading) {
        //     Image(this.startIconResource)
        //       .width(50)
        //       .height(50)
        //       .zIndex(2)
        //       .onClick(() => {
        //         this.iconOnclick();
        //       })
        //   }
        //   if (this.isLoading) {
        //     Progress({
        //       value: 0,
        //       total: 100,
        //       type: ProgressType.ScaleRing
        //     })
        //       .color(Color.Grey)
        //       .value(this.progressVal)
        //       .width(80)
        //       .style({
        //         strokeWidth: 15,
        //         scaleCount: 15,
        //         scaleWidth: 5
        //       })
        //       .zIndex(1)
        //   }
        // }


        if(this.mediaType == '我的音频'){

          VideoPlayer({
            videoSrc: this.mediaSrc,
            controller: this.controller,
            mediaType: this.mediaType
          })
            .zIndex(0)

        }

        else if(this.mediaType == '我的视频'){

          HttpPlayer({
            SRC_LIST:[this.mediaSrc],
            videoName:this.mediaSrc,
            ratio:this.radio

          })
            .backgroundColor('#5fffff')
            .zIndex(0)

        }





      }
      .height(this.mediaPlayerHeight)


      Column() {

        Flex({ direction: FlexDirection.Column }) {

          // 文本全屏or缩回按钮
          Row() {
            // Image(this.exchangeFullScreenIcon)
            //   .height(30)
            //   .width(40)
          }
          .height(20)
          .width('100%')
          .backgroundColor('#FFE6DA')
          // .onClick(() => {
          //
          //   this.exchangeShowMode();
          //
          //   this.textFullScreen = !this.textFullScreen;
          //
          // })
          .justifyContent(FlexAlign.Center)


          // 文本阅读器
          TextReader({
            videoName: this.mediaName,
            subtitleText: this.subtitleText
          })
            .height('95%')
            .width('100%')
            //.backgroundColor('#1fffff')

        }
        .height("100%")

      }
      //.backgroundColor('#f11111')
      .height(this.textReaderHeight)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  /*
     根据显示模式改变相应组件参数
   */
  exchangeShowMode() {
    if (this.textFullScreen == true) {
      if (this.mediaType == '我的音频') {
        this.mediaPlayerHeight = '5%'
        this.textReaderHeight = '90%'
        this.exchangeFullScreenIcon = $r('app.media.down')
      } else if (this.mediaType == '我的视频') {
        this.mediaPlayerHeight = '30%'
        this.textReaderHeight = '65%'
        this.exchangeFullScreenIcon = $r('app.media.down')

      }

    } else if (this.textFullScreen == false) {
      this.mediaPlayerHeight = '45%'
      this.textReaderHeight = '50%'
      this.exchangeFullScreenIcon = $r('app.media.up')

    }
  }

  /**
   * icon onclick callback
   */
  iconOnclick() {
    if (this.isPlay === true) {
      this.controller.pause()
      this.isPlay = false;
      this.isOpacity = false;
      return;
    }
    if (this.flag === true) {
      this.controller.start();
      this.isPlay = true;
      this.isOpacity = true;
    } else {
      this.isLoading = true;
      // The video loading is not complete. The loading action is displayed.
      let intervalLoading = setInterval(() => {
        if (this.progressVal >= 100) {
          this.progressVal = 0;
        } else {
          this.progressVal += 10;
        }
      }, 100)
      // The scheduled task determines whether the video loading is complete.
      let intervalFlag = setInterval(() => {
        if (this.flag === true) {
          this.controller.start();
          this.isPlay = true;
          this.isOpacity = true;
          this.isLoading = false;
          clearInterval(intervalFlag);
          clearInterval(intervalLoading);
        }
      }, 100);
    }
  }

  startRecord_HTTP() {
    console.info('==== 开始学习计时')

    let startRecordArgs: string = ''

    if (this.mediaType == '我的视频') {
      startRecordArgs = JSON.stringify(new StartRecordArgs("VIDEO", this.srcId, "test-studySessionNo-VIDEO"))
    } else if (this.mediaType == '我的音频') {
      startRecordArgs = JSON.stringify(new StartRecordArgs("AUDIO", this.srcId, "test-studySessionNo-AUDIO"))
    }

    let httpRequest_startRecord = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/studyRecord/startRecord"
    httpRequest_startRecord.request(// 请求url地址
      url,
      {
        // 请求方式
        method: http.RequestMethod.POST,

        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Cookie': 'SESSION_ID=' + this.token,
          'Content-Type': 'application/json'
        },
        // 请求的额外数据
        extraData: startRecordArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== startRecord_HTTP error code:" + err.code)
        console.info("==== startRecord_HTTP error message:" + err.message)
      } else {
        // 请求成功
        if (data.responseCode == 200) {
          console.info("==== 开始学习计时成功！")

          let json_string = JSON.stringify(data.result)
          console.info("==== startRecord_HTTP result:" + json_string)

          this.studyRecord = JSON.parse(JSON.parse(json_string))

          this.recordId = this.studyRecord.id
        } else {
          console.info("==== 开始学习计时失败！")
        }


      }

    })

  }

  endRecord_HTTP() {
    console.info('==== 结束学习计时')

    let endRecordArgs: string = JSON.stringify(new EndRecordArgs(this.recordId, 0))

    let httpRequest_endRecord = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/studyRecord/endRecord"
    httpRequest_endRecord.request(// 请求url地址
      url,
      {
        // 请求方式
        method: http.RequestMethod.POST,

        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Cookie': 'SESSION_ID=' + this.token,
          'Content-Type': 'application/json'
        },
        // 请求的额外数据
        extraData: endRecordArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== endRecord_HTTP error code:" + err.code)
        console.info("==== endRecord_HTTP error message:" + err.message)
      } else {
        // 请求成功
        if (data.responseCode == 200) {
          console.info("==== 结束学习计时成功！")

          let json_string = JSON.stringify(data.result)
          console.info("==== endRecord_HTTP result:" + json_string)
          // this.getFlashCardStudyList_HTTP()

        } else {
          console.info("==== 结束学习计时失败！")
        }


      }

    })
  }

  // getSubtitle_HTTP() {
  //   console.info('==== 获取该视频/音频字幕文件URL')
  //   console.info('==== token:'+this.token)
  //   let url = CommonConstants.API_HOST + "client/api/userFile/subtitle/" + this.mediaId
  //
  //   let httpRequest_getSubtitle = http.createHttp();
  //   httpRequest_getSubtitle.request(
  //     // 请求url地址
  //     url,
  //     {
  //       // 请求方式
  //       method: http.RequestMethod.GET,
  //
  //       // 可选，默认为60s
  //       connectTimeout: 60000,
  //       // 可选，默认为60s
  //       readTimeout: 60000,
  //       // 开发者根据自身业务需要添加header字段
  //       header: {
  //         'Cookie': 'SESSION_ID=' + this.token,
  //         'Content-Type': 'application/json'
  //       },
  //
  //     }, (err, data) => {
  //     if (err) {
  //       //请求失嫩
  //       console.info("==== getSubtitle_HTTP error code:" + err.code)
  //       console.info("==== getSubtitle_HTTP error message:" + err.message)
  //     } else {
  //
  //       //清求成功
  //       let json_string = JSON.stringify(data.result)
  //
  //
  //       this.subtitleUrl = JSON.parse(json_string)
  //
  //       console.info("==== 取字幕url的结果：" + this.subtitleUrl)
  //
  //
  //       this.downloadFile_HTTP()
  //     }
  //
  //
  //   })
  //
  //
  //
  //
  // }
  //
  //
  // downloadFile_HTTP(){
  //
  //   console.info('==== 通过URL下载字幕文件')
  //   let url_download = this.subtitleUrl
  //   let httpRequest_download = http.createHttp();
  //   httpRequest_download.request(
  //     // 请求url地址
  //     url_download,
  //     {
  //       // 请求方式
  //       method: http.RequestMethod.GET,
  //
  //       // 可选，默认为60s
  //       connectTimeout: 60000,
  //       // 可选，默认为60s
  //       readTimeout: 60000,
  //       // 开发者根据自身业务需要添加header字段
  //       header: {
  //         'Content-Type': 'application/json'
  //       },
  //
  //     }, (err, data) => {
  //     if (err) {
  //       //请求失嫩
  //       console.info("==== downloadFile_HTTP error code:" + err.code)
  //       console.info("==== downloadFile_HTTP error message:" + err.message)
  //     } else {
  //
  //
  //
  //       setTimeout(()=>{
  //         this.subtitleText = data.result.toString()
  //         if(this.subtitleText != '')
  //         console.info('==== 字幕：'+  123)
  //       },10)
  //
  //
  //
  //
  //
  //
  //
  //     }
  //   })
  //
  // }
  //

}



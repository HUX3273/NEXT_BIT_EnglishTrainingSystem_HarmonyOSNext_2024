import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants';

import { AddToShinyCardDialog } from './AddToShinyCard';
import { FlashCard } from '../model/FlashCard';
import prompt from '@ohos.prompt';
import { promptAction } from '@kit.ArkUI';
import { TextReader } from './TextReader';


@CustomDialog
export struct WordTranslatorDialog {
  @State transResult_chinese: string = '';
  @Consume isChosenArr: Array<Boolean>;
  @Consume chosenWordIndex: number;
  @Link word: string; // 单词
  @Link token: string;
  @State flashCard: FlashCard = new FlashCard(0, '', '', '', '', '', '', false, [], [], []) //存取到单词的一系列数据
  // 发音控制器
  pronunciationController: VideoController = new VideoController();
  //新建添加到闪卡的窗口控制器
  dialogController_shinyCard: CustomDialogController = new CustomDialogController({
    builder: AddToShinyCardDialog({
      //onCancel: this.onCancel,
      //onAccept: this.onAccept,
      word: $word,
      token: $token

    }),
    cancel: this.existApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  // 本窗口自己的控制器（若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后）
  controller: CustomDialogController
  private audioSrc: string = 'http://music.163.com/song/media/outer/url?id=447925558.mp3';
  private isWordTranslatable: string = "false";

  cancel() {
    console.info('====Callback when the first button is clicked')
    //this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  confirm() {
    console.info('====Callback when the second button is clicked')
    //this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  async aboutToAppear() {
    // 前端测试方法，改成从后端获取翻译结果和音频信息
    // this.getTranslation();
    this.isWordTranslatable_HTTP()

  }

  // 在自定义组件即将析构销毁时将 dialogController_translator 删除和置空
  aboutToDisappear() {
    // delete this.dialogController_shinyCard // 删除dialogController
    // this.dialogController_shinyCard = undefined // 将dialogController置空
  }

  build() {
    Column() {

      Column() {
        Row() {

          Row() {
            // 单词
            Text(this.word)
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .margin({ left: 20 })

            // 播放读音
            Column() {
              Video({
                src: this.flashCard.ttsUrl,
                controller: this.pronunciationController
              })
                .width(0)
                .height(0)
                .backgroundColor('#000000')
                .controls(false)
                .autoPlay(false)
                .objectFit(ImageFit.Contain)
                .loop(false)
                .onError(() => {
                  promptAction.showToast({
                    duration: 5000,
                    message: '请检查网络'
                  });
                })
              Image($r('app.media.pronounce'))
                .height(35)
                .width(35)
                .margin({ left: 10 })
                .onClick(() => {

                  console.info("==== 发音链接：" + this.flashCard.ttsUrl)
                  this.pronunciationController.start();
                })
            }

          }
          .height(60)


          // 添加到闪卡
          Image($r('app.media.add'))
            .height(25)
            .width(25)
            .margin({ top: 10, bottom: 10, right: 20 })
            .onClick(() => {

              // 弹出闪卡添加窗口
              this.dialogController_shinyCard.open()


            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width("100%")


        // 中文释义
        Text(this.flashCard.cnDescription)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 10, left: 20, right: 20 })


      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')


      // 单词对应的图片
      Image(this.flashCard.images[0] = '' ? " ":this.flashCard.images[0])
        .width(300)
        .height(200)
        .borderRadius(20)


      // 单词的英文释义
      Text(this.flashCard.enDescription)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 10, bottom: 20, left: 20, right: 20 })
      // TextReader({
      //   subtitleText: this.flashCard.enDescription,
      //   fontSize: 18,
      //   fontWeight:FontWeight.Medium
      // })
      //   .margin({ top: 10, bottom: 20, left: 20, right: 20 })


      // // 确认取消键
      // Flex({ justifyContent: FlexAlign.SpaceAround }) {
      //   Button('onCancel')
      //     .onClick(() => {
      //       this.controller.close()
      //       this.onCancel()
      //     }).backgroundColor(0xffffff).fontColor(Color.Black)
      //   Button('confirm')
      //     .onClick(() => {
      //       this.controller.close()
      //       this.confirm()
      //     }).backgroundColor(0xffffff).fontColor(Color.Red)
      // }.margin({ bottom: 10 })


    }
    .width("100%")

    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }

  // 判断单词是否可翻译
  isWordTranslatable_HTTP() {

    console.info("==== 判断单词是否可翻译")
    console.info("==== token:" + this.token)
    let url = CommonConstants.API_HOST + "client/api/flashcard/translatable?word=" + this.word
    let httpRequest_isWordTranslatable = http.createHttp();
    httpRequest_isWordTranslatable.request(// 请求url地址
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
        // 请求失败
        console.info("==== isWordTranslatable_HTTP error code:" + err.code)
        console.info("==== isWordTranslatable_HTTP error message:" + err.message)
      } else {

        // 请求成功
        this.isWordTranslatable = data.result as string
        console.info("==== 能否翻译：" + this.isWordTranslatable)

        if (this.isWordTranslatable == "true") {
          this.translateWord_HTTP()

        }


      }
    })

  }

  // 取单词翻译相关数据
  translateWord_HTTP() {

    console.info("==== 取单词翻译相关数据")
    console.info("==== token:" + this.token)
    let url = CommonConstants.API_HOST + "client/api/flashcard/translate?word=" + this.word
    let httpRequest_translateWord = http.createHttp();
    httpRequest_translateWord.request(// 请求url地址
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
        // 请求失败
        console.info("==== translateWord_HTTP error code:" + err.code)
        console.info("==== translateWord_HTTP error message:" + err.message)
      } else {

        // 请求成功
        let json_string = JSON.stringify(data.result)

        this.flashCard = JSON.parse(JSON.parse(json_string))

        console.info("==== 单词相关数据：" + this.flashCard.cnDescription)


      }
    })

  }

  // 接入后端后前端方案弃用，仅作前端测试
  // 调用百度翻译api获取单词的翻译
  // getTranslation() {
  //
  //   // 合成url中需要的sign
  //   var q: string = this.word
  //   var from: string = 'en'
  //   var to: string = 'zh'
  //   var appid: string = '20240229001977712' //自己账户的app id
  //
  //   var salt: string //盐，随机数就行
  //   var rand = cryptoFramework.createRandom();
  //   rand.generateRandom(1, (err, randData) => {
  //     if (err) {
  //       console.info("====[Callback] err: " + err.code);
  //     } else {
  //       console.info("====[Callback]: generate random result: " + randData.data);
  //       salt = randData.data.toString()
  //     }
  //   });
  //
  //   var token: string = 'gOD4WdYD430IqUQ2C1oY' //秘钥
  //   var sign: string = CryptoJS.MD5( appid + q + salt + token )
  //   console.info('====md5=' + sign)
  //
  //   //合成url
  //   //let testUrl = 'q=apple&from=en&to=zh&appid=20240229001977712&salt=123&sign=8372fbbb3813a255e3f62cabd17cc4ac'
  //   let requestUrl =
  //     CommonConstants.baidufanyi_base_url
  //     + 'q=' + q
  //     + '&from=' + from
  //     + '&to=' + to
  //     + '&appid=' + appid
  //     + '&salt=' + salt
  //     + '&sign=' + sign
  //
  //
  //   // 发出get请求
  //   http.createHttp().request(requestUrl, {
  //     method: http.RequestMethod.GET,
  //     connectTimeout: 60000,
  //     readTimeout: 60000
  //
  //   }, (err, data) => {
  //     if (err) {
  //       //请求失败
  //       console.info("====error code:" + err.code)
  //       console.info("====error message:" + err.message)
  //     } else {
  //       //请求成功
  //       var json_string = JSON.stringify(data.result)
  //
  //       var httpResponse = JSON.parse(JSON.parse(json_string))
  //
  //       var transResult = httpResponse.trans_result[0].dst
  //
  //       console.info("====翻译结果:" + transResult)
  //
  //       this.transResult_chinese = transResult;
  //
  //       // this.audioSrc = ''
  //     }
  //   })
  //
  // }


  // 闪卡添加界面点击了取消
  public onCancel() {
    console.info('====Callback when the first button is clicked')
    this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  // 闪卡添加界面点击了确认添加
  public onAccept() {
    console.info('====Callback when the second button is clicked')
    this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  public existApp() {
    console.info('====Click the callback in the blank area')
    this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态

  }
}

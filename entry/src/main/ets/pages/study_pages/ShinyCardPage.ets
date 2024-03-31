import router from '@ohos.router';
import http from '@ohos.net.http';
import { StudyList } from '../../model/StudyList';
import { VideoPlayer } from '../../view/MediaPlayer';
import { ShinyCardWords } from '../../viewmodel/ShinyCardWords';
import CommonConstants from '../../common/constants/CommonConstants';
import prompt from '@ohos.prompt';
import { FlashCard } from '../../model/FlashCard';
import { ReviewFlashCardArgs } from '../../net/request/ReviewFlashCardArgs';
import { promptAction } from '@kit.ArkUI';
import { TextReader } from '../../view/TextReader';
import { StudyRecord } from '../../model/StudyRecord';
import { StartRecordArgs } from '../../net/request/StartRecordArgs';
import { EndRecordArgs } from '../../net/request/EndRecordArgs';

@Entry
@Component
struct ShinyCardPage {
  @State seeAnswer: boolean = false;
  @State pageIndex: number = 0;
  @State title: string = '闪卡'
  @State reviewDone: boolean = false;
  @Provide isPlay: boolean = false;
  @Provide isOpacity: boolean = false;
  @Provide isLoading: boolean = false;
  @Provide progressVal: number = 0;
  @Provide flag: boolean = false;
  // 发音控制器
  pronunciationController: VideoController = new VideoController();
  scroller: Scroller = new Scroller();
  token: string = (router.getParams() as Record<string, Object>).token as string;
  private flashcard:FlashCard = new FlashCard(0,"","","","","","",false,[""],[],[])
  @Provide studyList: StudyList = new StudyList([ this.flashcard ], 0, 0) // 存从http获取的今日闪卡数据
  @State pageIsLoading: boolean = true;
  private reviewedCount:number = 0;

  backToMainPage(): void {
    router.replaceUrl({
      url: 'pages/MainPage',
    });
  }



  private srcId:number = -1;
  private recordId:number = -1
  studyRecord:StudyRecord = new StudyRecord(-1)

  async aboutToAppear() {

    this.reviewedCount = 0
    this.pageIndex = 0;
    this.getFlashCardStudyList_HTTP()


  }


  aboutToDisappear() {

    this.endRecord_HTTP()

  }


  build() {
    Column() {
      if(this.pageIsLoading == true){

        LoadingProgress()
          .width(100)
          .height(100)
          .margin({ top: 50 })

      } else if(this.pageIsLoading == false){

        Row() {
          // 返回
          Row() {
            Image($r('app.media.ic_back'))
              .width(30)
              .height(30)
              .margin({ left: 10 })
              .onClick(() => {
                // 页面跳转
                this.backToMainPage()
              })
          }
          .width('33.33%')
          .height(40)

          // 标题
          Row() {
            Text(this.title)
              .fontSize(25)
              .fontWeight(FontWeight.Medium)
              .fontWeight(FontWeight.Medium)

          }
          .width('33.33%')
          .height(40)
          .justifyContent(FlexAlign.Center)


          // 闪卡索引（页数）
          Row() {
            Text(this.reviewDone? " " :this.pageIndex + 1 + '/' + (this.studyList.flashcardToday - this.studyList.flashcardReadToday))
              .fontSize(25)
              .fontWeight(FontWeight.Medium)
              .fontWeight(FontWeight.Medium)

          }
          .width('33.33%')
          .height(40)
          .padding({ right: 20 })
          //.backgroundColor('#f11111')
          .justifyContent(FlexAlign.End)

        }
        .height('5%')
        //.backgroundColor('#0fffff')
        .width('100%')


        if(this.reviewDone == false){

          // 单词+发音+图片+释义+难度按钮
          Column() {

            // 单词+发音
            Row() {

              // 单词
              //Text(ShinyCardWords[this.pageIndex].word)
              Text(this.studyList.flashcards[this.pageIndex].word)
                .fontSize(50)
                .fontWeight(FontWeight.Bold)
              //.backgroundColor('#f111ff')


              // 播放读音
              // VideoPlayer({
              //   videoSrc: ShinyCardWords[this.pageIndex].audioSrc,
              //   controller: this.pronunciationController,
              //   mediaType: '我的发音'
              // })
              //   .width(55)
              //   .height(55)
              Column() {
                Video({
                  src: this.studyList.flashcards[this.pageIndex].ttsUrl,
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

                    console.info("==== 发音链接：" + this.studyList.flashcards[this.pageIndex].ttsUrl)
                    this.pronunciationController.start();
                  })
              }

            }
            .height(60)

          }
          .height('15%')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)


          // 图片+释义+难度按钮
          Column() {
            if (this.seeAnswer == true) {
              Column() {
                Image(this.studyList.flashcards[this.pageIndex].images[0])
                  .height('50%')
                  .margin({ top: 20, left: 20, right: 20, bottom: 20 })
                  .borderRadius(10)

                Image($r('app.media.sideline'))
                  .width('100%')

                Scroll(this.scroller){
                  Column() {
                    // 中文译文
                    Text(this.studyList.flashcards[this.pageIndex].cnDescription)
                      .fontSize(20)
                      .fontWeight(FontWeight.Medium)
                      .margin({ top: 20, left: 20, right: 20 })
                    // 英文译文
                    // Text(this.studyList.flashcards[this.pageIndex].enDescription)
                    //   .fontSize(20)
                    //   .fontWeight(FontWeight.Medium)
                    //   .margin({ top: 20, left: 20, right: 20 })
                    // 英文译文
                    TextReader({
                      subtitleText: this.studyList.flashcards[this.pageIndex].enDescription,
                      scroller:this.scroller,
                      fontSize: 20,
                      fontWeight:FontWeight.Medium
                    })
                      .margin({ top: 20, left: 20, right: 20 })


                  }
                  .justifyContent(FlexAlign.Start)
                  .alignItems(HorizontalAlign.Start)
                }
                .height('25%')

                Image($r('app.media.sideline'))
                  .width('100%')

                // 三个难度按钮
                Flex({ justifyContent: FlexAlign.SpaceAround }) {
                  Button('困难')
                    .fontSize(20)
                    .onClick(() => {
                      //ShinyCardWords[this.pageIndex].level = 'hard';
                      //ShinyCardWords[this.pageIndex].done = true;
                      // 通过接口传 难度 到后端
                      this.reviewFlashCard_HTTP(this.studyList.flashcards[this.pageIndex].id,"DIFFICULT")
                      this.nextShinyCard();

                    })
                    .backgroundColor('#EC5706')
                    .fontColor('#ffffff')
                    .borderRadius(10)
                    .width('30%')

                  Button('一般')
                    .fontSize(20)
                    .onClick(() => {
                      //ShinyCardWords[this.pageIndex].level = 'normal';
                      //ShinyCardWords[this.pageIndex].done = true;
                      // 通过接口传 难度 到后端
                      this.reviewFlashCard_HTTP(this.studyList.flashcards[this.pageIndex].id,"NORMAL")
                      this.nextShinyCard();
                    })
                    .backgroundColor('#FFA84E')
                    .fontColor('#ffffff')
                    .borderRadius(10)
                    .width('30%')

                  Button('容易')
                    .fontSize(20)
                    .onClick(() => {
                      //ShinyCardWords[this.pageIndex].level = 'easy';
                      //ShinyCardWords[this.pageIndex].done = true;
                      // 通过接口传 难度 到后端
                      this.reviewFlashCard_HTTP(this.studyList.flashcards[this.pageIndex].id,"EASY")
                      this.nextShinyCard();
                    })
                    .backgroundColor('#63D798')
                    .fontColor('#ffffff')
                    .borderRadius(10)
                    .width('30%')
                }
                .margin({ top: 20, bottom: 20 })
              }

            }


            if (this.seeAnswer == false) {
              Text('查看答案')
                .fontSize(25)
                .fontColor('#F07D41')
                .onClick(() => {
                  this.seeAnswer = true;
                })

            }


          }
          .height('80%')
          .width('100%')

        } else if(this.reviewDone == true){

          Text('恭喜，您已完成所有今天所有的闪卡！')

        }
      }





    }
    .height('100%')
    .width('100%')

  }


  // 转到下一个闪卡
  nextShinyCard() {

    this.reviewedCount ++

    if (this.pageIndex + 1 < (this.studyList.flashcardToday-this.studyList.flashcardReadToday)) {
      this.pageIndex = this.pageIndex + 1;

      this.seeAnswer = false;

    }

    if (this.reviewedCount == (this.studyList.flashcardToday-this.studyList.flashcardReadToday)) {
      this.reviewDone = true
    }




  }


  getFlashCardStudyList_HTTP() {

    console.info('==== 请求闪卡数据')
    let httpRequest_getFlashCardStudyList = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/flashcard/studyList"
    httpRequest_getFlashCardStudyList.request(
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
        // 请求失嫩
        console.info("==== httpRequest_getFlashCardStudyList error code:" + err.code)
        console.info("==== httpRequest_getFlashCardStudyList error message:" + err.message)
      } else {
        // 请求成功
        //let json_string = JSON.stringify(data.result)


        let tempList:StudyList = JSON.parse(data.result as string)

        if(tempList.flashcardReadToday != tempList.flashcardToday){
          this.studyList = tempList

        } else if(tempList.flashcardReadToday == tempList.flashcardToday) {
          this.reviewDone = true
        }

        this.pageIsLoading = false

        this.startRecord_HTTP()

        // console.info("==== LIST result:" + this.studyList.flashcards[0].id)
        // console.info("==== LIST result:"+this.training[0].clientUser.nickname)
        // console.info("==== LIST result:"+this.training[0].clientUserResourceFile.ossPath)

        //this.pageIndex = this.studyList.flashcardReadToday - 1

      }

    })


  }


  reviewFlashCard_HTTP( id:number ,reviewResult:string ) {

    console.info('==== 反馈闪卡难度，单词id：' + id)

    let reviewFlashCardArgs: string = JSON.stringify(new ReviewFlashCardArgs(id, reviewResult))

    let httpRequest_reviewFlashCard = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/flashcard/review"
    httpRequest_reviewFlashCard.request(
      // 请求url地址
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
        extraData: reviewFlashCardArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== reviewFlashCard_HTTP error code:" + err.code)
        console.info("==== reviewFlashCard_HTTP error message:" + err.message)
      } else {
        // 请求成功
       if(data.responseCode == 200){
         console.info("==== 反馈闪卡难度成功！")

         // this.getFlashCardStudyList_HTTP()

       } else {
         console.info("==== 反馈闪卡难度失败！")
       }


      }

    })


  }




  startRecord_HTTP(){
    console.info('==== 开始学习计时')

    let startRecordArgs: string = JSON.stringify(new StartRecordArgs("FLASH_CARD",this.studyList.flashcards[this.pageIndex].id,"test-studySessionNo-FLASH_CARD"))

    let httpRequest_startRecord = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/studyRecord/startRecord"
    httpRequest_startRecord.request(
      // 请求url地址
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
        //
        let json_string = JSON.stringify(data.result)
        console.info("==== startRecord_HTTP result:"+ json_string)
        if(data.responseCode == 200){
          console.info("==== 开始学习计时成功！")

          this.studyRecord  = JSON.parse(JSON.parse(json_string))

          this.recordId = this.studyRecord.id
        } else {
          console.info("==== 开始学习计时失败！")
        }


      }

    })

  }


  endRecord_HTTP(){
    console.info('==== 结束学习计时')

    let endRecordArgs: string = JSON.stringify(new EndRecordArgs(this.recordId,0))

    let httpRequest_endRecord = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/studyRecord/endRecord"
    httpRequest_endRecord.request(
      // 请求url地址
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

        let json_string = JSON.stringify(data.result)
        console.info("==== endRecord_HTTP result:"+ json_string)
        if(data.responseCode == 200){
          console.info("==== 结束学习计时成功！")

          // this.getFlashCardStudyList_HTTP()

        } else {
          console.info("==== 结束学习计时失败！")
        }


      }

    })
  }







}
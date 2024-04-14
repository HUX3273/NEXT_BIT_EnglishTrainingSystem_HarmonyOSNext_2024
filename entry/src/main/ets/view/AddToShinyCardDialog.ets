import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants';

import promptAction from '@ohos.promptAction';
import { AddFlashCardArgs } from '../net/request/AddFlashCardArgs';
import { FlashCard } from '../model/FlashCard';
import { UpdateFlashCardArgs } from '../net/request/UpdateFlashCardArgs';
import { MediaBean } from '../model/MediaBean';
import { MediaHelper } from '../common/utils/MediaHelper';
import { common } from '@kit.AbilityKit';
import { AddMyImageDialog } from './AddMyImageDialog';


@CustomDialog
export struct AddToShinyCardDialog {
  @State selectedIndexArr: Array<number> = [];
  @Link word: string; // 单词
  @Link token: string;
  @Link wordId: number
  @Link isFlashCardExist: Boolean
  @State httpPicSrcArr: Array<string> = []; // 存http获取的图片链接
  @State chosenPicSrcArr: Array<string> = []; // 存选中的的图片链接
  @State isChosenArr: Array<Boolean> = [
    false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false, false, false, false,
    false, false, false, false, false, false]; //存http获取的图片链接的选中信息
  private maxPicNum: number = 5;

  dialogController_myImage: CustomDialogController = new CustomDialogController({
    builder: AddMyImageDialog({
      word: $word,
      token: $token,
      wordId: $wordId,
      isFlashCardExist: $isFlashCardExist,
      mediaBean:$mediaBean

    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })

  controller: CustomDialogController // 自己的controller一定要放在最后


  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后
  onCancel() {
    console.info('====Callback when the first button is clicked')
    //this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  onAccept() {
    console.info('====Callback when the second button is clicked')
    //this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  @State mediaBean: MediaBean = new MediaBean('', 0, '', '');
  private mediaHelper: MediaHelper = new MediaHelper(getContext());
  private context = getContext(this) as common.UIAbilityContext

  async aboutToAppear() {

    this.searchImageForFlashCard_HTTP()

    //this.isFlashCardExist_HTTP()
  }

  build() {
    Column() {
      Text(this.isFlashCardExist ? '更新旧闪卡' : '添加新闪卡')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })
        .height("10%")

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Grid() {
          ForEach(this.httpPicSrcArr, (item: string, index: number) => {
            GridItem() {
              Column() {

                Stack() {
                  Checkbox()
                    .enabled(false)
                    .select(this.chosenPicSrcArr.indexOf(item) != -1 ? true : false)
                    .selectedColor('#ffff3200')
                    .zIndex(2)
                  Image(item)
                    .width(100)
                    .height(100)
                    .borderRadius(5)
                    .zIndex(0)
                }
                .alignContent(Alignment.TopStart)
                .onClick(() => {

                  console.info('====图片id：', index)

                  //item.isChosen = !item.isChosen
                  this.isChosenArr[index] = !this.isChosenArr[index]

                  let isSelectCount = 0
                  // 查已选中的数目 isSelectCount
                  for (let i = 0; i < this.httpPicSrcArr.length; i++) {
                    if (this.isChosenArr[i]) {
                      isSelectCount++
                    }
                  }

                  if (isSelectCount > this.maxPicNum) {
                    //item.isChosen = !item.isChosen
                    this.isChosenArr[index] = !this.isChosenArr[index]

                    console.info('====当前选中的超过5个了，也就是6个了，需要把已选的数据再设置回去。')
                    promptAction.showToast({ message: '最多选择5个哦' })
                    return
                  }

                  //更新显示状态
                  //ShinyCardPictures[index].isChosen = item.isChosen
                  if (this.isChosenArr[index] == true) {
                    if (this.chosenPicSrcArr.indexOf(item) == -1) {
                      this.chosenPicSrcArr.push(item) // 向数组中压入选中的图片源
                      // console.info('====压入图片 ' + index + ' ,chosenPicSrcArr：' + this.chosenPicSrcArr)

                      this.selectedIndexArr.push(index)
                      // console.info('====压入index ' + index + ' ,selectedIndexArr：' + this.selectedIndexArr)
                    }

                  } else if (this.isChosenArr[index] == false) {
                    if (this.chosenPicSrcArr.indexOf(item) != -1) {
                      this.chosenPicSrcArr.splice(this.chosenPicSrcArr.indexOf(item), 1) // 从数组中弹出取消选中的图片源
                      //  console.info('====弹出图片 ' + index + ' ,chosenPicSrcArr：' + this.chosenPicSrcArr)

                      this.selectedIndexArr.splice(this.selectedIndexArr.indexOf(index), 1)
                      // console.info('====弹出index ' + index + ' ,selectedIndexArr：' + this.selectedIndexArr)
                    }
                  }


                })

              }

              // Text(item.word)
              //   .fontSize(20)
              //   .fontWeight(FontWeight.Medium)
              //   .margin({ top: 16 })
            }
            .borderRadius(12)

          })

        }
        .columnsTemplate('1fr 1fr 1fr')
        .columnsGap(15)
        .rowsGap(15)
        .padding({ top: 10, bottom: 10, left: 10, right: 10 })

      }
      .height('60%')

      //.backgroundColor("#ffffbf00")


      Column() {
        Text("上传本地图片")
          .fontSize(15)
          .fontColor("#ff0090ff")
          .fontWeight(FontWeight.Medium)
          .margin({ top: 10 })
      }
      .width('50%')
      //.backgroundColor("#ff00ff88")
      .onClick(() => {
        // 上传自己本地的图片到闪卡库中
        console.info("==== 上传本地的图片到闪卡库中")
        this.handleClick(MediaOption.Picture)
        this.dialogController_myImage.open()
      })


      Row() {
        Button('取消')
          .fontSize(20)
          .onClick(() => {
            this.controller.close()
            this.onCancel()
          })
          .backgroundColor('#F8F8F8')
          .fontColor('#8D8D8D')
          .borderRadius(10)
          .width('30%')
          .margin({ right: 70 })
        Button('添加')
          .fontSize(20)
          .onClick(() => {

            // 添加闪卡 或 更新闪卡
            if (this.isFlashCardExist == false) {
              this.addFlashCard_HTTP(this.chosenPicSrcArr)
            } else if (this.isFlashCardExist == true) {
              this.updateFlashCard_HTTP(this.chosenPicSrcArr)
            }
            this.onAccept()
            this.controller.close()
          })
          .backgroundColor('#EC5706')
          .fontColor(Color.White)
          .borderRadius(10)
          .width('30%')
      }
      .margin({ top: 10, bottom: 20 })
      .width("100%")
      //.backgroundColor("#f11111")
      .justifyContent(FlexAlign.Center)

    }
    .height('90%')
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)

    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }

  // 取单词相关图片给用户选择
  searchImageForFlashCard_HTTP() {

    console.info("==== 取单词相关图片给用户选择")
    console.info("==== token:" + this.token)
    let url = CommonConstants.API_HOST + "client/api/flashcard/image/search?keyword=" + this.word
    let httpRequest_searchImageForFlashCard = http.createHttp();
    httpRequest_searchImageForFlashCard.request(// 请求url地址
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
        console.info("==== searchImageForFlashCard_HTTP error code:" + err.code)
        console.info("==== searchImageForFlashCard_HTTP error message:" + err.message)
      } else {

        // 请求成功
        //let json_string = JSON.stringify(data.result)
        //this.flashCard = JSON.parse(JSON.parse(json_string))
        //this.httpPicSrcArr[0] = data.result

        this.httpPicSrcArr = JSON.parse(data.result as string)

        console.info("==== 单词可选图片链接：" + this.httpPicSrcArr[0])


      }
    })

  }

  // 检查查闪卡是否存在
  isFlashCardExist_HTTP() {
    console.info('==== 添加闪卡前先检查闪卡是否存在')

    // REQUEST
    let httpRequest_isFlashCardExist = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/flashcard/byWord?word=" + this.word
    httpRequest_isFlashCardExist.request(// 请求url地址
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
        // 请求的额外数据。
        //extraData: addFlashCardArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== isFlashCardExist_HTTP error code:" + err.code)
        console.info("==== isFlashCardExist_HTTP error message:" + err.message)
      } else {
        // 请求成功
        let json_string = JSON.stringify(data.result)
        //
        let flashCardInfo: FlashCard = JSON.parse(JSON.parse(json_string))

        if (flashCardInfo.id == null) {
          this.isFlashCardExist = false // 调用 addFlashCard_HTTP
          console.info('==== 该闪卡不存在')

        } else {
          this.isFlashCardExist = true // 调用 updateFlashCard_HTTP
          console.info('==== 该闪卡已存在')
        }

      }

    }

    )

  }

  // 添加闪卡（全新单词才能用此接口）
  addFlashCard_HTTP(imagesUrl: Array<string>) {


    console.info('==== 添加闪卡')


    // BODY
    let addFlashCardArgs: string = JSON.stringify(new AddFlashCardArgs(this.word, imagesUrl))

    // REQUEST
    let httpRequest_addFlashCard = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/flashcard"
    httpRequest_addFlashCard.request(// 请求url地址
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
        // 请求的额外数据。
        extraData: addFlashCardArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== addFlashCard_HTTP error code:" + err.code)
        console.info("==== addFlashCard_HTTP error message:" + err.message)
      } else {
        // 请求成功
        // let json_string = JSON.stringify(data.result)
        //
        // this.training = JSON.parse(JSON.parse(json_string))
        // console.info("==== responseCod:" + data.responseCode)
        // console.info("==== resultType:" + data.resultType)
        // console.info("==== result:" + data.result)

        if (data.responseCode == 200) {
          console.info("==== 添加闪卡成功！")
          promptAction.showToast({
            message: "添加闪卡成功！"
          })

        } else {
          console.info("==== 添加闪卡失败")
          promptAction.showDialog({
            message: "添加失败，请稍后重试......"
          })
        }

      }

    })

  }

  // 更新闪卡的接口
  updateFlashCard_HTTP(imagesUrl: Array<string>) {


    console.info('==== 更新闪卡')


    // BODY
    let updateFlashCardArgs: string = JSON.stringify(new UpdateFlashCardArgs(this.wordId, imagesUrl, true, this.word))

    // REQUEST
    let httpRequest_addFlashCard = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/flashcard"
    httpRequest_addFlashCard.request(// 请求url地址
      url,
      {
        // 请求方式
        method: http.RequestMethod.PUT,

        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Cookie': 'SESSION_ID=' + this.token,
          'Content-Type': 'application/json'
        },
        // 请求的额外数据。
        extraData: updateFlashCardArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== updateFlashCard_HTTP error code:" + err.code)
        console.info("==== updateFlashCard_HTTP error message:" + err.message)
      } else {
        // 请求成功
        // let json_string = JSON.stringify(data.result)
        //
        // this.training = JSON.parse(JSON.parse(json_string))
        // console.info("==== responseCod:" + data.responseCode)
        // console.info("==== resultType:" + data.resultType)
        // console.info("==== result:" + data.result)

        if (data.responseCode == 200) {
          console.info("==== 更新闪卡成功！")
          promptAction.showToast({
            message: "更新闪卡成功！"
          })

        } else {
          console.info("==== 更新闪卡失败")
          promptAction.showDialog({
            message: "更新失败，请稍后重试......"
          })
        }

      }

    })


  }

  async handleClick(option: MediaOption) {
    // let mediaBean: MediaBean = new mediaBean('',0,'','');
    switch (option) {
      case MediaOption.Picture:
        this.mediaBean = await this.mediaHelper.selectPicture();
        break;
      case MediaOption.File:
        this.mediaBean = await this.mediaHelper.selectFile();
        break;
      default:
        break;
    }

  }
}


enum MediaOption {
  Picture = 0,
  File = 1,
}
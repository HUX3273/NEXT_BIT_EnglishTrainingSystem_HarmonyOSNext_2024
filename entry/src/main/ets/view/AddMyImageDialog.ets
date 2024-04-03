import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants';

import { ShinyCardPictureItem } from '../viewmodel/ChooseShinyCardPicture';
import promptAction from '@ohos.promptAction';
import { AddFlashCardArgs } from '../net/request/AddFlashCardArgs';
import { FlashCard } from '../model/FlashCard';
import { UpdateFlashCardArgs } from '../net/request/UpdateFlashCardArgs';
import { MediaBean } from '../model/MediaBean';
import { MediaHelper } from '../common/utils/MediaHelper';
import { common } from '@kit.AbilityKit';


@CustomDialog
export struct AddMyImageDialog {
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


  controller: CustomDialogController



  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后
  onCancel() {
    console.info('====Callback when the first button is clicked')
    //this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  onAccept() {
    console.info('====Callback when the second button is clicked')
    //this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  @Link mediaBean: MediaBean ;
  private mediaHelper: MediaHelper = new MediaHelper(getContext());
  private context = getContext(this) as common.UIAbilityContext

  async aboutToAppear() {

    //this.searchImageForFlashCard_HTTP()

    //this.isFlashCardExist_HTTP()
  }

  build() {
    Column() {
      Text(this.isFlashCardExist ? '更新旧闪卡' : '添加新闪卡')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })
        .height("10%")

      Column(){
        Image(this.mediaBean.localUrl)
          .width('80%').height('80%')
          .borderRadius(15)
        //.backgroundColor(Color.Grey)

      }
      .justifyContent(FlexAlign.Center)
      .width('100%').height('60%')

      Column() {

        Text("更换本地图片")
          .fontSize(15)
          .fontColor("#ff0090ff")
          .fontWeight(FontWeight.Medium)
          .margin({ top: 10 })

      }
      .onClick(() => {
        // 上传自己本地的图片到闪卡库中
        console.info("==== 上传自己本地的图片到闪卡库中")
        this.handleClick(MediaOption.Picture)
      })
      .width('50%')



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
        Button('上传')
          .fontSize(20)
          .onClick(() => {

            // // 添加闪卡 或 更新闪卡
            // if (this.isFlashCardExist == false) {
            //   this.addFlashCard_HTTP(this.chosenPicSrcArr)
            // } else if (this.isFlashCardExist == true) {
            //   this.updateFlashCard_HTTP(this.chosenPicSrcArr)
            // }

            // TODO 上传图片接口
            this.uploadImageForFlashCard_HTTP()



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

  //
  // // 添加闪卡（全新单词才能用此接口）
  // addFlashCard_HTTP(imagesUrl: Array<string>) {
  //
  //
  //   console.info('==== 添加闪卡')
  //
  //
  //   // BODY
  //   let addFlashCardArgs: string = JSON.stringify(new AddFlashCardArgs(this.word, imagesUrl))
  //
  //   // REQUEST
  //   let httpRequest_addFlashCard = http.createHttp();
  //   let url = CommonConstants.API_HOST + "client/api/flashcard"
  //   httpRequest_addFlashCard.request(// 请求url地址
  //     url,
  //     {
  //       // 请求方式
  //       method: http.RequestMethod.POST,
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
  //       // 请求的额外数据。
  //       extraData: addFlashCardArgs
  //
  //     }, (err, data) => {
  //     if (err) {
  //       // 请求失嫩
  //       console.info("==== addFlashCard_HTTP error code:" + err.code)
  //       console.info("==== addFlashCard_HTTP error message:" + err.message)
  //     } else {
  //       // 请求成功
  //       // let json_string = JSON.stringify(data.result)
  //       //
  //       // this.training = JSON.parse(JSON.parse(json_string))
  //       // console.info("==== responseCod:" + data.responseCode)
  //       // console.info("==== resultType:" + data.resultType)
  //       // console.info("==== result:" + data.result)
  //
  //       if (data.responseCode == 200) {
  //         console.info("==== 添加闪卡成功！")
  //         promptAction.showToast({
  //           message: "添加闪卡成功！"
  //         })
  //
  //       } else {
  //         console.info("==== 添加闪卡失败")
  //         promptAction.showDialog({
  //           message: "添加失败，请稍后重试......"
  //         })
  //       }
  //
  //     }
  //
  //   })
  //
  // }
  //
  // // 更新闪卡的接口
  // updateFlashCard_HTTP(imagesUrl: Array<string>) {
  //
  //
  //   console.info('==== 更新闪卡')
  //
  //
  //   // BODY
  //   let updateFlashCardArgs: string = JSON.stringify(new UpdateFlashCardArgs(this.wordId, imagesUrl, true, this.word))
  //
  //   // REQUEST
  //   let httpRequest_addFlashCard = http.createHttp();
  //   let url = CommonConstants.API_HOST + "client/api/flashcard"
  //   httpRequest_addFlashCard.request(// 请求url地址
  //     url,
  //     {
  //       // 请求方式
  //       method: http.RequestMethod.PUT,
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
  //       // 请求的额外数据。
  //       extraData: updateFlashCardArgs
  //
  //     }, (err, data) => {
  //     if (err) {
  //       // 请求失嫩
  //       console.info("==== updateFlashCard_HTTP error code:" + err.code)
  //       console.info("==== updateFlashCard_HTTP error message:" + err.message)
  //     } else {
  //       // 请求成功
  //       // let json_string = JSON.stringify(data.result)
  //       //
  //       // this.training = JSON.parse(JSON.parse(json_string))
  //       // console.info("==== responseCod:" + data.responseCode)
  //       // console.info("==== resultType:" + data.resultType)
  //       // console.info("==== result:" + data.result)
  //
  //       if (data.responseCode == 200) {
  //         console.info("==== 更新闪卡成功！")
  //         promptAction.showToast({
  //           message: "更新闪卡成功！"
  //         })
  //
  //       } else {
  //         console.info("==== 更新闪卡失败")
  //         promptAction.showDialog({
  //           message: "更新失败，请稍后重试......"
  //         })
  //       }
  //
  //     }
  //
  //   })
  //
  //
  // }
  //

  uploadImageForFlashCard_HTTP(){
    console.info('==== 闪卡图片上传')

      // BODY
      //let addFlashCardArgs: string = JSON.stringify(new AddFlashCardArgs(this.word, imagesUrl))

      // REQUEST
      let httpRequest_uploadImageForFlashCard = http.createHttp();
      let url = CommonConstants.API_HOST + "client/api/flashcard/image/upload"
    httpRequest_uploadImageForFlashCard.request(// 请求url地址
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
          //extraData: addFlashCardArgs

        }, (err, data) => {
        if (err) {
          // 请求失嫩
          console.info("==== uploadImageForFlashCard_HTTP error code:" + err.code)
          console.info("==== uploadImageForFlashCard_HTTP error message:" + err.message)
        } else {
          // 请求成功
          // let json_string = JSON.stringify(data.result)
          //
          // this.training = JSON.parse(JSON.parse(json_string))
          // console.info("==== responseCod:" + data.responseCode)
          // console.info("==== resultType:" + data.resultType)
          // console.info("==== result:" + data.result)

          if (data.responseCode == 200) {
            console.info("==== 上传闪卡图片成功！")
            promptAction.showToast({
              message: "上传闪卡图片成功！"
            })

          } else {
            console.info("==== 上传闪卡图片失败")
            promptAction.showDialog({
              message: "上传闪卡图片失败，请稍后重试......"
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
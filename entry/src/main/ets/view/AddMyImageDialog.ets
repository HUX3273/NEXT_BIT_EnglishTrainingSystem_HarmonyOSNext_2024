import promptAction from '@ohos.promptAction';
import { MediaBean } from '../model/MediaBean';
import { MediaHelper } from '../common/utils/MediaHelper';
import { common } from '@kit.AbilityKit';
import { BusinessError, request } from '@kit.BasicServicesKit';
import CommonConstants from '../common/constants/CommonConstants';
import fs from '@ohos.file.fs';

let context = getContext(this) as common.UIAbilityContext;
let cacheDir = context.cacheDir;


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

  @Link mediaBean: MediaBean;
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

      Column() {
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

  uploadImageForFlashCard_HTTP() {
    console.info('==== 闪卡图片上传')

    // console.info("==== 本地图片链接：" + this.mediaBean.localUrl)

    // 读取图片本地 uri
    let file = fs.openSync(this.mediaBean.localUrl, fs.OpenMode.CREATE);
    // 复制文件到缓存目录下
    fs.copyFileSync(file.fd, cacheDir + '/test.jpg')


    let uploadConfig: request.UploadConfig = {
      url: CommonConstants.API_HOST + "client/api/flashcard/image/upload",
      header: {
        'Accept': '*/*',
        'Cookie': 'SESSION_ID=' + this.token,
        'Content-Type': 'multipart/form-data'
      },
      method: 'POST',
      files: [
        { filename: this.word, name: 'file', uri: 'internal://cache/test.jpg', type: 'jpg' }
      ],
      data: [
        { name: 'keyword', value: this.word }
      ],
    }

    let uploadTask: request.UploadTask;

    try {
      request.uploadFile(getContext(), uploadConfig).then((data: request.UploadTask) => {
        uploadTask = data;


        uploadTask.on('progress', (uploadedSize, totalSize) => {
          console.info("==== upload totalSize:" + totalSize + "  uploadedSize:" + uploadedSize);
        })

        let headerCallback = (headers: object) => {
          console.info("==== upOnHeader headers:" + JSON.stringify(headers));
        };
        uploadTask.on('headerReceive', headerCallback);


        let upCompleteCallback = (taskStates: Array<request.TaskState>) => {
          for (let i = 0; i < taskStates.length; i++) {
            console.info("==== upOnComplete taskState:" + JSON.stringify(taskStates[i]));
          }
        };
        uploadTask.on('complete', upCompleteCallback);


        promptAction.showToast({
          message: "上传闪卡图片成功！"
        })
      }
      ).catch((err: BusinessError) => {
        console.error(`==== Failed to request the upload. Code: ${err.code}, message: ${err.message}`);
        promptAction.showDialog({
          message: "上传闪卡图片失败，请稍后重试......"
        })
      });


    } catch (err) {
      console.error(`==== Failed to request the upload. err: ${JSON.stringify(err)}`);
      promptAction.showDialog({
        message: "上传闪卡图片失败，请稍后重试......"
      })
    }


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
import router from '@ohos.router';
import PreferencesUtil from '../common/database/PreferencesUtil';
import { Training } from '../model/Training';
import { HorizontalPictureBookItem } from '../viewmodel/HorizontalMultiMediaItem';
import { HORIZONTAL_PICTUREBOOKS } from '../viewmodel/MultiMediaData';
@Component
export struct PictureBookModule {
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
              coverImgSrc: item.coverOssPath,
              bookSrc: item.clientUserResourceFile.ossPath,
              bookName: item.clientUserResourceFile.fileName,
            })
          }
          .margin({ left: 8, right: 8, bottom: 10 })
          .backgroundColor("#ffffff")
          .borderRadius(24)
        }, (item: HorizontalPictureBookItem) => JSON.stringify(item))
      }
      .columnsGap(18)


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


@Component
struct HorizontalItem {
  private coverImgSrc: string = '';
  private bookSrc: string = '';
  private bookSrcArr:Array<string> = ['']
  private bookName: string = '';
  public token: string = '';
  @State isPageLoading: Boolean = true


  async aboutToAppear() {

    this.bookSrcArr[0] = this.bookSrc

  }

  build() {
    Column() {
      Flex(){
        Image(this.coverImgSrc)
          .width(150)
          .height(104)
          .margin({ left: 8, right: 5 })
          .borderRadius(24)
          .backgroundColor("#ffd0d0d0")
        Text(this.bookName)
          .margin({
            top: 12,
            bottom: 12
          })
          .textAlign(TextAlign.Center)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
      }

    }
    .margin({ bottom: 10, top: 10 })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 点击后打开绘本
      router.pushUrl({
        url: 'pages/PictureBookReader',
        params: {
          coverImgSrc: this.coverImgSrc,
          bookSrc: this.bookSrcArr,
          bookName: this.bookName
        }
      });

    })
  }
}

import router from '@ohos.router';
import { HorizontalPictureBookItem } from '../viewmodel/HorizontalMultiMediaItem';
import { HORIZONTAL_PICTUREBOOKS } from '../viewmodel/MultiMediaData';
@Component
export struct PictureBookModule {
  private moduleName: string = '';

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
        ForEach(HORIZONTAL_PICTUREBOOKS, (item: HorizontalPictureBookItem) => {
          GridItem() {
            HorizontalItem({
              coverImgSrc: item.coverImgSrc,
              bookSrc: item.bookSrc,
              bookName: item.name,
            })
          }
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
    .backgroundColor('#FFFFFF')
  }


}


@Component
struct HorizontalItem {
  private coverImgSrc: string = '';
  private bookSrc: Array<string> = [''];
  private bookName: string = '';


  build() {
    Column() {
      Image(this.coverImgSrc)
        .width(132)
        .height(94)
        .onClick(() => {
          // TODO 点击后打开绘本
          router.pushUrl({
            url: 'pages/PictureBookReader',
            params: {
              coverImgSrc: this.coverImgSrc,
              bookSrc: this.bookSrc,
              bookName: this.bookName

            }
          });

        })
      Text(this.bookName)
        .margin({
          top: 12,
          bottom: 12
        })
        .textAlign(TextAlign.Center)
        .fontSize(16)
    }
    .justifyContent(FlexAlign.Center)
  }
}

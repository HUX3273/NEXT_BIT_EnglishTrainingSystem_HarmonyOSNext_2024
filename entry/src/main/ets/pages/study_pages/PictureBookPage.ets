import router from '@ohos.router';
import { PictureBookModule } from '../../view/PictureBookIndexModule';
@Entry
@Component
struct PictureBookPage {
  @State title: string = '绘本'


  backToMainPage():void{
    router.replaceUrl({
      url: 'pages/MainPage',
    });
  }

  build() {
    Column(){
      Row(){
        // 返回
        Row(){
          Image($r('app.media.ic_back'))
            .width(30)
            .height(30)
            .margin({left:10})
            .onClick(() => {
              // 页面跳转
              this.backToMainPage()
            })
        }
        .width('33.33%')
        .height(40)

        // 标题
        Row(){
          Text(this.title)
            .fontSize(25)
            .fontWeight(FontWeight.Medium)
            .fontWeight(FontWeight.Medium)

        }
        .width('33.33%')
        .height(40)
        .justifyContent(FlexAlign.Center)


        //


      }
      .width('100%')
      .height('5%')


      List() {
        ListItem() {
          PictureBookModule({ moduleName: '我的绘本' })
            .margin({ top: 20 })

        }

      }
      .listDirection(Axis.Vertical)
      .margin({ top: 18 })


    }
    .height('100%')

  }
}
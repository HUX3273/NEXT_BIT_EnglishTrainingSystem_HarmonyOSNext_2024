
import router from '@ohos.router';


@Entry
@Component
struct RankPage{
  @State title:string = '排名'


  backToMainPage():void{
    router.replaceUrl({
      url: 'pages/MainPage',
    });
  }

  build(){
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
    }
    .width('100%')
    .height('5%')
    ///////////////////////////////////


  }



}
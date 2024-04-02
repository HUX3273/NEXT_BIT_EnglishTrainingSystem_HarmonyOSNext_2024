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
        ForEach(this.training, (item: Training,index) => {
          GridItem() {
            HorizontalItem({
              coverImgSrc: item.coverOssPath,
              bookSrc: item.clientUserResourceFile.ossPath,
              index:index,
              bookName: item.clientUserResourceFile.fileName,
              token:this.token,
              srcId:item.clientUserResourceFile.id,
              treeCode:item.clientUserResourceFile.treeCode,
              training:$training
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



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@Component
struct HorizontalItem {
  private coverImgSrc: string = '';
  private bookSrc: string = '';
  private bookName: string = '';
  @State isPageLoading: Boolean = true
  private treeCode:string = ''

  public token: string = '';
  public srcId:number = -1;

  private index:number = 0;// 仅用于图片绘本，记录页面索引值


  @Link training: Array<Training>; // 用于PHOTO


  async aboutToAppear() {

    //console.info("==== HorizontalItem training:"+this.training)


  }

  build() {
    Column() {
      Row(){

        // 左图
        Column(){

          if(this.coverImgSrc == ''|| this.coverImgSrc == null){
            if(!this.bookSrc){
              Column(){
                if(this.bookSrc == null || this.bookSrc == ''){
                  Image(  $r("app.media.directory") )
                    .width('70%').height('70%')
                } else {
                  Image(  $r("app.media.book") )
                    .width('80%').height('80%')
                }
              }
              .width('100%').height('100%')
              //.backgroundColor('#ffd7d7d7')
              .justifyContent(FlexAlign.Center)
              .borderRadius(24)
              .margin({ left: 8, right: 5 })
            } else {

              if(this.bookSrc.match('pdf')){
                if(this.bookSrc == null || this.bookSrc == ''){
                  Image(  $r("app.media.directory") )
                    .width('70%').height('70%')
                } else {
                  Image(  $r("app.media.book") )
                    .width('80%').height('80%')
                }
              } else {
                Stack(){
                  LoadingProgress()
                    .width(60).height(60)
                    .margin({ left: 8, right: 5 })
                    .borderRadius(24)
                    .zIndex(0)

                  Image(  this.bookSrc )
                    .margin({ left: 8, right: 5 })
                    .borderRadius(24)
                    .zIndex(2)
                  // .backgroundImage($r('app.media.loading'))
                  // .backgroundImagePosition(Alignment.Center)
                }
                .width('100%').height('100%')
                .alignContent(Alignment.Center)
                .borderRadius(24)
                .margin({ left: 8, right: 5 })
              }


            }



          } else {

            Stack(){
              LoadingProgress()
                .width(60).height(60)
                .margin({ left: 8, right: 5 })
                .borderRadius(24)
                .zIndex(0)

              Image(  this.coverImgSrc )
                .margin({ left: 8, right: 5 })
                .borderRadius(24)
                .zIndex(2)
              // .backgroundImage($r('app.media.loading'))
              // .backgroundImagePosition(Alignment.Center)
            }

          }
        }
        .width('45%')


        // 文本
        Text(this.bookName)
          .margin({
            top: 12,
            bottom: 12
          })
          .textAlign(TextAlign.Center)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .width('55%')
      }
      .width('100%').height('100%')

    }
    .margin({ bottom: 10, top: 10 })
    .width('100%').height(120)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {

      if(this.bookSrc){
        // 点击后打开绘本
        if(this.bookSrc.match('pdf') != null){
          console.info("==== 绘本链接："+this.bookSrc)
          // PDF 格式绘本
          router.pushUrl({
            url: "pages/secondary_pages/PdfBookReader",
            params: {
              coverImgSrc: this.coverImgSrc,
              bookSrc:this.bookSrc,
              bookName: this.bookName,
              token:this.token,
              srcId:this.srcId
            }
          })
        } else {
          // PHOTO 格式绘本
          router.pushUrl({
            url: "pages/secondary_pages/PhotoBookReader",
            params: {
              coverImgSrc: this.coverImgSrc,
              photoTraining: this.training,
              //indexStart:this.index,
              bookName: this.bookName,
              token:this.token,
              srcId:this.srcId
            }
          })
        }
      } else {

        router.pushUrl({
          url: 'pages/secondary_pages/DirectoryPage',
          params: {
            token:this.token,
            treeCode:this.treeCode,
            directoryName:this.bookName
          }
        })

      }



    })
  }
}

import router from '@ohos.router';
import { Training } from '../../model/Training';
import { SearchMyWordDialog } from '../../view/SearchMyWordDialog';

@Entry
@Component
struct PhotoBookReader {
  private token: string = (router.getParams() as Record<string, Object>).token as string;
  private coverImgSrc: string = (router.getParams() as Record<string, Object>).coverImgSrc as string;
  private bookName: string = (router.getParams() as Record<string, Object>).bookName as string;
  private FULL_SCREEN_CANVAS_HEIGHT: string = '95%'
  private FULL_SCREEN_BAR_HEIGHT: string = '0%'
  private DEFAULT_CANVAS_HEIGHT: string = '80%'
  private DEFAULT_BAR_HEIGHT: string = '15%'
  @State indexStart: number = 0;
  @State bookIndexNow: number = 0; // 用于指示画布所在页
  @State canvasHeight: string = this.DEFAULT_CANVAS_HEIGHT;
  @State barHeight: string = this.DEFAULT_BAR_HEIGHT;
  @State scaleValue: number = 1
  @State pinchValue: number = 1
  @State pinchX: number = 0
  @State pinchY: number = 0
  @State imgOffSetX: number = 0
  @State imgOffSetY: number = 0
  @State isFullScreen: Boolean = false;
  private swiperController: SwiperController = new SwiperController()
  // bigScroller: Scroller = new Scroller()

  private photoTraining: Array<Training> = (router.getParams() as Record<string, Object>).photoTraining as Array<Training>;
  ; // PHOTO training list
  private bookSrcArr: Array<string> = []
  dialogController_searchMyWord: CustomDialogController = new CustomDialogController({
    builder: SearchMyWordDialog({
      token: this.token
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })

  aboutToAppear() {
    // 配置Web开启调试模式
    // web_webview.WebviewController.setWebDebuggingAccess(true);
    // console.info("==== PhotoBookReader training scr:" + this.photoTraining)
    // console.info("==== Page Index:" + this.indexStart)

    //this.bookSrcArr[0] = this.bookSrc

    for (let i = 0; i < this.photoTraining.length; i++) {
      this.bookSrcArr.push(this.photoTraining[i].clientUserResourceFile.ossPath)
    }

  }

  build() {
    Column() {
      // 标题栏
      Row() {
        // 返回上一页
        Row() {
          Image($r('app.media.ic_back'))
            .width(30)
            .height(30)
            .margin({ left: 10 })
            .onClick(() => {
              // 页面跳转
              router.back();
            })
        }
        .width('33.33%')
        .height(40)

        // // 展示视频标题
        // Row() {
        //   Text(this.bookName)
        //     .fontSize(25)
        //     .fontWeight(FontWeight.Medium)
        //     .fontWeight(FontWeight.Medium)
        //
        // }
        // .width('33.33%')
        // .height(40)
        // .justifyContent(FlexAlign.Center)


        Row() {
          // 显示页数
          Text(this.bookIndexNow + 1 + '/' + this.bookSrcArr.length.toString())
            .fontSize(25)
            .fontWeight(FontWeight.Medium)
            .fontWeight(FontWeight.Medium)
            .padding({ right: 20 })
        }
        .width('33.33%')
        .height(40)


        // 搜单词
        Row() {
          Image($r('app.media.search'))
            .width(26)
            .height(26)
            .margin({ right: 20 })
        }
        .height(40)
        .width('10%')
        .onClick(() => {
          // 点击右上角加号自己搜词
          this.dialogController_searchMyWord.open()

        })

      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .height("5%")
      .justifyContent(FlexAlign.SpaceBetween)


      // 绘本区
      // List({ scroller: this.bigScroller, initialIndex: 0 }){
      //   ForEach(this.bookSrc, (item, index) => {
      //     ListItem(){
      //       Image(item)
      //         .width('100%')
      //         .position({x:this.imgOffSetX,y:this.imgOffSetY})
      //         .height(this.canvasHeight)
      //         .backgroundColor('#AFEEEE')
      //         .scale(this.bookIndexNow == index ? { x: this.scaleValue, y: this.scaleValue, z: 1 } : { x: 1, y: 1, z: 1 })
      //         .gesture(
      //
      //           GestureGroup(GestureMode.Parallel, //平行识别
      //             // 二指捏合触发该手势事件
      //             PinchGesture({ fingers: 2 })
      //               .onActionStart((event?: GestureEvent) => {
      //                 console.info('====Pinch start')
      //               })
      //               .onActionUpdate((event?: GestureEvent) => {
      //                 if (event) {
      //                   this.scaleValue = this.pinchValue * event.scale
      //                   this.pinchX = event.pinchCenterX
      //                   this.pinchY = event.pinchCenterY
      //                 }
      //               })
      //               .onActionEnd(() => {
      //                 this.pinchValue = this.scaleValue
      //                 console.info('====Pinch end')
      //               }),
      //             // 双指滑动
      //             PanGesture()
      //
      //               .onActionUpdate((event?: GestureEvent) => {
      //                 if (event) {
      //                   console.info('====pan update')
      //                   this.imgOffSetX = this.imgOffSetX + event.offsetX/10;
      //                   this.imgOffSetY = this.imgOffSetX + event.offsetY/10;
      //                 }
      //               })
      //
      //           )
      //         )
      //     }
      //
      //
      //
      //   }, item => item)
      //
      // }
      // .listDirection(Axis.Horizontal)
      // .height('75%')

      Swiper(this.swiperController) {
        ForEach(this.bookSrcArr, (item: string, index) => {
          Stack() {
            LoadingProgress()
              .width(60).height(60)
              .draggable(false)
              .zIndex(0)
            Image(item)
              .width('100%')
              .draggable(false)//.backgroundColor('#AFEEEE')
              .zIndex(2)
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#fff6f6f6')
          .alignContent(Alignment.Center)
          .position(this.bookIndexNow == index ? { x: this.imgOffSetX, y: this.imgOffSetY } : { x: 0, y: 0 })
          .scale(this.bookIndexNow == index ? { x: this.scaleValue, y: this.scaleValue, z: 1 } : { x: 1, y: 1, z: 1 })
        })
      }
      .width('100%')
      .height(this.canvasHeight)
      .cachedCount(2)
      //.index(0)
      .autoPlay(false)
      .interval(4000)
      .indicator(false)
      .loop(true)
      .duration(0)
      .itemSpace(0)
      .curve(Curve.Linear)
      .disableSwipe(this.isFullScreen ? true : false)
      .onChange((index: number) => {
        this.bookIndexNow = index
        console.info('====您现在所在页index为 ' + this.bookIndexNow)
        this.scaleValue = 1;
        this.imgOffSetX = 0;
        this.imgOffSetY = 0;
      })
      .onClick(() => {
        console.info('====切换画布显示模式')
        if (this.canvasHeight == this.FULL_SCREEN_CANVAS_HEIGHT) {
          this.isFullScreen = false
          this.canvasHeight = this.DEFAULT_CANVAS_HEIGHT
          this.barHeight = this.DEFAULT_BAR_HEIGHT
        } else {
          this.isFullScreen = true
          this.canvasHeight = this.FULL_SCREEN_CANVAS_HEIGHT
          this.barHeight = this.FULL_SCREEN_BAR_HEIGHT
        }
      })
      .gesture(
        GestureGroup(GestureMode.Exclusive, //识别模式
          // 放大
          PinchGesture({ fingers: 2 })
            .onActionStart((event?: GestureEvent) => {
              if (this.isFullScreen) {
                console.info('====Pinch start')
              }

            })
            .onActionUpdate((event?: GestureEvent) => {
              if (this.isFullScreen) {
                if (event) {
                  this.scaleValue = this.pinchValue * event.scale
                  this.pinchX = event.pinchCenterX
                  this.pinchY = event.pinchCenterY
                }
              }

            })
            .onActionEnd(() => {
              if (this.isFullScreen) {
                this.pinchValue = this.scaleValue
                console.info('====Pinch end')
              }
            }),
          // 滑动
          PanGesture({ fingers: 1 })
            .onActionUpdate((event?: GestureEvent) => {
              if (this.isFullScreen) {
                if (event) {
                  console.info('====pan update')
                  this.imgOffSetX = this.imgOffSetX + event.offsetX / 10;
                  this.imgOffSetY = this.imgOffSetY + event.offsetY / 10;
                }
              }
            })
        )
      )


      // 底部图片滚轮
      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.bookSrcArr, (item: string, indexTarget) => {
          ListItem() {
            Image(item)
              .width(100)
              .height(100)
              .borderRadius(5)//.backgroundColor('#FFFFFF')
              .borderWidth(2)
              .borderColor(this.bookIndexNow == indexTarget ? '#fff54f22' : '#ffffff')
              .onClick(() => {
                this.indexStart = this.bookIndexNow
                console.info('====您点击了index为 ' + indexTarget + ' 的图片，该图片为' + item)

                if (this.indexStart < indexTarget) {
                  for (let i = 1;; i++) {
                    this.swiperController.showNext()
                    if ((this.indexStart + i) % this.bookSrcArr.length == indexTarget) {
                      this.indexStart = indexTarget
                      break
                    }
                  }
                } else if (this.indexStart > indexTarget) {
                  for (let i = 1;; i++) {
                    this.swiperController.showPrevious()
                    if ((this.indexStart - i) % this.bookSrcArr.length == indexTarget) {
                      this.indexStart = indexTarget
                      break
                    }
                  }
                }

              })

          }
        })
      }
      .height('15%')
      .listDirection(Axis.Horizontal) // 排列方向
      .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 10, endMargin: 10 }) // 每行之间的分界线
      .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
      .onScrollIndex((firstIndex: number, lastIndex: number) => {
        //console.info('====first' + firstIndex)
        //console.info('====last' + lastIndex)
      })
      .draggable(false)
      .margin({ top: 10 })
      .width('90%')
      .height(this.barHeight)

    }
    .width('100%').height('100%')

  }
}
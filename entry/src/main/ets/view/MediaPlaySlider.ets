/**
 * video slider component
 */
@Component
export struct VideoSlider {
  private controller: VideoController = new VideoController();
  private mediaType: string = '';
  @Consume isOpacity: boolean;
  @Consume currentStringTime: string;
  @Consume currentTime: number;
  @Consume durationTime: number;
  @Consume durationStringTime: string;
  @Consume isPlay: boolean;
  @Consume flag: boolean;
  @Consume isLoading: boolean;
  @Consume progressVal: number;

  build() {
    Column() {

      Row() {

        Slider({
          value: this.currentTime,
          min: 0,
          max: this.durationTime,
          step: 1,
          style: SliderStyle.OutSet
        })//.blockColor('#FFFFFF')
          .width('94%')
          .trackColor('#ffdedede')//.backgroundColor('#ffffff')
          .selectedColor('#EC5706')
          .trackThickness(3)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.sliderOnchange(value, mode);
          })

      }
      .width('100%').height('5%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)

      // 时间轴
      Row() {
        Text(this.currentStringTime)
          .fontSize(13)
          .fontColor(Color.White)
          .margin({ left: 10,top:5 })
        Text(this.durationStringTime)
          .fontSize(13)
          .margin({ right: 10,top:5 })
          .fontColor(Color.White)
      }
      .width('94%').height('20%')
      .justifyContent(FlexAlign.SpaceBetween)

      // 控制栏
      Row() {
        // 上一首
        Image($r('app.media.previous'))
          .width(40)
          .height(40)
        // 播放暂停

        Image(this.isPlay ? $r('app.media.pause_2') : $r('app.media.play_2'))
          .width(50)
          .height(50)
          .margin({ left: 20, right: 20 })
          .onClick(() => {
            this.iconOnclick();
          })
        // 下一首
        Image($r('app.media.next'))
          .width(40)
          .height(40)
      }
      .width('100%').height('75%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize({ width: '100%', height: '100%' })

    //.backgroundColor('#c6ff6600')
  }

  /**
   * icon onclick callback
   */
  iconOnclick() {
    if (this.isPlay === true) {
      this.controller.pause()
      this.isPlay = false;
      this.isOpacity = false;
      return;
    }
    if (this.flag === true) {
      this.controller.start();
      this.isPlay = true;
      this.isOpacity = true;
    } else {
      this.isLoading = true;
      // The video loading is not complete. The loading action is displayed.
      let intervalLoading = setInterval(() => {
        if (this.progressVal >= 100) {
          this.progressVal = 0;
        } else {
          this.progressVal += 10;
        }
      }, 100)
      // The scheduled task determines whether the video loading is complete.
      let intervalFlag = setInterval(() => {
        if (this.flag === true) {
          this.controller.start();
          this.isPlay = true;
          this.isOpacity = true;
          this.isLoading = false;
          clearInterval(intervalFlag);
          clearInterval(intervalLoading);
        }
      }, 100);
    }
  }

  /**
   * video slider component onchange callback
   */
  sliderOnchange(value: number, mode: SliderChangeMode) {
    this.currentTime = Number.parseInt(value.toString());
    this.controller.setCurrentTime(Number.parseInt(value.toString()), SeekMode.Accurate);
    if (mode === SliderChangeMode.Begin || mode === SliderChangeMode.Moving) {
      this.isOpacity = false;
    }
    if (mode === SliderChangeMode.End) {
      this.isOpacity = true;
    }
  }
}
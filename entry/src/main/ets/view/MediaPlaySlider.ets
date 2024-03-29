
/**
 * video slider component
 */
@Component
export struct VideoSlider {
  private controller: VideoController = new VideoController();
  private mediaType:string='';
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
    Row({ space: 12 }) {
      Image(this.isPlay ? $r('app.media.ic_pause') : $r('app.media.ic_play'))
        .width(24)
        .height(24)
        .margin({ left: 12 })
        .onClick(() => {
          this.iconOnclick();
        })
      Text(this.currentStringTime)
        .fontSize(16)
        .fontColor(Color.White)
        .margin({ left: 12 })
      Slider({
        value: this.currentTime,
        min: 0,
        max: this.durationTime,
        step: 1,
        style: SliderStyle.OutSet
      })
        //.blockColor('#FFFFFF')
        .width('50%')
        .trackColor('#ffffff')
        .selectedColor('#EC5706')
        .showSteps(true)
        .showTips(true)
        .trackThickness(this.isOpacity ? 2 : 4)
        .onChange((value: number, mode: SliderChangeMode) => {
          this.sliderOnchange(value, mode);
        })
      Text(this.durationStringTime)
        .fontSize(16)
        .margin({ right: 12 })
        .fontColor(Color.White)
    }
    .opacity(this.isOpacity ? 0.5 : 1)
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#373737')
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
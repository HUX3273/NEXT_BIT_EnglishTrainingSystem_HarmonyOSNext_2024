import prompt from '@ohos.promptAction';
import { VideoSlider } from './MediaPlaySlider';

/**
 * video controller component
 */
@Component
export struct VideoPlayer {
  videoSrc: string = '';
  private controller: VideoController = new VideoController();
  private previewUris: Resource = $r('app.string.empty');
  private mediaType: string = '';
  @State mainPlayerHeight: string = '90%';
  @State mainPlayerBackgroundColor: string = '#000000';
  @Provide currentTime: number = 0;
  @Provide durationTime: number = 0;
  @Provide durationStringTime: string = '00:00';
  @Provide currentStringTime: string = '00:00';
  @Consume isPlay: boolean;
  @Consume isOpacity: boolean;
  @Consume isLoading: boolean;
  @Consume progressVal: number;
  @Consume flag: boolean;

  aboutToAppear() {

    if (this.mediaType == '我的视频') {
      this.mainPlayerHeight = '90%';
    } else if (this.mediaType == '我的音频') {
      this.mainPlayerHeight = '0%'
      this.mainPlayerBackgroundColor = '#ff8bcdff'
    }
  }

  build() {
    Column() {

      Video({
        src: this.videoSrc,
        previewUri: this.previewUris,
        controller: this.controller
      })
        .width('100%')
        .height(this.mainPlayerHeight)
        //.backgroundColor('#000000')
        .controls(false)
        .autoPlay(false)
        .objectFit(ImageFit.Contain)
        .loop(false)
        .onUpdate((event) => {
          if (event) {
            this.currentTime = event.time;
            this.currentStringTime = this.changeSliderTime(this.currentTime);
          }
        })
        .onPrepared((event) => {
          this.prepared(event?.duration);
        })
        .onFinish(() => {
          this.finish();
        })
        .onError(() => {
          prompt.showToast({
            duration: 5000,
            message: '请检查网络'
          });
        })


      Column(){
        if(this.mediaType == '我的视频' || this.mediaType == '我的音频'){
          VideoSlider({
            controller: this.controller,
            mediaType: this.mediaType
          })
            .height(this.mediaType == '我的视频' ? '10%' : '100%')
            //.backgroundColor('#f1111f')
        }

      }

    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
    //.backgroundColor(this.mainPlayerBackgroundColor)

  }



  /**
   * video component prepared callback
   */
  prepared(duration: number) {
    this.durationTime = duration;
    let second: number = duration % 60;
    let min: number = Number.parseInt((duration / 60).toString());
    let head = min < 10 ? `${'0'}${min}` : min;
    let end = second < 10 ? `${'0'}${second}` : second;
    this.durationStringTime = `${head}${':'}${end}`;
    this.flag = true;
  }

  /**
   * video component finish callback
   */
  finish() {
    this.isPlay = false;
    this.isOpacity = false;
  }



  changeSliderTime(value: number): string {
  let second: number = value % 60;
  let min: number = Number.parseInt((value / 60).toString());
  let head = min < 10 ? `${ '0' }${min}` : min;
  let end = second < 10 ? `${ '0' }${second}` : second;
  let nowTime = `${head}${ ':' }${end}`;
  return nowTime;
}

}
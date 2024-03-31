import { Rank } from '../model/Rank';

@Component
export default struct RankListItem {
  private rankItem: Rank = new Rank(-1, '', '', -1, -1, false)
  public index: number = 0;

  brandColor:string = '#F8F8F8'

  rankColor:string = '#EFEFEF'
  rankNumberColor:string = '#000000'

  fontColor:string = '#000000'

  aboutToAppear(): void {

    if(this.rankItem.isMe == true){
      this.brandColor = '#FFAA43'
      this.fontColor = '#ffffff'
    }

    if(this.rankItem.rankNo == 1){
      this.rankColor = '#EAC76F'
      this.rankNumberColor = '#ffffff'
    } else  if(this.rankItem.rankNo == 2){
      this.rankColor = '#C1C1C1'
      this.rankNumberColor = '#ffffff'
    } else if(this.rankItem.rankNo == 3){
      this.rankColor = '#ffd0936c'
      this.rankNumberColor = '#ffffff'
    }

  }


  build() {
    Row() {

      Stack() {

        Row() {
          Stack() {
            Image(this.rankItem.avatar)
              .height(55)
              .width(55)
              .borderRadius(35)
              .backgroundImage($r('app.media.user_default'))
              .zIndex(2)
            Text()
              .height(65)
              .width(65)
              .backgroundColor("#ffffff")
              .borderRadius(35)
              .zIndex(0)
          }
        }
        .borderRadius(35)
        .width('20%')
        .zIndex(2)

        Row() {
          Row() {
            // 排名
            Stack(){
              Text()
                .height(30)
                .width(30)
                .backgroundColor(this.rankColor)
                .borderRadius(35)
                .zIndex(0)
              Text(this.rankItem.rankNo.toString())
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.rankNumberColor)
                .zIndex(2)
            }


            // 名字
              Text(this.rankItem.childName)
                .fontSize(16)
                .fontColor(this.fontColor)
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
                .margin({left:10})

          }
          .width('55%')

          // 学习时间
          Row() {
            Image($r('app.media.clock'))
              .height(25)
              .width(25)
            Text(this.rankItem.duration.toString() + '秒')
              .fontColor(this.fontColor)
              .margin({ left: 10, right: 10 })
          }
          .width('25%')
        }
        .justifyContent(FlexAlign.End)
        .height(50)
        .borderRadius(25)
        .width('100%')
        .backgroundColor(this.brandColor)
        .zIndex(0)

      }
      .width('100%')
      .alignContent(Alignment.Start)

    }
    .height(60)
    .width('100%')

  }
}
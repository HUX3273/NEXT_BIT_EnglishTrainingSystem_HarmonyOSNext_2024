import { Rank } from '../model/Rank';

@Component
export default struct RankListItem {
  private rankItem: Rank = new Rank(-1, '', '', -1, -1, false)
  public index: number = 0;

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
            Text(this.rankItem.rankNo.toString())
              .fontSize(16)
              .fontWeight(FontWeight.Medium)

            // 名字
            if (this.rankItem.isMe == true) {
              Text(this.rankItem.childName)
                .fontSize(16)
                .fontColor("#f11111")
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
            } else {
              Text(this.rankItem.childName)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
            }


          }
          .width('55%')

          // 学习时间
          Row() {
            Image($r('app.media.clock'))
              .height(25)
              .width(25)
            Text(this.rankItem.duration.toString() + '秒')
              .margin({ left: 10, right: 10 })
          }
          .width('25%')
        }
        .justifyContent(FlexAlign.End)
        .height(50)
        .borderRadius(25)
        .width('100%')
        .backgroundColor('#F8F8F8')
        .zIndex(0)

      }
      .width('100%')
      .alignContent(Alignment.Start)

    }
    .height(60)
    .width('100%')

  }
}
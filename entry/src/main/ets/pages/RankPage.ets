import router from '@ohos.router';
import CommonConstants from '../common/constants/CommonConstants';
import { RankList } from '../model/RankList';
import { http } from '@kit.NetworkKit';
import { Rank } from '../model/Rank';
import RankListItem from '../view/RankListItem';


@Entry
@Component
struct RankPage {
  @State title: string = '学习榜单'
  token: string = (router.getParams() as Record<string, Object>).token as string;
  userID: string = (router.getParams() as Record<string, Object>).userID as string;
  @State rankList: RankList = new RankList(-1, -1, '', '', -1, [])

  backToMainPage(): void {
    router.replaceUrl({
      url: 'pages/MainPage',
    });
  }

  aboutToAppear(): void {

    this.getStudyRankList_HTTP("DAYS", "PICTURE_BOOK")
    // rankType:  DAYS,WEEK,MONTH,ALL
    // resourceContentType:  VIDEO,AUDIO,PICTURE_BOOK,FLASH_CARD

  }

  build() {
    Column() {
      Row() {
        // 返回
        Row() {
          Image($r('app.media.ic_back'))
            .width(30)
            .height(30)
            .margin({ left: 10 })
            .onClick(() => {
              // 页面跳转
              this.backToMainPage()
            })
        }
        .width('33.33%')
        .height(40)

        // 标题
        Row() {
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

      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      // 排行榜列表
      List({ space: 12 }) {
        ForEach(this.rankList.rankListList, (item: Rank, index: number | undefined) => {
            ListItem() {
              RankListItem({
                rankItem: item,
                index: index
              })
                .margin({ left: 10, right: 10 })
          }

        }, (item: Rank) => JSON.stringify(item))
      }
      .edgeEffect(EdgeEffect.None)
      .margin({ top: 10 })
      .width("100%")
      .height("100%")
    }

  }

  // 查询排行榜
  getStudyRankList_HTTP(rankType: string, resourceContentType: string) {
    console.info('==== 查询排行榜')
    //console.info('==== token:' + this.token)
    let url = CommonConstants.API_HOST + "client/api/study/rank-list?rankType=" + rankType + "&resourceContentType=" + resourceContentType

    let httpRequest_getStudyRankList = http.createHttp();
    httpRequest_getStudyRankList.request(// 请求url地址
      url,
      {
        // 请求方式
        method: http.RequestMethod.GET,

        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Cookie': 'SESSION_ID=' + this.token,
          'Content-Type': 'application/json'
        },

      }, (err, data) => {
      if (err) {
        //请求失嫩
        console.info("==== getStudyRankList_HTTP error code:" + err.code)
        console.info("==== getStudyRankList_HTTP error message:" + err.message)
      } else {

        //清求成功
        let json_string = JSON.stringify(data.result)

        this.rankList = JSON.parse(JSON.parse(json_string))

        console.info("==== " + rankType + " " + resourceContentType + " 排名结果：" + this.rankList.currentRankNo)

        if(this.rankList.currentRankNo != null || (this.rankList.currentRankNo >= 1 && this.rankList.currentRankNo <= this.rankList.rankListList.length)){
          let index = this.rankList.currentRankNo - 1
          this.rankList.rankListList[index].isMe = true

        }


      }


    })

  }
}
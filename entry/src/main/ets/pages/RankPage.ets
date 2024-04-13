import router from '@ohos.router';
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
  @State rankType: string = "DAYS"
  @State resourceContentType: string = "PICTURE_BOOK"
  @State isPageLoading: Boolean = true

  backToMainPage(): void {
    router.back()
  }

  aboutToAppear(): void {

    this.getStudyRankList_HTTP(this.rankType, this.resourceContentType)
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


        // 我的排名
        Row() {
          Text("我的排名：")
            .fontSize(12)
            .fontWeight(FontWeight.Normal)
            .fontWeight(FontWeight.Normal)
          if (this.isPageLoading == false) {
            Text(!this.rankList.currentRankNo ? '暂无' : this.rankList.currentRankNo.toString())
              .fontSize(18)
              .fontWeight(FontWeight.Normal)
              .fontWeight(FontWeight.Normal)
          }

        }
        .width('33.33%')
        .height(40)
        .justifyContent(FlexAlign.Center)

      }
      .width('100%')
      .height('5%')

      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////


      // 选择榜单类型
      Row() {
        Row() {

          // 选择统计周期
          // DAYS,WEEK,MONTH,ALL
          Row() {
            Select([
              { value: '日榜' },
              { value: '周榜' },
              { value: '月榜' },
              { value: '总榜' }])
              .selected(0)
              .value('日榜')
              .font({ size: 16, weight: 500 })
              .fontColor('#182431')
              .selectedOptionFont({ size: 16, weight: 400 })
              .optionFont({ size: 16, weight: 400 })
              .onSelect((index: number) => {
                console.info('==== 统计周期Select:' + index)

                if (index == 0) {
                  this.rankType = 'DAYS'
                } else if (index == 1) {
                  this.rankType = 'WEEK'
                } else if (index == 2) {
                  this.rankType = 'MONTH'
                } else if (index == 3) {
                  this.rankType = 'ALL'
                }

              })
          }
          .justifyContent(FlexAlign.Center)
          .width('50%')

          // 选择统计的学习资源类型
          // VIDEO,AUDIO,PICTURE_BOOK,FLASH_CARD
          Row() {
            Select([
              { value: '绘本' },
              { value: '视频' },
              { value: '音频' },
              { value: '闪卡' }])
              .selected(2)
              .value('音频')
              .font({ size: 16, weight: 500 })
              .fontColor('#182431')
              .selectedOptionFont({ size: 16, weight: 400 })
              .optionFont({ size: 16, weight: 400 })
              .onSelect((index: number) => {
                console.info('==== 学习资源类型Select:' + index)

                if (index == 0) {
                  this.resourceContentType = 'PICTURE_BOOK'
                } else if (index == 1) {
                  this.resourceContentType = 'VIDEO'
                } else if (index == 2) {
                  this.resourceContentType = 'AUDIO'
                } else if (index == 3) {
                  this.resourceContentType = 'FLASH_CARD'
                }


              })
          }
          .justifyContent(FlexAlign.Center)
          .width('50%')

        }
        //.backgroundColor('#ffff9f2b')
        .width("70%")

        Row() {
          Button("查询")
            .backgroundColor('#fffc8a00')
            .onClick(() => {
              this.isPageLoading = true
              this.getStudyRankList_HTTP(this.rankType, this.resourceContentType)
            })
        }
        .height('90%')
        .width("20%")
      }
      .justifyContent(FlexAlign.End)
      .height('5%')
      .width('100%')


      if (this.isPageLoading == true) {
        LoadingProgress()
          .width(60).height(60)
      } else {
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
        .height("90%")
      }

    }

  }

  // 查询排行榜
  getStudyRankList_HTTP(rankType: string, resourceContentType: string) {
    console.info('==== 查询排行榜')
    //console.info('==== token:' + this.token)
    let url = 'https://toolkit.diegodad.com/client/api/study/rank-list?rankType=' + rankType + '&resourceContentType=' + resourceContentType

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


        let json_string = JSON.stringify(data.result)

        console.info("==== " + rankType + " " + resourceContentType + " 排名结果：" + this.rankList.currentRankNo)
        //清求成功
        if (data.responseCode == 200) {
          this.rankList = JSON.parse(JSON.parse(json_string))
          if (this.rankList.currentRankNo != null && (this.rankList.currentRankNo >= 1 && this.rankList.currentRankNo <= this.rankList.rankListList.length)) {
            let index = this.rankList.currentRankNo - 1
            this.rankList.rankListList[index].isMe = true
          }
        }


        this.isPageLoading = false

      }


    })

  }
}
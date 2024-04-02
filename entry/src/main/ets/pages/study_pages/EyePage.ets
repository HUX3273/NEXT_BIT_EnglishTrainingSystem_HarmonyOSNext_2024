import router from '@ohos.router';
import http from '@ohos.net.http';
import CommonConstants from '../../common/constants/CommonConstants';
import { MultiMediaModule } from '../../view/MediaIndexModule';
import { GetTrainingListArgs } from '../../net/request/GetTrainingListArgs';
import { Training } from '../../model/Training';
import PreferencesUtil from '../../common/database/PreferencesUtil';
@Entry
@Component
struct EyePage {
  @State title: string = '磨眼睛'

  token: string = (router.getParams() as Record<string, Object>).token as string;

  @Provide training:Array<Training> = []


  backToMainPage():void{
    router.replaceUrl({
      url: 'pages/MainPage',
    });

  }


  async aboutToAppear() {

    await PreferencesUtil.getToken().then((value) => {
      this.token = value
    });

    this.getTrainingList_HTTP()

  }


  build() {
    Column(){
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



        // 其他
        Row(){

        }
        .width('33.33%')
        .height(60)


      }
      .width('100%')
      .height('5%')


      List() {
        ListItem() {
          MultiMediaModule({
            moduleName: '我的视频'
          })
            .margin({ top: 20 })
        }

      }
      .listDirection(Axis.Vertical)
      .margin({ top: 20 })

    }

  }


  getTrainingList_HTTP() {

    console.info('==== 请求训练清单（视频）')

    let getTrainingListArgs: string = JSON.stringify(new GetTrainingListArgs('VIDEO', ''))

    let httpRequest_getTrainingList = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/trainingList/list"
    httpRequest_getTrainingList.request(
      // 请求url地址
      url,
      {
        // 请求方式
        method: http.RequestMethod.POST,

        // 可选，默认为60s
        connectTimeout: 60000,
        // 可选，默认为60s
        readTimeout: 60000,
        // 开发者根据自身业务需要添加header字段
        header: {
          'Cookie': 'SESSION_ID=' + this.token,
          'Content-Type': 'application/json'
        },
        // 请求的额外数据。
        extraData: getTrainingListArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== getTrainingList_HTTP error code:" + err.code)
        console.info("==== getTrainingList_HTTP error message:" + err.message)
      } else {
        // 请求成功
        let json_string = JSON.stringify(data.result)

        this.training = JSON.parse(JSON.parse(json_string))


        // console.info("==== LIST result:"+this.training[0].id)
        // console.info("==== LIST result:"+this.training[0].clientUser.nickname)
        // console.info("==== LIST result:"+this.training[0].clientUserResourceFile.ossPath)


      }

    })


  }



}
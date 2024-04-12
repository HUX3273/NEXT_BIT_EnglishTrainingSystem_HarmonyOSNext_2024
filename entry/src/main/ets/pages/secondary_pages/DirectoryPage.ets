import router from '@ohos.router';
import PreferencesUtil from '../../common/database/PreferencesUtil';
import { Training } from '../../model/Training';
import { PictureBookModule } from '../../view/PictureBookIndexModule';
import { http } from '@kit.NetworkKit';
import { GetTrainingListArgs } from '../../net/request/GetTrainingListArgs';
import CommonConstants from '../../common/constants/CommonConstants';

@Entry
@Component
// 绘本次级目录
struct DirectoryPage {
  @State title: string = (router.getParams() as Record<string, Object>).bookName as string;

  private token: string = (router.getParams() as Record<string, Object>).token as string;

  private treeCode: string = (router.getParams() as Record<string, Object>).treeCode as string;


  @Provide training:Array<Training> = []



  async aboutToAppear() {

    // await PreferencesUtil.getToken().then((value) => {
    //   this.token = value
    // });

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
              router.back()
            })
        }
        .width('33.33%')
        .height(40)

        // 标题
        Row(){
          Text(this.title = null ? '绘本':this.title)
            .fontSize(25)
            .fontWeight(FontWeight.Medium)
            .fontWeight(FontWeight.Medium)

        }
        .width('33.33%')
        .height(40)
        .justifyContent(FlexAlign.Center)


        //


      }
      .width('100%')
      .height('5%')


      List() {
        ListItem() {
          PictureBookModule({ moduleName: '我的绘本',token: this.token})
            .margin({ top: 20 })

        }

      }
      .listDirection(Axis.Vertical)
      .margin({ top: 18 })


    }
    .height('100%')

  }




  getTrainingList_HTTP() {

    console.info('==== 请求训练清单（绘本）')

    let getTrainingListArgs: string = JSON.stringify(new GetTrainingListArgs('PICTURE_BOOK', this.treeCode))

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
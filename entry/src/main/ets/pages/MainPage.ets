import MainViewModel from '../viewmodel/MainViewModel';
import MainPageGrid from '../viewmodel/MainPageGrid';
import router from '@ohos.router';
import PreferencesUtil from '../common/database/PreferencesUtil';
import CommonConstants from '../common/constants/CommonConstants';
import http from '@ohos.net.http';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct MainPage {
  @State message: string = 'Hello World'

  @State userName: string = (router.getParams() as Record<string, Object>).userName as string;
  @State token: string = (router.getParams() as Record<string, Object>).token as string;
  @State userID: string = (router.getParams() as Record<string, Object>).userID as string;
  @State avatar: string = (router.getParams() as Record<string, Object>).avatar as string;

  pageJump(desPage: String): void {
    router.pushUrl({
      url: 'pages/study_pages/' + desPage,
      params: {
        token: this.token,
        treeCode: ''
      }
    });
  }

  async aboutToAppear() {

    // await PreferencesUtil.getUserName().then((value) => {
    //   this.userName = value;
    // });
    //
    // await PreferencesUtil.getToken().then((value) => {
    //   this.token = value
    // });
    //
    // await PreferencesUtil.getUserID().then((value) => {
    //   this.userID = value
    // });
    //
    // await PreferencesUtil.getAvatar().then((value) => {
    //   this.avatar = value
    // });
  }

  build() {
    Column() {
      Row() {
        Row() {
          Stack() {
            Row() {
              Stack() {
                // 显示用户头像
                if(this.avatar == null || this.avatar == ''){
                  Image($r('app.media.user_default'))
                    .height(67)
                    .width(67)
                    .borderRadius(40)
                    .zIndex(2)
                } else {
                  Image(this.avatar)
                    .height(67)
                    .width(67)
                    .borderRadius(40)
                    .zIndex(2)
                }

                Text()
                  .height(75)
                  .width(75)
                  .backgroundColor("#ffffff")
                  .borderRadius(40)
                  .zIndex(0)
              }
            }
            .borderRadius(40)
            .zIndex(2)

            Row() {
              Row() {
                // 名字
                Text(this.userName)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .textAlign(TextAlign.Start)
              }
              .width('50%')
            }
            .justifyContent(FlexAlign.End)
            .height(57)
            .borderRadius(40)
            .width('100%')
            .backgroundColor('#FFAA43')
            .zIndex(0)
          }
          .width('90%')
          .margin({ top: 50,left:'10%'})
          .alignContent(Alignment.Start)

        }
        .width('50%')
        //.backgroundColor('#1fffff')


        Row() {

          // 排名
          Image($r('app.media.rank'))
            .width(70)
            .height(70)
            .margin({ top: 50, right: 10 })
            .onClick(() => {
              // 跳转到排名页面
              router.pushUrl({
                url: 'pages/RankPage',
                params: {
                  token: this.token,
                  userID: this.userID
                }
              });
            })

          // 登出
          Image($r('app.media.logout'))
            .width(70)
            .height(70)
            .margin({ top: 50, right: '10%' })
            .onClick(() => {

              AlertDialog.show(
                {
                  title: '退出登录', // 标题
                  message: '确认要退出登录?', // 内容
                  autoCancel: false, // 点击遮障层时，是否关闭弹窗。
                  alignment: DialogAlignment.Bottom, // 弹窗在竖直方向的对齐方式
                  offset: { dx: 0, dy: -20 }, // 弹窗相对alignment位置的偏移量
                  primaryButton: {
                    value: '取消',
                    action: () => {
                      console.info('====取消登出');
                    }
                  },
                  secondaryButton: {
                    value: '退出',
                    fontColor: '#D94838',
                    action: () => {
                      console.info('====确认登出');
                      // TODO 测试时暂时不注销token
                      //this.logout_HTTP()
                      // 跳转登出页面
                      router.replaceUrl({
                        url: 'pages/LoginPage',
                      });
                    }

                  },
                  cancel: () => { // 点击遮障层关闭dialog时的回调
                    console.info('====Closed callbacks');
                  }
                }
              )


            })
        }
        .justifyContent(FlexAlign.End)
        .width('50%')

      }
      .width('100%')
      .margin({ top: 26 })


      // 显示6个功能模块
      Grid() {
        ForEach(MainViewModel.getGridData(), (item: MainPageGrid) => {
          GridItem() {
            Column() {
              Image(item.img)
                .width(100)
                .height(100)
              Text(item.title)
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 16 })
            }
            .alignItems(HorizontalAlign.Center)
          }

          .borderRadius(12)
          .backgroundColor('#F8F8F8')
          .onClick(() => {
            // 页面跳转
            this.pageJump(item.des_page)

          })

        }, (item: MainPageGrid) => JSON.stringify(item))
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(18)
      .rowsGap(18)
      .padding({ top: 30, bottom: 30, left: 10, right: 10 })
      .backgroundColor(Color.White)
      .borderRadius(24)
      .height('70%')
      .margin({ top: 10 })


      Flex(){
        // 测试按钮
        Button('TestPage entrance')
          .onClick(() => {
            //let simpleName = AppStorage.SetAndLink('simplePropName', "你好")
            //console.info('====测试：' + simpleName)
            router.pushUrl({
              url: 'pages/TestPage',

            });
          })

        // 网页按钮
        Button('WebPage entrance')
          .onClick(() => {
            //let simpleName = AppStorage.SetAndLink('simplePropName', "你好")
            //console.info('====测试：' + simpleName)
            router.pushUrl({
              url: 'pages/WebPage',
            });
          })


        // AVPLAYER
        Button('AVPLAYER entrance')
          .onClick(() => {
            //let simpleName = AppStorage.SetAndLink('simplePropName', "你好")
            //console.info('====测试：' + simpleName)
            router.pushUrl({
              url: "pages/secondary_pages/HttpsPlayer",
            });
          })
      }


    }
    .height('100%')
    .width('100%')
  }





  // 在后台把本token注销
  logout_HTTP() {
    console.info('====获取用户信息')

    let url = CommonConstants.API_HOST + "client/api/logout"

    let httpRequest_logout = http.createHttp();
    httpRequest_logout.request(// 请求url地址
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
        console.info("====logout_HTTP error code:" + err.code)
        console.info("====logout_HTTP error message:" + err.message)
      } else {

        // 请求失嫩
        console.info("====退出登录成功" + data.responseCode)

        // 删除用户数据
        PreferencesUtil.deleteToken()
        PreferencesUtil.deleteUserName()


      }
    })
  }

}
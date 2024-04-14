import MainViewModel from '../view/MainViewModel';
import MainPageGrid from '../view/MainPageGrid';
import router from '@ohos.router';
import PreferencesUtil from '../common/database/PreferencesUtil';
import CommonConstants from '../common/constants/CommonConstants';
import http from '@ohos.net.http';
import { ChangeAccountDialog } from '../view/ChangeAccountDialog';
import { SearchMyWordDialog } from '../view/SearchMyWordDialog';

@Entry
@Component
struct MainPage {
  @State message: string = 'Hello World'
  @State userName: string = (router.getParams() as Record<string, Object>).userName as string;
  @State token: string = (router.getParams() as Record<string, Object>).token as string;
  @State userID: string = (router.getParams() as Record<string, Object>).userID as string;
  @State avatar: string = (router.getParams() as Record<string, Object>).avatar as string;
  @State accountIndex: number = (router.getParams() as Record<string, Object>).accountIndex as number;

  dialogController_changeAccount: CustomDialogController = new CustomDialogController({
    builder: ChangeAccountDialog({
      accountIndex: this.accountIndex
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })


  dialogController_searchMyWord: CustomDialogController = new CustomDialogController({
    builder: SearchMyWordDialog({
      token:this.token
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })





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

    if (this.accountIndex == 0) {

      await PreferencesUtil.getUserName().then((value) => {
        this.userName = value;
      });
      await PreferencesUtil.getToken().then((value) => {
        this.token = value
      });
      await PreferencesUtil.getUserID().then((value) => {
        this.userID = value
      });
      await PreferencesUtil.getAvatar().then((value) => {
        this.avatar = value
      });

    } else if (this.accountIndex == 1) {

      await PreferencesUtil.getUserName_1().then((value) => {
        this.userName = value;
      });
      await PreferencesUtil.getToken_1().then((value) => {
        this.token = value
      });
      await PreferencesUtil.getUserID_1().then((value) => {
        this.userID = value
      });
      await PreferencesUtil.getAvatar_1().then((value) => {
        this.avatar = value
      });

    }


  }

  build() {
    Column() {

      // 搜词
      Row() {
        Image($r('app.media.search'))
          .width(26)
          .height(26)
          .margin({ right: 20 })
      }
      .justifyContent(FlexAlign.End)
      .width('100%').height(50)
      .onClick(() => {
        // 点击右上角加号自己搜词
        this.dialogController_searchMyWord.open()

      })


      // 头像 + 用户名 + 排名 + 登出按钮
      Row() {

        // 头像 + 用户名
        Row() {
          Stack() {
            Row() {
              Stack() {
                // 显示用户头像
                if (this.avatar == null || this.avatar == '') {
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
          .margin({ left: '10%' })
          .alignContent(Alignment.Start)
          .onClick(() => {
            // 打开切换账号的界面，选定新账号后刷新本界面
            // promptAction.showToast({message:"hello world!"})
            this.dialogController_changeAccount.open()
          })

        }
        .width('50%')

        //.backgroundColor('#1fffff')

        // 排名 + 登出
        Row() {
          // 排名
          Image($r('app.media.rank'))
            .width(70)
            .height(70)
            .margin({ right: 10 })
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
            .margin({ right: '10%' })
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
                      this.logout_HTTP()

                      if (this.accountIndex == 0) {
                        PreferencesUtil.deleteUserName()
                        PreferencesUtil.deleteToken()
                        PreferencesUtil.deleteUserID()
                        PreferencesUtil.deleteAvatar()
                      } else if (this.accountIndex == 1) {
                        PreferencesUtil.deleteUserName_1()
                        PreferencesUtil.deleteToken_1()
                        PreferencesUtil.deleteUserID_1()
                        PreferencesUtil.deleteAvatar_1()
                      }

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


      Row() {
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


        // // AVPLAYER
        // Button('AVPLAYER entrance')
        //   .onClick(() => {
        //     //let simpleName = AppStorage.SetAndLink('simplePropName', "你好")
        //     //console.info('====测试：' + simpleName)
        //     router.pushUrl({
        //       url: "pages/secondary_pages/HttpsPlayer",
        //     });
        //   })

      }.width('100%')

    }
    .height('100%')
    .width('100%')
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

      }
    })
  }
}
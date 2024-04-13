import { promptAction, router } from '@kit.ArkUI'
import PreferencesUtil from '../common/database/PreferencesUtil'

@CustomDialog
export struct ChangeAccountDialog {
  @State accountIndex: number = -1
  private maxAccountNum = 2
  @State loggedInAccountNum: number = 0;
  @State userName: string = '';
  @State token: string = '';
  @State userID: string = '';
  @State avatar: string = '';
  @State userName_1: string = '';
  @State token_1: string = '';
  @State userID_1: string = '';
  @State avatar_1: string = '';
  // @State userName_2: string = '';
  // @State token_2: string = '';
  // @State userID_2: string = '';
  // @State avatar_2: string = '';
  controller: CustomDialogController // 自己的controller一定要放在最后

  async aboutToAppear() {

    await this.getLoggedUserInfo()

    if (this.userName != '') {
      this.loggedInAccountNum++
    }

    if (this.userName_1 != '') {
      this.loggedInAccountNum++
    }


  }

  build() {
    Column() {

      Text("切换账户")
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })
        .height("10%")

      // 用户0
      Row() {
        Row() {
          Stack() {
            Row() {
              Stack() {
                Image(this.avatar)
                  .height(65)
                  .width(65)
                  .borderRadius(45)
                  .backgroundImage('')
                  .zIndex(2)
                Text()
                  .height(75)
                  .width(75)
                  .backgroundColor("#ffffff")
                  .borderRadius(45)
                  .zIndex(0)
              }
            }
            .borderRadius(45)
            .width('20%')
            .zIndex(2)

            Row() {
              // 名字
              Text(this.userName)
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
            }
            .justifyContent(FlexAlign.Center)
            .height(60)
            .borderRadius(35)
            .width('100%')
            .backgroundColor(this.accountIndex == 0 ? '#FFAA43' : '#F8F8F8')
            .zIndex(0)
          }
          .width('100%')
          .alignContent(Alignment.Start)
        }
        .width('100%')
      }
      .width(300).height(100)
      .onClick(() => {
        if (this.userName != '') {
          router.replaceUrl({
            url: 'pages/MainPage',
            params: {
              userName: this.userName,
              token: this.token,
              userID: this.userID,
              avatar: this.avatar,
              accountIndex: 0
            }
          })
        }
      })


      // 用户1
      Row() {
        Row() {
          Stack() {
            Row() {
              Stack() {
                Image(this.avatar_1)
                  .height(65)
                  .width(65)
                  .borderRadius(45)
                  .backgroundImage('')
                  .zIndex(2)
                Text()
                  .height(75)
                  .width(75)
                  .backgroundColor("#ffffff")
                  .borderRadius(45)
                  .zIndex(0)
              }
            }
            .borderRadius(45)
            .width('20%')
            .zIndex(2)

            Row() {
              // 名字
              Text(this.userName_1)
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
            }
            .justifyContent(FlexAlign.Center)
            .height(60)
            .borderRadius(35)
            .width('100%')
            .backgroundColor(this.accountIndex == 1 ? '#FFAA43' : '#F8F8F8')
            .zIndex(0)
          }
          .width('100%')
          .alignContent(Alignment.Start)
        }
        .width('100%')
      }
      .width(300).height(100)
      .onClick(() => {
        if (this.userName_1 != '') {
          router.replaceUrl({
            url: 'pages/MainPage',
            params: {
              userName: this.userName_1,
              token: this.token_1,
              userID: this.userID_1,
              avatar: this.avatar_1,
              accountIndex: 1
            }
          })
        }
      })


      Text("添加新用户")
        .fontSize(18)
        .fontColor("#ff0090ff")
        .fontWeight(FontWeight.Medium)
        .margin({ top: 30, bottom: 30 })
        .onClick(() => {
          if (this.loggedInAccountNum < this.maxAccountNum) { // 如果用户上限未满
            router.replaceUrl({
              url: 'pages/LoginPage',
            })
          } else {
            promptAction.showDialog({ message: "已达到可登录账户上限，请先退出一个账户" })
          }
        })
    }

  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



  async getLoggedUserInfo() {

    // 用户0
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


    // 用户1
    await PreferencesUtil.getUserName_1().then((value) => {
      this.userName_1 = value;
    });
    await PreferencesUtil.getToken_1().then((value) => {
      this.token_1 = value
    });
    await PreferencesUtil.getUserID_1().then((value) => {
      this.userID_1 = value
    });
    await PreferencesUtil.getAvatar_1().then((value) => {
      this.avatar_1 = value
    });


  }
}
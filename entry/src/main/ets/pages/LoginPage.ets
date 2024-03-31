import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import http from '@ohos.net.http';
import CommonConstants from '../common/constants/CommonConstants';
import { LoginBySmsArgs } from '../net/request/LoginBySmsArgs';
import LoginResponse from '../common/constants/LoginResponse';
import { UserInfo } from '../model/UserInfo';
import PreferencesUtil from '../common/database/PreferencesUtil';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct LoginPage {
  @State account: string = '';
  @State captcha: string = '';
  @State isShowProgress: boolean = false;
  @State format: string = 'ss'
  @State getCodeInCD: boolean = false;
  @State token: string = '' // 登录成功后返回的凭证
  @State paidMember: boolean = false; // 登录成功，是否为付费用户
  textTimerController: TextTimerController = new TextTimerController()
  // private timeOutId: number = -1;
  private CD: number = 30000;
  private loginSucceed: boolean = false;
  private userInfo: UserInfo = new UserInfo(0, '', '', '', '');



  async aboutToAppear() {

  }

  build() {
    Column() {
      Column({ space: 10 }) {
        Text($r('app.string.login'))
          .fontSize($r('app.float.page_title_text_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.title_text_color'))
          .padding({
            left: $r('app.float.page_padding_horizontal'),
            right: $r('app.float.page_padding_horizontal'),
            top: $r('app.float.login_page_padding_vertical'),
            bottom: $r('app.float.login_page_padding_vertical')
          })

        TextInput({ placeholder: $r('app.string.account') })
          .maxLength(11)
          .type(InputType.Number)//.inputStyle()
          .onChange((value: string) => {
            this.account = value;
          })
          .width(300)


        Flex() {
          TextInput({ placeholder: $r('app.string.captcha') })
            .maxLength(11)
            .type(InputType.Number)
            .width(200)
            .onChange((value: string) => {
              this.captcha = value;
            })

          Button($r('app.string.get_captcha'))
            .fontSize(13)//.width('30%')
            .onClick(() => {
              // 请求验证码
              if (this.account != '' && this.getCodeInCD == false) {
                this.getValidCode_HTTP()
                this.getCodeInCD = true
                this.textTimerController.start()
              } else if (this.account == '') {
                prompt.showToast({
                  message: "账号不能为空！"
                })
              } else if (this.getCodeInCD == true) {
                prompt.showToast({
                  message: "短时间内不能重复请求验证码哦~"
                })
              }


            })
            .backgroundColor('#EC5706')
        }
        .width(300)

        TextTimer({ isCountDown: true, count: this.CD, controller: this.textTimerController })
          .format(this.format)
          .fontColor(Color.Black)
          .fontSize(50)
          .onTimer((utc: number, elapsedTime: number) => {
            //console.info('====textTimer notCountDown utc is：' + utc + ', elapsedTime: ' + elapsedTime)
            if (elapsedTime >= this.CD) {
              this.getCodeInCD = false
              this.textTimerController.reset()
            }
          })


        Button($r('app.string.login'), { type: ButtonType.Capsule })
          .width(300)
          .fontWeight(FontWeight.Medium)
          .margin({ top: $r('app.float.login_button_margin_top') })
          .onClick(() => {
            this.login();
          })
          .backgroundColor('#EC5706')

        if (this.isShowProgress) {
          LoadingProgress()
            .width('40vp')
            .height('40vp')
            .margin({ top: '30vp' })
        }

      }
      .height("60%")
      .padding({
        left: $r('app.float.page_padding_horizontal'),
        right: $r('app.float.page_padding_horizontal'),
        top: $r('app.float.login_page_padding_vertical'),
        bottom: $r('app.float.login_page_padding_vertical')
      })
    }
    .height("100%")
    .width("100%")
    .justifyContent(FlexAlign.Center)
  }

  // 登录
  login(): void {
    if (this.account == '' || this.captcha == '') {
      prompt.showToast({
        message: $r('app.string.input_empty_tips')
      })

    } else {
      this.isShowProgress = true;

      // 登录
      this.loginBySms_HTTP()

      setTimeout(() => {
        if (this.loginSucceed) {
          this.isShowProgress = false;
          router.replaceUrl({
            url: 'pages/MainPage',
            params: {
              // userAccount: this.account,
              // userName: this.userInfo.avatar
            }
          })
        } else {
          this.isShowProgress = false;
          prompt.showToast({
            message: '账号或验证码错误'
          })
        }
      }, 2000)


    }
  }

  // 请求验证码
  public getValidCode_HTTP() {

    console.info('==== 请求验证码')
    let httpRequest_getCode = http.createHttp();
    let url:string = CommonConstants.API_HOST + "client/api/parent/getValidCodeByPhone/" + this.account
    httpRequest_getCode.request(// 请求url地址
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
          'Content-Type': 'application/json'
        }
      })

  }

  // 通过验证码登录
  public loginBySms_HTTP() {

    console.info('==== 验证码登录')

    let loginBySmsArgs: string = JSON.stringify(new LoginBySmsArgs(
      this.account,
      this.captcha,
      "PARENT",
      0,
      "1.2.0")
    )

    let url = CommonConstants.API_HOST + "client/api/loginBySms"

    let httpRequest_loginBySms = http.createHttp();
    httpRequest_loginBySms.request(// 请求url地址
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
          'Content-Type': 'application/json'
        },
        // 请求的额外数据。
        extraData: loginBySmsArgs

      }, (err: BusinessError, data: http.HttpResponse) => {
      if (err) {
        // 请求失嫩
        console.info("==== loginBySms_HTTP error code:" + err.code)
        console.info("==== loginBySms_HTTP error message:" + err.message)
      } else {
        // 请求成功
        let json_string = JSON.stringify(data.result)
        console.info("==== result:" + json_string)

        let loginResponse: LoginResponse = JSON.parse(JSON.parse(json_string))
        this.token = loginResponse.token
        this.paidMember = loginResponse.paidMember

        console.info("==== token:" + this.token)

        if (this.token != undefined) {
          // 登录成功获取用户信息
          this.loginSucceed = true
          this.getUserInfo_HTTP()
        }


      }

    })


  }

  public getUserInfo_HTTP() {

    console.info('==== 获取用户信息')

    let url = CommonConstants.API_HOST + "client/api/parent/detail"

    let httpRequest_getUserInfo = http.createHttp();
    httpRequest_getUserInfo.request(// 请求url地址
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
        console.info("==== getUserInfo_HTTP error code:" + err.code)
        console.info("==== getUserInfo_HTTP error message:" + err.message)
      } else {

        //清求成功
        let json_string = JSON.stringify(data.result)

        this.userInfo = JSON.parse(JSON.parse(json_string))


        console.info("==== phone:" + this.userInfo.phone)
        console.info("==== children name:" + this.userInfo.childrenName)


        // 数据持久化
        PreferencesUtil.saveUserName(this.userInfo.childrenName)
        PreferencesUtil.saveToken(this.token)
        PreferencesUtil.saveUserID(this.userInfo.id.toString())


      }


    })

  }
}
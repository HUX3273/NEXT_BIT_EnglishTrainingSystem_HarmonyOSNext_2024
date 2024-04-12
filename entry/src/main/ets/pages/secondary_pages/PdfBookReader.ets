import url from '@ohos.url';
import web_webview from '@ohos.web.webview';
import { BusinessError } from '@ohos.base';
import router from '@ohos.router';
import { SearchMyWordDialog } from '../../view/SearchMyWordDialog';
import { StartRecordArgs } from '../../net/request/StartRecordArgs';
import { http } from '@kit.NetworkKit';
import CommonConstants from '../../common/constants/CommonConstants';
import { EndRecordArgs } from '../../net/request/EndRecordArgs';
import { StudyRecord } from '../../model/StudyRecord';
import { window } from '@kit.ArkUI';


@Entry
@Component
struct PdfBookReader {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController();
  responseResource: WebResourceResponse = new WebResourceResponse();

  localUrl: string = 'http://pdfviewer.local';
  interceptedUrl: string = this.localUrl;
  pdfUrl:string = ''

  private bookSrc: string = (router.getParams() as Record<string, Object>).bookSrc as string
  private coverImgSrc: string = (router.getParams() as Record<string, Object>).coverImgSrc as string;
  private bookName: string = (router.getParams() as Record<string, Object>).bookName as string;
  private token: string = (router.getParams() as Record<string, Object>).token as string;
  private srcId:number = (router.getParams() as Record<string, Object>).srcId as number;

  private recordId:number = -1
  studyRecord:StudyRecord = new StudyRecord(-1)


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





  async aboutToAppear() {

    // 允许自旋转
    let orientation:number = window.Orientation.AUTO_ROTATION;// 可选参数：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V2/js-apis-bundlemanager-0000001427585060-V2
    try {
      // 设置屏幕旋转
      globalThis.windowClass.setPreferredOrientation(orientation, (err:BusinessError) => {});
      console.info('==== 设置屏幕 orientation 成功' );
    } catch (exception) {
      console.error('==== 设置失败: ' + JSON.stringify(exception));
    }

    //设置不显示bar
    let names = [];
    try {
      globalThis.windowClass.setWindowSystemBarEnable(names, (err: BusinessError) => {
        if (err.code) {
          console.error('==== Failed to set the system bar to be invisible. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('==== Succeeded in setting the system bar to be invisible.');
      });
    } catch (exception) {
      console.error('==== Failed to set the system bar to be invisible. Cause:' + JSON.stringify(exception));
    }


    this.pdfUrl = this.bookSrc

    // 开始计时
    this.startRecord_HTTP()

  }

  async aboutToDisappear(){

    // 禁止自旋转
    let orientation:number = window.Orientation.PORTRAIT;// 可选参数：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V2/js-apis-bundlemanager-0000001427585060-V2
    try {
      // 设置屏幕旋转
      globalThis.windowClass.setPreferredOrientation(orientation, (err:BusinessError) => {});
      console.info('==== 设置屏幕 orientation 成功' );
    } catch (exception) {
      console.error('==== 设置失败: ' + JSON.stringify(exception));
    }

    // 恢复显示bar
    let names = ['status', 'navigation'];
    try {
      globalThis.windowClass.setWindowSystemBarEnable(names, (err: BusinessError) => {
        if (err.code) {
          console.error('==== Failed to set the system bar to be invisible. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('==== Succeeded in setting the system bar to be invisible.');
      });
    } catch (exception) {
      console.error('==== Failed to set the system bar to be invisible. Cause:' + JSON.stringify(exception));
    }

    // 结束计时
    this.endRecord_HTTP()

  }

  build() {
    Column() {

      // 标题栏
      Row() {
        // 返回上一页
        Row() {
          Image($r('app.media.ic_back'))
            .width(30)
            .height(30)
            .margin({ left: 10 })
            .onClick(() => {
              // 页面跳转
              router.back();
            })
        }
        .width('10%')
        .height(40)

        // 标题
        Row() {
          Text(this.bookName)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontWeight(FontWeight.Medium)

        }
        .height(40)
        .width('80%')
        .justifyContent(FlexAlign.Center)

        Row() {
          Image($r('app.media.search'))
            .width(26)
            .height(26)
            .margin({right:20})

        }
        .height(40)
        .width('10%')
        .onClick(() => {
          // 点击右上角加号自己搜词
          this.dialogController_searchMyWord.open()

        })
        //.justifyContent(FlexAlign.Center)

      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .height("5%")
      .onAppear(async  () => {
        try {
          console.info(" ==== "+this.pdfUrl)
          // this.pdfUrl = 'https://mozilla.github.io/pdf.js/web/compressed.tracemonkey-pldi-09.pdf';
          this.interceptedUrl = url.URL.parseURL(this.pdfUrl).origin;
          this.webviewController.loadUrl(`${this.interceptedUrl}/pdfviewer/viewer.html#${this.pdfUrl}`);
        } catch (error) {
          const e: BusinessError = error as BusinessError;
          console.error(`==== ErrorCode: ${e.code},  Message: ${e.message}`);
        }
      })



      Stack(){

        Text("")
          .width("100%")
          .height(33)
          .backgroundColor("#ffffff")
          .zIndex(2)

        // pdf显示
        Web({
          src: '',
          controller: this.webviewController
        })
          .domStorageAccess(true)
          .fileAccess(true)
          .mixedMode(MixedMode.All)
          .onInterceptRequest((event) => {
            if (event) {
              // 拦截页面请求
              const requestUrl = event.request.getRequestUrl()
              if (requestUrl.startsWith(this.interceptedUrl)) {
                // 构造响应数据
                const relativePath = url.URL.parseURL(requestUrl).pathname.replace(/^\//, '');
                if (relativePath.endsWith(".pdf") && !requestUrl.startsWith(this.localUrl)) {
                  return null;
                }
                const resource = $rawfile(relativePath);
                this.responseResource.setResponseData(resource);
                this.responseResource.setResponseEncoding('utf-8');
                let mimeType = "text/plain";
                if (relativePath.endsWith(".pdf")) {
                  mimeType = "application/pdf";
                } else if (relativePath.endsWith(".gif")) {
                  mimeType = "image/gif";
                } else if (relativePath.endsWith(".png")) {
                  mimeType = "image/png";
                } else if (relativePath.endsWith(".svg")) {
                  mimeType = "image/svg+xml";
                } else if (relativePath.endsWith(".css")) {
                  mimeType = "text/css";
                } else if (relativePath.endsWith(".html")) {
                  mimeType = "text/html";
                } else if (relativePath.endsWith(".js")) {
                  mimeType = "text/javascript";
                }
                this.responseResource.setResponseMimeType(mimeType);
                this.responseResource.setResponseCode(200);
                this.responseResource.setReasonMessage('OK');
                return this.responseResource;
              }
            }
            return null;
          })
          .zIndex(0)
      }
      .alignContent(Alignment.TopStart)


    }
  }



  startRecord_HTTP(){
    console.info('==== 开始学习计时')

    let startRecordArgs: string = JSON.stringify(new StartRecordArgs("PICTURE_BOOK",this.srcId ,"test-studySessionNo-PICTURE_BOOK"))

    let httpRequest_startRecord = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/studyRecord/startRecord"
    httpRequest_startRecord.request(
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
        // 请求的额外数据
        extraData: startRecordArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== startRecord_HTTP error code:" + err.code)
        console.info("==== startRecord_HTTP error message:" + err.message)
      } else {
        // 请求成功
        if(data.responseCode == 200){
          console.info("==== 开始学习计时成功！")

          let json_string = JSON.stringify(data.result)
          console.info("==== startRecord_HTTP result:"+ json_string)


            this.studyRecord  = JSON.parse(JSON.parse(json_string))

          this.recordId = this.studyRecord.id
        } else {
          console.info("==== 开始学习计时失败！")
        }


      }

    })

  }


  endRecord_HTTP(){
    console.info('==== 结束学习计时')

    let endRecordArgs: string = JSON.stringify(new EndRecordArgs(this.recordId,0))

    let httpRequest_endRecord = http.createHttp();
    let url = CommonConstants.API_HOST + "client/api/studyRecord/endRecord"
    httpRequest_endRecord.request(
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
        // 请求的额外数据
        extraData: endRecordArgs

      }, (err, data) => {
      if (err) {
        // 请求失嫩
        console.info("==== endRecord_HTTP error code:" + err.code)
        console.info("==== endRecord_HTTP error message:" + err.message)
      } else {
        // 请求成功
        if(data.responseCode == 200){
          console.info("==== 结束学习计时成功！")

          let json_string = JSON.stringify(data.result)
          console.info("==== endRecord_HTTP result:"+ json_string)
          // this.getFlashCardStudyList_HTTP()

        } else {
          console.info("==== 结束学习计时失败！")
        }


      }

    })
  }



}

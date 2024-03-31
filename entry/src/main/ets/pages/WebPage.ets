import url from '@ohos.url';
import web_webview from '@ohos.web.webview';
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct Index {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController();
  responseResource: WebResourceResponse = new WebResourceResponse();
  localUrl: string = 'http://pdfviewer.local';
  interceptedUrl: string = this.localUrl;
  pdfUrl: string = '';

  aboutToAppear() {
    // 配置Web开启调试模式
    web_webview.WebviewController.setWebDebuggingAccess(true);
  }

  build() {
    Column() {
      Row() {
        Button('pdfjs http')
          .onClick(async () => {
            try {
              this.pdfUrl = 'https://mozilla.github.io/pdf.js/web/compressed.tracemonkey-pldi-09.pdf';
              this.interceptedUrl = url.URL.parseURL(this.pdfUrl).origin;
              this.webviewController.loadUrl(`${this.interceptedUrl}/pdfviewer/viewer.html#${this.pdfUrl}`);
            } catch (error) {
              const e: BusinessError = error as BusinessError;
              console.error(`==== ErrorCode: ${e.code},  Message: ${e.message}`);
            }
          })
      }


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
    }
  }
}

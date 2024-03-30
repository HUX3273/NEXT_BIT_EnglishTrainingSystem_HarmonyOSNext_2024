import { WordTranslatorDialog } from './WordTranslatorDialog';
import PreferencesUtil from '../common/database/PreferencesUtil';
import { prompt, promptAction } from '@kit.ArkUI';

@CustomDialog
export struct SearchMyWordDialog {
  @State word: string = '';
  @State token: string = ''
  @Provide isChosenArr: Array<Boolean> = [];
  @Provide chosenWordIndex: number = 0;
  private rExpForWord: RegExp = /[a-zA-Z]+/; //用于提取单词
  //新建单击查词的窗口控制器
  dialogController_translator: CustomDialogController = new CustomDialogController({
    builder: WordTranslatorDialog({
      word: $word,
      token: $token,
    }),
    cancel: this.existApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  // 本窗口自己的控制器（若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在最后）
  ownController: CustomDialogController

  async aboutToAppear() {
    await PreferencesUtil.getToken().then((value) => {
      this.token = value
    });

  }

  build() {
    Column() {


      Text('查询单词')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })


      TextInput()
        .type(InputType.Normal)
        .width("80%")
        .margin({top:10})
        .onChange((value: string) => {
          this.word = value
        })


      Row() {
        Button('取消')
          .fontSize(20)
          .backgroundColor('#F8F8F8')
          .fontColor('#8D8D8D')
          .borderRadius(10)
          .width('30%')
          .margin({ right: 70 })
          .onClick((event: ClickEvent) => {
            this.ownController.close()
          })

        Button('查询')
          .fontSize(20)
          .backgroundColor('#EC5706')
          .fontColor(Color.White)
          .borderRadius(10)
          .width('30%')
          .onClick((event: ClickEvent) => {

            let tempStrArr:Array<string> = [' ']
            tempStrArr = this.word.match(this.rExpForWord) as Array<string>
            if(tempStrArr != null){
              this.word = tempStrArr[0]
              this.dialogController_translator.open()
            } else {
              promptAction.showToast({
                message: "请检查单词的语法"
              })
            }

          })

      }
      .margin({top:20,bottom:20})
      .width("100%")
      .justifyContent(FlexAlign.Center)

    }

  }

  public existApp() {
    console.info('====Click the callback in the blank area')

  }
}
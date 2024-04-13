import PreferencesUtil from '../common/database/PreferencesUtil';
import { WordTranslatorDialog } from './WordTranslatorDialog';


@Component
export struct TextReader {
  @State count: number = 0;
  @State caption: string = '';
  @State wordArr: Array<string> = []; // 存分词后的结果
  @State word: string = ''; // 去除标点符号等非法字符后的英文单词
  @State token: string = ''
  @Provide isChosenArr: Array<Boolean> = []; //存该分词是否被选中
  @Provide chosenWordIndex: number = 0;
  scroller: Scroller = new Scroller();
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
  private videoName: string = '';
  // 正则表达式
  private rExpForSplit: RegExp = /[ \n\t>]/; //用于分词
  //private rExpForNewline: RegExp = /[A-Z]/;  //用于匹配大写首字母然后换行
  private rExpForTimeTag_1: RegExp = /[0-9][0-9]:[0-9][0-9]/; // 用于删除字幕的时间戳日期
  private rExpForTimeTag_2: RegExp = /--/; // 用于删除字幕的时间戳--
  private rExpForTimeTag_3: RegExp = /"?#/; // 用于删除color="#ffffff" 与 #
  // private rExpForTimeTag_4: RegExp = /\w+(?=<\/font)/; // 选中字母后跟随</font>符号的单词，需要删掉后面跟随的</font>
  private rExpForTimeTag_5: RegExp = /(?<=<)\w+/; // 选中字母前由有符号<的单词，用于删除<font

  private rExpForPunctuation: RegExp = /[.。!！?？]/; //用于检测符号换行
  private rExpForWord: RegExp = /[a-zA-Z]+/; //用于提取单词
  private subtitleText: string = 'NOTHING FOUND~';
  private fontSize: number = 24; // 文本字体大小
  private fontWeight: FontWeight = FontWeight.Bold;

  async aboutToAppear() {
    // await PreferencesUtil.getToken().then((value) => {
    //   this.token = value
    // });
    //this.readfile_from_rawfile();

    // 分词
    // this.wordArr = this.subtitleText.split(this.rExpForTimeTag);
    this.wordArr = this.subtitleText.split(this.rExpForSplit);

    //this.wordArr = this.subtitleText.split(" ");
    //初始化 isChosenArr 数组
    for (let index = 0; index < this.wordArr.length; index++) {
      this.isChosenArr[index] = false;
    }
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          Text() {
            ForEach(this.wordArr, (item: string, index: number) => {

              if (!this.rExpForTimeTag_1.test(item) && !this.rExpForTimeTag_2.test(item) && !this.rExpForTimeTag_3.test(item)
                      && !this.rExpForTimeTag_5.test(item) ) {


                Span(item.split('<')[0])
                  .fontSize(this.fontSize)
                  .fontColor(this.isChosenArr[index] == false ? '#000000' : '#EC5706')
                  .fontWeight(this.fontWeight)
                  .onClick(() => {

                    console.info('==== 您点击了span：', item)

                    if (item.match(this.rExpForWord) != null) {

                      this.chosenWordIndex = index;
                      this.isChosenArr[index] = true

                      let tempStrArr: Array<string> = ['']
                      tempStrArr = item.match(this.rExpForWord) as Array<string>
                      this.word = tempStrArr[0]

                      console.info('==== 您点击了单词：', this.word)

                      // Prompt.showDialog({
                      //   title:this.word,
                      //   message:'翻译内容展示',
                      //
                      // })

                      //弹出自定义的窗口
                      if (this.dialogController_translator != undefined) {
                        this.dialogController_translator.open()
                      }


                    }

                  })
                /*
                    span功能极其有限，不支持长按！！！
                 */
                //
                // .gesture(
                //   // 绑定可以重复触发的LongPressGesture
                //   LongPressGesture({ repeat: false })
                //     .onAction((event: GestureEvent) => {
                //
                //         this.chosenWordIndex = index;
                //         this.isChosenArr[index] = true
                //
                //         this.word = item.match(this.rExpForWord)[0]
                //
                //         console.info('====您长按了单词：', this.word)
                //
                //         //弹出闪卡添加窗口
                //         this.dialogController_shinyCard.open()
                //
                //
                //     })
                // )


                // 将单词排版成完整的文本
                if (this.rExpForPunctuation.test(item)) {
                  Span('\n') //添加换行符
                } else {
                  Span(' ') //添加空格
                }


              }

            })
          }
        }
        .margin({ bottom: 20 })

      }
      .width('95%').height('100%')
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }

  public onCancel() {
    console.info('====Callback when the first button is clicked')
    this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  public onAccept() {
    console.info('====Callback when the second button is clicked')
    this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态
  }

  public existApp() {
    console.info('====Click the callback in the blank area')
    this.isChosenArr[this.chosenWordIndex] = false //取消选中后解除单词的选中状态

  }

  //  仅供本地测试，接入后端后废弃
  // 从rawfile中取字幕文件
  // async readfile_from_rawfile() {
  //   try {
  //     let uint8Array = await globalThis.context.resourceManager.getRawFileContent('rawfile/test.txt');
  //     //let str = String.fromCharCode.apply(null, new Uint8Array(uint8Array.buffer));
  //     let textDecoder = new util.TextDecoder("utf-8"); //解决中文乱码的问题，文件是什么编码格式括号里就写什么格式
  //     let str = textDecoder.decode(new Uint8Array(uint8Array));
  //
  //     this.caption = str;
  //
  //   } catch (error) {
  //     console.info("====Error Happened While Reading Files From Raw Files!")
  //
  //   }
  // }
}
import Check_Access from '../common/utils/Detector'
import { common } from '@kit.AbilityKit'
import Request_Permission_From_Users from '../common/utils/Applicant'

@Entry
@Component
struct Index {

  //将应用是否获取权限这条信息用布尔型变量ifAccessible储存
  @State ifAccessible:boolean = false

  //new两个弹窗控制器
  private dialogController_Accessible : CustomDialogController = new CustomDialogController({
    builder:dialog({
      message:'已获取权限'
    })
  })

  private dialogController_Inaccessible : CustomDialogController = new CustomDialogController({
    builder:dialog({
      message:'暂未获取权限'
    })
  })

  //编写异步方法detect,调用之前已写好的模块文件Detector
  async detect(){
    let res = await Check_Access()
    this.ifAccessible = res
    if(res){
      this.dialogController_Accessible.open()
    }else{
      this.dialogController_Inaccessible.open()
    }

  }



  //获取上下文对象, 储存在成员变量context中
  private context = getContext(this) as common.UIAbilityContext

  //编写异步方法,调用之前已写好的模块文件Applicant
  async apply(){
    let res = await Request_Permission_From_Users(this.context)
    this.ifAccessible = res
    if(res){
      this.dialogController_Accessible.open()
    }else{
      this.dialogController_Inaccessible.open()
    }
  }



  build() {
    Row() {
      Column() {

        //添加两个Button组件和一个Image组件

        //条件渲染Image组件
        if(this.ifAccessible){
          Image($r('app.media.video_list0'))
            .height(200)
            .width(200)
        }else{
          Image($r('app.media.video_list2'))
            .height(200)
            .width(200)
        }

        //第一个Button组件
        Button('检查应用是否获得权限')
          .fontSize(20)
          .width('70%')
          .margin({
            top:40
          })
          .backgroundColor(Color.Pink)
            //设置onclick回调，并调用异步函数detect()
          .onClick(()=>{
            this.detect()
          })

        //第二个Button组件
        Button('向用户动态申请权限')
          .fontSize(20)
          .width('70%')
          .margin({
            top:20
          })
          .backgroundColor(Color.Pink)
            //设置onclick回调，并调用异步函数apply()
          .onClick(()=>{
            this.apply()
          })

      }
      .width('100%')
    }
    .height('100%')
  }
}

//自定义弹窗
@CustomDialog
struct dialog{

  controller:CustomDialogController

  @State message:string = ''

  build(){
    Column() {
      Text(this.message)
        .fontSize(20)
        .height(40)
        .fontColor(Color.White)
    }
    .width('100%')
    .backgroundColor(Color.Gray)
  }

}
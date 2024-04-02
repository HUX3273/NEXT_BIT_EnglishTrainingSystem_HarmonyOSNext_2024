import { display } from '@kit.ArkUI';

export default class DisplayUtils{


  public getScreenWidth():number {

    let displayClass:display.Display[] = [];
    display.getAllDisplays((err, data) => {
      displayClass = data;
      if (err.code) {
        console.error('Failed to obtain all the display objects. Code: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in obtaining all the display objects. Data: ' + JSON.stringify(data));
    });

    let length = displayClass[0].width
    console.info("==== 屏幕宽度："+length)
    return length

  }


  public getScreenHeight():number {

    let displayClass:display.Display[] = [];
    display.getAllDisplays((err, data) => {
      displayClass = data;
      if (err.code) {
        console.error('Failed to obtain all the display objects. Code: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in obtaining all the display objects. Data: ' + JSON.stringify(data));
    });

    let length = displayClass[0].height
    console.info("==== 屏幕高度："+length)
    return length

  }





}





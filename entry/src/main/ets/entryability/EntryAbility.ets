import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import Logger from '../common/utils/Logger';
import PreferencesUtil from '../common/database/Preferencesutil';
import { AbilityConstant, Want } from '@kit.AbilityKit';
import { GlobalContext } from '../common/utils/GlobalContext';
import { HttpProxyCacheServer, HttpProxyCacheServerBuilder,CacheListener,FileNameGenerator ,HeaderInjector} from '@ohos/video-cache';
import GlobalProxyServer from '../common/proxy/GlobalProxyServer';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';


const TAG = '[entryAbility]';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    Logger.info(TAG, 'onCreate');
    GlobalContext.getContext().setObject('abilityWant', want);


    // 创建首选项
    PreferencesUtil.createAllPreferences(this.context);


    // 设置默认首选项数据
    PreferencesUtil.saveDefaultAll(10,'','2ed90bd3-446b-41a6-b8cd-f804f718382a','3325','');


  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability



    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        console.error('==== 获取失败' + JSON.stringify(err));
        return;
      }
      console.info('==== 获取主窗口的实例：' + JSON.stringify(data));
      globalThis.windowClass = data // 赋值给全局变量windowClass
    });





    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');


    windowStage.loadContent('pages/LoginPage', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}

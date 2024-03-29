/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import dataPreferences from '@ohos.data.preferences';
import { GlobalContext } from '../utils/GlobalContext';
import Logger from '../utils/Logger';

const TAG = '[PreferencesUtil]';
const PREFERENCES_NAME = 'myPreferences';   // 首选项名字

// 首选项Key字段
const KEY_APP_FONT_SIZE = 'appFontSize';
const KEY_USER_NAME = 'userName';
const KEY_TOKEN = 'token'



/**
 * The PreferencesUtil provides preferences of create, save and query.
 */
export class PreferencesUtil {

  ////////////////////////////////////////         创建首选项           ////////////////////////////////////////

  createAllPreferences(context: Context) {
    let allPreferences: Function = (() => {
      // 获取首选项实例
      let preferences: Promise<dataPreferences.Preferences> = dataPreferences.getPreferences(context,
        PREFERENCES_NAME);
      return preferences;
    });
    GlobalContext.getContext().setObject('getAllPreferences', allPreferences);
  }




  ////////////////////////////////////////         在应用创建时给数据默认值           ////////////////////////////////////////

  // 通过has方法判断首选项中是否包含指定的key，保证指定的key不会被重复保存
  saveDefaultAll(fontSize: number,userName: string,token: string) {
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getAllPreferences') as Function;
    getAllPreferences().then((preferences: dataPreferences.Preferences) => {
      // 判断保存的key是否存在

        // 保存font
      preferences.has(KEY_APP_FONT_SIZE).then(async (isExist: boolean) => {
        Logger.info(TAG, '==== preferences has changeFontSize is ' + isExist);
        if (!isExist) {
          await preferences.put(KEY_APP_FONT_SIZE, fontSize);
          preferences.flush();
        }
      }).catch((err: Error) => {
        Logger.error(TAG, '==== Has the value failed with err: ' + err);
      });

        // 保存userName
      preferences.has(KEY_USER_NAME).then(async (isExist: boolean) => {
        Logger.info(TAG, '==== preferences has userName is ' + isExist);
        if (!isExist) {
          await preferences.put(KEY_USER_NAME, userName);
          preferences.flush();
        }
      }).catch((err: Error) => {
        Logger.error(TAG, '==== Has the value failed with err: ' + err);
      });

      // 保存token
      preferences.has(KEY_TOKEN).then(async (isExist: boolean) => {
        Logger.info(TAG, '==== preferences has token is ' + isExist);
        if (!isExist) {
          await preferences.put(KEY_TOKEN, token);
          preferences.flush();
        }
      }).catch((err: Error) => {
        Logger.error(TAG, '==== Has the value failed with err: ' + err);
      });

    }).catch((err: Error) => {
      Logger.error(TAG, '==== Get the preferences failed, err: ' + err.message);
    });



  }


  ////////////////////////////////////////     存数据     ////////////////////////////////////////

  // 通过flush方法把应用数据保存到文件中，使得应用数据保存期限变长，

  saveChangeFontSize(fontSize: number){
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getAllPreferences') as Function;
    getAllPreferences().then(async (preferences: dataPreferences.Preferences) => {
      // 保存 fontSize 数据
      await preferences.put(KEY_APP_FONT_SIZE, fontSize);
      // 数据持久化
      preferences.flush();
    }).catch((err: Error) => {
      Logger.error(TAG, '====put the preferences failed, err: ' + err);
    });
  }

  saveUserName(userName: string){
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getAllPreferences') as Function;
    getAllPreferences().then(async (preferences: dataPreferences.Preferences) => {
      // 保存 userName 数据
      await preferences.put(KEY_USER_NAME, userName);
      // 数据持久化
      preferences.flush();
    }).catch((err: Error) => {
      Logger.error(TAG, '====put the preferences failed, err: ' + err);
    });
  }

  saveToken(token: string){
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getAllPreferences') as Function;
    getAllPreferences().then(async (preferences: dataPreferences.Preferences) => {
      // 保存 token 数据
      await preferences.put(KEY_TOKEN, token);
      // 数据持久化
      preferences.flush();
    }).catch((err: Error) => {
      Logger.error(TAG, '====put the preferences failed, err: ' + err);
    });
  }



  ////////////////////////////////////////         取数据           ////////////////////////////////////////

  //  该方法通过key-value键值对方式读取，常量KEY_APP_FONT_SIZE作为key，默认数据fontSize作为value，把的到的结果赋值给变量fontSize，通过return方式把值返回去
  async getChangeFontSize() {
    let fontSize: number = 0;
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getAllPreferences') as Function;
    fontSize = await (await getAllPreferences()).get(KEY_APP_FONT_SIZE, fontSize);
    return fontSize;
  }
  async getUserName() {
    let userName: string = '';
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getAllPreferences') as Function;
    userName = await (await getAllPreferences()).get(KEY_USER_NAME, userName);
    return userName;
  }

  async getToken() {
    let token: string = '';
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getAllPreferences') as Function;
    token = await (await getAllPreferences()).get(KEY_TOKEN, token);
    return token;
  }


  ////////////////////////////////////////         删除数据           ////////////////////////////////////////

  // 删除首选项数据需要获取preferences实例，用delete方法删除指定的key所对应的值，常量KEY_APP_FONT_SIZE作为key，通过Promise异步回调是否删除成功
  async deleteChangeFontSize() {
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getFontPreferences') as Function;
    const preferences: dataPreferences.Preferences = await getAllPreferences();
    let deleteValue = preferences.delete(KEY_APP_FONT_SIZE);
    deleteValue.then(() => {
      Logger.info(TAG, '====Succeeded in deleting the key appFontSize.');
    }).catch((err: Error) => {
      Logger.error(TAG, '====Failed to delete the key appFontSize. Cause: ' + err);
    });
  }
  async deleteUserName() {
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getAllPreferences') as Function;
    const preferences: dataPreferences.Preferences = await getAllPreferences();
    let deleteValue = preferences.delete(KEY_USER_NAME);
    deleteValue.then(() => {
      Logger.info(TAG, '====Succeeded in deleting the key userName.');
    }).catch((err: Error) => {
      Logger.error(TAG, '====Failed to delete the key userName. Cause: ' + err);
    });
  }
  async deleteToken() {
    let getAllPreferences: Function = GlobalContext.getContext().getObject('getAllPreferences') as Function;
    const preferences: dataPreferences.Preferences = await getAllPreferences();
    let deleteValue = preferences.delete(KEY_TOKEN);
    deleteValue.then(() => {
      Logger.info(TAG, '====Succeeded in deleting the key token.');
    }).catch((err: Error) => {
      Logger.error(TAG, '====Failed to delete the key token. Cause: ' + err);
    });
  }




}



// export class PreferencesUtil {
//
//   createFontPreferences(context: Context) {
//     let fontPreferences: Function = (() => {
//       // 获取首选项实例
//       let preferences: Promise<dataPreferences.Preferences> = dataPreferences.getPreferences(context,
//         PREFERENCES_NAME);
//       return preferences;
//     });
//     GlobalContext.getContext().setObject('getFontPreferences', fontPreferences);
//   }
//
//
//   // 通过has方法判断首选项中是否包含指定的key，保证指定的key不会被重复保存
//   saveDefaultFontSize(fontSize: number) {
//     let getFontPreferences: Function = GlobalContext.getContext().getObject('getFontPreferences') as Function;
//     getFontPreferences().then((preferences: dataPreferences.Preferences) => {
//       // 判断保存的key是否存在
//       preferences.has(KEY_APP_FONT_SIZE).then(async (isExist: boolean) => {
//         Logger.info(TAG, 'preferences has changeFontSize is ' + isExist);
//         if (!isExist) {
//           // 保存数据
//           await preferences.put(KEY_APP_FONT_SIZE, fontSize);
//           preferences.flush();
//         }
//       }).catch((err: Error) => {
//         Logger.error(TAG, 'Has the value failed with err: ' + err);
//       });
//     }).catch((err: Error) => {
//       Logger.error(TAG, 'Get the preferences failed, err: ' + err);
//     });
//   }
//
//
//   // 通过flush方法把应用数据保存到文件中，使得应用数据保存期限变长，
//   saveChangeFontSize(fontSize: number) {
//     let getFontPreferences: Function = GlobalContext.getContext().getObject('getFontPreferences') as Function;
//     getFontPreferences().then(async (preferences: dataPreferences.Preferences) => {
//       // 保存数据
//       await preferences.put(KEY_APP_FONT_SIZE, fontSize);
//       // 数据持久化
//       preferences.flush();
//     }).catch((err: Error) => {
//       Logger.error(TAG, 'put the preferences failed, err: ' + err);
//     });
//   }
//
//
//   //  该方法通过key-value键值对方式读取，常量KEY_APP_FONT_SIZE作为key，默认数据fontSize作为value，把的到的结果赋值给变量fontSize，通过return方式把值返回去
//   async getChangeFontSize() {
//     let fontSize: number = 0;
//     let getFontPreferences: Function = GlobalContext.getContext().getObject('getFontPreferences') as Function;
//     fontSize = await (await getFontPreferences()).get(KEY_APP_FONT_SIZE, fontSize);
//     return fontSize;
//   }
//
//
//   // 删除首选项数据需要获取preferences实例，用delete方法删除指定的key所对应的值，常量KEY_APP_FONT_SIZE作为key，通过Promise异步回调是否删除成功
//   async deleteChangeFontSize() {
//     let getFontPreferences: Function = GlobalContext.getContext().getObject('getFontPreferences') as Function;
//     const preferences: dataPreferences.Preferences = await getFontPreferences();
//     let deleteValue = preferences.delete(KEY_APP_FONT_SIZE);
//     deleteValue.then(() => {
//       Logger.info(TAG, 'Succeeded in deleting the key appFontSize.');
//     }).catch((err: Error) => {
//       Logger.error(TAG, 'Failed to delete the key appFontSize. Cause: ' + err);
//     });
//   }
//
//
//
// }


export default new PreferencesUtil();


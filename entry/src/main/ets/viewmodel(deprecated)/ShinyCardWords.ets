// 仅作前端单独测试使用
@Observed

export class ShinyCardWord {
  word: string; // 单词
  picSrc: Array<string>; // 图源，多个图随机选一个展示
  audioSrc: string; // 音源
  level: string; // 难度等级
  transl_cn: string; // 中文译文
  transl_en: string; // 英文译文
  done: boolean;  // 是否完成该闪卡的复习

  constructor(word:string,picSrc:Array<string>,audioSrc: string,level: string,transl_cn: string,transl_en: string,done:boolean) {
    this.word = word;
    this.picSrc = picSrc;
    this.audioSrc = audioSrc;
    this.level = level;
    this.transl_cn = transl_cn;
    this.transl_en = transl_en;
    this.done = done
  }
}

export const ShinyCardWords: ShinyCardWord[] = [
  new ShinyCardWord('apple',
    // 图片源
    ['https://www.industryleadersmagazine.com/wp-content/uploads/2012/04/Apple.jpg',
    'https://www.organic-center.org/sites/default/files/research/2018/10/Apple1.jpg',
    'https://fruitmaven.com/wp-content/gallery/arkansas-black-apple/arkansas-black-apple-whole-slice.jpg',
    'https://1000logos.net/wp-content/uploads/2016/10/apple-emblem.jpg',
    'https://pngimg.com/uploads/apple_logo/apple_logo_PNG19673.png'],
    // 音源
    'http://music.163.com/song/media/outer/url?id=447925558.mp3',
    // 难度等级
    '',
    // 中文译文
    'n. 苹果',
    // 英文译文
    'An apple is a round fruit with smooth red, yellow, or green skin and firm white flesh.',
    // 是否复习完成
    false
  ),

  new ShinyCardWord('pear',[],'','','','', false),

];
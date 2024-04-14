/*
仅供前端独立测试时使用
 */
@Observed
export class ShinyCardPictureItem {
  id: number; //
  picSrc: string; // 图源
  word: string; //
  isChosen: boolean;

  constructor(id: number,picSrc: string,word: string,isChosen:boolean) {
    this.id = id;
    this.picSrc = picSrc;
    this.word = word;
    this.isChosen = isChosen;
  }
}


export const ShinyCardPictures: ShinyCardPictureItem[] = [
  new ShinyCardPictureItem(1,'https://www.industryleadersmagazine.com/wp-content/uploads/2012/04/Apple.jpg','apple',false ),
  new ShinyCardPictureItem(2,'https://www.organic-center.org/sites/default/files/research/2018/10/Apple1.jpg','apple',false ),
  new ShinyCardPictureItem(3,'https://fruitmaven.com/wp-content/gallery/arkansas-black-apple/arkansas-black-apple-whole-slice.jpg','apple',false),
  new ShinyCardPictureItem(4,'https://1000logos.net/wp-content/uploads/2016/10/apple-emblem.jpg','apple',false ),
  new ShinyCardPictureItem(5,'https://pngimg.com/uploads/apple_logo/apple_logo_PNG19673.png','apple',false ),
  new ShinyCardPictureItem(6,'https://www.thoughtco.com/thmb/69eMd-vX2MbwT8dh9tM2b50jOxA=/3554x2843/filters:fill(auto,1)/herbstfarben-144476015-5867d0525f9b586e02213437.jpg','apple',false),
];

import { HorizontalMultiMediaItem, HorizontalPictureBookItem } from './HorizontalMultiMediaItem';



// 视频资源
export const HORIZONTAL_VIDEOS: HorizontalMultiMediaItem[] = [
  new HorizontalMultiMediaItem(1, $r('app.media.video_list0'),'http://video.chinanews.com/flv/2019/04/23/400/111773_web.mp4' ,'视频1'),
  new HorizontalMultiMediaItem(2, $r('app.media.video_list1'),'http://vjs.zencdn.net/v/oceans.mp4' ,'视频2'),
  new HorizontalMultiMediaItem(3, $r('app.media.video_list2'),'https://media.w3.org/2010/05/sintel/trailer.mp4','视频3'),

];



// 音频资源
export const HORIZONTAL_AUDIOS: HorizontalMultiMediaItem[] = [
  new HorizontalMultiMediaItem(1, $r('app.media.audio'),'http://music.163.com/song/media/outer/url?id=447925558.mp3' ,'音频1'),
  new HorizontalMultiMediaItem(2, $r('app.media.audio'),'https://www.cambridgeenglish.org/images/153149-movers-sample-listening-test-vol2.mp3' ,'音频2'),
  new HorizontalMultiMediaItem(3, $r('app.media.audio'),'http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3','音频3'),

];



// 绘本资源
export const HORIZONTAL_PICTUREBOOKS:HorizontalPictureBookItem[] = [
  new HorizontalPictureBookItem(1,
    'https://www.industryleadersmagazine.com/wp-content/uploads/2012/04/Apple.jpg',
    // 绘本图片源
    ['https://www.industryleadersmagazine.com/wp-content/uploads/2012/04/Apple.jpg',
      'https://www.organic-center.org/sites/default/files/research/2018/10/Apple1.jpg',
      'https://fruitmaven.com/wp-content/gallery/arkansas-black-apple/arkansas-black-apple-whole-slice.jpg',
      'https://1000logos.net/wp-content/uploads/2016/10/apple-emblem.jpg',
      'https://pngimg.com/uploads/apple_logo/apple_logo_PNG19673.png'],
    '绘本1'),
  new HorizontalPictureBookItem(2,
    'https://1000logos.net/wp-content/uploads/2016/10/apple-emblem.jpg',
    [''],
    '绘本2'),
  new HorizontalPictureBookItem(3,
    'https://pngimg.com/uploads/apple_logo/apple_logo_PNG19673.png',
    [''],
    '绘本3')


]





import MainPageGrid from './MainPageGrid';

export class MainViewModel {

  /**
   * Get data of the grid.
   *
   * @return {Array<PageResource>} GridData.
   */
  getGridData(): Array<MainPageGrid> {
    let GridData: MainPageGrid[] = [
      new MainPageGrid($r('app.string.mouth'), $r('app.media.mouth'),'MouthPage'),
      new MainPageGrid($r('app.string.eye'), $r('app.media.eye'),'EyePage'),
      new MainPageGrid($r('app.string.ear'), $r('app.media.ear'),'EarPage'),
      new MainPageGrid($r('app.string.shiny_card'), $r('app.media.shiny_card'),'ShinyCardPage'),
      new MainPageGrid($r('app.string.picture_book'), $r('app.media.picture_book'),'PictureBookPage'),
      new MainPageGrid($r('app.string.oral_practice'), $r('app.media.oral_practice'),'OralPracticePage'),
    ];
    return GridData;
  }

}

export default new MainViewModel();
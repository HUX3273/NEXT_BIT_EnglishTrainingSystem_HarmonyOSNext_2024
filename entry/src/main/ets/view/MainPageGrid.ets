/**
 * List item data entity.
 */
export default class MainPageGrid {
  /**
   * Text of list item.
   */
  title: Resource;
  /**
   * Image of list item.
   */
  img: Resource;
  /**
   * destination page of list item.
   */
  des_page: String;
  /**
   * Other resource of list item.
   */
  others?: Resource;

  constructor(title: Resource, img: Resource,des_page: String, others?: Resource) {
    this.title = title;
    this.img = img;
    this.des_page = des_page
    this.others = others;
  }
}
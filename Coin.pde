/**
* This is a coin, a trigger object by default
*
*/
class Coin extends Actor{
  /**
   * Creates coin at location
   * @param x_ x location for coin
   * @param y_ y location for coin
   * @param img_ the image for the coin
   */
  Coin(float x_, float y_, PImage img_) {
    super(x_, y_);

    collisionMode = TRIGGERC;

    cTop = 10;
    cBottom = 10;
    cLeft = 10;
    cRight = 10;

    img = img_;
  }
  /**
   * Updates the coin's angle
   */
  @Override
  void update() {
    angle = sin(millis()*0.005)*0.5;
  }



}

/**
* The camera 2d class does the main translation of the game. acting as a camera moving around
* it does the movements smoothly, thus not 100% on the target all the time.
*
* @author  Donny Wu
* @version 1.0
*/
class Cam2D extends GameObject {
  // how fast the camera moves
  float smoothFactor;

  /**
   * Creates a camera where 0,0 is at the center of the screen
   * Also starts smooth panning
   */
  Cam2D() {
    super(width/2, height/2);

    des = loc.copy();
    smoothFactor = .1;
  }

  /**
   * Creates a camera where 0,0 is at x,y
   * Also starts smooth panning
   * @param x_ x location for center
   * @param y_ y location for center
   */
  Cam2D(float x_, float y_, float angle_) {
    super(x_, y_, angle_);

    angleDes = angle_;
    des = loc.copy();
    smoothFactor = .1;
  }

  /**
   * Overrides the default blank gameObject update method
   * Should be ran every game tick
   */
  @Override
  void update() {
    smoothMove(smoothFactor);
    smoothRotate(smoothFactor);


    for (int c = 0; c < updatePhysics; c++) {
      simplePhysicsCal();
    }

    translate(width/2-width/4,height/2);
    rotate(angle);
    scale(sin(millis()*0.01)*0.05+1+0.05);
    translate(loc.x, loc.y);

  }

}

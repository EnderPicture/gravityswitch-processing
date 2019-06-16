/**
* The GameObject class consists of simple physics calculations and image based animations
*
*/
class GameObject{

  // physics values
  PVector loc, vel, acc, des;
  // angle valeus
  float angle, angleVel, angleAcc, angleDes;
  // the display image
  PImage img;
  // animation frames
  PImage[] frames;

  // so it can keep track of the last millisecond it changed the frame, frame c is the current frame
  int lastMilAni;
  int frameC;

  boolean centralImgArray;

  // this is for central image array based animatoin
  int minFrame;
  int maxFrame;

  /**
   * Star an game object at 0,0
   */
  GameObject() {
    loc =  new PVector();
    vel =  new PVector();
    acc =  new PVector();
    des =  new PVector();
  }

  /**
   * Star an gameObject up with location
   * @param x_ the X locaiton of the new gameObject
   * @param y_ the Y locaiton of the new gameObject
   */
  GameObject(float x_, float y_) {
    loc =  new PVector(x_, y_);
    vel =  new PVector();
    acc =  new PVector();
    des =  new PVector();
  }

  /**
   * Star an gameObject up with location and angle
   * @param x_ the X locaiton of the new gameObject
   * @param y_ the Y locaiton of the new gameObject
   * @param angle_ the angle the object will be at
   */
  GameObject(float x_, float y_, float angle_) {
    loc =  new PVector(x_, y_);
    vel =  new PVector();
    acc =  new PVector();
    des =  new PVector();
    angle = angle_;
  }

  /**
   * Star an gameObject up with location and an name for animations
   * @param x_ the X locaiton of the new actor
   * @param y_ the Y locaiton of the new actor
   * @param minFrame_ where the frame gatherer should start its image grabbing
   * @param maxFrame_ where the frame gatherer should end its image grabbing
   * @param fileName_ the file path to the image files. has to be in "fileName_"+00000.png format
   */
  GameObject(float x_, float y_, int minFrame_, int maxFrame_, String fileName_) {
    loc =  new PVector(x_, y_);
    vel =  new PVector();
    acc =  new PVector();
    des =  new PVector();

    frames = new PImage[maxFrame_ - minFrame_];
    for (int c = 0; c < maxFrame_- minFrame_; c++)
      frames[c] = loadImage(fileName_+nf(c+minFrame_,5)+".png");

    // defualt image;
    img = frames[0];
  }

  /**
   * Star an gameObject up with location and the usage of image array reference
   * @param x_ the X locaiton of the new actor
   * @param y_ the Y locaiton of the new actor
   * @param minFrame_ the min frame the actor can use from the image array
   * @param maxFrame_ the max frame the actor can use from the image array
   * @param frames_ the preloaded image array
   */
  GameObject(float x_, float y_, int minFrame_, int maxFrame_, PImage[] frames_) {
    loc =  new PVector(x_, y_);
    vel =  new PVector();
    acc =  new PVector();
    des =  new PVector();

    minFrame = minFrame_;
    maxFrame = maxFrame_;


    frames = frames_;

    // defualt image;
    img = frames[minFrame_];

    centralImgArray = true;
  }

  /**
   * Smoothly animate between des and loc
   * @param smoothFactor_ 0 - 1 where 1 is no smoothMove and 0 is no movment at all
   */
  void smoothMove(float smoothFactor_) {
    float vX = des.x - loc.x;
    float vY = des.y - loc.y;

    vX *= smoothFactor_;
    vY *= smoothFactor_;

    vel = new PVector(vX, vY);
  }

  /**
   * Smoothly rotate between angle des and angle loc
   * @param smoothFactor_ 0 - 1 where 1 is no smoothRotate and 0 is no rotation at all
   */
  void smoothRotate(float smoothFactor_) {
    // angleDes += (int)(angleDes/TWO_PI)*TWO_PI;

    // if (angleDes < 0) {
    //   angleDes += (int)(abs(angleDes)/TWO_PI)*TWO_PI+TWO_PI;
    // }

    // if (this instanceof Cam2D) {
    //   println(angleDes);
    // }

    float v = angleDes - angle;

    // go the shorter way
    if (v > PI)
      v -= 2*PI;
    if (v < -PI)
      v += 2*PI;

    angleVel = v*smoothFactor_;
  }

  /**
   * Calculate physics
   */
  void simplePhysicsCal() {

    vel.add(acc);
    loc.add(vel);
    angleVel += angleAcc;
    angle    += angleVel;



    // vel.add(acc.copy().mult((float)deltaTo60FPS));
    // loc.add(vel.copy().mult((float)deltaTo60FPS));
    //
    // angleVel += angleAcc*deltaTo60FPS;
    // angle    += angleVel*deltaTo60FPS;
  }

  /**
   * Animate img
   * @param min_ min frame index
   * @param max_ max frame index
   * @param aniSpeed_ millisecond per frame
   * @param loop_ should the animation loop?
   * @param reverse_ should the animation be ran in reverse?
   */
  void animate(int min_, int max_, int aniSpeed_, boolean loop_, boolean reverse_) {

    // advance frame
    if (millis() - lastMilAni > aniSpeed_) {
      if (reverse_)
        frameC--;
      else
        frameC++;

      lastMilAni = millis();
    }

    if (reverse_) {
      // the index is going in reverse
      if (frameC > max_)
        // this should not happen, but if it does, we can handle it
        frameC = max_;
      else if (loop_ && frameC < min_)
        // if it should loop, put it to the max again
        frameC = max_;
      else if (!loop_ && frameC < min_)
        // if it should not, stay at min
        frameC = min_;
    } else {
      // the index is going forward
      if (frameC < min_)
        // this should not happen, but if it does, we can handle it
        frameC = min_;
      else if (loop_ && frameC > max_)
        // if it should loop, put it to the min again
        frameC = min_;
      else if (!loop_ && frameC > max_)
        // if it should not, stay at max
        frameC = max_;
    }

    img = frames[frameC];
  }
  // useless update. put here as placeholder for future inheritance
  void update() {
  }

  /**
   * render the gameObject. If has image, draw image. If not, draw a rectangle.
   */
  void render() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(angle);

    if (img != null)
      image(img, 0, 0);
    else {
      rect(0,0,100,200);
      ellipse(0,0,20,20);
    }

    popMatrix();
  }
}

/**
* This class is called platform, but it is much more than that. It can be trigger blocks too
* Things like checkpoint flags are made using a confiuration of platform atributs.
*
*/
class Platform extends Actor {
  // tells the collided object if the platform have gravity on that face.
  boolean gTop, gLeft, gRight, gBottom;
  // the tag of the platform. it can have different effects on the player, like death or win
  String tag;

  /**
   * Star an gameObject up with location
   * @param x_ the X locaiton of the player
   * @param y_ the Y locaiton of the player
   * @param angle_ angle of the platform
   */
  Platform(float x_, float y_, float angle_) {
    super(x_,y_);

    angle = angle_;
    cTop = 50;
    cBottom = 50;
    cLeft = 50;
    cRight = 50;

    // println(gTop+""+gLeft+""+gRight+""+gBottom);
  }

  /**
   * Star an gameObject up with location
   * @param x_ the X locaiton of the player
   * @param y_ the Y locaiton of the player
   * @param angle_ the angle of the platform
   * @param minFrame_ the min frame the platform can use
   * @param maxFrame_ the max frame the platform can use
   * @param frames_ get the reference of the image array
   */
  Platform(float x_, float y_, float angle_, int minFrame_, int maxFrame_, PImage[] frames_) {
    super(x_, y_, minFrame_, maxFrame_, frames_);

    loc.x = x_;
    loc.y = y_;
    angle = angle_;
    cTop = 50;
    cBottom = 50;
    cLeft = 50;
    cRight = 50;

    // println(gTop+""+gLeft+""+gRight+""+gBottom);
  }

  /**
   * animates the platform
   */
  @Override
  void update() {
    if (frames != null && centralImgArray == true)
      animate(minFrame, maxFrame, 1000/60, true, false);
  }

  /**
   * Render the platform with tint
   */
  @Override
  void render() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(angle);


    if (tag != null) {
      if (tag.equals("DEATH")) {
        tint(255,0,0);
      } else if (tag.equals("O")) {
        // bitshift, faster.
        tint((dynamicColor >> 16) & 0xFF,
            (dynamicColor >> 8) & 0xFF,
            dynamicColor & 0xFF);
      } else {

        int checkpointNum = -1;
        // if the tag is pure number, this should not crash, but if it does, it is not a checkpoint
        try {
          checkpointNum = Integer.parseInt(tag);
        } catch (Exception e) {
          // do nothing...
        }
        // if it is not -1, it means it is a real checkpoint. so render it like a checkpoint
        if (checkpointNum != -1 && checkpointNum <= checkpointState) {
          tint(0,255,0);
        }

      }
    } else {
      // the normal tint for a block
      // bitshift, faster.
      tint((dynamicColor >> 16) & 0xFF,
          (dynamicColor >> 8) & 0xFF,
          dynamicColor & 0xFF);
    }



    if (img == null) {
      rect(0,0,cLeft+cRight,cBottom+cTop);
    } else {
      image(img,0,0);
    }


    noTint();

    popMatrix();

  }

}

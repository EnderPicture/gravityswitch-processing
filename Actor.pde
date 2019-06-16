/**
* To be used when box collision with rotation is needed
*
*/
class Actor extends GameObject{

  // collision mode with all its modes under as FINALS
  int collisionMode;

  final int NORMC = 0;
  final int TRIGGERC = 1;
  final int NOC = 2;

  float cRight, cLeft, cTop, cBottom;

  // face codes on which face did the object hit
  final int TOP_FACE = 1;
  final int RIGHT_FACE = 2;
  final int BOTTOM_FACE = 3;
  final int LEFT_FACE = 4;

  // if the object is grounded
  boolean grounded;

  // temp collison objects, cleared every frame
  ArrayList<Platform> collidedPlatforms;
  // temp trigger objects, cleared every frame
  ArrayList<Platform> triggerObjects;
  // basically, how much push back collision should do
  float deltaColision;
  // which face of this object did b collided with.
  int aSideCollided;
  // which face of the other object did this object collided with.
  int bSideCollided;

  // the gravityDirection in rad
  float gravityDirection;

  /**
   * Starts an actor up at 00
   */
  Actor() {
    super();
    // default collision box;
    cTop = 50;
    cBottom = 50;
    cLeft = 50;
    cRight = 50;

    collidedPlatforms = new ArrayList<Platform>();
    triggerObjects = new ArrayList<Platform>();
  }

  /**
   * Star an actor up with location
   * @param x_ the X locaiton of the new actor
   * @param y_ the Y locaiton of the new actor
   */
  Actor(float x_, float y_) {
    super(x_,y_);
    // default collision box;
    cTop = 50;
    cBottom = 50;
    cLeft = 50;
    cRight = 50;

    collidedPlatforms = new ArrayList<Platform>();
    triggerObjects = new ArrayList<Platform>();
  }

  /**
   * Star an actor up with location and an name for animations
   * @param x_ the X locaiton of the new actor
   * @param y_ the Y locaiton of the new actor
   * @param minFrame_ where the frame gatherer should start its image grabbing
   * @param maxFrame_ where the frame gatherer should end its image grabbing
   * @param fileName_ the file path to the image files. has to be in "fileName_"+00000.png format
   */
  Actor(float x_, float y_, int minFrame_, int maxFrame_, String fileName_) {
    super(x_, y_, minFrame_, maxFrame_, fileName_);
    // default collision box;
    cTop = 50;
    cBottom = 50;
    cLeft = 50;
    cRight = 50;

    collidedPlatforms = new ArrayList<Platform>();
    triggerObjects = new ArrayList<Platform>();
  }

  /**
   * Star an actor up with location and the usage of image array reference
   * @param x_ the X locaiton of the new actor
   * @param y_ the Y locaiton of the new actor
   * @param minFrame_ the min frame the actor can use from the image array
   * @param maxFrame_ the max frame the actor can use from the image array
   * @param frames_ the preloaded image array
   */
  Actor(float x_, float y_, int minFrame_, int maxFrame_, PImage[] frames_) {
    super(x_, y_, minFrame_, maxFrame_, frames_);
    // default collision box;
    cTop = 50;
    cBottom = 50;
    cLeft = 50;
    cRight = 50;

    collidedPlatforms = new ArrayList<Platform>();
    triggerObjects = new ArrayList<Platform>();
  }


  /**
   * Star an actor up with location and the usage of image array reference
   * @param b_ the object actor is trying to check the collision to
   * @return boolean that is true if it has collided
   */
  boolean collision(Actor b_) {
    float aVel1, aVel2, aVel3, aVel4, bVel1, bVel2, bVel3, bVel4, avb, bva, minDelta;
    PVector roedACBoxTR, roedACBoxTL, roedACBoxBR, roedACBoxBL, roedBCBoxTR, roedBCBoxTL, roedBCBoxBR, roedBCBoxBL;

    Actor b = b_;

    // stores the smallest delta
    deltaColision = MAX_FLOAT;
    minDelta = MAX_FLOAT;

    // Rotated locations for each of the angles
    PVector aLocRotatedA = loc.copy().rotate(-angle);
    PVector bLocRotatedA = b.loc.copy().rotate(-angle);

    PVector aLocRotatedB = loc.copy().rotate(-b.angle);
    PVector bLocRotatedB = b.loc.copy().rotate(-b.angle);

    // Collision boxes
    PVector aCBoxTR = new PVector(cRight,-cTop);
    PVector aCBoxTL = new PVector(-cLeft,-cTop);
    PVector aCBoxBR = new PVector(cRight,cBottom);
    PVector aCBoxBL = new PVector(-cLeft,cBottom);

    PVector bCBoxTR = new PVector(b.cRight,-b.cTop);
    PVector bCBoxTL = new PVector(-b.cLeft,-b.cTop);
    PVector bCBoxBR = new PVector(b.cRight,b.cBottom);
    PVector bCBoxBL = new PVector(-b.cLeft,b.cBottom);

    // a's planes
    // rotate the collision b's collisoin box to match
    roedBCBoxTR = bCBoxTR.copy().rotate(-angle+b.angle);
    roedBCBoxTL = bCBoxTL.copy().rotate(-angle+b.angle);
    roedBCBoxBR = bCBoxBR.copy().rotate(-angle+b.angle);
    roedBCBoxBL = bCBoxBL.copy().rotate(-angle+b.angle);
    // a's x plane

    aVel1 = aCBoxTR.x + aLocRotatedA.x;
    aVel2 = aCBoxTL.x + aLocRotatedA.x;
    aVel3 = aCBoxBR.x + aLocRotatedA.x;
    aVel4 = aCBoxBL.x + aLocRotatedA.x;

    bVel1 = roedBCBoxTR.x + bLocRotatedA.x;
    bVel2 = roedBCBoxTL.x + bLocRotatedA.x;
    bVel3 = roedBCBoxBR.x + bLocRotatedA.x;
    bVel4 = roedBCBoxBL.x + bLocRotatedA.x;

    float[] aXAVels = {aVel1, aVel2, aVel3, aVel4};
    float[] aXBVels = {bVel1, bVel2, bVel3, bVel4};

    avb = max(aXAVels) - min(aXBVels);
    bva = max(aXBVels) - min(aXAVels);

    if (avb < minDelta) {
      minDelta = avb;
      aSideCollided = LEFT_FACE;
    }
    if (bva < minDelta) {
      minDelta = bva;
      aSideCollided = RIGHT_FACE;
    }

    // collided?
    boolean aXC = avb > 0 && bva > 0;
    if (!aXC)
      return false;
    else {
      if (avb < deltaColision)
      deltaColision = avb;
      if (bva < deltaColision)
      deltaColision = bva;
    }

    // a's y plane
    aVel1 = aCBoxTR.y + aLocRotatedA.y;
    aVel2 = aCBoxTL.y + aLocRotatedA.y;
    aVel3 = aCBoxBR.y + aLocRotatedA.y;
    aVel4 = aCBoxBL.y + aLocRotatedA.y;

    bVel1 = roedBCBoxTR.y + bLocRotatedA.y;
    bVel2 = roedBCBoxTL.y + bLocRotatedA.y;
    bVel3 = roedBCBoxBR.y + bLocRotatedA.y;
    bVel4 = roedBCBoxBL.y + bLocRotatedA.y;

    float[] aYAVels = {aVel1, aVel2, aVel3, aVel4};
    float[] aYBVels = {bVel1, bVel2, bVel3, bVel4};

    avb = max(aYAVels) - min(aYBVels);
    bva = max(aYBVels) - min(aYAVels);

    // println("LEFT/TOP:"+avb+" RIGHT/BOTTOM:"+bva);

    if (avb < minDelta) {
      minDelta = avb;
      aSideCollided = TOP_FACE;
    }
    if (bva < minDelta) {
      minDelta = bva;
      aSideCollided = BOTTOM_FACE;
    }

    // collided?
    boolean aYC = avb > 0 && bva > 0;
    if (!aYC)
      return false;
    else {
      if (avb < deltaColision)
      deltaColision = avb;
      if (bva < deltaColision)
      deltaColision = bva;
    }

    // reset minDelta so it will work again for b's planes
    minDelta = MAX_FLOAT;

    // b's planes
    // rotate the collision a's collisoin box to match
    roedACBoxTR = aCBoxTR.copy().rotate(-b.angle+angle);
    roedACBoxTL = aCBoxTL.copy().rotate(-b.angle+angle);
    roedACBoxBR = aCBoxBR.copy().rotate(-b.angle+angle);
    roedACBoxBL = aCBoxBL.copy().rotate(-b.angle+angle);
    // b's x plane

    bVel1 = bCBoxTR.x + bLocRotatedB.x;
    bVel2 = bCBoxTL.x + bLocRotatedB.x;
    bVel3 = bCBoxBR.x + bLocRotatedB.x;
    bVel4 = bCBoxBL.x + bLocRotatedB.x;

    aVel1 = roedACBoxTR.x + aLocRotatedB.x;
    aVel2 = roedACBoxTL.x + aLocRotatedB.x;
    aVel3 = roedACBoxBR.x + aLocRotatedB.x;
    aVel4 = roedACBoxBL.x + aLocRotatedB.x;

    float[] bXAVels = {aVel1, aVel2, aVel3, aVel4};
    float[] bXBVels = {bVel1, bVel2, bVel3, bVel4};

    avb = max(bXAVels) - min(bXBVels);
    bva = max(bXBVels) - min(bXAVels);
    if (avb < minDelta) {
      minDelta = avb;
      bSideCollided = LEFT_FACE;
    }
    if (bva < minDelta) {
      minDelta = bva;
      bSideCollided = RIGHT_FACE;
    }

    // collided?
    boolean bXC = avb > 0 && bva > 0;
    if (!bXC)
      return false;
    else {
      if (avb < deltaColision)
      deltaColision = avb;
      if (bva < deltaColision)
      deltaColision = bva;
    }


    // b's y plane
    bVel1 = bCBoxTR.y + bLocRotatedB.y;
    bVel2 = bCBoxTL.y + bLocRotatedB.y;
    bVel3 = bCBoxBR.y + bLocRotatedB.y;
    bVel4 = bCBoxBL.y + bLocRotatedB.y;

    aVel1 = roedACBoxTR.y + aLocRotatedB.y;
    aVel2 = roedACBoxTL.y + aLocRotatedB.y;
    aVel3 = roedACBoxBR.y + aLocRotatedB.y;
    aVel4 = roedACBoxBL.y + aLocRotatedB.y;


    float[] bYAVels = {aVel1, aVel2, aVel3, aVel4};
    float[] bYBVels = {bVel1, bVel2, bVel3, bVel4};

    avb = max(bYAVels) - min(bYBVels);
    bva = max(bYBVels) - min(bYAVels);
    if (avb < minDelta) {
      minDelta = avb;
      bSideCollided = TOP_FACE;
    }
    if (bva < minDelta) {
      minDelta = bva;
      bSideCollided = BOTTOM_FACE;
    }

    // collided?
    boolean bYC = avb > 0 && bva > 0;
    if (!bYC)
      return false;
    else {
      if (avb < deltaColision)
      deltaColision = avb;
      if (bva < deltaColision)
      deltaColision = bva;
    }


    return aXC && aYC && bXC && bYC;

  }

  /**
   * For use when object needs to collide with platforms.
   * switches gravity automatically and sends the trigger objects into the arraylist
   * also sends the collided platforms into the arraylist as well.
   */
  void collisionController() {

    // clear all the temp reference arraylists so it can be used again.
    collidedPlatforms.clear();
    triggerObjects.clear();

    grounded = false;

    for(int c = 0; c < world.platforms.size(); c ++) {
      Platform p = world.platforms.get(c);
      if (collision(p)) {
        if (p.collisionMode == NORMC) {
          // if the the platform is colliding with THIS, add it to the collidedPlatforms list
          collidedPlatforms.add(p);

          float pushAngle = p.angle;

          if (p.tag != null && p.tag.equals("O")) {
            // opposite day
            // pushes different direction depending on which side is touching.

            if (bSideCollided == TOP_FACE) {
              if (p.gTop) {
                angleDes = pushAngle;
                gravityDirection = pushAngle+PI;
                grounded = true;
              } else {
                grounded = false;
              }
            } else if (bSideCollided == BOTTOM_FACE) {
              pushAngle += PI;
              if (p.gBottom) {
                angleDes = pushAngle;
                gravityDirection = pushAngle+PI;
                grounded = true;
              } else {
                grounded = false;
              }
            } else if (bSideCollided == LEFT_FACE) {
              pushAngle -= PI/2;
              if (p.gLeft) {
                angleDes = pushAngle;
                gravityDirection = pushAngle+PI;
                grounded = true;
              } else {
                grounded = false;
              }
            } else if (bSideCollided == RIGHT_FACE) {
              pushAngle += PI/2;
              if (p.gRight) {
                angleDes = pushAngle;
                gravityDirection = pushAngle+PI;
                grounded = true;
              } else {
                grounded = false;
              }
            } else {
              grounded = false;
            }

          } else {
            // normal gravity blocks
            // pushes different direction depending on which side is touching.

            if (bSideCollided == TOP_FACE) {
              if (p.gTop) {
                angleDes = pushAngle;
                gravityDirection = pushAngle;
                grounded = true;
              } else {
                grounded = false;
              }
            } else if (bSideCollided == BOTTOM_FACE){
              pushAngle += PI;
              if (p.gBottom) {
                angleDes = pushAngle;
                gravityDirection = pushAngle;
                grounded = true;
              } else {
                grounded = false;
              }
            } else if (bSideCollided == LEFT_FACE) {
              pushAngle -= PI/2;
              if (p.gLeft) {
                angleDes = pushAngle;
                gravityDirection = pushAngle;
                grounded = true;
              } else {
                grounded = false;
              }
            } else if (bSideCollided == RIGHT_FACE) {
              pushAngle += PI/2;
              if (p.gRight) {
                angleDes = pushAngle;
                gravityDirection = pushAngle;
                grounded = true;
              } else {
                grounded = false;
              }
            } else {
              grounded = false;
            }

          }



          // push the object up to the place it should be
          loc.sub(new PVector(0,deltaColision).rotate(pushAngle));

          // eliminate the velocity that hits
          vel.rotate(-pushAngle);
          vel.y = 0;
          vel.rotate(pushAngle);
        }
        else if (p.collisionMode == TRIGGERC) {
          // add to the trigger arraylist
          triggerObjects.add(p);
        }
      }
    }

  }


  // float roundDes(float num_, int numOfDes_) {
  //   return round(num_ * pow(numOfDes_,numOfDes_)) / pow(numOfDes_,numOfDes_);
  // }
}

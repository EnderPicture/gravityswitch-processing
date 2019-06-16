/**
* Player object. Uses input from the keyboard
*
*/
class Player extends Actor {

  int jumpCount;
  int jumpDuration;
  int jumped;

  // float jumpHeight;
  // float groundLevel;

  boolean dead;

  boolean lastUpHold;

  boolean lastGrounded;

  /**
   * Star an gameObject at 0,0
   */
  Player() {
    super();
    img = loadImage("Player.png");

    cTop = img.height/2;
    cBottom = img.height/2;
    cLeft = img.width/2;
    cRight = img.width/2;

    jumpDuration = 5;
  }

  /**
   * Star an gameObject up with location
   * @param x_ the X locaiton of the player
   * @param y_ the Y locaiton of the player
   */
  Player(float x_, float y_, float gravityDirection_) {
    super(x_,y_);

    angle = gravityDirection_;
    angleDes = gravityDirection_;

    gravityDirection = gravityDirection_;

    img = loadImage("Player.png");

    cTop = img.height/2;
    cBottom = img.height/2;
    cLeft = img.width/2;
    cRight = img.width/2;

    jumpDuration = 5;
  }

  /**
   * Updates the player
   */
  @Override
  void update() {

    // even if fps goes below 60fps, physics still goines at 60fps
    for (int c = 0; c < updatePhysics; c++) {
      simplePhysicsCal();
      movementController(inputController());
      collisionController();
    }
    // println(vel.x+" "+vel.y);
    smoothRotate(0.25);

    for (Actor a : collidedPlatforms){
      Platform p = (Platform)a;

      // ellipse(p.loc.x,p.loc.y,120,120);

      if (p.tag != null)  {
        if (p.tag.equals("WIN")) {
          world.menuWin.on = true;
        } else if (p.tag.equals("DEATH")) {
          dead = true;
        }

      }

    }
    // hanlde all trigger objects
    for (Actor a : triggerObjects) {

      if (a instanceof Platform) {
        Platform p = (Platform)a;

        int checkpointNum = -1;

        try {
          checkpointNum = Integer.parseInt(p.tag);
        } catch (Exception e) {
          // do nothing...
        }

        if (checkpointNum != -1 && checkpointNum > checkpointState) {
          checkpointState = checkpointNum;
          checkpoints[checkpointNum].score = world.score;
          checkpoints[checkpointNum].musicLoc = bgMusic.position();
        }
      }



    }
    lastGrounded = grounded;
  }

  /**
   * Checks if the player can jump
   * @return boolean can the player jump right now??
   */
  boolean canJump() {
    return jumpCount < jumpDuration && jumped < 1;
  }

  /**
   * Handles keyboard inputs
   * @return a PVector with keyboard inputs
   */
  PVector inputController() {
    PVector input = new PVector();


    if (!upHold && lastUpHold) {
      jumped++;
    }

    lastUpHold = upHold;

    if (grounded) {
      jumpCount = 0;
      jumped = 0;
      // groundLevel = loc.copy().rotate(-gravityDirection).y;
      // jumpHeight = 0;
    }

    if (upHold) {
      if (canJump()) {
        input.y -= 1;
        jumpCount++;
        }
    }


    // if (downHold)
    //   input.y += 1;
    // if (leftHold)
    //   input.x -= 1;
    // if (rightHold)
    //   input.x += 1;

    if (downHold)
      input.y += 0.3;
    if (leftHold)
      input.x -= 0.5;
    if (rightHold) {
      input.x += 1.5;
    } else {
      input.x += 1;
    }

    // right key is always held down

    // input.normalize;
    // println(input);
    return input;
  }

  /**
   * Controls movement and gravity
   * @param input uses the input and moves the player
   */
  void movementController(PVector input) {

    input.mult(5);

    input.y += world.gravity;

    acc = input.rotate(gravityDirection);

    acc.rotate(-gravityDirection);

    float aX = -vel.copy().rotate(-gravityDirection).x;
    float aY = -vel.copy().rotate(-gravityDirection).y;

    aX *= 0.4;
    aY *= 0.02;

    acc.add(new PVector(aX, aY));

    acc.rotate(gravityDirection);
  }


}

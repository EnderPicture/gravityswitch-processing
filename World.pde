/**
* Contians the world and its functions, like menus, constant gravity force,
* camera, and much more.
*
* @author  Donny Wu
* @version 1.0
*/
class World {

  // the storeage for the current frame's onscreen patforms
  ArrayList<Platform> platforms = new ArrayList<Platform>();

  // the whole level, returned by the level reader
  Actor[][] level;
  // the player
  Player player;
  // the camera
  Cam2D camera;

  // constant gravity
  float gravity;

  // values for the start delay at the end of pause menu, death menu, and checkpoint reset.
  int lastStartDelay;
  int startDelay;

  // get all of the menus working
  MenuLoading menuLoading;
  MenuDeath menuDeath;
  MenuPause menuPause;
  Gui gui;
  MenuWin menuWin;

  // the level reader
  LevelReader lr;

  // the zhold state in the last frame
  boolean oldZHold;
  // the xhold state in the last frame
  boolean oldXHold;
  // if the world should reload from file
  boolean shouldReload;
  // the score, as in coins
  int score;

  /**
   * start a world in the center
   */
  World() {
    // make a new level reader
    lr = new LevelReader();
    // set the delay to 250
    startDelay = 250;

    // set global gravity force
    gravity = 1;
    // make a new player
    player = new Player();
    // make a new camera that centers at player's location
    camera = new Cam2D(player.loc.x,player.loc.y, 0);

    // make all the new menus
    menuLoading = new MenuLoading();
    menuDeath = new MenuDeath();
    menuPause = new MenuPause();
    gui = new Gui();
    menuWin = new MenuWin();

    // set should load level to true;
    shouldReload = true;

    //set current millis to the last start delay so it knows when to count down
    lastStartDelay = millis();
  }

  /**
   * updates the world in every frame
   */
  void update() {
    // set the background to the 8th the brightness of the dynamicColor for a dark background
    background(red(dynamicColor)/8, green(dynamicColor)/8, blue(dynamicColor)/8);

    // let the camera do its thing.
    pushMatrix();



    // update the camera
    camera.des = new PVector(-player.loc.x,-player.loc.y);
    camera.angleDes = -player.gravityDirection;
    camera.update();

    if (lr.percentDone == -1) {
      // if percetn done is -1, that means the level reader has not been ran before
      lr.startLevelReader("Sprits/MainMap.png");
      lr.percentDone = 0;
    }

    if (!menuLoading.on) {
      // if the the menu loading is not on, it means loading is over and the world can function

      if (millis() - lastStartDelay > startDelay && !menuPause.on && !menuLoading.on && !menuDeath.on && !menuWin.on) {
        // if no menus are on
        // a little delay before the player starts moving.
        player.update();

        // is holding the reset key. RESET.
        if (xHold && !oldXHold) {
          lastStartDelay = millis();
          if (checkpointState == -1) {
            // default starting position
            world.resetWorld(new CheckPoint(new PVector(0,0), 0));
          } else {
            world.resetWorld(checkpoints[checkpointState]);
          }
        }
      }

      // if the gui should show up or not
      if (!menuLoading.on && !menuDeath.on)
        gui.on = true;
      else
        gui.on = false;

      // if should reaload, reload the level array from the level reader
      if (shouldReload) {
        copyLevelOver(lr.level);
        shouldReload = false;
      }

      if (player.dead && !menuDeath.on) {
        // dead, so get on it and turn on the death menu.
        menuDeath.on = true;
      }


      // draw the minimap backgournd
      drawBackgroundMinmap();

      // clear the temp arraylist for platforms
      platforms.clear();
      // whole drawing the screen, it will fill in the platforms arraylist
      onScreenObjectsManager();

    }

    // render the player with a tint
    playerRenderTint();

    // close camera influence
    popMatrix();

    // check dismiss menu or pause
    if (zHold && !oldZHold && !menuLoading.on) {
      if (menuDeath.on)
        menuDeath.on = false;
      else if (menuWin.on)
        menuWin.on = false;
      else
        menuPause.on = menuPause.on ? false : true;
      lastStartDelay = millis();
    }

    // update all menus
    gui.update();
    gui.render();
    menuLoading.update();
    menuLoading.render();
    menuDeath.update();
    menuDeath.render();
    menuPause.update();
    menuPause.render();
    menuWin.update();
    menuWin.render();

    // update old to new.
    oldZHold = zHold;
    oldXHold = xHold;
  }

  /**
   * Copies an external level into the world
   * @param level_ a 2D array that contains level info
   */
  void copyLevelOver(Actor[][] level_) {

    level = new Actor[level_.length][level_[0].length];

    for (int x = 0; x < level_.length; x++) {
      for (int y = 0; y < level_[0].length; y++ ) {
        level[x][y] = level_[x][y];
      }
    }
  }


  /**
   * go through and loads only the ones that the player may see on screen
   * uses dynamic loading system that maps the player's location to an 2d Level array
   */
  void onScreenObjectsManager() {

    // map the player location to the 2D array location
    PVector topLeft     = locToArrayIndex(new PVector(player.loc.x-max(width,height)+width/4,
                                                      player.loc.y-max(width,height)+width/4));
    PVector bottomRight = locToArrayIndex(new PVector(player.loc.x+max(width,height)+width/4,
                                                      player.loc.y+max(width,height)+width/4));

    // find the start and end of this box
    int xStart = (int)(topLeft.x > 0 ? topLeft.x : 0);
    int xEnd = (int)(bottomRight.x < level.length ? bottomRight.x : level.length);
    int yStart = (int)(topLeft.y > 0 ? topLeft.y : 0);
    int yEnd = (int)(bottomRight.y < level[0].length ? bottomRight.y : level[0].length);

    // loop though the whole thing
    for (int y = yStart; y < yEnd; y++) {
      for (int x = xStart; x < xEnd; x++) {
        Actor a = level[x][y];
        if (a != null) {
          if (a instanceof Platform) {
            Platform p = (Platform)a;

            // this is a no collision block, for decoration, so just render it
            if (p.collisionMode == p.NOC) {
              p.render();
            } else {
              platforms.add(p);
              p.update();
              p.render();
            }
          } else if (a instanceof Coin) {
            if (player.collision(a)) {
              // if player is touching the coin, remove it and score
              landSound.rewind();
              landSound.play();
              score++;
              level[x][y] = null;
            } else {
              a.update();
              noTint();
              a.render();
            }
          }
        }
      }
    }
  }

  /**
   * draws the player with a tint
   */
  void playerRenderTint() {
    // bitshift, faster.
    tint((dynamicColor >> 16) & 0xFF,
        (dynamicColor >> 8) & 0xFF,
        dynamicColor & 0xFF);
    player.render();
    noTint();
  }

  /**
   * draws the backgorund minimap. It is o.5x version of the real platform
   * this draws the background using rect() I did not use an image for this
   * beuase it makes no sense ot store a blank image and then draw it.
   */
  void drawBackgroundMinmap() {
    // map the player location to the 2D array location
    PVector topLeft     = locToArrayIndex(new PVector(player.loc.x-max(width*2,height*2)+width/4,
                                                      player.loc.y-max(width*2,height*2)+width/4));
    PVector bottomRight = locToArrayIndex(new PVector(player.loc.x+max(width*2,height*2)+width/4,
                                                      player.loc.y+max(width*2,height*2)+width/4));

    // find the start and end of this box
    int xStart = (int)(topLeft.x > 0 ? topLeft.x : 0);
    int xEnd = (int)(bottomRight.x < level.length ? bottomRight.x : level.length);
    int yStart = (int)(topLeft.y > 0 ? topLeft.y : 0);
    int yEnd = (int)(bottomRight.y < level[0].length ? bottomRight.y : level[0].length);

    fill(red(dynamicColor)/4, green(dynamicColor)/4, blue(dynamicColor)/4);
    // grab all the real platofrm and draw it
    for (int y = yStart; y < yEnd; y++) {
      for (int x = xStart; x < xEnd; x++) {
        Actor a = level[x][y];
        if (a != null) {
          if (a instanceof Platform) {
            Platform p = (Platform)a;

            pushMatrix();
            translate(p.loc.x/2+player.loc.x/2, p.loc.y/2+player.loc.y/2);
            rotate(p.angle);
            rect(0,0,(p.cLeft+p.cRight)/2,(p.cTop+p.cBottom)/2);
            popMatrix();
          }
        }
      }
    }
  }

  /**
   * Maps the location of the player to the level 2D array
   * @param loc_ players location
   */
  PVector locToArrayIndex(PVector loc_) {
    float pX = loc_.x/(lr.platformSize*2)+level.length/2;
    float pY = loc_.y/(lr.platformSize*2)+level[0].length/2;

    return new PVector(pX,pY);
  }

  /**
   * Copies an external level into the world
   * @param cp check point object that that contains the repswn point
   */
  void resetWorld(CheckPoint cp) {
    player = new Player(cp.loc.x,cp.loc.y,cp.angle);
    score = cp.score;
    bgMusic.rewind();
    bgMusic.skip(cp.musicLoc);
    bgMusic.loop();
    shouldReload = true;
  }
}

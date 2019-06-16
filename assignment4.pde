import java.util.Map;

import ddf.minim.*;

// keycodes
private final int UP_KEY    = 38;
private final int LEFT_KEY  = 37;
private final int DOWN_KEY  = 40;
private final int RIGHT_KEY = 39;
private final int SHIFT_KEY = 16;
private final int Z_KEY     = 90;
private final int X_KEY     = 88;
private final int C_KEY     = 67;

// stores the world
World world;

// 60fps physics over here
int physicsTiming = 1000/60;
// when does the next physics calculation happen?
int nextPhysicsCal;

// how many times to update physics this frame?
int updatePhysics;

// all of the key booleans
boolean upHold,downHold,leftHold,rightHold,zHold,xHold,cHold,shiftHold;

// the color that changes every frame. it is the color you see on screen.
color dynamicColor;
// the speed the colour changes
float colorChangeSpeed;

// the font that every thing is going to use.
PFont font;

// start up pause screen text.
String intro = "Arrow keys to Move,\nZ to Pause\nand dismiss menus,\nX to return to\npervious checkpoint.";
String introButton = "start";

// the locations of checkpoints
CheckPoint[] checkpoints;
// which check point the player has passed?
int checkpointState = -1;

Minim minim;
AudioPlayer bgMusic;
AudioPlayer bgMusicTIN;
AudioPlayer landSound;

void setup() {
  size(1280,720,P2D);

  // I like stuff to be drawn in the center
  rectMode(CENTER);
  imageMode(CENTER);

  // max framerate, do how much the computer can do.
  frameRate(1000);

  // This game does not do strokes thanyou very much
  noStroke();

  // load minim
  minim = new Minim(this);
  // load all the sounds
  bgMusic = minim.loadFile("The Impossible Game OST Level 1,2,3 and 4 Music.mp3");
  bgMusicTIN = minim.loadFile("The Impossible Game OST Level 1,2,3 and 4 MusicSLOWANDTINNY.mp3");
  landSound = minim.loadFile("LandSound.wav");

  // make new world
  world = new World();
  // turn on the loading menu
  world.menuLoading.on = true;

  // the font wont change, so why not just set it in the constructor
  font = loadFont("PressStart2P-Regular-100.vlw");
  textFont(font);

  // the speed the colour changes
  colorChangeSpeed = 0.01;

  // set the next physics calculation timing
  nextPhysicsCal = millis()+physicsTiming;
}

void draw() {
  // set the title bar with game name and FPS
  surface.setTitle("GravitySwitch   FPS: "+frameRate);
  // println(frameRate);
  // scale(0.25);
  // translate(width,height);

  updateMilisecondDelta();

  // calculate the next dynamic color
  dynamicColor = dynamicColorCalc(colorChangeSpeed);
  // update the world
  world.update();
}

/**
 * Calculates the dynamic dynamic colours you see on screen switching
 * it does it by changing the colour mode to HSB, rotationg it by millis()*X
 * it then resotres the to the RGB 255 colour mode.
 * @param speed_ the speed that the color changes where 0 is no change.
 * @return color the calculated color.
 */
color dynamicColorCalc(float speed_) {
  colorMode(HSB, 360, 100, 100);
  color c = color(millis()*speed_%360,100,100);
  colorMode(RGB, 255, 255, 255);

  c = red(c) > 200 ? color(200,green(c),blue(c)) : c;

  return c;
}

/**
 * Calculates how many times the physics engine should calculate
 * physics
 */
void updateMilisecondDelta() {
  if (nextPhysicsCal < millis()) {
    updatePhysics = (millis()-nextPhysicsCal)/physicsTiming;
    // println(updatePhysics);
    nextPhysicsCal += updatePhysics*physicsTiming;
  } else {
    updatePhysics = 0;
  }
}

/**
 * Keyboard binding pressed
 */
void keyPressed() {
  switch (keyCode) {
    case UP_KEY:
      upHold = true;
      break;
    case LEFT_KEY:
      leftHold = true;
      break;
    case DOWN_KEY:
      downHold = true;
      break;
    case RIGHT_KEY:
      rightHold = true;
      break;
    case SHIFT_KEY:
      shiftHold = true;
      break;
    case Z_KEY:
      zHold = true;
      break;
    case X_KEY:
      xHold = true;
      break;
    case C_KEY:
      cHold = true;
      break;
  }
}

/**
 * Keyboard binding released
 */
void keyReleased() {
  switch (keyCode) {
    case UP_KEY:
      upHold = false;
      break;
    case LEFT_KEY:
      leftHold = false;
      break;
    case DOWN_KEY:
      downHold = false;
      break;
    case RIGHT_KEY:
      rightHold = false;
      break;
    case SHIFT_KEY:
      shiftHold = false;
      break;
    case Z_KEY:
      zHold = false;
      break;
    case X_KEY:
      xHold = false;
      break;
    case C_KEY:
      cHold = false;
      break;
  }
}


// isn't this just the jankiest thing ever... used to be in the world.lr.level reder.
// yes yes, I know it looks ugly. lots word.lr. What can I do? Manual java threading with Runnables and handlers?
/**
* This level reader reads a level image file then, saves the finished level 2D
* aray into the LevelReader's temp Level array.
*/
void readLevel() {

  world.lr.img = loadImage(world.lr.levelFileName);
  world.lr.img.loadPixels();

  // because image loading takes more time, it should weigh more on the progress bar
  int imageLoadingWeight = 10000;

  world.lr.finishingPoint = world.lr.platformFramesFNum*imageLoadingWeight+
                   world.lr.platformOFramesFNum*imageLoadingWeight+
                   world.lr.platformSFramesFNum*imageLoadingWeight+
                   world.lr.checkPointSaveFNum*imageLoadingWeight+
                   (world.lr.img.height/world.lr.TILE_SIZE) *
                   (world.lr.img.width/world.lr.TILE_SIZE)+
                   world.lr.img.width*world.lr.img.height;


  // making center memory location for all platforms
  world.lr.platformFrames = new PImage[world.lr.platformFramesFNum];
  for (int c = 0; c < world.lr.platformFrames.length; c++) {
    world.lr.platformFrames[c] = loadImage(world.lr.platformFileName+nf(c,5)+".png");
    world.lr.doneCount+=imageLoadingWeight;
  }

  // making center memory location for all platforms
  world.lr.platformOFrames = new PImage[world.lr.platformOFramesFNum];
  for (int c = 0; c < world.lr.platformOFrames.length; c++) {
    world.lr.platformOFrames[c] = loadImage(world.lr.platformOFileName+nf(c,5)+".png");
    world.lr.doneCount+=imageLoadingWeight;
  }

  // mating center memory location for all platformS
  world.lr.platformSFrames = new PImage[world.lr.platformSFramesFNum];
  for (int c = 0; c < world.lr.platformSFrames.length; c++) {
    world.lr.platformSFrames[c] = loadImage(world.lr.platformSFileName+nf(c,5)+".png");
    world.lr.doneCount+=imageLoadingWeight;
  }

  // save spot
  world.lr.checkPointSave = new PImage[world.lr.checkPointSaveFNum];
  for (int c = 0; c < world.lr.checkPointSave.length; c++) {
    world.lr.checkPointSave[c] = loadImage(world.lr.checkPointSaveName+nf(c,5)+".png");
    world.lr.doneCount+=imageLoadingWeight;
  }

  HashMap<Integer,CheckPoint> tempCheckPoints = new HashMap<Integer,CheckPoint>();

  // convert pixel array into a 2D array. easier to work with
  color[][] map = new color[world.lr.img.width][world.lr.img.height];
  world.lr.level = new Actor[world.lr.img.width/world.lr.TILE_SIZE][world.lr.img.height/world.lr.TILE_SIZE];

  for (int c = 0; c < world.lr.img.width*world.lr.img.height; c++) {
    int x = c % world.lr.img.width;
    int y = c/world.lr.img.width;

    world.lr.doneCount++;

    map[x][y] = world.lr.img.pixels[c];
  }

  // go through the 2D array
  for (int y = 0; y < world.lr.img.height; y += world.lr.TILE_SIZE) {
    for (int x = 0; x < world.lr.img.width; x += world.lr.TILE_SIZE) {
      world.lr.doneCount++;
      if (map[x+1][y+1] != world.lr.blank) {
        if (map[x+1][y+1] == world.lr.normalBlock) {
          // normal collision active block

          float pX = x/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.width/world.lr.TILE_SIZE*world.lr.platformSize;
          float pY = y/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.height/world.lr.TILE_SIZE*world.lr.platformSize;
          float rotation = 0;

          if (map[x][y] == world.lr.positive || map[x+2][y] == world.lr.positive || map[x][y+2] == world.lr.positive || map[x+2][y+2] == world.lr.positive ||
              map[x][y] == world.lr.negative || map[x+2][y] == world.lr.negative || map[x][y+2] == world.lr.negative || map[x+2][y+2] == world.lr.negative) {
            // this is a 45 degrees slant block

            boolean gravity = false;

            if (map[x][y] == world.lr.positive) {
              // top left
              pX -= world.lr.platformSize/2;
              pY -= world.lr.platformSize/2;
              rotation = PI/2 + PI/4;
              gravity = true;
            } else if (map[x+2][y] == world.lr.positive) {
              // top right
              pX += world.lr.platformSize/2;
              pY -= world.lr.platformSize/2;
              rotation = PI + PI/4;
              gravity = true;
            } else if (map[x][y+2] == world.lr.positive) {
              // bottom left
              pX -= world.lr.platformSize/2;
              pY += world.lr.platformSize/2;
              rotation = PI/4;
              gravity = true;
            } else if (map[x+2][y+2] == world.lr.positive) {
              // bottom right
              pX += world.lr.platformSize/2;
              pY += world.lr.platformSize/2;
              rotation = PI + PI/2 + PI/4;
              gravity = true;
            } else if (map[x][y] == world.lr.negative) {
              // top left no gravity
              pX -= world.lr.platformSize/2;
              pY -= world.lr.platformSize/2;
              rotation = PI/2 + PI/4;
            } else if (map[x+2][y] == world.lr.negative) {
              // top right no gravity
              pX += world.lr.platformSize/2;
              pY -= world.lr.platformSize/2;
              rotation = PI + PI/4;
            } else if (map[x][y+2] == world.lr.negative) {
              // bottom left no gravity
              pX -= world.lr.platformSize/2;
              pY += world.lr.platformSize/2;
              rotation = PI/4;
            } else if (map[x+2][y+2] == world.lr.negative) {
              // bottom right no gravity
              pX += world.lr.platformSize/2;
              pY += world.lr.platformSize/2;
              rotation = PI + PI/2 + PI/4;
            }

            int fpa = 30;
            int frameStart = 0;
            int frameEnd = 0;

            if (gravity) {
              frameStart = 0;
              frameEnd = frameStart+fpa-1;
            } else {
              frameStart = fpa;
              frameEnd = fpa;
            }

            Platform p = new Platform(pX,pY,rotation,frameStart, frameEnd, world.lr.platformSFrames);
            // Platform p = new Platform(pX,pY,rotation);

            if (gravity) {
              p.gTop = true;
            }

            float slantSizeW = new PVector((world.lr.platformSize-world.lr.cBoxDelta),(world.lr.platformSize-world.lr.cBoxDelta)).mag();
            float slantSizeH = new PVector((world.lr.platformSize-world.lr.cBoxDelta)/2,(world.lr.platformSize-world.lr.cBoxDelta)/2).mag();

            p.cTop = slantSizeH;
            p.cBottom = slantSizeH;
            p.cLeft = slantSizeW-1;
            p.cRight = slantSizeW-1;





            world.lr.level[x/world.lr.TILE_SIZE][y/world.lr.TILE_SIZE] = p;


          } else if (map[x][y] == world.lr.death) {
            // does the same thing, but this is a death block, so the tag will be DEATH
            int fpa = 30;
            int frameStart = 15*fpa;
            int frameEnd = frameStart;


            Platform p = new Platform(pX,pY,rotation,frameStart+1, frameEnd+1, world.lr.platformFrames);

            p.cTop = world.lr.platformSize-world.lr.cBoxDelta;
            p.cBottom = world.lr.platformSize-world.lr.cBoxDelta;
            p.cLeft = world.lr.platformSize-world.lr.cBoxDelta;
            p.cRight = world.lr.platformSize-world.lr.cBoxDelta;

            p.tag = "DEATH";

            world.lr.level[x/world.lr.TILE_SIZE][y/world.lr.TILE_SIZE] = p;

          } else if (map[x+1][y] == world.lr.positiveO || map[x][y+1] == world.lr.positiveO || map[x+2][y+1] == world.lr.positiveO || map[x+1][y+2] == world.lr.positiveO) {

            // this is a reverse gravity block

            // framesPerAnimation
            int fpa = 30;

            // frame start end as defaults
            int frameStart = 0;
            int frameEnd = 0;

            // default gravity setting
            boolean gTop = false;
            boolean gBottom = false;
            boolean gLeft = false;
            boolean gRight = false;

            // check for gravity
            if (map[x+1][y] == world.lr.positiveO)
            gTop = true;
            if (map[x+1][y+2] == world.lr.positiveO)
            gBottom = true;
            if (map[x][y+1] == world.lr.positiveO)
            gLeft = true;
            if (map[x+2][y+1] == world.lr.positiveO)
            gRight = true;

            // 16 ways T B L R can form, select the right range of frames
            if (gTop && gRight && gBottom && gLeft) {
              frameStart = 0;
              frameEnd = frameStart+fpa-1;
            } else if (!gTop && gRight && gBottom && gLeft) {
              frameStart = fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && !gRight && gBottom && gLeft) {
              frameStart = 2*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && gRight && !gBottom && gLeft) {
              frameStart = 3*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && gRight && gBottom && !gLeft) {
              frameStart = 4*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (!gTop && !gRight && gBottom && gLeft) {
              frameStart = 5*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && !gRight && !gBottom && gLeft) {
              frameStart = 6*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && gRight && !gBottom && !gLeft) {
              frameStart = 7*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (!gTop && gRight && gBottom && !gLeft) {
              frameStart = 8*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (!gTop && gRight && !gBottom && gLeft) {
              frameStart = 9*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && !gRight && gBottom && !gLeft) {
              frameStart = 10*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop) {
              frameStart = 11*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gRight) {
              frameStart = 12*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gBottom) {
              frameStart = 13*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gLeft) {
              frameStart = 14*fpa;
              frameEnd = frameStart+fpa-1;
            } else {
              frameStart = 15*fpa;
              frameEnd = frameStart;
            }

            Platform p = new Platform(pX,pY,rotation,frameStart, frameEnd, world.lr.platformOFrames);

            // set it to the normal size of collision
            p.cTop = world.lr.platformSize-world.lr.cBoxDelta;
            p.cBottom = world.lr.platformSize-world.lr.cBoxDelta;
            p.cLeft = world.lr.platformSize-world.lr.cBoxDelta;
            p.cRight = world.lr.platformSize-world.lr.cBoxDelta;

            // set the gravity faces
            p.gTop = gTop;
            p.gBottom = gBottom;
            p.gLeft = gLeft;
            p.gRight = gRight;

            // tag it with O so the platform knows what it is
            p.tag = ("O");

            world.lr.level[x/world.lr.TILE_SIZE][y/world.lr.TILE_SIZE] = p;

          } else {

            // this is a normal block, so make a new platform

            // framesPerAnimation
            int fpa = 30;

            int frameStart = 0;
            int frameEnd = 0;


            boolean gTop = false;
            boolean gBottom = false;
            boolean gLeft = false;
            boolean gRight = false;


            if (map[x+1][y] == world.lr.positive)
            gTop = true;
            if (map[x+1][y+2] == world.lr.positive)
            gBottom = true;
            if (map[x][y+1] == world.lr.positive)
            gLeft = true;
            if (map[x+2][y+1] == world.lr.positive)
            gRight = true;

            // 16 ways T B L R can form, select the right range of frames
            if (gTop && gRight && gBottom && gLeft) {
              frameStart = 0;
              frameEnd = frameStart+fpa-1;
            } else if (!gTop && gRight && gBottom && gLeft) {
              frameStart = fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && !gRight && gBottom && gLeft) {
              frameStart = 2*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && gRight && !gBottom && gLeft) {
              frameStart = 3*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && gRight && gBottom && !gLeft) {
              frameStart = 4*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (!gTop && !gRight && gBottom && gLeft) {
              frameStart = 5*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && !gRight && !gBottom && gLeft) {
              frameStart = 6*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && gRight && !gBottom && !gLeft) {
              frameStart = 7*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (!gTop && gRight && gBottom && !gLeft) {
              frameStart = 8*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (!gTop && gRight && !gBottom && gLeft) {
              frameStart = 9*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop && !gRight && gBottom && !gLeft) {
              frameStart = 10*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gTop) {
              frameStart = 11*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gRight) {
              frameStart = 12*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gBottom) {
              frameStart = 13*fpa;
              frameEnd = frameStart+fpa-1;
            } else if (gLeft) {
              frameStart = 14*fpa;
              frameEnd = frameStart+fpa-1;
            } else {
              frameStart = 15*fpa;
              frameEnd = frameStart;
            }

            Platform p = new Platform(pX,pY,rotation,frameStart, frameEnd, world.lr.platformFrames);

            // set it to the normal size of collision
            p.cTop = world.lr.platformSize-world.lr.cBoxDelta;
            p.cBottom = world.lr.platformSize-world.lr.cBoxDelta;
            p.cLeft = world.lr.platformSize-world.lr.cBoxDelta;
            p.cRight = world.lr.platformSize-world.lr.cBoxDelta;


            p.gTop = gTop;
            p.gBottom = gBottom;
            p.gLeft = gLeft;
            p.gRight = gRight;



            world.lr.level[x/world.lr.TILE_SIZE][y/world.lr.TILE_SIZE] = p;
          }

        } else if (map[x+1][y+1] == world.lr.noCBlock) {

          float pX = x/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.width/world.lr.TILE_SIZE*world.lr.platformSize;
          float pY = y/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.height/world.lr.TILE_SIZE*world.lr.platformSize;
          float rotation = 0;

          Platform p = new Platform(pX,pY,rotation,450, 450, world.lr.platformFrames);
          p.collisionMode = p.NOC;

          world.lr.level[x/world.lr.TILE_SIZE][y/world.lr.TILE_SIZE] = p;

        } else if (map[x+1][y+1] == world.lr.checkpointFlag) {
          // this is a check point flag OBJECT
          float pX = x/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.width/world.lr.TILE_SIZE*world.lr.platformSize;
          float pY = y/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.height/world.lr.TILE_SIZE*world.lr.platformSize;
          float rotation = 0;
          int checkPointNum = 0;
          // check in which direction should the flag be at.
          // the read channel incodes the checkPoint ID. So grab that real quick
          if (map[x+1][y] != world.lr.blank && map[x+1][y] != world.lr.outlineGray) {
            // red channel
            checkPointNum = (map[x+1][y] >> 16) & 0xFF;
            rotation = PI;
          }
          else if (map[x+1][y+2] != world.lr.blank && map[x+1][y+2] != world.lr.outlineGray) {
            // red channel
            checkPointNum = (map[x+1][y+2] >> 16) & 0xFF;
            rotation = 0;
          }
          else if (map[x][y+1] != world.lr.blank && map[x][y+1] != world.lr.outlineGray) {
            // red channel
            checkPointNum = (map[x][y+1] >> 16) & 0xFF;
            rotation = PI/2;
          }
          else if (map[x+2][y+1] != world.lr.blank && map[x+2][y+1] != world.lr.outlineGray) {
            // red channel
            checkPointNum = (map[x+2][y+1] >> 16) & 0xFF;
            rotation = PI+PI/2;
          }

          Platform p = new Platform(pX,pY,rotation,0, world.lr.checkPointSave.length-1, world.lr.checkPointSave);

          // set the collisionMode to trigger
          p.collisionMode = p.TRIGGERC;

          // tag the platform with the checkpoint ID
          p.tag = checkPointNum+"";

          p.cTop = world.lr.platformSize-world.lr.cBoxDelta;
          p.cBottom = world.lr.platformSize-world.lr.cBoxDelta;
          p.cLeft = world.lr.platformSize-world.lr.cBoxDelta;
          p.cRight = world.lr.platformSize-world.lr.cBoxDelta;

          // this is so that the game can look back in order of from 0 to # where the check points are.
          CheckPoint c = new CheckPoint(p.loc.copy(),p.angle);
          tempCheckPoints.put(checkPointNum,c);


          world.lr.level[x/world.lr.TILE_SIZE][y/world.lr.TILE_SIZE] = p;
        } else if (map[x+1][y+1] == world.lr.coin) {
          // this is a coin OBJECT
          float pX = x/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.width/world.lr.TILE_SIZE*world.lr.platformSize;
          float pY = y/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.height/world.lr.TILE_SIZE*world.lr.platformSize;
          // make coin with coin image
          Coin c = new Coin(pX, pY, world.lr.coinImage);
          world.lr.level[x/world.lr.TILE_SIZE][y/world.lr.TILE_SIZE] = c;
        } else if (map[x+1][y+1] == world.lr.win) {
          // this is a win block
          float pX = x/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.width/world.lr.TILE_SIZE*world.lr.platformSize;
          float pY = y/world.lr.TILE_SIZE*world.lr.platformSize*2-world.lr.img.height/world.lr.TILE_SIZE*world.lr.platformSize;

          Platform p = new Platform(pX,pY,0,450, 450, world.lr.platformFrames);

          // set it to the normal size of collision
          p.cTop = world.lr.platformSize-world.lr.cBoxDelta;
          p.cBottom = world.lr.platformSize-world.lr.cBoxDelta;
          p.cLeft = world.lr.platformSize-world.lr.cBoxDelta;
          p.cRight = world.lr.platformSize-world.lr.cBoxDelta;

          // no gravity at all please
          p.gTop = false;
          p.gBottom = false;
          p.gLeft = false;
          p.gRight = false;

          // set tag as WIN so the player can know.
          p.tag = ("WIN");

          world.lr.level[x/world.lr.TILE_SIZE][y/world.lr.TILE_SIZE] = p;
        }
      }
    }
  }

  // save the new checkpoint list into array
  checkpoints = new CheckPoint[tempCheckPoints.size()];
  for (int c = 0; c < tempCheckPoints.size(); c++) {
    checkpoints[c] = tempCheckPoints.get(c);
  }

  // set the pause menu to the intro menu.
  world.menuPause.text = intro;
  world.menuPause.b.text = introButton;
  world.menuPause.on = true;
}
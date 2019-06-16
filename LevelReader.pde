/**
* This class reads a image file and saves it as a level 2D array ram for the
* world to copy over. The main part of the level loader is inside the main sketch
* because of multitreading.
*
*/
class LevelReader{

  color blank = color(255,255,255);
  color outlineGray = color(236,236,236);
  color normalBlock = color(0,0,0);

  color noCBlock = color(37,37,37);
  color checkpointFlag = color(0,0,255);

  color positive = color(0,255,0);
  color positiveO = color(0,255,255);
  color negative = color(100,100,100);
  color death = color(255,0,0);
  color coin = color(255,255,0);
  color win = color(255,0,255);

  float platformSize = 50;

  final int TILE_SIZE = 3;

  float cBoxDelta = 0;

  PImage[] platformFrames;
  String platformFileName = "Sprits/PlatformAnimation/Platform_";
  int platformFramesFNum = 452;

  PImage[] platformOFrames;
  String platformOFileName = "Sprits/PlatformAnimation/PlatformO_";
  int platformOFramesFNum = 450;

  PImage[] platformSFrames;
  String platformSFileName = "Sprits/PlatformAnimation/PlatformS_";
  int platformSFramesFNum = 31;

  PImage[] checkPointSave;
  String checkPointSaveName = "Sprits/PlatformAnimation/SaveBlock_";
  int checkPointSaveFNum = 30;

  PImage img;

  PImage coinImage;

  Actor[][] level;

  float percentDone = -1;
  int doneCount;
  int finishingPoint;

  String levelFileName;

  void startLevelReader(String fileName_) {

    coinImage = loadImage("Sprits/Coin.png");

    levelFileName = fileName_;
    thread("readLevel");
  }

  // the read level method should and used to be in here, but it can't be accessed with the thread() method. so.... moved to the main sketch file. How sad eh?

}

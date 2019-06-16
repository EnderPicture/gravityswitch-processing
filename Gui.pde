/**
* The coins panel at the top right of the screen.
*
*/
class Gui extends Menu{
  PImage scoreImage;

  /**
   * Updates the GUI
   */
  Gui() {
    super();
    scoreImage = loadImage("Sprits/ScoreGUI.png");
  }
  /**
   * Updates the GUI
   */
  @Override
  void update() {
    smoothMove(0.25);
    for (int c = 0; c < updatePhysics; c++) {
      simplePhysicsCal();
    }

    offLoc = new PVector(0,-scoreImage.height*1.01);

    if (on) {
      des = onLoc;
    }
    else {
      des = offLoc;
    }

  }
  /**
   * Renders the GUI
   */
  @Override
  void render() {
    if (loc.y >= -scoreImage.height) {
      pushMatrix();
      translate(loc.x+width-scoreImage.width/2,loc.y+scoreImage.height/2);
      tint(red(dynamicColor), green(dynamicColor), blue(dynamicColor),255*0.875);
      image(scoreImage,0,0);

      fill(dynamicColor);
      textSize(32);
      textAlign(CENTER,CENTER);
      text("Coins:"+nf(world.score,5), 10, 0);

      popMatrix();
    }
  }
}

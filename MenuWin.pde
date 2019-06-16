/**
* Menu that shows when the player wins
*
* @author  Donny Wu
* @version 1.0
*/
class MenuWin extends Menu {
  // button
  Button b;
  // win text
  String text = "Congratulations!";
  // the last staet of on
  boolean lastOn;
  /**
   * Updates the menu
   */
  MenuWin () {
    super();
    b = new Button(new PVector(0,100), new PVector(550,50));
    b.text = "Erase Checkpoints";
  }
  /**
   * Updates the menu
   */
  @Override
  void update() {
    super.update();
    b.renderingLoc = new PVector(loc.x+width/2,loc.y+height/2);
    b.update();
    if (b.clicked) {
      on = false;
    }

    if (lastOn && !on) {
      checkpointState = -1;
      world.resetWorld(new CheckPoint(new PVector(0,0),0));
      world.menuPause.on = true;
      world.menuPause.text = intro;
      world.menuPause.b.text = introButton;
    }

    lastOn = on;
  }

  /**
   * Renders the menu
   */
 @Override
  void render() {
    if (loc.y >= -height) {
      pushMatrix();
      translate(loc.x+width/2,loc.y+height/2);
      fill(red(dynamicColor)/16, green(dynamicColor)/16, blue(dynamicColor)/16,255*0.875);

      rect(0,0,width,height);

      fill(dynamicColor);
      textSize(50);
      textAlign(CENTER,BOTTOM);
      text(text+"\nYou've won with\n"+world.score+" coins.", 0, 0);

      b.render();
      // if (world.lr.finishingPoint != 0)
      //   rect(0,0,width*((float)world.lr.doneCount/world.lr.finishingPoint),height);

      popMatrix();
    }

  }
}

/**
* Menu that shows when the player pressed pause or at the start of the game.
*
*/
class MenuPause extends Menu {
  // button
  Button b;
  // pausemenu text
  String text = "";
  // the last staet of on
  boolean lastOn;

  /**
   * Updates the menu
   */
  MenuPause () {
    super();
    b = new Button(new PVector(0,100), new PVector(225,50));
    b.text = "";
  }

  /**
   * Updates the menu
   */
  @Override
  void update() {
    super.update();
    b.renderingLoc = new PVector(loc.x+width/2,loc.y+height/2);
    b.update();
    if (b.clicked)
      on = false;

    if (!on && b.text.equals(introButton)) {
      text = "Paused";
      b.text = "resume";
    }

    if (!lastOn && on) {
      bgMusicTIN.rewind();
      bgMusicTIN.skip(bgMusic.position()*2);
      bgMusic.pause();
      bgMusicTIN.loop();
    } else if (lastOn && !on) {
      // pause the tinny music
      bgMusic.rewind();
      bgMusic.skip(bgMusicTIN.position()/2);
      bgMusicTIN.pause();
      bgMusic.loop();
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
      text(text, 0, 0);

      b.render();
      // if (world.lr.finishingPoint != 0)
      //   rect(0,0,width*((float)world.lr.doneCount/world.lr.finishingPoint),height);

      popMatrix();
    }

  }
}

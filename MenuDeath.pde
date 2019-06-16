/**
* Menu that shows when the player dies. Random deathmessages will show up.
*
* @author  Donny Wu
* @version 1.0
*/
class MenuDeath extends Menu {
  // button
  Button b;
 // the last staet of on
  boolean lastOn;
  // death messages
  String[] deathMessages = {"Your timing was off.",
                            "You’re worse than the\ndeveloper of this game.",
                            "The death block…\nwas too powerful…",
                            "You ran into a block,\nthe only way\nyou can end it.",
                            "Poor cube, you failed.",
                            "You're a sad cube.",
                            "If you want to\nrun into a block, don’t\naccidentally do it. ",
                            "If the objective\nis to fail, then do it\nin the beginning.",
                            "You went far,\nbut not far enough.",
                            "Keep trying,\nbut you’ll fail\nin the process.",
                            "Get good.",
                            "Have you ever tried\nUncle Fatih's man?\nOh man, this best pizza",
                            "This might just be\neasier if you just open\nyour eyes dude."};

  String text = "DEAD";

  MenuDeath () {
    super();
    b = new Button(new PVector(0,100), new PVector(225,50));
    b.text = "retry?";
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

    if (!lastOn && on) {
      text = deathMessages[(int)random(deathMessages.length)]+"\nCoins:"+nf(world.score,5);
      bgMusicTIN.rewind();
      bgMusicTIN.skip(bgMusic.position()*2);
      bgMusic.pause();
      bgMusicTIN.loop();
    } else if (lastOn && !on) {

      // pause the tinny music
      bgMusicTIN.pause();

      if (checkpointState == -1) {
        // default starting position
        world.resetWorld(new CheckPoint(new PVector(0,0), 0));
      } else {
        world.resetWorld(checkpoints[checkpointState]);
      }
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

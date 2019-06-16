/**
* Menu that shows when the game is loading
*
*/
class MenuLoading extends Menu{

  /**
   * Updates the menu
   */
  MenuLoading () {
    super();
  }

  /**
   * Updates the menu
   */
  @Override
  void update() {
    super.update();
  }

  /**
   * Renders the menu
   */
  @Override
  void render() {
    if (loc.y >= -height) {
      pushMatrix();
      translate(loc.x+width/2,loc.y+height/2);
      fill(red(dynamicColor)/16, green(dynamicColor)/16, blue(dynamicColor)/16);

      rect(0,0,width,height);


      if (world.lr.finishingPoint != 0) {
        float percent = (float)world.lr.doneCount/world.lr.finishingPoint;

        // draw the loading bar
        fill(red(dynamicColor)/3, green(dynamicColor)/3, blue(dynamicColor)/3);
        rect(0,0,width*percent,height/2);

        fill(red(dynamicColor)/8, green(dynamicColor)/8, blue(dynamicColor)/8,255*0.875);
        textSize(50);
        textAlign(CENTER,BOTTOM);
        text((int)(percent*100)+"%", 0, 0);
        textAlign(CENTER,TOP);
        textSize(32);

        text("Loading...", 0, 0);

        // if loading is done, start the game sunny!
        if (percent >= 1) {
          on = false;
        }
      }

      popMatrix();
    }

  }
}

/**
* Base code for a menu object. It can go up and out of the way, or down to cover the whole screen.
*
* @author  Donny Wu
* @version 1.0
*/
class Menu extends GameObject {


  PVector offLoc = new PVector(0,-height*1.01);
  PVector onLoc = new PVector(0,0);

  boolean on;

  /**
   * Start a new menu
   */
  Menu () {
    super();
  }



  /**
   * Updates the menu
   */
  @Override
  void update() {
    smoothMove(0.25);
    for (int c = 0; c < updatePhysics; c++) {
      simplePhysicsCal();
    }

    offLoc = new PVector(0,-height*1.01);

    if (on) {
      des = onLoc;
    }
    else {
      des = offLoc;
    }

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


      // if (world.lr.finishingPoint != 0)
      //   rect(0,0,width*((float)world.lr.doneCount/world.lr.finishingPoint),height);

      popMatrix();
    }
  }
}

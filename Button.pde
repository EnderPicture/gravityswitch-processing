/**
* This is a custom button. Did not like that thrid part library as I could not
* dynamically move it, tell it when to render, and follow transltations.
*
*/
class Button {
  // where is the button being rendered
  PVector renderingLoc;
  // where is the canvas located
  PVector canvasLoc;
  // how big the button is
  PVector size;

  // how much darder will the button be when at those stages
  int hoverButton = 2;
  int holdButton = 3;
  int normalButton = 0;

  // true when mouse is hovering over the button
  boolean hoverOver;

  // true when left mouse buttton is down and is ontop of the button
  boolean pressed;
  // the last postion it was in
  boolean lastPressed;
  // is true in one tick.
  boolean clicked;
  // the temp text that will be replaced but menus that uses this.
  String text = "Hello";

  /**
   * Creates coin at location
   * @param canvasLoc_ x and y loc for canvas' location
   * @param size_ width and height size for the button
   */
  Button (PVector canvasLoc_, PVector size_) {
    canvasLoc = canvasLoc_;
    size = size_;
    renderingLoc = new PVector();
  }

  /**
   * Does all the cecking for button feature
   */
  void update() {
    // calculates the actual screen location so the mouse can be mapped to the button
    PVector actualScreenLoc = renderingLoc.copy().add(canvasLoc);

    // check if the mouse is hovering over the button
    hoverOver = mouseX < actualScreenLoc.x+size.x/2 && mouseX > actualScreenLoc.x-size.x/2 &&
                mouseY < actualScreenLoc.y+size.y/2 && mouseY > actualScreenLoc.y-size.y/2;

    // check if the button is pressed
    pressed = hoverOver && mousePressed && mouseButton == LEFT;

    /*
    pressed does not mean clicked man. first the button needs to be still over the button
    then the button needs to be pressed in the last frame but it is not in this one.
    this means the click is valid and only happens on the mousebutton released
    */
    clicked = hoverOver && lastPressed && !pressed;

    lastPressed = pressed;
  }

  /**
   * Renders the button at the correct color and darkness
   */
  void render() {
    // start both colors
    color textColor;
    color buttonColor;

    // will be changed here depending on the state of the button
    if (pressed) {
      textColor = color(red(dynamicColor)/(3+holdButton),green(dynamicColor)/(3+holdButton),blue(dynamicColor)/(3+holdButton));
      buttonColor = color(red(dynamicColor)/holdButton,green(dynamicColor)/holdButton,blue(dynamicColor)/holdButton);
    } else if (hoverOver) {
      textColor = color(red(dynamicColor)/(3+hoverButton),green(dynamicColor)/(3+hoverButton),blue(dynamicColor)/(3+hoverButton));
      buttonColor = color(red(dynamicColor)/hoverButton,green(dynamicColor)/hoverButton,blue(dynamicColor)/hoverButton);
    } else {
      textColor = color(red(dynamicColor)/(3+normalButton),green(dynamicColor)/(3+normalButton),blue(dynamicColor)/(3+normalButton));
      buttonColor = dynamicColor;
    }

    // draw the button over here with text and correct darkness
    pushMatrix();
    translate(canvasLoc.x, canvasLoc.y);
    fill(buttonColor);
    rect(0,0,size.x,size.y);


    fill(textColor);
    textSize(32);
    textAlign(CENTER,CENTER);
    text(text, 0, 0);

    popMatrix();

  }
}

// ---------------------------------------------------------
// Base class for views to handle x and y offsets as well as
// the width and the height.  It also has logic for determining
// whether a screen point is inside the view.  It uses the template
// method pattern for subclass view implementations.
// ---------------------------------------------------------

public class View {
  protected int x, y, w, h;
  
  // Initializes the x, y, width, and height dimensions of the view
  public View(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  // Draws common view structures and calls drawView for subclasses
  public void draw() {
    clip(x, y, w, h);
    fill(0,0,0);
    rect(x, y, w, h);
    drawView();
    noClip();
  }
  
  // Override to draw a specific view
  protected void drawView() {
  }
  
  // Determines whether or not the screen x and y are in the view.
  public boolean isInside(int screenX, int screenY) {
    return screenX >= x && screenX <= x + w && screenY >= y && screenY <= y + h;
  }
}

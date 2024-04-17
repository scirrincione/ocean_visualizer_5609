// ---------------------------------------------------------
// Draws the elevation path
// ---------------------------------------------------------

public class ElevationPathView extends View {
  private MapModel model;
  
  public ElevationPathView(MapModel model, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.model = model;
  }
  
  public void drawView() {
    fill(255);
    text("Year Comparison View", x + 50, y + 50);
  }
  
  public void mousePressed() {
  }
  
  
};

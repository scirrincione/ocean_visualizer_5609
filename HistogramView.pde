// ---------------------------------------------------------
// Draws the histogram
// ---------------------------------------------------------

// View class draws the model
public class HistogramView extends View {
  private MapModel model;
  
  public HistogramView(MapModel model, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.model = model;
  }
  
  public void drawView() {
    fill(255);
    text("Comparison View", x + 50, y + 50);
    
    
  }

  
};

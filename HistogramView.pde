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
    text("Histogram View", x + 50, y + 50);
    
    color from = color(11,48,16);
    color to = color(235,255,238);
    
    color next = from;
    // Color block
    for(int i = 0; i < 255; i+=1){
      noStroke();
      fill(next);
      rect(x+10+(i*2.1), y+250, 2.1, 25);
      next = lerpColor(from, to, (float)i/255);
      
    }
    
    next = from;
    int low = 240;
    int high = 75;
    
    ArrayList<Point> points = model.getMap().getPoints();
    int[] picValues = new int[256];
    for(int i = 0; i < picValues.length; i++) {
      picValues[i] = 0;
    }
    
    for(int i = 0; i < points.size(); i++){
      int val = (int)(points.get(i).getValue()*255);
      picValues[val]++;
    }
    
    float max = max(picValues);
    
    for(int i = 0; i < picValues.length; i++){
      float frac = (float)picValues[i] / max;
      picValues[i] = (int)(frac*(low-high));
    }
    
    for(int i = 0; i < picValues.length - 3; i+=2){
      stroke(255);
      line(x+10+(i*2.1), (y+low)-picValues[i], x+10+((i+2)*2.1), (y+low)-picValues[i+2]);
      
    }
    
    
  }

  
};

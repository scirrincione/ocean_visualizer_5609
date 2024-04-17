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
    text("Elevation Path View", x + 50, y + 50);
    if(model.getMap().getPath().size() >= 2){
        setGraphic();
     }
  }
  
  public void mousePressed() {
    if(mouseButton == LEFT){
      if(model.getMap().getPath().size() >= 2){
        model.getMap().addPathPoint(mouseX, mouseY);
      }
      else {
        model.getMap().addPathPoint(mouseX, mouseY);
      }
    }
    if(mouseButton == RIGHT){
      model.getMap().clearPath();
    }
  }
  
  public void setGraphic(){
    ArrayList<Point> orig_path = model.getMap().getPath();
    ArrayList<Point> graph_path = new ArrayList<Point>();
    
    for(int i = 0; i < orig_path.size()-1; i++){
      stroke(255);
      float distance = orig_path.get(i).distanceFrom(orig_path.get(i+1));
      int numPoints = (int) distance/3;
      graph_path.add(orig_path.get(i));
      for(int j = 0; j < numPoints; j++) {
        int newX = (int) lerp(orig_path.get(i).getX(), orig_path.get(i+1).getX(), (float)j/numPoints);
        int newY = (int) lerp(orig_path.get(i).getY(), orig_path.get(i+1).getY(), (float)j/numPoints);
        graph_path.add(new Point(newX, newY, model));
      }
    }
    graph_path.add(orig_path.get(orig_path.size()-1));
    float min = 1;
    float max = 0;
    for(int i = 0; i < graph_path.size(); i++){
      float currVal = graph_path.get(i).getValue();
      if(currVal < min){
        min = currVal;
      }
      if(currVal > max){
        max = currVal;
      }
    }
    for(int i = 0; i < graph_path.size(); i++){
      fill(255);
      //float elevation = lerp(0, 1, max-min
      circle(x+(i*((float)w/(graph_path.size()-1))), y+h-((graph_path.get(i).getValue())*h), 5);
      //System.out.println(y+h-((graph_path.get(i).getValue())*h));
      //circle(x+((i+1)*((float)w/(graph_path.size()-1))), y+h-((graph_path.get(i+1).getValue())*h), 5);
    }
   
  }
  
};

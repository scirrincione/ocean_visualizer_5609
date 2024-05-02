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
    text("Year Comparison Histogram View", x + 50, y + 50);
    
    /*
    stroke(255);
    line(50, height-30, 50, height-200);
    line(50, height-30, 860, height-30);
    
    text("Var", 10, height-220);
    text("Year", 865, height-10);
    
    //label years x axis
    int minYear = model.getCurrColumns().getRow(1).getInt("min");
    int maxYear = model.getCurrColumns().getRow(1).getInt("max");
    int diff = maxYear - minYear;
    for(int i = 0; i < diff; i+=10){
      text(i+minYear, i*800/diff+40, height-10);
    }
    
    //label data amount y axis
    Table mData = model.getData();
    Table col = model.getCurrColumns();
    for(int i = 0; i < col.getRowCount(); i++){
      TableRow currRow = col.getRow(i);
      if(currRow.getInt("included") == 1){
        fill(model.getColor(currRow.getInt("color")-4));
        textSize(15);
        text(currRow.getInt("min"), 10, height-40+((i-4)*12));
        text(currRow.getInt("max"), 10+((i-4)*25), height-200);
        textSize(20);
      }
    }*/
    /*
    //put down included data
    for(int i = 0; i < mData.getRowCount(); i++){
      TableRow currRowData = mData.getRow(i);
      for(int j = 0; j < col.getRowCount(); i++){
        TableRow currRowCol = col.getRow(j);
        if(currRowCol.getInt("included") == 1){
          fill(model.getColor(currRow.getInt("color")-4));
          line
        }
      }
    }*/
    
    // get all of the points that would be on the graph
    Table mData = model.getData();
    Table cols = model.getCurrColumns();
    plot.setPos(50,50);
    for(int i = 0; i < cols.getColumnCount(); i++){
      TableRow currCol = cols.getRow(i);
      if(currCol.getInt("included") == 1){
        GPointsArray points = new GPointsArray(mData.getRowCount());
        for(int j = 0; j < mData.getRowCount(); j++){ 
          TableRow currRow = mData.getRow(j);
          points.add(j, currRow.getFloat(currCol.getString("var")));
        }
        plot.setPoints(points);
        plot.defaultDraw();
      }
    }
    
    

  }
  
  public void mousePressed() {
  }
  
  
};

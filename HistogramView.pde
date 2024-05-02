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
    text("Temperature Comparison View", x + 50, y + 50);
    
    stroke(255);
    line(width-450, height-30, width-450, height-200);
    line(width-450, height-33, width-20, height-33);
    
    text("Var", width-480, height-210);
    text("Max", width-490, height-190);
    text("Temp", width-480, height-3);
    text("Min", width-490, height-30);
    
    //add temp indicators
    int tempMin = model.getCurrColumns().getInt(4, "min");
    int tempMax = model.getCurrColumns().getInt(4, "max");
    int numInd = 5; //number of temp indicators
    int[] buckets = new int[numInd+1];
    for(int i = 0; i <= numInd; i++){
      buckets[i] = tempMin+(tempMax-tempMin)/numInd*i;
      text(buckets[i], width-(460-((i*430)/numInd)), height-18);
    }
    
    //collect data
    Table mData = model.getData();
    Table cols = model.getCurrColumns();
    for(int i = 0; i < cols.getColumnCount(); i++){
      TableRow currCol = cols.getRow(i);
      if(currCol.getInt("included") == 1){ // if the variable is included
        for(int j = 0; j < mData.getRowCount(); j++){ //go through the data table for coordinates in the region
          TableRow currRow = mData.getRow(j);
          if(model.coordinatesInRegion(currRow.getFloat("longitude"), currRow.getFloat("latitude"))){
            //place based on buckets
          }
        }
        
      }
    }
  }

  
};

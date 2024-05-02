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
    int maxHeight = 170;
    //collect data
    Table mData = model.getData();
    Table cols = model.getCurrColumns();
    for(int i = 0; i < cols.getRowCount(); i++){
      TableRow currCol = cols.getRow(i); //get info of the current variable
      if(currCol.getInt("included") == 1){ // if the variable is included
      float[] vals = new float[buckets.length]; // add up every var correlating with temp var
      int[] counts = new int[buckets.length]; // count for dividing later
      for(int l = 0; l < buckets.length; l++){ // initializing
        vals[l] = 0;
        counts[l] = 0;
      }
        for(int j = 0; j < mData.getRowCount(); j++){ //go through the data table for coordinates in the region
          TableRow currRow = mData.getRow(j); // get the current row of data to look at
          if(model.coordinatesInRegion(currRow.getFloat("longitude"), currRow.getFloat("latitude"))){ // if within selected region
            for(int r = 0; r < buckets.length; r++){ // go through temperature buckets
              //System.out.println(r + " " +vals[r] + " " + (buckets[r]-(tempMax-tempMin)/numInd) + " " + (buckets[r]+(tempMax-tempMin)/numInd));
              if(currRow.getInt("temperature") > buckets[r]-(tempMax-tempMin)/numInd && currRow.getInt("temperature") < buckets[r]+(tempMax-tempMin)/numInd){ // if within bucket
                vals[r] += currRow.getFloat(currCol.getString("var")); // add to bucket count
                counts[r]++;
              }
            }
          }
        }
        int offset = i*5;
        for(int r = 0; r < buckets.length; r++){
              fill(model.getColor(currCol.getInt("color")-4));
              float currHeight = maxHeight*(vals[r]/counts[r])/currCol.getFloat("max");
              rect(width-(460-((r*430/numInd)))+offset-10, height-33-currHeight, 5, currHeight);
            }
        
      }
    }
  }

  
};

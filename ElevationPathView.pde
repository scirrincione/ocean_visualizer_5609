// ---------------------------------------------------------
// Draws the elevation path
// ---------------------------------------------------------
import java.util.Map;
import java.util.TreeMap;

public class ElevationPathView extends View {
  private MapModel model;
  private TreeMap<Integer, ArrayList<Float>> yearToAvgMap; // i.e. {1945 : [temp, oxygen, pH, chloro]} treemaps are sorted in ascending order
  int yZero = y + h - 50; // Variables for normalized plot region
  int yOne = y + 50;
  int xZero = x + 50;
  int xOne = x + w - 50;
    
  public ElevationPathView(MapModel model, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.model = model;
  }

  public void setYearAvgs() {
      TreeMap<Integer, ArrayList<ArrayList<Float>>> yearToValuesMap = new TreeMap<>(); // {1945 : [[1],[2],[3],[4]]}
  
      Table data = model.getData();
      for (int i = 0; i < data.getRowCount(); i++) {
          TableRow currRow = data.getRow(i);
          if(!model.coordinatesInRegion(currRow.getFloat("longitude"), currRow.getFloat("latitude"))) { // Coordinates outside of region
            continue;
          }
          int year = currRow.getInt("year");
  
          if (yearToValuesMap.containsKey(year)) {
              ArrayList<ArrayList<Float>> valuesList = yearToValuesMap.get(year);
              addVariableToList(valuesList.get(0), currRow, "temperature");
              addVariableToList(valuesList.get(1), currRow, "oxygen");
              addVariableToList(valuesList.get(2), currRow, "pH");
              addVariableToList(valuesList.get(3), currRow, "chlorophyl");
          } else {
              ArrayList<ArrayList<Float>> valuesList = new ArrayList<>();
              ArrayList<Float> tempList = new ArrayList<>();
              ArrayList<Float> oxygenList = new ArrayList<>();
              ArrayList<Float> phList = new ArrayList<>();
              ArrayList<Float> chlorophylList = new ArrayList<>();
              addVariableToList(tempList, currRow, "temperature");
              addVariableToList(oxygenList, currRow, "oxygen");
              addVariableToList(phList, currRow, "pH");
              addVariableToList(chlorophylList, currRow, "chlorophyl");
              valuesList.add(tempList);
              valuesList.add(oxygenList);
              valuesList.add(phList);
              valuesList.add(chlorophylList);
              yearToValuesMap.put(year, valuesList);
          }
      }
      
      this.yearToAvgMap = new TreeMap<>();
      for (Map.Entry<Integer, ArrayList<ArrayList<Float>>> entry : yearToValuesMap.entrySet()) { // Compute normalized averages
        int year = entry.getKey();
        ArrayList<ArrayList<Float>> listOfLists = entry.getValue();
        ArrayList<Float> averages = new ArrayList<>();

        for (ArrayList<Float> list : listOfLists) {
            float sum = 0;
            for (float num : list) {
                sum += num;
            }
            float average = sum / list.size();
            averages.add(average);
        }
        yearToAvgMap.put(year, averages);
      }
  }
  
  void addVariableToList(ArrayList<Float> list, TableRow row, String varName) {
    float var_val = row.getFloat(varName);
    if(Float.isNaN(var_val)) {
      return;
    }
    list.add(var_val);
  }

  public void drawView() {
    fill(255);
    text("Normalized Averages in Region by Year", x + w - 350, y + 35);
    
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
    //Table mData = model.getData();
    //Table cols = model.getCurrColumns();
    //plot.setPos(50,50);
    //for(int i = 0; i < cols.getColumnCount(); i++){
    //  TableRow currCol = cols.getRow(i);
    //  if(currCol.getInt("included") == 1){
    //    GPointsArray points = new GPointsArray(mData.getRowCount());
    //    for(int j = 0; j < mData.getRowCount(); j++){ 
    //      TableRow currRow = mData.getRow(j);
    //      points.add(j, currRow.getFloat(currCol.getString("var")));
    //    }
    //    plot.setPoints(points);
    //    plot.defaultDraw();
    //  }
    //}
    
    stroke(255);
    line(xZero, yZero, xZero, yOne); // y-axis
    line(xZero, yZero, xOne, yZero); // x-axis
    noStroke();
    
    text("Var", xZero - 20, yOne - 10);
    text("Max", xZero - 40, yOne + 10);
    text("Year", xOne + 10, yZero);
    text("Min", xZero - 35, yZero + 5);

    Table currCols = model.getCurrColumns();
    if(yearToAvgMap == null || yearToAvgMap.size() <= 1) {
      return;
    }
    
    float xSpacing = (xOne - xZero) / (yearToAvgMap.size() - 1);
    float prevX = xOne;
    float prevTemp = 0;
    float prevO2 = 0;
    float prevPH = 0;
    float prevChloro = 0;
    int i = 0;
    for (Integer year : yearToAvgMap.keySet()) {
      float xLoc = xZero + xSpacing * i;
      pushMatrix();
      translate(xLoc, yZero + 5);
      rotate(HALF_PI);
      text(str(year), 0, 0); // Draws text at 90 deg rotation
      popMatrix();
      
      ArrayList<Float> mappedNormalizedAvgs = normalizeAndMapAvgs(year); //<>//
      noStroke();
      if(currCols.getInt(4,"included") == 1) {
        int fillColor = color(224,114,4);
        fill(fillColor, 120);
        float temp_n = mappedNormalizedAvgs.get(0);
        circle(xLoc, temp_n, 5);
        stroke(fillColor, 120);
        if(i != 0) {
          line(prevX, prevTemp, xLoc, temp_n);
        }
        prevTemp = temp_n;
      }
      if(currCols.getInt(5,"included") == 1) {
        int fillColor = color(3,44,252);
        fill(fillColor, 120);
        float oxygen_n = mappedNormalizedAvgs.get(1);
        circle(xLoc, oxygen_n, 5);
        stroke(fillColor, 120);
        if(i != 0) {
          line(prevX, prevO2, xLoc, oxygen_n);
        }
        prevO2 = oxygen_n;
      }
      if(currCols.getInt(6,"included") == 1) {
        int fillColor = color(255,245,99);
        fill(fillColor, 120);
        float ph_n = mappedNormalizedAvgs.get(2);
        circle(xLoc, ph_n, 5);
        stroke(fillColor, 120);
        if(i != 0) {
          line(prevX, prevPH, xLoc, ph_n);
        }
        prevPH = ph_n;
      }
      if(currCols.getInt(7,"included") == 1) {
        int fillColor = color(3,252,44);
        fill(fillColor, 120);
        float chloro_n = mappedNormalizedAvgs.get(3);
        circle(xLoc, chloro_n, 5);
        stroke(fillColor, 120);
        if(i != 0) {
          line(prevX, prevChloro, xLoc, chloro_n);
        }
        prevChloro = chloro_n;
      }
      fill(255);
      
      i++;
      prevX = xLoc;
    }
  }
  
  private ArrayList<Float> normalizeAndMapAvgs(Integer year) {
    ArrayList<Float> avgs = yearToAvgMap.get(year);
    ArrayList<Float> normalizedMappedAvgs = new ArrayList<Float>();
    //println(year)
    //println(avgs);
    Table currColumns = model.getCurrColumns();
    float temp_min = currColumns.getFloat(4, "min");
    float temp_max = currColumns.getFloat(4, "max");
    float oxygen_min = currColumns.getFloat(5, "min");
    float oxygen_max = currColumns.getFloat(5, "max");
    float pH_min = currColumns.getFloat(6, "min");
    float pH_max = currColumns.getFloat(6, "max");
    float chlorophyl_min = currColumns.getFloat(7, "min");
    float chlorophyl_max = currColumns.getFloat(7, "max");
    
    float temp_normalized = (avgs.get(0) - temp_min) / (temp_max - temp_min);
    println(temp_normalized);
    float oxygen_normalized = (avgs.get(1) - oxygen_min) / (oxygen_max - oxygen_min);
    float pH_normalized = (avgs.get(2) - pH_min) / (pH_max - pH_min);
    float chlorophyl_normalized = (avgs.get(3) - chlorophyl_min) / (chlorophyl_max - chlorophyl_min);
    
    float temp_mapped = map(temp_normalized, 0, 1, yZero, yOne);
    float oxygen_mapped  = map(oxygen_normalized, 0, 1, yZero, yOne);
    float pH_mapped  = map(pH_normalized, 0, 1, yZero, yOne);
    float chlorophyl_mapped  = map(chlorophyl_normalized, 0, 1, yZero, yOne);
    
    normalizedMappedAvgs.add(temp_mapped);
    normalizedMappedAvgs.add(oxygen_mapped);
    normalizedMappedAvgs.add(pH_mapped);
    normalizedMappedAvgs.add(chlorophyl_mapped);
    return normalizedMappedAvgs;
  }
  
  public void mousePressed() {
  }
  
  
};

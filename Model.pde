// ---------------------------------------------------------
// The MapModel class holds all the information necessary
// for working with an elevation map.  This class is application
// independent and should be separate from graphics and interaction
// logic.
// ---------------------------------------------------------

// Model class for holding information
public class MapModel {
  private ElevationMap map;
  // table for the data and table for which data has been selected
  private Table dataTable;
  private Table columns;
  private int currYear;
  private color[] colors;
  
  // Pass in a filepath to an image.  It will use the red channel for determining the elevation.
  public MapModel(String filePath, Table data, Table col, color[] c) {
    PImage heightMap = loadImage(filePath);
    map = new ElevationMap(heightMap, 0.0, 1.0);
    dataTable = data;
    columns = col;
    currYear = col.getRow(1).getInt("min");
    colors = c;
  }
  
  public color getColor(int num){
    return colors[num];
  }
  
  public int getCurrYear(){
    return currYear;
  }
  
  public void incCurrYear(){
    boolean found = false;
    for(int i = 0; i < dataTable.getRowCount(); i++){
      TableRow currRow = dataTable.getRow(i);
      if(currRow.getInt("year") == currYear && !found){
        found = true;
      }
      if(found && currRow.getInt("year") != currYear){
        currYear = currRow.getInt("year");
        return;
      }
    }
  }
  
  public void decCurrYear(){
    boolean found = false;
    for(int i = dataTable.getRowCount()-1; i >= 0; i--){
      TableRow currRow = dataTable.getRow(i);
      if(currRow.getInt("year") == currYear && !found){
        found = true;
      }
      if(found && currRow.getInt("year") != currYear){
        currYear = currRow.getInt("year");
        return;
      }
    }
  }
  
  // Get's the elevation map
  public ElevationMap getMap() {
    return map;
  }
  
  public Table getData(){
    return dataTable;
  }
  
  public Table getCurrColumns(){
    return columns;
  }
};



// Defines an elevation map for working with terrain
public class ElevationMap {
  private PImage heightMap;
  private PImage colorImage;
  private float low;
  private float high;
  
  // The heightmap image defines the width and height and the low and high allows the user to specify the elevation range.
  // The elevation map also holds a color image that can be edited with getColor(x,y) and setColor(x,y,c)
  public ElevationMap(PImage heightMap, float low, float high) {
    this.heightMap = heightMap;
    this.low = low;
    this.high = high;
    colorImage = new PImage(heightMap.width, heightMap.height);
    colorImage.copy(heightMap, 0, 0, heightMap.width, heightMap.height, 0, 0, heightMap.width, heightMap.height);
    heightMap.loadPixels();
    colorImage.loadPixels();
  }
 
  // Get the map width
  public int getWidth() {
    return heightMap.width;
  }
  
  // Get the map height
  public int getHeight() {
    return heightMap.height;
  }
  
  // Get the color image for drawing and editing purposes
  public PImage getColorImage() {
    return colorImage;
  }
  
  // Get the color at a point in the map
  public color getColor(int x, int y) {
    return colorImage.pixels[x + y*heightMap.width];
  }
  
  // Sets the color at a point in the map
  public void setColor(int x, int y, color c) {
    colorImage.pixels[x + y*heightMap.width] = c;
  }
}

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
  
  private float pointRadius;
  private PVector toggledPoint;
  ArrayList<PVector> regionPoints;
  
  private PanZoomMap panZoomMap;
  
  // Pass in a filepath to an image.  It will use the red channel for determining the elevation.
  public MapModel(String filePath, Table data, Table col, color[] c) {
    PImage heightMap = loadImage(filePath);
    map = new ElevationMap(heightMap, 0.0, 1.0);
    dataTable = data;
    columns = col;
    this.pointRadius = 5;
    this.regionPoints = new ArrayList<PVector>();
    currYear = col.getRow(1).getInt("min");
    colors = c;
  }
  
  public color getColor(int num){
    return colors[num];
  }
  
  private void setZoomMap(PanZoomMap panZoomMap) { // This is disgusting remove it later prolly
    this.panZoomMap = panZoomMap;
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
  
  public ArrayList<PVector> getRegionPoints() {
    return regionPoints;
  }
  
  public boolean pointToggled(PVector point) {
    return point == toggledPoint;
  }
  
    // Add or select waypoints
  public void click(int click_x, int click_y) {
    if (click_x < width-250) {
    float x = panZoomMap.screenXtoLongitude(click_x);
    float y = panZoomMap.screenYtoLatitude(click_y);
    PVector clicked = clickedPoint(x,y);
    if(clicked != null) {
      this.toggledPoint = clicked;
    } else {
      PVector newPoint = new PVector(x, y);
      this.regionPoints.add(newPoint);
      this.toggledPoint = newPoint;
    }
    }
  }
  
  public void drag(int x, int y) {
    if(toggledPoint == null) {
      return;
    }
    toggledPoint.x = panZoomMap.screenXtoLongitude(x);
    toggledPoint.y = panZoomMap.screenYtoLatitude(y);
  }
  
  public void deletePoint() {
    if(toggledPoint != null) {
      regionPoints.remove(toggledPoint);
      toggledPoint = null;
    }
  }
  
  public PVector clickedPoint(float x, float y) {
    for (PVector point : this.regionPoints) {
      float distance = dist(x, y, point.x, point.y);
      if (distance <= this.pointRadius) {
        return point;
      }
    }
    return null;
  }
  
  boolean coordinatesInRegion(float longitude, float latitude) {
    int n = this.regionPoints.size();
    if(n <= 2) {
      return false;
    }
    boolean inside = false;
    PVector p1 = this.regionPoints.get(0);
    for (int i = 0; i <= n; i++) {
      PVector p2 = this.regionPoints.get(i % n);
      if (latitude > min(p1.y, p2.y)) {
        if (latitude <= max(p1.y, p2.y)) {
          if (longitude <= max(p1.x, p2.x)) {
            if (p1.y != p2.y) {
              float xints = (latitude - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
              if (longitude <= xints) {
                inside = !inside;
              }
            }
          }
        }
      }
      p1 = p2;
    }
    return inside;
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

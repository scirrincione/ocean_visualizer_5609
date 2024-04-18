// ---------------------------------------------------------
// The MapModel class holds all the information necessary
// for working with an elevation map.  This class is application
// independent and should be separate from graphics and interaction
// logic.
// ---------------------------------------------------------

// Model class for holding information
public class MapModel {
  private ElevationMap map;
  
  // Pass in a filepath to an image.  It will use the red channel for determining the elevation.
  public MapModel(String filePath) {
    PImage heightMap = loadImage(filePath);
    map = new ElevationMap(heightMap, 0.0, 1.0);
  }
  
  // Get's the elevation map
  public ElevationMap getMap() {
    return map;
  }
};

public class Point{
  private int x;
  private int y;
  private float value;

  public Point(int x, int y, float v){
    this.x = x;
    this.y = y;
    value = v;
  }
  
  public Point(int x, int y, MapModel map){
    value = map.getMap().getElevation(x, y);
    this.x = x;
    this.y = y;
  }
  
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public float getValue(){
    return value;
  }
  
  public void setX(int x){
    this.x = x;
  }
  
  public void setY(int y){
    this.y = y;
  }
  
  public float distanceFrom(Point p2){
    return sqrt(pow(p2.getX()-x, 2) + pow(p2.getY()-y, 2));
  }
  
  public void setCoord(int x, int y, float v){
    this.x = x;
    this.y = y;
    value = v;
  }
  
};

// Defines an elevation map for working with terrain
public class ElevationMap {
  private PImage heightMap;
  private PImage colorImage;
  private float low;
  private float high;
  private ArrayList<Point> points;
  private ArrayList<Point> path;
  
  // The heightmap image defines the width and height and the low and high allows the user to specify the elevation range.
  // The elevation map also holds a color image that can be edited with getColor(x,y) and setColor(x,y,c)
  public ElevationMap(PImage heightMap, float low, float high) {
    this.heightMap = heightMap;
    this.low = low;
    this.high = high;
    this.points = new ArrayList<Point>();
    this.path = new ArrayList<Point>();
    colorImage = new PImage(heightMap.width, heightMap.height);
    colorImage.copy(heightMap, 0, 0, heightMap.width, heightMap.height, 0, 0, heightMap.width, heightMap.height);
    heightMap.loadPixels();
    colorImage.loadPixels();
    setPoints();
    setMap(color(11,48,16), color(235,255,238));
  }
  
  public void addPathPoint(int x, int y){
    //int loc = x + y*colorImage.width;
    float value = getElevation(x,y);
    path.add(new Point(x, y, value));
  }
  
  public ArrayList<Point> getPath() {
    return path;
  }
  
  public void clearPath(){
    path.clear();
  }
  
  public void setMap(color lowColor, color highColor){
    for(int i = 0; i < points.size(); i++){
      //int loc = points.get(i).getX() + points.get(i).getY()*colorImage.width;
      setColor(points.get(i).getX(), points.get(i).getY(), getCurrColor(points.get(i).getValue(), lowColor, highColor));
      //System.out.println(colorImage.pixels[loc]);
    }
  }
  
  public color getCurrColor(float value, color lowColor, color highColor){
    color x = lerpColor(lowColor, highColor, value);
    return x;
  }
  
  public void setPoints(){
    for(int y = 0; y < colorImage.height; y++){
      for(int x = 0; x < colorImage.width; x++){
        //int loc = x + y*colorImage.width;
        float value = getElevation(x,y);
        points.add(new Point(x, y, value));
      }
    }
  }
  
  public ArrayList<Point> getPoints(){
    return points;
  }
  
  // Get the map width
  public int getWidth() {
    return heightMap.width;
  }
  
  // Get the map height
  public int getHeight() {
    return heightMap.height;
  }
  
  // Get the elevation at a point in the map
  public float getElevation(int x, int y) {
    float normalizedElevation = 1.0*red(heightMap.pixels[x + y*heightMap.width])/255.0;
    return lerp(low, high, normalizedElevation);
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

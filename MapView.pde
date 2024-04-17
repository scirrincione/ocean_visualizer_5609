// ---------------------------------------------------------
// Draws the Map for height image.
// ---------------------------------------------------------

public class MapView extends View {
  private MapModel model;
  private float zoom = 1.0;
  public float translateX = 0.0;
  public float translateY = 0.0;
  private PanZoomPage panZoomPage;
  PImage img;
  float imgScale;
  float aspect;
  
  public MapView(MapModel model, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.model = model;
    img = model.getMap().getColorImage();
    panZoomPage = new PanZoomPage(x, y, w, h);
    panZoomPage.fitPageOnScreen();
    
    if (img.width > img.height) {
      imgScale = 1.0/img.width;
    } else {
      imgScale = 1.0/img.height;
    }
  }
  
  public void drawView() {
    // Center the map
    float imageX = panZoomPage.pageXtoScreenX(0.5);
    float imageY = panZoomPage.pageYtoScreenY(0.5);
    
    // Draw the map using the panZoomPage
    pushMatrix();
    translate(imageX, imageY);
    scale(1.0*panZoomPage.pageLengthToScreenLength(1.0)*imgScale);
    translate(-img.width/2,-img.height/2);
    image(img, 0, 0);
    popMatrix();
    
    // Show the cross hairs for querying the image
    stroke(200,0,0);
    line(mouseX,0, mouseX,h);
    line(0,mouseY, w,mouseY);
    fill(255,255,255);
    textSize(20);
    int imgX = screenXtoImageX(mouseX);
    int imgY = screenYtoImageY(mouseY);
    if (imgX >= 0 && imgX < img.width && imgY >= 0 && imgY < img.height) {
      text("" + imgX + ", " + imgY , mouseX+50, mouseY+50);
    }
    fill(0,0,0);
    stroke(0,0,0);
    
    ArrayList<Point> path = model.getMap().getPath();
    for(int i = 0; i < path.size(); i++) {
      fill(191,45,0);
      circle(path.get(i).getX(), path.get(i).getY(), 5);
      if(path.size() > 1 && i > 0){
        line(path.get(i-1).getX(), path.get(i-1).getY(), path.get(i).getX(), path.get(i).getY());
      }
      
    }
   
      
  }

  // Use the screen position to get the x value of the image
  public int screenXtoImageX(int screenX) {
    float x = panZoomPage.screenXtoPageX(screenX);
    return (int)((x-0.5 + img.width*imgScale/2)*img.width/(img.width*imgScale));
  }
  
  // Use the screen position to get the y value of the image
  public int screenYtoImageY(int screenY) {
    float y = panZoomPage.screenYtoPageY(screenY);
    return (int)((y-0.5 + img.height*imgScale/2)*img.height/(img.height*imgScale));
  }
};

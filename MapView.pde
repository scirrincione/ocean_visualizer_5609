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

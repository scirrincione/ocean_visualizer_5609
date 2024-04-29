// ---------------------------------------------------------
// Draws the Map for height image.
// ---------------------------------------------------------

public class MapView extends View {
  private MapModel model;
  private float zoom = 1.0;
  public float translateX = 0.0;
  public float translateY = 0.0;
  // year variable needs to start at the first year of data
  public int currYear = 1950;
  int boxSize = 20; // sets size of check box
  Table checkBoxes; // table of where the check boxes are (x, y, included, var)
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
      imgScale = 2.0/img.width;
    } else {
      imgScale = 1.0/img.height;
    }
    
    // set check box info here to make clicking easier
    checkBoxes = new Table();
    checkBoxes.addColumn("x", Table.INT);
    checkBoxes.addColumn("y", Table.INT);
    checkBoxes.addColumn("included", Table.INT);
    checkBoxes.addColumn("var", Table.STRING);
    Table data = model.getData();
    int checkWidth = 190;
    int checkHeight = (int)(data.getColumnCount()*boxSize*2);
    int numBoxes = data.getColumnCount();
    for(int i = 0; i < numBoxes; i++){
      TableRow newRow = checkBoxes.addRow();
      newRow.setInt("y", checkHeight/numBoxes*i+20);
      newRow.setInt("x", width-checkWidth);
      newRow.setString("var", data.getColumnTitle(i));
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
    
    // draws check box using precalculated checkbox variables 
    Table col = model.getCurrColumns();
    int numBoxes = checkBoxes.getRowCount();
    int checkWidth = 190;
    int checkHeight = (int)(numBoxes*boxSize*2);
    fill(255, 150);
    rect(width-checkWidth-10, 10, checkWidth, checkHeight);
    for(int i = 0; i < numBoxes; i++){
      if (col.getInt(i, "included") == 0){
        fill(255);
      }
      else {
        fill(0);
      }
      square(checkBoxes.getInt(i,"x"), checkBoxes.getInt(i, "y"), boxSize);
      fill(0);
      textSize(boxSize);
      text(checkBoxes.getString(i, "var"), checkBoxes.getInt(i, "x")+boxSize*1.5, checkBoxes.getInt(i, "y")+15);
    }
    
    // draw points based on latitude and longitude
    // IMPORTANT!!!! CHANGES WILL NEED TO BE MADE IN HERE IF DATA SET UP IS CHANGED
    Table data = model.getData();
    for(int i = 0; i < data.getRowCount(); i++){
      TableRow currRow = data.getRow(i);
      if(currRow.getInt("year") == currYear){
        // for loop starts at 3 because first 3 columns are year, latitude, longitude
        for(int j = 3; j < data.getColumnCount(); j++){
          float[] currPos = convertLatLongToMap(currRow.getFloat("long"), currRow.getFloat("lat"));
          fill(255);
          circle(panZoomPage.pageXtoScreenX(currPos[0]), panZoomPage.pageYtoScreenY(currPos[1]), 20);
        }
      }
    }
  }
  
  public float[] convertLatLongToMap(float lon, float lat){
    float x = (float)((lon+180.0)/360.0*img.width);
    float y = (float)(img.height-((lat+90.0)/180.0*img.height));
    return new float[]{panZoomPage.screenXtoPageX(x),panZoomPage.screenYtoPageY(y)};
  }
  
  public void mousePressed(){
    
    // this just checks if a checkbox was clicked on, if so it sets included to 1 if it was 0 or 0 if it was 1
    for(int i = 0; i < checkBoxes.getRowCount(); i++){
      if(mouseX >= checkBoxes.getInt(i, "x") && mouseX <= checkBoxes.getInt(i, "x")+boxSize && mouseY >= checkBoxes.getInt(i, "y") && mouseY <= checkBoxes.getInt(i, "y")+boxSize){
        model.getCurrColumns().setInt(i, "included", (model.getCurrColumns().getInt(i, "included")+1)%2);
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

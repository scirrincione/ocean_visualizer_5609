// ---------------------------------------------------------
// Draws the Map for height image.
// ---------------------------------------------------------

public class MapView extends View {
  private MapModel model;
  private float zoom = 1.0;
  public float translateX = 0.0;
  public float translateY = 0.0;
  // year variable needs to start at the first year of data
  public int currYear;
  int boxSize = 20; // sets size of check box
  Table checkBoxes; // table of where the check boxes are (x, y, included, var)
  private PanZoomMap panZoomMap;
  PImage img;
  float imgScale;
  float aspect;
  int startCol;
  
  public MapView(MapModel model, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.model = model;
    img = model.getMap().getColorImage();
    panZoomMap = new PanZoomMap(-90, -180, 90, 180);
    panZoomMap.fitPageOnScreen();
    if (img.width > img.height) {
      imgScale = 2.0/img.width;
    } else {
      imgScale = 1.0/img.height;
    }
    
    currYear = model.getCurrYear();
    
    // set check box info here to make clicking easier
    startCol = 4; //column to start from so year isn't included in checkboxes
    checkBoxes = new Table();
    checkBoxes.addColumn("x", Table.INT);
    checkBoxes.addColumn("y", Table.INT);
    checkBoxes.addColumn("included", Table.INT);
    checkBoxes.addColumn("var", Table.STRING);
    Table data = model.getData();
    int checkWidth = 190;
    int checkHeight = (int)((data.getColumnCount()-startCol)*boxSize*2);
    int numBoxes = data.getColumnCount()-startCol;
    for(int i = startCol; i < data.getColumnCount(); i++){
      TableRow newRow = checkBoxes.addRow();
      newRow.setInt("y", checkHeight/numBoxes*(i-startCol)+20);
      newRow.setInt("x", width-checkWidth);
      newRow.setString("var", data.getColumnTitle(i));
    }
  }
  
  
  public void drawView() {
    // Center the map
    /*float imageX = panZoomPage.pageXtoScreenX(0.5);
    float imageY = panZoomPage.pageYtoScreenY(0.5);
    
    // Draw the map using the panZoomPage
    pushMatrix();
    translate(imageX, imageY);
    scale(1.0*panZoomPage.pageLengthToScreenLength(1.0)*imgScale);
    translate(-img.width/2,-img.height/2);
    image(img, 0, 0);
    popMatrix();*/
    float x1 = panZoomMap.longitudeToScreenX(-180);
    float y1 = panZoomMap.latitudeToScreenY(90);
    float x2 = panZoomMap.longitudeToScreenX(180);
    float y2 = panZoomMap.latitudeToScreenY(-90);
    image(img, x1, y1, x2-x1, y2-y1);
    
    fill(255);
    String s2 = "(" + panZoomMap.screenXtoLongitude(mouseX) + ", " + panZoomMap.screenYtoLatitude(mouseY) +  ")";
    text(s2, mouseX, mouseY);
    
    // draws check box using precalculated checkbox variables 
    Table col = model.getCurrColumns();
    int numBoxes = checkBoxes.getRowCount();
    int checkWidth = 190;
    int checkHeight = (int)(numBoxes*boxSize*2);
    fill(255, 150);
    rect(width-checkWidth-10, 10, checkWidth, checkHeight);
    for(int i = 0; i < numBoxes; i++){
      if (col.getInt(i+startCol, "included") == 0){
        fill(255);
      }
      else {
        fill(model.getColor(i));
      }
      square(checkBoxes.getInt(i,"x"), checkBoxes.getInt(i, "y"), boxSize);
      fill(0);
      textSize(boxSize);
      text(checkBoxes.getString(i, "var"), checkBoxes.getInt(i, "x")+boxSize*1.5, checkBoxes.getInt(i, "y")+15);
    }
    
    // draw points based on latitude and longitude
    Table data = model.getData();
    currYear = model.getCurrYear();
    for(int i = 0; i < data.getRowCount(); i++){
      TableRow currRow = data.getRow(i);
      if(currRow.getInt("year") == currYear){
        // for loop starts at 3 because first 3 columns are year, latitude, longitude
        for(int j = startCol; j < data.getColumnCount(); j++){
          fill(model.getColor(col.getInt(j-startCol, "color")), 120);
          noStroke();
          if(col.getInt(j-startCol,"included") == 1){
            circle(panZoomMap.longitudeToScreenX(currRow.getFloat("longitude")), panZoomMap.latitudeToScreenY(currRow.getFloat("latitude")), log(currRow.getFloat(j)));
          }
          stroke(0);
        }
      }
    }
    
    
    // year changer
    fill(255);
    rect(width-150, height/2+50, 140, 60);
    fill(0);
    text("Year: " + model.getCurrYear(), width-125, height/2+68);
    rect(width-140, height/2+75, 50, 30);
    rect(width-70, height/2+75, 50, 30);
    fill(255);
    text("prev", width-135, height/2+95);
    text("next", width-65, height/2+95);
  }
  
  
  void mousePressed(){
    
    // this just checks if a checkbox was clicked on, if so it sets included to 1 if it was 0 or 0 if it was 1
    for(int i = 0; i < checkBoxes.getRowCount(); i++){
      if(mouseX >= checkBoxes.getInt(i, "x") && mouseX <= checkBoxes.getInt(i, "x")+boxSize && mouseY >= checkBoxes.getInt(i, "y") && mouseY <= checkBoxes.getInt(i, "y")+boxSize){
        model.getCurrColumns().setInt(i+startCol, "included", (model.getCurrColumns().getInt(i+startCol, "included")+1)%2);
      }
        
    }
    if(mouseX >= width-140 && mouseX <= width-90 && mouseY >= height/2+75 && mouseY <= height/2+105 && model.getCurrYear() >= model.getCurrColumns().getRow(1).getInt("min")){
      model.decCurrYear();
    }
    if(mouseX >= width-70 && mouseX <= width-20 && mouseY >= height/2+75 && mouseY <= height/2+105 && model.getCurrYear() <= model.getCurrColumns().getRow(1).getInt("max")){
      model.incCurrYear();
    }
  }

  // Use the screen position to get the x value of the image
  public int screenXtoImageX(int screenX) {
    float x = panZoomMap.screenXtoPageX(screenX);
    return (int)((x-0.5 + img.width*imgScale/2)*img.width/(img.width*imgScale));
  }
  
  // Use the screen position to get the y value of the image
  public int screenYtoImageY(int screenY) {
    float y = panZoomMap.screenYtoPageY(screenY);
    return (int)((y-0.5 + img.height*imgScale/2)*img.height/(img.height*imgScale));
  }
};

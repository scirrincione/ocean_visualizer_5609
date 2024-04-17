// ---------------------------------------------------------
// Draws the 3D spatial view of the height data.
// ---------------------------------------------------------

public class Spatial3DView extends View {
  private MapModel model;
  int scl = 5;
  int cols, rows;
  int meshSize;
  PGraphics scene;
  float aspect;
  float rotation = 0;
  float zoom = 1.0;
  
  public Spatial3DView(MapModel model, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.model = model;

    // Use width and height to create height mesh.
    meshSize = min(w,h);
    cols = meshSize / scl;
    rows = meshSize / scl;
    aspect = 1.0*model.getMap().getWidth()/model.getMap().getHeight();
    
    // Allows us to draw to a texture
    scene = createGraphics(w, h, P3D);
  }
  
  public void drawView() {
    // Begin drawing the 3D texture
    scene.beginDraw();
    scene.background(0);
    scene.noStroke();
    scene.fill(0,0,0);
    scene.rect(0,0, w, h);
    scene.fill(255);
    scene.lights();
    
    // Translate the mesh to a 3D view
    scene.translate(0,0,250);
    scene.translate(w/2, h/2); 
    scene.rotateX(PI/3);
    scene.rotateZ(rotation);
    scene.scale(0.4*zoom);
    scene.translate(-meshSize*aspect/2, -meshSize/2);   
        
    // Draw the mesh as a set of Triangle Strips
    for (int y = 0; y < rows-1; y++) {
      scene.beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < cols; x++) {
        int yLookup = (int)(1.0*y/(rows-1)*model.getMap().getHeight());
        int xLookup = (int)(1.0*x/(cols)*model.getMap().getWidth());
        int yp1Lookup = (int)(1.0*(y+1)/(rows-1)*model.getMap().getHeight());
        
        // Draw the plane and raise each point in the z direction based on the height
        if (xLookup < model.getMap().getWidth() && yLookup < model.getMap().getHeight() && yp1Lookup < model.getMap().getHeight()) {
          scene.fill(model.getMap().getColor(xLookup, yLookup));
          scene.vertex(x*scl*aspect, y*scl, model.getMap().getElevation(xLookup, yLookup)*255/3);
          scene.fill(model.getMap().getColor(xLookup, yp1Lookup));
          scene.vertex(x*scl*aspect, (y+1)*scl, model.getMap().getElevation(xLookup, yp1Lookup)*255/3);
        }
      }
      scene.endShape();
    }
    
    
    // Example line and sphere drawing
    /*scene.strokeWeight(10);
    scene.stroke(255,0,0);
    drawLineOnMap(scene, 0, 0, 0.5, 0.5);
    drawLineOnMap(scene, 0.5, 0.5, 0.25, 0.75);
    drawLineOnMap(scene, 0.25, 0.75, 0.55, 0.80);
    scene.strokeWeight(1);
    scene.noStroke();
    scene.fill(0,0,255);
    drawSphereOnMap(scene, 0.25, 0.75, 10);
    scene.fill(0,255,0);
    drawBoxOnMap(scene, 0.5, 0.5, 10); */
    
    // End drawing the texture
    scene.endDraw();
    
    // Draw the scene texture.
    pushMatrix();
    translate(x, y);
    image(scene, 0, 0);
    popMatrix();
  }

  // Draws a line above the mesh using the height.
  void drawLineOnMap(PGraphics scene, float normX1, float normY1, float normX2, float normY2) {
    int w = model.getMap().getWidth();
    int h = model.getMap().getHeight();
    int x1 = (int)(normX1*w);
    int y1 = (int)(normY1*h);
    int x2 = (int)(normX2*w);
    int y2 = (int)(normY2*h);
    int z1 = (int)(model.getMap().getElevation(x1, y1)*255/3) + 5;
    int z2 = (int)(model.getMap().getElevation(x2, y2)*255/3) + 5;
    scene.line(normX1*meshSize*aspect, normY1*meshSize, z1, normX2*meshSize*aspect, normY2*meshSize, z2);
  }
  
  // Draws a sphere above the mesh using the height.
  void drawSphereOnMap(PGraphics scene, float normX, float normY, int size) {
    scene.pushMatrix();
    translateShapeOnMap(scene, normX, normY, size);
    scene.sphere(size);
    scene.popMatrix();
  }
  
  // Draws a box above the mesh using the height.
  void drawBoxOnMap(PGraphics scene, float normX, float normY, int size) {
    scene.pushMatrix();
    translateShapeOnMap(scene, normX, normY, size);
    scene.box(size);
    scene.popMatrix();
  }
  
  // Translates a shape above the mesh using the height.
  void translateShapeOnMap(PGraphics scene, float normX, float normY, int size) {
    int w = model.getMap().getWidth();
    int h = model.getMap().getHeight();
    int x = (int)(normX*w);
    int y = (int)(normY*h);
    int z = (int)(model.getMap().getElevation(x, y)*255/3) + 5+size/2;
    scene.translate(normX*meshSize*aspect, normY*meshSize, z);
  }
  
  // Sets the scene horizontal rotation
  void setRotation(float rot) {
    rotation = rot;
  }
  
  // Gets the zoom level
  public float getZoom() {
    return zoom;
  }
  
  // Sets the zoom level
  void setZoom(float zoom) {
    this.zoom = zoom;
  }
};

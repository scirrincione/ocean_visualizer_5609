// ---------------------------------------------------------
// In this application, the controller can update the model,
// query the view, and modify view display parameters
// ---------------------------------------------------------

public class Controller {
  // The model and view references
  private MapModel model;
  private MapView mapView;
  private Spatial3DView spatialView;
  private ElevationPathView elevationPathView;
  private HistogramView histogramView;
  
  // Pass in the model and view for use
  Controller(MapModel model, MapView mapView, Spatial3DView spatialView, ElevationPathView elevationPathView, HistogramView histogramView) {
    this.model = model;
    this.mapView = mapView;
    this.spatialView = spatialView;
    this.elevationPathView = elevationPathView;
    this.histogramView = histogramView;
  }
  
  // Controls the update loop of the simulation
  public void update(float dt) {
    spatialView.setRotation(frameCount/1000.0);
  }
  
  public void mousePressed() {
    if (mapView.isInside(mouseX, mouseY) && (mouseButton == LEFT || mouseButton == CENTER || mouseButton == RIGHT)) {
      mapView.panZoomPage.mousePressed();
      elevationPathView.mousePressed();
    }
  }
  
  public void mouseReleased() {
  }
  
  public void mouseDragged() {   
    if (mapView.isInside(mouseX, mouseY) && (mouseButton == CENTER || mouseButton == RIGHT)) {
      mapView.panZoomPage.mouseDragged();
    }
  }
  
  public void mouseMoved() {
    if (mapView.isInside(mouseX, mouseY)) {
      cursor(CROSS);
    }
    else {
      cursor(ARROW);
    }
  }
  
  public void mouseWheel(MouseEvent event) {
    if (mapView.isInside(mouseX, mouseY)) {
      mapView.panZoomPage.mouseWheel(event);
    }
    
    if (spatialView.isInside(mouseX, mouseY)) {
      spatialView.setZoom(spatialView.getZoom() + event.getCount()*0.1);
    }
  }
}

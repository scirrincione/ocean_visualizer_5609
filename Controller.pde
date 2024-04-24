// ---------------------------------------------------------
// In this application, the controller can update the model,
// query the view, and modify view display parameters
// ---------------------------------------------------------

public class Controller {
  // The model and view references
  private MapModel model;
  private MapView mapView;
  private ElevationPathView elevationPathView;
  private HistogramView histogramView;
  
  // Pass in the model and view for use
  Controller(MapModel model, MapView mapView, ElevationPathView elevationPathView, HistogramView histogramView) {
    this.model = model;
    this.mapView = mapView;
    this.elevationPathView = elevationPathView;
    this.histogramView = histogramView;
  }
  
  // Controls the update loop of the simulation
  // used to update spatial 3d view but we don't need that
  public void update(float dt) {
  }
  
  public void mousePressed() {
   
  }
  
  public void mouseReleased() {
  }
  
  public void mouseDragged() {   
   
  }
  
  public void mouseMoved() {
    
  }
  
  public void mouseWheel(MouseEvent event) {
    
    
  }
}

// ---------------------------------------------------------
// The application contains a model, a view, and a controller.
//
// - The model is a particle simulation that is independent of
//   graphics and user interaction. (notice that the model does 
//   not know about the view or the controller).
//
// - The view simply draws the model
//
// - The controller is the heart of this specific application.
//   It is the glue that ties the model and the view together.
// ---------------------------------------------------------
public class Application {
  
  // The model
  private MapModel model;
  
  // The views
  private MapView mapView; // need to change to go across screen instead of just top left
  private ElevationPathView elevationPathView; // need to change to year graph in proposal
  private HistogramView histogramView; // need to change to comparison graph in proposal
  int starYear = 1970;
  int endYear = 2020;
  //Import data 
  Table OSD;

  //Making some dummy data just to get started on the views,
  Table DummyData;
  
  //table that shows which columns are being represented
  
  Table currColumns;
  
  // The Controller
  private Controller controller;
  
  public Application() {
    OSD = loadTable("data/parsed_OSDmaster_v2.csv", "header");
    
    //currColumns is a data table with information about the different variables.
    //When a data variable is selected included is turned from 0 to 1 so that other
    //elements of the code know that this variable should now be displayed
    //color is supposed to be the index in the color list it's kind of funky since
    //some of the variables don't have colors so subtract 4 for any of the variables
    currColumns = new Table();
    currColumns.addColumn("var");
    currColumns.addColumn("included");
    currColumns.addColumn("color");
    currColumns.addColumn("min");
    currColumns.addColumn("max");
    
    
    
    for(int i = 0; i < OSD.getColumnCount(); i++){
      TableRow newRow = currColumns.addRow();
      newRow.setString("var", OSD.getColumnTitle(i));
      newRow.setInt("included", 0);
      newRow.setFloat("min", OSD.getFloat(i, OSD.getColumnTitle(i)));
      newRow.setFloat("max", OSD.getFloat(i, OSD.getColumnTitle(i)));
      newRow.setInt("color", i);
    }
    
    //get the maxes and mins for any graph displays
    for(int i = 0; i < OSD.getRowCount(); i++){
      for(int j = 0; j < OSD.getColumnCount(); j++){
        float currVal = OSD.getFloat(i, j);
        float currMin = currColumns.getFloat(j, "min");
        float currMax = currColumns.getFloat(j, "max");
        if(currVal < currMin){
          currColumns.setFloat(j, "min", currVal);
        }
        if(currVal > currMax){
          currColumns.setFloat(j, "max", currVal);
        }

      }
    }
    
    //set up the color list
    color[] colors = {color(252,186,3), color(3,44,252), color(252,152,3), color(3,252,44)};
    // Create the model and set the height map we are interested in working with
    model = new MapModel("earth-2k.png", OSD, currColumns, colors);
    
    // Create the views
    mapView = new MapView(model,0,0, width-1,(int)(0.65*height));
    elevationPathView = new ElevationPathView(model, 0,(int)(0.65*height)+2, (int)(width*0.65),(int)(0.35*height)-2);
    histogramView = new HistogramView(model, (int)(width*0.65+3),(int)(0.65*height)+2, (int)(width*0.35-3),(int)(0.35*height)-2);
    
    // Create the controller that updates the model and queries the views
    controller = new Controller(model, mapView, elevationPathView, histogramView);
  }
  
  // This method is part of the update loop.
  public void update(float dt) {
    controller.update(dt);
  }
  
  // This method draws the views
  public void draw() {
    background(100, 100, 100);
    ellipseMode(RADIUS);
    mapView.draw();
    elevationPathView.draw();
    histogramView.draw();
  }
  
  // Getter for the controller for handling events
  public Controller getController() {
    return controller;
  }  
};

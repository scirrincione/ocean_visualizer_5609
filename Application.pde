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

    OSD = loadTable("data/OSDmaster.csv", "header");
    
    //starts at row 22 it seems 
    for (int i = 22; i < OSD.getRowCount(); i++) {
      
    
    }

    currColumns = new Table();
    currColumns.addColumn("var");
    currColumns.addColumn("included");
    currColumns.addColumn("color");
    
    // start dummy data creation
    DummyData = new Table();
    DummyData.addColumn("year");
    DummyData.addColumn("lat");
    DummyData.addColumn("long");
    DummyData.addColumn("plankton");
    DummyData.addColumn("oxygen");
    DummyData.addColumn("ph");
    DummyData.addColumn("temp");
    for(int i = 0; i < 50; i++){
      DummyData.addRow();
      DummyData.setInt(i,"year", 1950+i);
      DummyData.setFloat(i,"lat", 36);
      DummyData.setFloat(i,"long", -96);
      DummyData.setFloat(i,"plankton", i);
      DummyData.setFloat(i,"oxygen", i);
      DummyData.setFloat(i,"ph", i);
      DummyData.setFloat(i,"temp", i);
    }
    //end dummy data creation (this can all be safely deleted later
   
    for(int i = 0; i < DummyData.getColumnCount(); i++){
      TableRow newRow = currColumns.addRow();
      newRow.setString("var", DummyData.getColumnTitle(i));
      newRow.setInt("included", 0);
      newRow.setInt("color", i*20);
    }
    // Create the model and set the height map we are interested in working with
    model = new MapModel("earth-2k.png", DummyData, currColumns);
    
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

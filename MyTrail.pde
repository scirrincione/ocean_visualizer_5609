// Create an application
Application application = null;
int time = 0;

int starYear = 1970;
int endYear = 2020;

//Import data 
Table OSD = loadTable("data/OSDmaster.csv", "header");


// Create the application and intialize the time
void setup() {
  size(1600,800,P3D);
  application = new Application();
  time = millis();
  
  //starts at row 22 it seems 
  for (int i = 22; i < OSD.getRowCount(); i++) {
    
  
  }

}

// Render the graphics application
void draw() {
  // Calculate time elapsed since last draw call
  int oldTime = time;
  time = millis();
  float dt = 1.0*(time-oldTime)/1000.0;
  
  // Update the application based on time elapsed
  application.update(dt);
  
  // Render the application
  application.draw();
}

// ---------------------------------------------------------
// Events are handled by the application's controller code:
// ---------------------------------------------------------

// Call the controller's event method
void mousePressed() {
  application.getController().mousePressed();
}

// Call the controller's event method
void mouseReleased() {
  application.getController().mouseReleased();
}

// Call the controller's event method
void mouseDragged() {
  application.getController().mouseDragged();
}

// Call the controller's event method
public void mouseMoved() {
  application.getController().mouseMoved();
}

// Call the controller's event method
void mouseWheel(MouseEvent event) {
  application.getController().mouseWheel(event);
}

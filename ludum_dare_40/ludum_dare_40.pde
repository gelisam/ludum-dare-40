final int WINDOW_WIDTH = 640;
final int WINDOW_HEIGHT = 640;
final int GRID_WIDTH = 100;
final int GRID_HEIGHT = 100;
final int CLASS_WIDTH = 60;
final int CLASS_HEIGHT = 60;
final int CLASS_DX = (GRID_WIDTH - CLASS_WIDTH) / 2;
final int CLASS_DY = (GRID_HEIGHT - CLASS_HEIGHT) / 2;

// connector types
final int NO_CONNECTOR = 0;
final int WHITE_ARROW_CONNECTOR = 1; // inheritance
final int BLACK_DIAMOND_CONNECTOR = 2; // composition
final int WHITE_DIAMOND_CONNECTOR = 3; // aggregation


void setup() {
  size(640, 640);

  stroke(0);
  textAlign(CENTER);
}

void draw_grid(int w, int h) {
  stroke(128);
  for (int i=0; i<=w; ++i) {
    line(i*GRID_WIDTH, 0, i*GRID_WIDTH, h*GRID_HEIGHT);
  }
  for (int j=0; j<=h; ++j) {
    line(0, j*GRID_HEIGHT, w*GRID_WIDTH, j*GRID_HEIGHT);
  }
}


void draw_box(String name, int i, int j) {
  stroke(0);

  fill(255);
  rect(i*GRID_WIDTH+CLASS_DX, j*GRID_HEIGHT+CLASS_DY, CLASS_WIDTH, CLASS_HEIGHT-1);
  line(i*GRID_WIDTH+CLASS_DX, j*GRID_HEIGHT+CLASS_DY+20, i*GRID_WIDTH+CLASS_DX+CLASS_WIDTH, j*GRID_HEIGHT+CLASS_DY+20);

  fill(0);
  text(name, i*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, j*GRID_HEIGHT+CLASS_DY+15);
}

void draw_connector(int connector_type, int i1, int j1, int i2, int j2) {
  stroke(0);
  if (connector_type == NO_CONNECTOR) {
    line(i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT, i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10);
  } else if (connector_type == WHITE_ARROW_CONNECTOR) {
    fill(255);
    quad(i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT, i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2-5, j1*GRID_HEIGHT+CLASS_DY+70, i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10, i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2+5, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10);
  } else {
    fill((connector_type == BLACK_DIAMOND_CONNECTOR) ? 0 : 255);
    quad(i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT, i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2-5, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+5, i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10, i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2+5, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+5);
  }

  line(i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10, i2*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, j2*GRID_HEIGHT+CLASS_DY);
}

void draw() {
  // UPDATE


  // DRAW

  int w = 4;
  int h = 3;
  background(215);
  pushMatrix();
  translate((WINDOW_WIDTH-w*GRID_WIDTH)/2, (WINDOW_HEIGHT-h*GRID_HEIGHT)/2); // center

  draw_grid(w, h);

  draw_box("Widget", 0, 0);
  draw_box("Person", 0, 1);
  draw_connector(NO_CONNECTOR, 0, 0, 0, 1);

  draw_box("Bank", 1, 0);
  draw_box("Account", 1, 1);
  draw_connector(WHITE_ARROW_CONNECTOR, 1, 0, 1, 1);

  draw_box("Circle", 2, 0);
  draw_box("Rectangle", 2, 1);
  draw_connector(BLACK_DIAMOND_CONNECTOR, 2, 0, 2, 1);

  draw_box("Shape", 3, 0);
  draw_box("Entity", 3, 1);
  draw_connector(WHITE_DIAMOND_CONNECTOR, 3, 0, 3, 1);

  popMatrix();


  // DEBUG
}
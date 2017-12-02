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
  for (int x=0; x<=w; ++x) {
    line(x*GRID_WIDTH, 0, x*GRID_WIDTH, h*GRID_HEIGHT);
  }
  for (int y=0; y<=h; ++y) {
    line(0, y*GRID_HEIGHT, w*GRID_WIDTH, y*GRID_HEIGHT);
  }
}


void draw_box(String name, int x, int y) {
  stroke(0);

  fill(255);
  rect(x*GRID_WIDTH+CLASS_DX, y*GRID_HEIGHT+CLASS_DY, CLASS_WIDTH, CLASS_HEIGHT-1);
  line(x*GRID_WIDTH+CLASS_DX, y*GRID_HEIGHT+CLASS_DY+20, x*GRID_WIDTH+CLASS_DX+CLASS_WIDTH, y*GRID_HEIGHT+CLASS_DY+20);

  fill(0);
  text(name, x*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, y*GRID_HEIGHT+CLASS_DY+15);
}

void draw_connector(int connector_type, int x1, int y1, int x2, int y2) {
  stroke(0);
  if (connector_type == NO_CONNECTOR) {
    line(x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT, x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10);
  } else if (connector_type == WHITE_ARROW_CONNECTOR) {
    fill(255);
    quad(x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT, x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2-5, y1*GRID_HEIGHT+CLASS_DY+70, x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10, x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2+5, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10);
  } else {
    fill((connector_type == BLACK_DIAMOND_CONNECTOR) ? 0 : 255);
    quad(x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT, x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2-5, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+5, x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10, x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2+5, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+5);
  }

  line(x1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, y1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT+10, x2*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2, y2*GRID_HEIGHT+CLASS_DY);
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
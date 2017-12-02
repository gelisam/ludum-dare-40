final int WINDOW_WIDTH = 640;
final int WINDOW_HEIGHT = 640;

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
    line(x*100, 0, x*100, h*100);
  }
  for (int y=0; y<=h; ++y) {
    line(0, y*100, w*100, y*100);
  }
}


void draw_box(String name, int x, int y) {
  fill(255);
  rect(x*100, y*100, 60, 59);
  line(x*100, y*100+20, x*100+60, y*100+20);

  fill(0);
  text(name, x*100+30, y*100+15);
}

void draw_connector(int connector_type, int x1, int y1, int x2, int y2) {
  if (connector_type == NO_CONNECTOR) {
    line(x1*100+30, y1*100+60, x1*100+30, x1*100+70);
  } else if (connector_type == WHITE_ARROW_CONNECTOR) {
    fill(255);
    quad(x1*100+30, y1*100+60, x1*100+25, y1*100+70, x1*100+30, y1*100+70, x1*100+35, y1*100+70);
  } else {
    fill((connector_type == BLACK_DIAMOND_CONNECTOR) ? 0 : 255);
    quad(x1*100+30, y1*100+60, x1*100+25, y1*100+65, x1*100+30, y1*100+70, x1*100+35, y1*100+65);
  }

  line(x1*100+30, y1*100+70, x2*100+30, y2*100);
}

void draw() {
  // UPDATE


  // DRAW

  int w = 4;
  int h = 3;
  background(215);
  pushMatrix();
  translate((WINDOW_WIDTH-w*100)/2, (WINDOW_HEIGHT-h*100)/2); // center

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
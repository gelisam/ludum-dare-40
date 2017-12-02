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

  background(215);

  draw_box("Widget", 1, 1);
  draw_box("Person", 1, 2);
  draw_connector(NO_CONNECTOR, 1, 1, 1, 2);

  draw_box("Bank", 2, 1);
  draw_box("Account", 2, 2);
  draw_connector(WHITE_ARROW_CONNECTOR, 2, 1, 2, 2);

  draw_box("Circle", 3, 1);
  draw_box("Rectangle", 3, 2);
  draw_connector(BLACK_DIAMOND_CONNECTOR, 3, 1, 3, 2);

  draw_box("Shape", 4, 1);
  draw_box("Entity", 4, 2);
  draw_connector(WHITE_DIAMOND_CONNECTOR, 4, 1, 4, 2);


  // DEBUG
}
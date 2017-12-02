final int WINDOW_WIDTH = 640;
final int WINDOW_HEIGHT = 640;

void setup() {
  size(640, 640);

  stroke(0);
  textAlign(CENTER);
}

void draw_box(String name, int x, int y) {
  fill(255);
  rect(x, y, 60, 60);
  line(x, y+20, x+60, y+20);

  fill(0);
  text(name, x+30, y+15);
}

void draw() {
  // UPDATE


  // DRAW

  background(255);

  draw_box("Widget", 100, 50);


  // DEBUG
}
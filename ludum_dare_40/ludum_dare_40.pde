final int WINDOW_WIDTH = 640;
final int WINDOW_HEIGHT = 640;

void setup() {
  size(640, 640);

  stroke(0);
  textAlign(CENTER);
}

void draw_box(String name, int x, int y) {
  fill(255);
  rect(x*100, y*100, 60, 60);
  line(x*100, y*100+20, x*100+60, y*100+20);

  fill(0);
  text(name, x*100+30, y*100+15);
}

void draw() {
  // UPDATE


  // DRAW

  background(255);

  draw_box("Widget", 3, 1);
  draw_box("Person", 3, 2);
  draw_box("Bank", 4, 2);


  // DEBUG
}
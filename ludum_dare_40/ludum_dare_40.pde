final int WINDOW_WIDTH = 640;
final int WINDOW_HEIGHT = 640;

PVector[] points = new PVector[100];
int next_point_index;

void setup() {
  size(640, 640);
}

void draw() {
  for (int i=1; i<next_point_index; ++i) {
    line(points[i-1].x, points[i-1].y, points[i].x, points[i].y);
  }
}

void mouseDragged() {
  if (next_point_index < points.length) {
    points[next_point_index] = new PVector(mouseX, mouseY);
    ++next_point_index;
  }
}
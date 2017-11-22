final int WINDOW_WIDTH = 640;
final int WINDOW_HEIGHT = 640;

final int MAX_POINTS = 100;
PVector[] points = new PVector[MAX_POINTS];
float[] strength = new float[MAX_POINTS];
int next_point_index;

void setup() {
  size(640, 640);
  for (int i=0; i<MAX_POINTS; ++ i) {
    points[i] = new PVector();
    strength[i] = 0;
  }
}

void draw() {
  background(212);
  for (int i=1; i<MAX_POINTS; ++i) {
    stroke(0, 0, 0, min(strength[i-1], strength[i]));
    line(points[i-1].x, points[i-1].y, points[i].x, points[i].y);
  }
}

void mouseDragged() {
  if (next_point_index < MAX_POINTS) {
    points[next_point_index] = new PVector(mouseX, mouseY);
    strength[next_point_index] = 255;
    next_point_index = (next_point_index + 1) % MAX_POINTS;
  }
}
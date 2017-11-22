final int WINDOW_WIDTH = 640;
final int WINDOW_HEIGHT = 640;

final int MAX_POINTS = 100;
PVector[] points = new PVector[MAX_POINTS];
float[] strengths = new float[MAX_POINTS];
int next_point_index;

void setup() {
  size(640, 640);
  for (int i=0; i<MAX_POINTS; ++ i) {
    points[i] = new PVector();
    strengths[i] = 0;
  }
}

void draw() {
  background(212);

  PVector prev_point = points[MAX_POINTS-1];
  float prev_strength = strengths[MAX_POINTS-1];
  for (int i=0; i<MAX_POINTS; ++i) {
    PVector point = points[i];
    float strength = strengths[i];

    stroke(0, 0, 0, min(prev_strength, strength));
    line(prev_point.x, prev_point.y, point.x, point.y);

    prev_point = point;
    prev_strength = strength;
  }
}

void mouseDragged() {
  if (next_point_index < MAX_POINTS) {
    points[next_point_index] = new PVector(mouseX, mouseY);
    strengths[next_point_index] = 255;
    next_point_index = (next_point_index + 1) % MAX_POINTS;
    strengths[next_point_index] = 0;
  }
}
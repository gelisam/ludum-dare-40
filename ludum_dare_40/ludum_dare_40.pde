final int WINDOW_WIDTH = 640;
final int WINDOW_HEIGHT = 640;
final float PARTICLE_RADIUS = 5.0f;
final int PARTICLE_COUNT = 100;

final int MAX_POINTS = 100;
PVector[] points = new PVector[MAX_POINTS];
float[] strengths = new float[MAX_POINTS];
int next_point_index;

class Particle
{
  PVector pos;
  PVector vel;
  float radius;
  Particle()
  {
    pos = new PVector();
    vel = new PVector();
    pos.x = pos.y = 0;
    vel.x = vel.y = 0;
    radius = PARTICLE_RADIUS;
  }
  void Reset()
  {
    pos.x = (random(WINDOW_WIDTH));
    pos.y = 0;
    vel.x = 0;
    vel.y = 0;
  }
  void Update()
  {
    pos.x += vel.x;
    pos.y += vel.y;
    vel.y += 0.1f;
    if( Finished() )
      Reset();
  }
  void Draw()
  {
    fill(255,0,0);
    ellipse( pos.x, pos.y, radius, radius );
  }
  void SetPosY( float y )
  {
    pos.y = y;
  }
  void SetPosX( float x )
  {
    pos.x = x;
  }
  boolean Finished()
  {
    return (pos.y > WINDOW_HEIGHT);
  }
}

Particle[] particles;


void setup() {
  size(640, 640);
  for (int i=0; i<MAX_POINTS; ++ i) {
    points[i] = new PVector();
    strengths[i] = 0;
  }
  
  // Particles
  particles = new Particle[PARTICLE_COUNT];
  for( int i=0; i<PARTICLE_COUNT; i++ )
  {
    particles[i] = new Particle();
    particles[i].Reset();
    particles[i].SetPosY( -2.0f * (random(WINDOW_HEIGHT)) );
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
  
  for( int i=0; i<PARTICLE_COUNT; i++ )
  {
    particles[i].Update();
    particles[i].Draw();
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
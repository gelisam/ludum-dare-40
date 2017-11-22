final int WINDOW_WIDTH = 640;
final int WINDOW_HEIGHT = 640;
final float PARTICLE_RADIUS = 5.0f;
final int PARTICLE_COUNT = 100;

final float FADE_TIME = 1.0; // seconds

final int MAX_POINTS = 100;

PVector[] points = new PVector[MAX_POINTS];
float[] strengths = new float[MAX_POINTS];
int next_point_index;

// Debugging
final int indicatorCount = 4;
PVector[] indicator = new PVector[indicatorCount];
int indicatorIndex = 0;

float WhichSide( PVector p, PVector s1, PVector s2 )
{
  PVector ssVec = new PVector( s2.x-s1.x, s2.y-s1.y );
  PVector spVec = new PVector( p.x-s1.x, p.y-s1.y );
  PVector crossVec = ssVec.cross(spVec);
  return crossVec.z;
}

boolean IsCross( PVector p1, PVector p2, PVector s1, PVector s2 )
{
  float w1 = WhichSide( p1, s1, s2 );
  float w2 = WhichSide( p2, s1, s2 );
  return ((w1*w2)<0);
}

boolean IsCollide( PVector p1, PVector p2, PVector s1, PVector s2 )
{
  return IsCross( p1, p2, s1, s2 ) && IsCross( s1, s2, p1, p2 );
}

int particleFillVUp = 0xFFFFFF00;
int particleFillVDn = 0xFFFF0000;

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
  void Collide( PVector s1, PVector s2 )
  {
    PVector posNext = new PVector(pos.x+vel.x, pos.y+vel.y);
    if( IsCollide( pos, posNext, s1, s2 ) )
    {
      vel.y = -vel.y;
    }
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
    if( vel.y>0 )
    {
      stroke(particleFillVUp);
      fill(particleFillVUp);
    }
    else
    {
      stroke(particleFillVDn);
      fill(particleFillVDn);
    }
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
  
  for( int i=0; i<indicatorCount; i++ )
  {
    indicator[i] = new PVector(0,0);
  }
}

void draw() {
  background(212);

  // UPDATE

  float dt = 1.0/60; // assuming 60fps

  // make the line fade over time
  for (int i=0; i<MAX_POINTS; ++i) {
    strengths[i] -= lerp(0.0, 255.0, dt / FADE_TIME);
  }


  // DRAW

  PVector prev_point = points[MAX_POINTS-1];
  float prev_strength = strengths[MAX_POINTS-1];
  for (int i=0; i<MAX_POINTS; ++i) {
    PVector point = points[i];
    float strength = strengths[i];

    stroke(0, 0, 0, min(prev_strength, strength));
    line(prev_point.x, prev_point.y, point.x, point.y);

    if( strength>0 )
    {
      for( int j=0; j<PARTICLE_COUNT; j++ )
      {
          particles[j].Collide( prev_point, point );
      }
    }

    prev_point = point;
    prev_strength = strength;
  }
  
  for( int i=0; i<PARTICLE_COUNT; i++ )
  {
    particles[i].Update();
    particles[i].Draw();
  } 
  
  //float w = WhichSide( indicator[0], indicator[2], indicator[3] );
  //for( int i=0; i<indicatorCount; i++ )
  //{
  //  fill( 0, i*64, 255-(i*64) );
  //  if( IsCollide(indicator[0],indicator[1],indicator[2],indicator[3]) ) stroke( 255,0,0 );
  //  else stroke( 255,255,0 );
  //  ellipse( indicator[i].x, indicator[i].y, 20, 20 );
  //}
}

void mousePressed()
{
  indicator[ indicatorIndex ].x = mouseX;
  indicator[ indicatorIndex ].y = mouseY;
  indicatorIndex = (indicatorIndex+1) % 4;
}

void mouseDragged() {
  if (next_point_index < MAX_POINTS) {
    points[next_point_index] = new PVector(mouseX, mouseY);
    strengths[next_point_index] = 255;
    next_point_index = (next_point_index + 1) % MAX_POINTS;
    strengths[next_point_index] = 0;
  }
}
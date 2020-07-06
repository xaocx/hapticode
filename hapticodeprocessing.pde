import processing.serial.*;
Serial myPort;  
float val;  
int v ; 
// dynamic list with our points, PVector holds position
ArrayList<PVector> points = new ArrayList<PVector>();

// placeholder for vector field calculations

// colors used for points
color[] pal = {
  color(0, 91, 197), 
  color(0, 180, 252), 
  color(23, 249, 255), 
  color(223, 147, 0), 
  color(248, 190, 0)
};

// global configuration
float vector_scale = 0.01; // vector scaling factor, we want small steps
float time = 0; // time passes by

import com.leapmotion.leap.*;
PImage cono;
int br2;

color canvasColor = 0xffffff;
float alphaVal = 10;

Controller leap = new Controller();
int x1;



void setup() {
  frameRate(120);
  size(800, 800);
  strokeWeight(0.66);
  background(0);
  noFill();
  smooth(8);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);

  // noiseSeed(1111); // sometimes we select one noise field

  // create points from [-3,3] range
  for (float x=-3; x<=3; x+=0.07) {
    for (float y=-3; y<=3; y+=0.07) {
      // create point slightly distorted
      PVector v = new PVector(x+randomGaussian()*0.003, y+randomGaussian()*0.003);
      points.add(v);
    }
  }
}

void draw() {

  Frame frame = leap.frame();
  Pointable pointer = frame.pointables().frontmost();
  if ( pointer.isValid() ) {

    color frontColor = color( 255, 0, 0, alphaVal );

    InteractionBox iBox = frame.interactionBox();
    Vector tip = iBox.normalizePoint(pointer.tipPosition());
    fingerPaint(tip, frontColor);
  }




  int point_idx = 0; // point index
  for (PVector p : points) {
    // map floating point coordinates to screen coordinates
    float xx = map(p.x, -6.5, 6.5, 0, width);
    float yy = map(p.y, -6.5, 6.5, 0, height);

    // select color from palette (index based on noise)
    int cn = (int)(100*pal.length*noise(point_idx))%pal.length;
    stroke(pal[cn], 15);
    point(xx, yy); //draw


    ////ESTÁTICO
    //PVector v = new PVector(0, 0);

    ////Movimiento
    //PVector v = new PVector(0.1, 0.1);

    // placeholder for vector field calculations
    float n = TWO_PI * noise(p.x, p.y);
    PVector v = new PVector(cos(n), sin(n));

    p.x += vector_scale * v.x;
    p.y += vector_scale * v.y;

    // go to the next point
    point_idx++;
  }
  time += 0.001;
}

void fingerPaint(Vector tip, color paintColor) {
  fill(paintColor);
  float x = tip.getX() * width;
  float y = height - tip.getY() * height;
  ellipse( x, y, 10, 10); 

  int x1 = int(x); 
  int y1 = int(y); 
  float b =   brightness(get(x1, y1));

float bx = constrain(b,0,100);
  val=map(bx, 0, 100, 0, 255);
  v = int(val); 
  myPort.write(v);
  
    println(b + "serial" +  v);
}

void keyPressed()
{
  background(canvasColor);
}

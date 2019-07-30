import processing.video.*;
import codeanticode.syphon.*;

OPC opc;
SyphonClient client;

PGraphics canvas;

float spin = 0.001;
float radiansPerBucket = radians(2);
float decay = 0.97;
float opacity = 50;
float minSize = 0.1;
float sizeScale = 0.6;
PImage colors;

int posX=51, posY;
int speedX = 20;
int speedY  = 5;
int c = 0;
float spacing;
int offset;

void setup() {
  size(480, 400, P3D);
  frameRate(30);
  colors = loadImage("colors.png");
  setupMateMatrix();

  println("Available Syphon servers:");
  println(SyphonClient.listServers());

  client = new SyphonClient(this);

  colorMode(HSB);
  background(0);
}

void setupMateMatrix() {
  opc = new OPC(this, "127.0.0.1", 7890);
}

void mousePressed() {
  opc.setStatusLed(true);
  background(0);
}

void mouseReleased() {
  opc.setStatusLed(false);
}

void draw() {
  if (client.newFrame()) {
    background(0);
    canvas = client.getGraphics(canvas);
    image(canvas, 0, 0, width, height);
  }
}

void stop() {
  background(0);
  super.stop();
}

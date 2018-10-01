import org.openkinect.processing.*;

Kinect kinect;

OPC opc;
MateMatrix mm;

PShader shader;
PGraphics pg;
float minThresh = 30;
float maxThresh = 840;
PImage img;
float t = 0;
int nbCratesX = 6;
int nbCratesY = 5;

int kinectFill = -1;

void settings() {
  int w = nbCratesX * mm.CRATE_W * mm.SPACING;
  int h = nbCratesY * mm.CRATE_H * mm.SPACING;
  size(w, h, P3D);
}

void setup() {
  kinect = new Kinect(this);
  frameRate(400);

  kinect.initDepth();
  kinect.enableMirror(true);

  img = createImage(kinect.width, kinect.height, RGB);

  shader = loadShader("sinewave2.glsl");
  pg = createGraphics(width, height, P3D);

  opc = new OPC(this, "127.0.0.1", 7890);
  //opc.setDithering(false);
  //opc.setInterpolation(false);  
  // Set up your LED mapping here
  mm = new MateMatrix(this, opc, 6, 5);
  mm.init();
}

void draw() {
  background(0);
  surface.setTitle(frameRate + "fps");

  img.loadPixels();

  //minThresh = map(mouseX, 0, width, 0, 2048);
  //maxThresh = map(mouseY, 0, height, 0, 2048);

  int[] depth = kinect.getRawDepth();

  for (int x = 0; x < kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int offset = x + y * kinect.width;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh) {
        img.pixels[offset] = -1;
      } else {
        img.pixels[offset] = 1;
      }
    }
  }

  img.updatePixels();

  // shader
  shader.set("time", (float) millis() / 100.0);
  shader.set("resolution", float(pg.width), float(pg.height));
  shader.set("freq0", abs(sin(millis()*0.01)));  

  pg.beginDraw();
  pg.shader(shader);
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();

  pg.blend(img, 0, 0, width, height, 0, 0, width, height, SUBTRACT);
  //image(img, 0, 0);
  image(pg, 0, 0);

  /*
  fill(255);
  textSize(32);
  text(minThresh + " " + maxThresh, 20, 20);
  */
}

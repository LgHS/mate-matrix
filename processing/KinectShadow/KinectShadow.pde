import org.openkinect.processing.*;

Kinect kinect;

OPC opc;
MateMatrix mm;

PShader shader;
PGraphics pg;
float minThresh = 0;
float maxThresh = 800;
PImage cam;
float t = 0;
int nbCratesX = 6;
int nbCratesY = 5;

int kinectFill = -1;

int occupation = 0;

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

  cam = createImage(kinect.width, kinect.height, RGB);

  shader = loadShader("simple.glsl");
  colorMode(HSB, 360,255,255);

  opc = new OPC(this, "127.0.0.1", 7890);
  //opc.setDithering(false);
  //opc.setInterpolation(false);  
  // Set up your LED mapping here
  mm = new MateMatrix(this, opc, 6, 5);
  mm.init();
}

PImage third;

void draw() {
  //background(130, 100);
  surface.setTitle(frameRate + "fps");
  occupation = 0;

  cam.loadPixels();

  //minThresh = map(mouseX, 0, width, 0, 2048);
  //maxThresh = map(mouseY, 0, height, 0, 2048);

  int[] depth = kinect.getRawDepth();

  for (int x = 0; x < kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int offset = x + y * kinect.width;
      int d = depth[offset];  

      if (d > minThresh && d < maxThresh) {
        cam.pixels[offset] = -1;
        occupation++;
      } else {
        cam.pixels[offset] = 0;
      }
    }
  }

  cam.updatePixels();
  
  float occupationRatio = occupation * 1.0f / (kinect.width * kinect.height);
  
  // shader
  shader.set("time", occupationRatio);
  shader.set("cam", cam.get()); 
  shader.set("res", kinect.width, kinect.height);
  //shader.set("freq0", abs(sin(millis()*0.0001)));  
  
  //pg.beginDraw();
  shader(shader);
  //fill(degrees(abs(TWO_PI * sin(frameCount * 0.0002))), 150, 255);
  rect(0, 0, kinect.width, kinect.height);
  //pg.endDraw();

  //tint(255, 127);
  //pg.blend(img, 0, 0, width, height, 0, 0, width, height, SUBTRACT);
  //image(img, 0, 0);  
  
  //image(pg, 0, 0);
  //fill(0,100);
  //rect(0,0, width, height);
  /*
  fill(255);
  textSize(32);
  text(minThresh + " " + maxThresh, 20, 20);
  */
}

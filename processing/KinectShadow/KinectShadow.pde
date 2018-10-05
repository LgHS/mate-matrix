import org.openkinect.processing.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress broadcastLocation; 

Kinect kinect;
OPC opc;
MateMatrix mm;
JSONObject config;

PShader shader;
PGraphics pg;
PImage cam;

float minThresh = 0;
float maxThresh = 800;
float occupationThreshold = 0.2f;
boolean isIdle = true;
boolean useIdle = false;

float t = 0;
int nbCratesX = 6;
int nbCratesY = 5;

int kinectFill = -1;

int occupation = 0;

void settings() {
  config = loadJSONObject("matrix_config.json");
  int cols = config.getInt("cols");
  int rows = config.getInt("rows");
  int crateW = config.getInt("crateW");
  int crateH = config.getInt("crateH");
  int spacing = config.getInt("spacing");
  int w = cols*crateW*spacing;
  int h  = rows *crateH*spacing;
  size(w,h,P3D);
}

void setup() {
  kinect = new Kinect(this);
  frameRate(400);

  kinect.initDepth();
  kinect.enableMirror(true);

  oscP5 = new OscP5(this, 10000);

  shader = loadShader("simple.glsl");
  colorMode(HSB, 360,255,255);

  cam = createImage(kinect.width, kinect.height, RGB);
  pg = createGraphics(width, height, P3D);

  opc = new OPC(this, "127.0.0.1", 7890);
  mm = new MateMatrix(this, opc, config);
  mm.init(true);
}

PImage third;

void draw() {
  surface.setTitle(frameRate + "fps");
  occupation = 0;

  cam.loadPixels();

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
  
  isIdle = useIdle && (occupationRatio < occupationThreshold);
  
  // shader
  shader.set("idle", isIdle);
  shader.set("time", millis() * 0.001);
  shader.set("occupation", occupationRatio);
  shader.set("cam", cam.get()); 
  shader.set("res", kinect.width*1.0f, kinect.height*1.0f);
  
  //shader(shader);
  //fill(204, 102, 0);
  //rect(0, 0, width, height);
  pg.beginDraw();
  pg.shader(shader);
  pg.rect(0, 0, width, height);
  pg.endDraw();
  
  image(pg, 0, 0);
}

void exit() {
  background(0);
  super.exit();
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.addrPattern().equals("/oscControl/slider1")) {
    minThresh = 2048 * theOscMessage.get(0).floatValue();
  }

  if(theOscMessage.addrPattern().equals("/oscControl/slider2")) {
    maxThresh = 2048 * theOscMessage.get(0).floatValue();;
  }

  if(theOscMessage.addrPattern().equals("/oscControl/slider3")) {
    occupationThreshold = theOscMessage.get(0).floatValue();
  }

  if(theOscMessage.addrPattern().equals("/oscControl/toggle1")) {
    useIdle = theOscMessage.get(0).floatValue() == 1.0f;
  }
}
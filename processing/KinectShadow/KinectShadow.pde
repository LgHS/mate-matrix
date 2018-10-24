import org.openkinect.processing.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress broadcastLocation; 

Kinect kinect;
OPC opc;
MateMatrix mm;
JSONObject config;

PGraphics pg;
PImage cam;

float minThresh = 0;
float maxThresh = 2048*0.46;
float occupationThreshold = 0.06f;
boolean isIdle = true;
boolean useIdle = true;

float t = 0;
int nbCratesX = 6;
int nbCratesY = 5;

int kinectFill = -1;

int occupation = 0;

boolean showButtons = true; // true;

IdleAnimation idleAnimation;
AnimationFactory animationFactory;
AnimationInterface currentAnim;

int interval = 60000;
int lastRecordedTime = 0;

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

  colorMode(HSB, 360,255,255);

  cam = createImage(kinect.width, kinect.height, RGB);
  pg = createGraphics(width, height, P3D);

  opc = new OPC(this, "127.0.0.1", 7890);
  mm = new MateMatrix(this, opc, config);
  mm.init();

  idleAnimation = new IdleAnimation();
  animationFactory = new AnimationFactory();
  currentAnim = animationFactory.getNextAnimation();
  currentAnim.beforeDraw();
}

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

  if(isIdle) {
    pg = idleAnimation.draw(pg, cam, occupationRatio);
  } else {
    if(millis() - lastRecordedTime > interval){
      //currentAnim = animationFactory.getNextAnimation();
      //interval = currentAnim.duration();
      lastRecordedTime = millis(); 
      currentAnim.beforeDraw();
    }
    pg = currentAnim.draw(pg, cam, occupationRatio);
  }
  
  image(pg, 0, 0);

  if(showButtons) {
    drawButtons();
  }
}

void drawButtons() {
  int nbButtons = 3;
  int buttonSize = 120;
  
  for(int i = 0; i < nbButtons; i++) {
    int yPosition = height / nbButtons * i + height / (nbButtons * 2);
    fill(0, 0, 255, 200);
    noStroke();
    ellipse(20 + buttonSize / 2, yPosition, buttonSize, buttonSize);
    ellipse(width - 20 - buttonSize / 2, yPosition, buttonSize, buttonSize);
  }
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
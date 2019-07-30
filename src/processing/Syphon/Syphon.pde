import processing.video.*;
import codeanticode.syphon.*;

MateMatrix mm;
JSONObject config;
OPC opc;
SyphonClient client;

PGraphics canvas;

void settings() {
  config = loadJSONObject("matrix_config.json");
  int cols = config.getInt("cols");
  int rows = config.getInt("rows");
  int crateW = config.getInt("crateW");
  int crateH = config.getInt("crateH");
  int spacing = config.getInt("spacing");
  int w = cols*crateW*spacing;
  int h  = rows *crateH*spacing;
  size(w, h, P3D);
}

void setup() {
  frameRate(60);
  setupMateMatrix();

  client = new SyphonClient(this);

  colorMode(HSB);
  background(255, 0, 0);
}

void setupMateMatrix() {
  opc = new OPC(this, "127.0.0.1", 7890);

  mm = new MateMatrix(this, opc, config);
  mm.init();
}

void draw() {
  /*
  background(255);
  fill(0);
  rect(mouseX-150, mouseY-50, 300, 100);
  */
  try {
    background(0);
    canvas = client.getGraphics(canvas);
    image(canvas, 0, 0, width, height);
    } catch(Exception e) {

    }
}

void stop() {
  background(0);
  super.stop();
}

void mousePressed() {
}

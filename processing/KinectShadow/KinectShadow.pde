import org.openkinect.processing.*;

Kinect kinect;

PImage img;

int numCols = 28;
int numRows = 25;

float minThresh = 0;
float maxThresh = 800;

void setup() {
  size(640, 480);
  kinect = new Kinect(this);

  kinect.initDepth();

  img = createImage(kinect.width, kinect.height, RGB);
}

void draw() {
  background(0);

  img.loadPixels();
  
  //minThresh = map(mouseX, 0, width, 0, 2048);
  //maxThresh = map(mouseY, 0,height, 0, 2048);

  int[] depth = kinect.getRawDepth();

  for (int x = 0; x < kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int offset = x + y * kinect.width;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh) {
        img.pixels[offset] = color(255, 0, 150);
      } else {
        img.pixels[offset] = color(0);
      }
    }
  }

  img.updatePixels();
  image(img, 0, 0);
  /*
  fill(255);
  textSize(32);
  text(minThresh + " " + maxThresh, 20, 20);
  */
}

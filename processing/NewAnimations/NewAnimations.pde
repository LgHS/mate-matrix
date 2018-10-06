

// This is an empty Processing sketch with support for Fadecandy.
import processing.sound.*;

AudioIn input;
FFT fft;
Amplitude amplitude;



// Declare a scaling factor
int scale = 20;

// Define how many FFT bands we want
int bands = 64;

// declare a drawing variable for calculating rect width
float r_width;

// Create a smoothing vector
float[] sum = new float[bands];
float max=0;
int bandIndex = 0;

// Create a smoothing factor
float smooth_factor = 0.2;


OPC opc;
MateMatrix mm;

float t = 0;

int nbCratesX = 9;
int nbCratesY = 3;

void settings() {
  int w = nbCratesX * mm.CRATE_W * mm.SPACING;
  int h = nbCratesY * mm.CRATE_H * mm.SPACING;
  size(w, h);
}
void setup()
{
  // size(100, 100);

  opc = new OPC(this, "127.0.0.1", 7890);
  //opc.setDithering(false);
  //opc.setInterpolation(false);  
  // Set up your LED mapping here
  mm = new MateMatrix(this, opc, nbCratesX, nbCratesY);
  mm.init(false);
  rectMode(CENTER);
  frameRate(200);
  colorMode(HSB);
  textSize(80);


  // Calculate the width of the rects depending on how many bands we have
  r_width = width/float(bands);

  // Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  input = new AudioIn(this, 1);
  input.amp(1.0);
  input.start();
  amplitude = new Amplitude(this);

  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(input);
  amplitude.input(input);
}

void draw()
{
  background(0);
  fill(255);
  noStroke();

  fft.analyze();


  for (int i = 0; i < bands; i++) {
    // Smooth the FFT data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smooth_factor;
    if (sum[i]>max)max=sum[i];
  }
  surface.setTitle(frameRate+" fps -  "+amplitude.analyze()+" RMS");
  if (amplitude.analyze() > 0.1) {
    anim1();
    bandIndex = (bandIndex+2 < bands) ? bandIndex+2:0;
  } else {
    if (random(500)<2) {
      for (int i = 0; i <= (width / 10)+10; i+=1) {
        fill(sin(frameCount*0.01)*360, 255, 255);
        rect((i*width/10)+10, height/2, sin(millis())*20, height);
      }
    }
  }
}

void exit() {
  background(0);
  super.exit();
}


void anim2() {

  for (int x = 10; x < width; x += 10) {
    for (int y = 10; y < height; y += 10) {

      float n = noise(x*0.005, y*0.005, sum[bandIndex]*(x+y)*0.5);
      pushMatrix();
      translate(x, y);
      rotate(TWO_PI * n);
      scale(10);
      if (random(1000)<999) {

        fill(degrees(TWO_PI*n), 255, 255);
        //fill(255, n*255);
      } else {
        //scale(0.2);
        fill(255);
      }

      rect(0, 0, 1, 1);
      popMatrix();
    }
  }
}
void anim1() {
  pushMatrix();

  for (int i = 0; i < bands; i++) {
    fill(map(sum[i], 0, max/4, 180, 80), 255, 255);
    // Draw the rects with a scale factor
    rect( i*r_width, height/2, r_width, -sum[i]*height*scale );
  }
  popMatrix();
}

void anim3() {
  input.amp(1.0);
  scale = 1000;
  pushMatrix();
  translate(width/2, height/2);
  surface.setTitle(""+sum[bandIndex]);
  for (float p = 0; p < 360; p+=(360/bands)) {
    float posY = sin(p) * sum[bandIndex]*scale;
    float posX = cos(p) * sum[bandIndex]*scale;
    //fill(255);
    strokeWeight(2);
    fill(sum[20]*scale, 255, 255);
    ellipse(posX, posY, 10, 10);
  }
  popMatrix();
}

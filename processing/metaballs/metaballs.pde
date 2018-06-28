// example sketch based on Dan Schiffman's Metaballs algorithm and @scanlime OPC Client library
import ddf.minim.*;
import ddf.minim.analysis.*;

OPC opc;

Minim       minim;
AudioPlayer player=null;
FFT         fft;
String filename = "/Users/gberger/Music/Sympathy_Roosevelt.mp3";

MateMatrix mm;
Blob[] blobs = new Blob[30];

void setup()
{
  size(480, 400);
  opc = new OPC(this, "127.0.0.1", 7890);  
  // pixelDensity(2);
  colorMode(HSB);

  // Set up your LED mapping here

  mm = new MateMatrix(this, opc);
  mm.init();
  for (int i = 0; i < blobs.length; i++) {
    blobs[i] = new Blob(random(width), random(height));
  }

  minim = new Minim(this);
  player = minim.loadFile(filename, 2048);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.logAverages(30, 7);
  player.loop();
}

void draw()
{
  background(0);

  if (player.isPlaying()) {
    fft.forward(player.mix);
    int i = 0;
    for (Blob b : blobs) {

      b.r = fft.getBand(i);

      i+=10;
    }
  }

  loadPixels();

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      
      float sum = 0;
      for (Blob b : blobs) {
        float d = dist(x, y, b.pos.x, b.pos.y);
        sum += 200 * b.r / d;
      }

      pixels[index] = color(constrain(sum,0,250), 200, 200);
    }
  }

  updatePixels();
  for (Blob b : blobs) {

    b.update();
    b.show();
  }
}

void exit() {
  print("exit");
  background(0); 

  super.exit();
}

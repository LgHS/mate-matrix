import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.video.*;

Capture cam;
/**
 * First test with the OPC Client from @scanlime  
 */


OPC opc;

Minim       minim;
AudioPlayer player=null;
FFT         fft;
BeatDetect beat;
float[] fftFilter;
String filename = "/Users/gberger/Music/Kinomono - Laika.mp3";
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
  size(720, 360, P3D);
  frameRate(30);
  // colorMode(HSB);
  colors = loadImage("colors.png");
  // cam = new Capture(this, 720, 360);
  setupMateMatrix();
  minim = new Minim(this); 

  // Small buffer size!
  player = minim.loadFile(filename, 512);
  player.loop();
  fft = new FFT(player.bufferSize(), player.sampleRate());
  print(fft.specSize());
  fftFilter = new float[fft.specSize()];
  // cam.start();
  //strokeWeight(1.0);
  //noFill();
  colorMode(HSB);
}

void setupMateMatrix() {
  opc = new OPC(this, "127.0.0.1", 7890);
  spacing = width / 24;
  offset = int (spacing*2);
  float H = height / 2 + spacing * 2.5;
  float H2 = height / 2 - spacing * 2.5;

  // ROW 0 (3 crates)
  opc.ledGrid(104, 4, 5, offset, H, spacing, spacing, -PI, true, false);
  opc.ledGrid(84, 4, 5, offset + spacing * 4, H, spacing, spacing, -PI, true, false);
  opc.ledGrid(64, 4, 5, offset + spacing * 4 * 2, H, spacing, spacing, -PI, true, false);
  // ROW 0 (3 crates)
  opc.ledGrid(40, 4, 5, offset + spacing * 4 * 3, H, spacing, spacing, -PI, true, false);
  opc.ledGrid(20, 4, 5, offset + spacing * 4 * 4, H, spacing, spacing, -PI, true, false);
  opc.ledGrid(0, 4, 5, offset + spacing * 4 * 5, H, spacing, spacing, -PI, true, false);

  // ROW 1
  opc.ledGrid(128, 4, 5, offset + spacing * 4 * 5, H2, spacing, spacing, -PI, true, false);
  opc.ledGrid(148, 4, 5, offset + spacing * 4 * 4, H2, spacing, spacing, -PI, true, false);
  opc.ledGrid(168, 4, 5, offset + spacing * 4 * 3, H2, spacing, spacing, -PI, true, false);

  opc.ledGrid(192, 4, 5, offset + spacing * 4 * 2, H2, spacing, spacing, -PI, true, false);
  opc.ledGrid(212, 4, 5, offset + spacing * 4, H2, spacing, spacing, -PI, true, false);
  opc.ledGrid(232, 4, 5, offset, H2, spacing, spacing, -PI, true, false);
}

void mousePressed() {
  opc.setStatusLed(true);
  background(0);
}

void mouseReleased() {
  opc.setStatusLed(false);
}

void draw() {
  //noFill();
  // stroke(255);
  background(0);
  /*
  fft.forward(player.mix);
  for (int i = 0; i < fftFilter.length; i++) {
    fftFilter[i] = max(fftFilter[i] * decay, log(1 + fft.getBand(i)));
  }

  for (int i = 0; i < fftFilter.length; i += 3) {   
    color rgb = colors.get(int(map(i, 0, fftFilter.length-1, 0, colors.width-1)), colors.height/2);
    fill(rgb, fftFilter[i] * 200);
    blendMode(ADD);

    float size = height * (minSize + sizeScale * fftFilter[i]);
    
      rect(i*10, height-30, spacing, height-size);
    
   // PVector center = new PVector(width * (fftFilter[i] * 0.2), 0);
    
  }
  /*
  if(cam.available()){
   cam.read();
   image(cam,0,0);
   }
   */
  // image(logo, mouseX, mouseY);
  // The entire effect happens in a pixel shader
  /*
  effect.set("time", millis() / 1000.0);
   effect.set("hue", float(mouseX) / width);
   shader(effect);
   rect(0, 0, width, height);
   resetShader();
   //*/
  /*

   fill(255, 0, 0);
   ellipse(mouseX, mouseY, 30, 30);
   */
  /*
  rect(posX, 0, 50, height);
   posX += speedX;
   if (posX > width -offset || posX < offset/2) {
   speedX = -speedX;
   }
   fill(c%360, 255, 255);
   c++;
  /*
   ellipse(posX, posY, 60, 60);
   
   posY += speedY;
   
   if(posY > height || posY < 0){
   speedY = -speedY;
   }
   */
}

void stop() {
  background(0); 
  // player.close();
  // minim.stop();
  super.stop();
}

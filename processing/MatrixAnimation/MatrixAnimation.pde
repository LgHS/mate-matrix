// example sketch based on Dan Schiffman's Metaballs algorithm and @scanlime OPC Client library
import ddf.minim.*;
import ddf.minim.analysis.*;

OPC opc;

Minim       minim;
AudioInput input;
FFT         fft;


MateMatrix mm;

ArrayList<AudioReactiveAnimationInterface> anims = new ArrayList<AudioReactiveAnimationInterface>();

void setup()
{
  size(480, 400);
  opc = new OPC(this, "127.0.0.1", 7890);  
  // pixelDensity(2);
  colorMode(HSB);

  // Set up your LED mapping here
  mm = new MateMatrix(this, opc);
  mm.init();
  
  // audio analysis configuration
  minim = new Minim(this);
  input = minim.getLineIn();
  fft = new FFT(input.bufferSize(), input.sampleRate());
  fft.logAverages(3, 7);
  anims.add(new MetaBallsAnimation());
  
}

void draw()
{
  background(0);

  
  fft.forward(input.mix);
  anims.get(0).displayFrame(fft);
}

void exit() {
  print("exit");
  background(0); 

  super.exit();
}

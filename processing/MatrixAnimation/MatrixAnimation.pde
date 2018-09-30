// example sketch based on Dan Schiffman's Metaballs algorithm and @scanlime OPC Client library
import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;

OPC opc;

Minim       minim;
AudioInput input;
FFT         fft;
Serial enttec;

static final int CRATES = 30;

MateMatrix mm;
JSONObject config;

DMXMode dmx;

AnimationRunner animRunner;
// byte[] lastDMX = new byte[519];
// byte[] colors = new byte[CRATES];
void setup()
{
  size(480, 500, P3D);
  opc = new OPC(this, "127.0.0.1", 7890);
  // opc.setPixelCount(6*6*20);
  // pixelDensity(2);
  println(Serial.list());
  colorMode(HSB);

  config = loadJSONObject("matrix_config.json");
  // Set up your LED mapping here
  mm = new MateMatrix(this, opc, 6, 5, 0, 0);
  //mm = new MateMatrix(this, opc, config);
  mm.initMicroFest();
  //mm.initMultiblock(config);
  //mm.init();


  // audio analysis configuration
  minim = new Minim(this);

  input = minim.getLineIn();

  fft = new FFT(input.bufferSize(), input.sampleRate());
  fft.linAverages(256);
  //fft.logAverages(3, 7);


  // animation runner
  animRunner = new AnimationRunner(input, fft);
  dmx = new DMXMode(this, opc);
  String dmxSerialPort = config.getString("dmxSerialPort");
  try {
    enttec = new Serial(this, dmxSerialPort, 115000);
    enttec.bufferUntil(0xE7);
  }
  catch(RuntimeException e) {
    println("no dmx interface, forcing auto mode");
    dmx.setMode(1);
  }
}

void draw() {
  //background(0);
  //fill(140, 200, 255);
  //rect(mouseX, mouseY, 100,100);
  //*
  if (! dmx.isActive()) {
    //colorMode(RGB);
    //dmx.show();

    //opc.pixelLocations = null;
    background(0);
    noStroke();
  } else {
    colorMode(HSB);
    if (opc.pixelLocations == null) {
      mm.init();
    }
    try {
      animRunner.choseAnimFromDMX(dmx.getAnimationSelector());
      if (dmx.getRandomAnim()) {
        animRunner.selectAnimation();
      }
    }
    catch(NullPointerException e) {
      println("error 1");
      println(e.getMessage());
    }


    animRunner.run();
  }

  //*/
}

/*
  GBE: XXX findout how to let the DMXMode class handle the event
 */
void serialEvent(Serial s) {

  try {
    dmx.manageMessage(enttec);
  }
  catch(RuntimeException e) {
    println("error manageMessage");
    println(e.getMessage() );
    println(e.getStackTrace());
  }
}


void exit() {
  print("exit");
  background(0);

  super.exit();
}

void keyPressed() {
  if (key == ' ') {
    animRunner.selectAnimation();
  }
  if (key>='0' && key <= '9') {
    animRunner.selectAnimation(key-48);
  }
  if (key == 'a' || key == 'A') {
    animRunner.toggleAutoMode();
  }
}

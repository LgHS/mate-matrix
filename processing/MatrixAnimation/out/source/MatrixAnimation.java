import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 
import processing.serial.*; 
import java.util.Arrays; 
import java.util.Arrays; 
import java.net.*; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MatrixAnimation extends PApplet {

// example sketch based on Dan Schiffman's Metaballs algorithm and @scanlime OPC Client library




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

public void setup()
{
  
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

public void draw() {
  //background(0);
   //fill(140, 200, 255);
   //rect(mouseX, mouseY, 100,100);
  //*
  if(! dmx.isActive()){
    //colorMode(RGB);
    //dmx.show();
    
    //opc.pixelLocations = null;
    background(0);
    noStroke();
    
   }else{
    colorMode(HSB);
    if(opc.pixelLocations == null){
    mm.init();
   }
   try{
    animRunner.choseAnimFromDMX(dmx.getAnimationSelector());
    if(dmx.getRandomAnim()){
      animRunner.selectAnimation();
    }
   }catch(NullPointerException e){
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
public void serialEvent(Serial s) {

  try {
    dmx.manageMessage(enttec);
  }
  catch(RuntimeException e) {
    println("error manageMessage");
    println(e.getMessage() );
    println(e.getStackTrace());
  }
}


public void exit() {
  print("exit");
  background(0);

  super.exit();
}

public void keyPressed() {
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
abstract class AbstractGrid implements AudioReactiveAnimationInterface{
  protected FFT fft;
  protected float offset;
  public void displayFrame(FFT fft){
    this.fft = fft;
    background(0);

    noFill();
    stroke(255);
    colorMode(HSB);


    offset  = mm.SPACING/2;
    // hook
    changeDesignElements();

    for(int x = 0; x < mm.cols; x++){
      for(int y = 0; y < mm.rows; y++){
        float posX = offset+x*mm.CRATE_W*mm.SPACING;
        float posY = offset*2 + y * mm.CRATE_H*mm.SPACING;
        drawCrate(posX, posY, (mm.CRATE_W-1)*mm.SPACING+1, (mm.CRATE_H-1)*mm.SPACING+1 );
      }


    }

  }
  /** this is the hook to implement if we want to draw in each cell**/
  abstract protected void drawCrate(float x, float y, float w, float h);
  abstract protected void changeDesignElements();
}
abstract class AbstractShaderAnimation implements AudioReactiveAnimationInterface {
  protected PShader shader;
  protected PGraphics pg;
  
  AbstractShaderAnimation(String shaderFile) {
    shader = loadShader(shaderFile);
    pg = createGraphics(width, height, P3D);
  }
  public void displayFrame(FFT fft) {

    shader.set("time", (float) millis()/100.0f);
    shader.set("resolution", PApplet.parseFloat(pg.width), PApplet.parseFloat(pg.height));
    setAdditionalParams(fft);
    pg.beginDraw();
    pg.shader(shader);
    pg.rect(0, 0, pg.width, pg.height);
    pg.endDraw();

    image(pg, 0, 0);
  }

  protected abstract void setAdditionalParams(FFT fft);
}
abstract class AbstractSplitAnimation{

  protected PVector[] blocks;

}
class AnimationRunner {
  ArrayList<AudioReactiveAnimationInterface> anims = new ArrayList<AudioReactiveAnimationInterface>();
  int animIndex=0;
  long start = 0;
  int sec = 1000;
 // int[] durations = {5*sec, 2*sec, 2*sec, 3*sec, sec/2, sec*3, sec*8};
  int[] durations = {};
  boolean auto=true;

  AudioInput in;
  FFT fft;
//  PVector[] blocks = new PVector[]{new PVector(3,3), new PVector(6,3), new PVector(3,3)}
  AnimationRunner(AudioInput in, FFT fft) {
    anims.add(new Grid());
    anims.add(new MetaBallsAnimation());
    //anims.add(new NervousWaves2());
    anims.add(new LineAnimation(in));
    anims.add(new BreathingLines(in));
    anims.add(new MonjoriShader("monjori.glsl"));
    // anims.add(new Logo(in));
    anims.add(new CratesAnimation());
    anims.add(new SineWaveShader("sinewave.glsl"));
    anims.add(new GenericShader("spiral.glsl"));
    anims.add(new AudioReactiveShader("sinewave2.glsl", new int[]{80}));
    anims.add(new RectSplitAnimation(new PVector[]{new PVector(3,3), new PVector(6,3), new PVector(3,3)}));
    this.in = in;
    this.fft = fft;
    start = millis();
  }

  public void run() {
    if (in.mix == null) {
      anims.get(5).displayFrame(fft);
    } else {
      fft.forward(in.mix);
      anims.get(animIndex).displayFrame(fft);

      if (auto) {
        if (millis() - start > (animIndex < durations.length ? durations[animIndex] : random(1000,5000))) {
          start = millis();
          animIndex = PApplet.parseInt(random(0, anims.size()));
        }
      }
    }
  }
  // xxx duration should be in the Animation class
  private int getDuration() {
    return PApplet.parseInt(random(5000, 15000));
  }
  public void selectAnimation() {
    int index = PApplet.parseInt(random(0, anims.size()));
    selectAnimation(index);
  }
  public void selectAnimation(int i) {
    if (i > anims.size() -1) {
      i = 0;
    }
    animIndex = i;

    start = millis();
  }
  public void choseAnimFromDMX(int val){
    // if dmx fader is off no choice
    if(val == 0){
      return;
    }
    int animIndex = floor(map(val, 1, 255, 0, anims.size()));
    selectAnimation(animIndex);
  }

  public void toggleAutoMode() {
    auto = !auto;
    println("auto mode: ", auto?"enabled":"disabled");
  }
}
interface AudioReactiveAnimationInterface{
 public void displayFrame(FFT fft); 
}
class AudioReactiveShader extends AbstractShaderAnimation{
  private int[] freqs;
    AudioReactiveShader(String shaderFile){
      super(shaderFile);
    }
    AudioReactiveShader(String shaderFile, int[] freqs){
      super(shaderFile);
      this.freqs = freqs;
    }

    protected void setAdditionalParams(FFT fft){
      for(int i = 0; i < freqs.length; i++){
        String paramName = "freq"+i;

        shader.set(paramName, fft.getBand(freqs[i]));
      }
    }

}
class Blob {
   // no encapsulation but we know what we're doing, right?
   PVector pos;
   float r;
   PVector vel;
   public Blob(float x, float y){
       pos = new PVector(x, y);
       r = random(10,30);
       vel = PVector.random2D();
       vel.mult(random(0.5f,2));
   }
  
  public void show(){
     noFill();
     noStroke();
     //stroke(0);
     //strokeWeight(4);
     ellipse(pos.x, pos.y, r*2, r*2);
  }
  
  public void update(){
    pos.add(vel);
    if(pos.x < 0 || pos.x > width){
       vel.x *= -1; 
    }
    
    if(pos.y < 0 || pos.y > height){
       vel.y *= -1; 
    }
  }
  
}
 // stolen from https://www.openprocessing.org/sketch/514836
class BreathingLines implements AudioReactiveAnimationInterface {
  int numLines = 24;
  float theta = 0;
  AudioInput in;
  BreathingLines(AudioInput in){
    this.in = in;
  }
  public void displayFrame(FFT fft) {
    background(0);
    stroke(255);
    fill(255);
    strokeCap(PROJECT);
    //line(width/2, height/4, width/2, 3*height/4);
    //int frame = (int) (30 * sin(theta));
    for (int i = 0; i < numLines; i++) {
      float x = (i+1) * ((float) width/(numLines+1));
      float distFromCenter = dist(x, 0, width/2, 0);
      float waveOffset = map(distFromCenter, 0, width/2, 0, 100);
      float wave = 20 * sin((HALF_PI)* sin((-frameCount + waveOffset) / 40.0f)) + fft.getBand(4);
      strokeWeight(abs(wave));
      stroke(wave*3, 200, 255);
      line(x, 0, x, height/2 );
      stroke(wave, 200, 255);
      line(x, height/2, x, height );
    }

    theta+= PI/60;
  }
}
class CratesAnimation implements AudioReactiveAnimationInterface {
  int x=0;
  int y = 0;
  public void displayFrame(FFT fft) {
    background(0);
    noStroke();
    if (random(10)>4) {
      float hue = map(x+y*frameCount%110, 0, 260, 110 , 330);
      fill(hue, 255, 200);
   
    } else {
      fill(0);
    }
    int posX = x*mm.SPACING*mm.CRATE_W;
    int posY = y*mm.SPACING*mm.CRATE_H;
    pushMatrix();
    
    translate(posX, posY);
   // rotate(TWO_PI*fft.getBand(400));
    //scale(fft.getBand(200));
    
    rect(0, 0 , mm.CRATE_W*mm.SPACING, mm.CRATE_H*mm.SPACING);
    popMatrix();
    
    x++;y++;
    if(x > mm.cols)x=0;
    if(y> mm.rows)y=0;
  }
}


class DMXEffectsManager {
  private OPC opc;
  private int pixelCount;
  private int mainColor = color(0,0,0);
  private byte[] dmxMessage;
  private int messageOffset = 5;



  public DMXEffectsManager(OPC opc){
    this.opc = opc;
    this.pixelCount = opc.pixelLocations.length;

  }

  public void applyEffect(byte[] dmxMessage){
    this.dmxMessage = dmxMessage;
    setMainColor();

    //clear();

    if(getDMXIntValue(DMXMapping.CRATES_FIRST) > 0){
      individualCrates();
    }
    if(getDMXIntValue(DMXMapping.FULL_ON) > 0){
        fullOn();
    }
    // if a color of side block is on : show it
    if(getDMXIntValue(DMXMapping.FRONT_LEFT_R) > 0 || getDMXIntValue(DMXMapping.FRONT_LEFT_G)>0 || getDMXIntValue(DMXMapping.FRONT_LEFT_B)>0){
      clear();
      int col = rgbForDMXChannels(
          DMXMapping.FRONT_LEFT_R,
          DMXMapping.FRONT_LEFT_G,
          DMXMapping.FRONT_LEFT_B,
        255);
      // For a column 2*4 bottles width + 5*5 bottles
      int nbCol = 2;
      int nbLines = 5;
      int matrixTotalWidth = 6*20; // 6 crates Width * 20 bottles
      for(int x = 0; x < nbCol ; x++){
          for(int y = 0; y < nbLines; y++){
              int index =  y * matrixTotalWidth + x * 20;

              for(int p = index; p < index + 20; p++){
                opc.setPixel(p, col);
              }

          }
      }

    }
    if(getDMXIntValue(DMXMapping.FRONT_RIGHT_R)>0 || getDMXIntValue(DMXMapping.FRONT_RIGHT_G)>0 || getDMXIntValue(DMXMapping.FRONT_RIGHT_B)>0){
      int c = rgbForDMXChannels(DMXMapping.FRONT_LEFT_R, DMXMapping.FRONT_LEFT_G, DMXMapping.FRONT_LEFT_B);

    }
    if(getDMXIntValue(DMXMapping.CENTER_R) > 0){

    }
    if(getDMXIntValue(DMXMapping.LINES_POS) > 0){

    }
    if(getDMXIntValue(DMXMapping.COLS_POS)>0){

    }

  }

  public void individualCrates(){
    byte[] colors = new byte[CRATES * 3];

    System.arraycopy(dmxMessage, DMXMapping.CRATES_FIRST, colors, 0, CRATES*3);

    for(int i = 0; i < CRATES; i++){
      for(int j = 0; j < 20; j++){

        // color pixelColor = colorFromBytes(byte(0xFF), crateColors[i*3], crateColors[i*3+1], crateColors[i*3+2]);
        int  pixelColor = 255 << 24 | PApplet.parseInt(colors[i*3]) << 16 | PApplet.parseInt(colors[i*3+1]) << 8 | PApplet.parseInt(colors[i*3+2]);
        opc.setPixel(i*20+j, pixelColor );
      }

    }
  }

  public void setMainColor(){
    mainColor = rgbForDMXChannels(
        DMXMapping.FULL_R, DMXMapping.FULL_B, DMXMapping.FULL_G, 255
      );
  }
  public void clear(){
    for(int i = 0; i < pixelCount; i++){
      opc.setPixel(i, 0);
    }
    // opc.writePixels();
  }

  public void fullOn(){

    int c = getDMXIntValue(DMXMapping.FULL_ON) << 24 | getDMXIntValue(DMXMapping.FULL_R) << 16 | getDMXIntValue(DMXMapping.FULL_G) << 8 | getDMXIntValue(DMXMapping.FULL_B);
    if(c == 0){
      c = mainColor;
    }

    for(int p = 0; p < pixelCount; p++){
      opc.setPixel(p, c);
    }
  }

  public int rgbForDMXChannels(int r, int g, int b, int a){
    return colorFromValues(
        getDMXIntValue(r),
        getDMXIntValue(g),
        getDMXIntValue(b),
        a
      );

  }
  public int rgbForDMXChannels(int r, int g, int b){
    return colorFromValues(
        getDMXIntValue(r),
        getDMXIntValue(g),
        getDMXIntValue(b),
        255
      );
  }
  // util function that returns a color from 4 bytes
  public int colorFromValues(byte r, byte g, byte b, byte a){
    return colorFromValues(PApplet.parseInt(r), PApplet.parseInt(g), PApplet.parseInt(b), PApplet.parseInt(a));

  }
  public int colorFromValues(int r, int g, int b, int a){
    int c = a << 24 | r << 16 | g << 8 | b;
    return c;
  }


  public int HSBFromHue(byte h){
    return colorFromValues(h, (byte)(0XFF), (byte)(0xFF), (byte)(0xFF));
  }

// beware of the duplicate code !!
  public byte getDMXValue(int channel ){
    // BE CAREFUL : first dmx channel is at index 6, last being 518
    return dmxMessage[messageOffset + channel];
  }
  public int getDMXIntValue(int channel){
    return PApplet.parseInt(getDMXValue(channel));
  }
}

// TODO : I want to be in a json file please !!
static final class DMXMapping{

  public static final int MODE = 1;
  public static final int ANIM_SELECTION = 2;
  public static final int RANDOM_ANIM = 3;
  public static final int FULL_ON = 4;
  public static final int FULL_R = 5;
  public static final int FULL_G = 6;
  public static final int FULL_B = 7;

  public static final int FRONT_LEFT_R = 8;
  public static final int FRONT_LEFT_G = 9;
  public static final int FRONT_LEFT_B = 10;

  public static final int FRONT_RIGHT_R = 11;
  public static final int FRONT_RIGHT_G = 12;
  public static final int FRONT_RIGHT_B = 13;

  public static final int CENTER_R = 14;
  public static final int CENTER_G = 15;
  public static final int CENTER_B = 15;

  public static final int LINES_POS = 16;
  public static final int LINE_R = 17;
  public static final int LINE_G = 18;
  public static final int LINE_B = 19;

  public static final int COLS_POS = 20;
  public static final int COLS_R = 21;
  public static final int COLS_G = 22;
  public static final int COLS_B = 22;
  // goes from channel 30 to channel 30+ 3*NB_CRATES
  public static final int CRATES_FIRST = 30;


}


class DMXMode {
  private OPC opc;
  private PApplet parent;

  byte[] dmxMessage;

  private int mode = 0;
  // first useful dmx message starts at index 6
  private int messageOffset = 5;


  private DMXEffectsManager em;

  public DMXMode(PApplet parent, OPC opc){
    this.opc = opc;
    this.parent = parent;
    dmxMessage = new byte[519];

    em = new DMXEffectsManager(opc);


  }

  public void show(){

    em.applyEffect(dmxMessage);
    opc.writePixels();
  }

  public void manageMessage(Serial dmxSerial){

    try{
      dmxSerial.readBytes(dmxMessage);

      // check start sequence
      if (dmxMessage[0] == (byte)(0x7E)) {

        // if message label == 5 (dmx received)
        if (dmxMessage[1] == 5) {

          // lastDMX[2] & lastDMX[3] are the size of the message
          int msgLength = dmxMessage[2] << 8 | PApplet.parseInt(dmxMessage[3]);
          // lastDMX[4] is the error byte => if != 0 => message has an error
          if(dmxMessage[4] != (byte)(0x00)){
            println("message has error");
            // if error, back to automatic mode
            mode = 0;
            return;

          }
          // lastDMX[5] should be 0x00 : it the verification character

          mode = getDMXIntValue(DMXMapping.MODE);



          /*
            for(int i = 7; i < 36*3; i+=3){
              colors[i/3] = 255 << 24 | lastDMX[i]<<16 | lastDMX[i+1]<<8 | int(lastDMX[i+2]);

            }
          */
        }
      }else{
        print("can't find enttec start delimiter found this instead");

        println(hex(dmxMessage[0]));
        dmxSerial.clear();
      }

    }catch(RuntimeException e){
      println("Error while receiving Serial packet");
      println(e.getMessage());
    }

  }

  public boolean isActive(){
    return mode != 0;
  }

  public void setMode(int mode){
    this.mode = mode;
  }

  public int getAnimationSelector(){

    return getDMXIntValue(DMXMapping.ANIM_SELECTION);
  }
  public boolean getRandomAnim(){
    return getDMXIntValue(DMXMapping.RANDOM_ANIM) == 255;
  }

  public byte getDMXValue(int channel ){
    // BE CAREFUL : first dmx channel is at index 6, last being 518
    return dmxMessage[messageOffset + channel];
  }
  public int getDMXIntValue(int channel){
    return PApplet.parseInt(getDMXValue(channel));
  }

}
class GenericShader extends AbstractShaderAnimation {

  GenericShader(String shaderFile) {
    //this.shader = loadShader(shaderFile);
    super(shaderFile);
  }
  public void displayFrame(FFT fft) {
    shader.set("time", (float) millis()/1000.0f);
    shader.set("resolution", PApplet.parseFloat(pg.width), PApplet.parseFloat(pg.height));

    pg.beginDraw();
    pg.shader(shader);
    noStroke();
    pg.rect(0, 0, pg.width, pg.height);
    pg.endDraw();

    image(pg, 0, 0);
  }

  protected void setAdditionalParams(FFT fft) {
  }
}
class Grid extends AbstractGrid{
  public void drawCrate(float x, float y,float w, float h ) {
    pushMatrix();
    translate(x, y);
    stroke(120+fft.getBand(250)*10, 255,255);
    if(millis() % 1000 < 5){
    }else{
      
      rect(sin(fft.getBand(20)*10)*3*mm.SPACING,mm.SPACING*fft.getBand(200), w, h*sin(fft.getBand(150)));
    }
    popMatrix();
  }

  protected void changeDesignElements(){
    strokeWeight(1.5f*fft.getAvg(30) );
  }
}
class LineAnimation implements AudioReactiveAnimationInterface {

  float t = 0.003f;
  AudioInput in;
  LineAnimation(AudioInput in) {
    this.in = in;
  }
  public void displayFrame(FFT fft) {
    background(0,200);
    stroke(255);
    strokeWeight(18);
    for (int i = 0; i < in.mix.level()*90; i++){
      // println(in.mix.level());
      float h = abs(sin(t))*height+0.3f*i;
      float w = abs(cos(t))*width+0.3f*i;
      //stroke(map(h,0,height, 0, 130),255,255);
      stroke(255);
      line(i*20, h, width-i*20, h);
      //stroke(map(w,0,width, 160, 360),255,255);
      stroke(255);
      line(w, i*20, w, height-i*20);
      t+=0.003f;
    }
    strokeWeight(1);
  }
}
class Logo implements AudioReactiveAnimationInterface {
  PImage logo;
  AudioInput in;
  float t = 0.1f;
  float scale = 1.2f;
  
  PVector pos;
  PVector velocity;
  
  BeatDetect beat;
  
  Logo(AudioInput in) {
    logo = loadImage("fesses.png");
    this.in = in;
    beat = new BeatDetect();
    pos = new PVector(width/2, height/2);
    velocity = new PVector(2,0);
  }
  public void displayFrame(FFT fft) {
    imageMode(CENTER);
    background(abs(sin(fft.getBand(60))*200));
    image(logo, pos.x, pos.y);
    //fft.getBand(20), fft.getBand(40);  
    
    
    if(pos.x > width - logo.width/2 || pos.x < logo.width/2){
      velocity.x *= -1;
    }
    
    
    pos.add(velocity);
    t+=0.1f;
  }
}
/**
  Manages pixel mapping to OPC via the @Scanlime class
**/
class MateMatrix {

  private OPC opc;

  private float offset;
  private PApplet applet;
  private float crateWidth;
  private int cols = 6;
  private int rows = 4;
  private int posX = 0;
  private int posY = 0;
  private boolean enabled;

  public int SPACING = 20;
  // todo : take data fromconfig file
  public static final int PIXELS_PER_CRATE = 20;
  public static final int CRATE_H = 5;
  public static final int CRATE_W = 4;

  private int[] pixelLocationsTmp;


  public MateMatrix(PApplet applet, OPC opc) {
    this(applet, opc, 6, 4);
  }

  public MateMatrix(PApplet applet, OPC opc, JSONObject config){

    this(applet, opc, config.getInt("cols"), config.getInt("rows"));
    this.SPACING = config.getInt("spacing");
  }
  public MateMatrix(PApplet applet, OPC opc, int cols, int rows) {
    this.opc = opc;
    this.applet = applet;
    this.cols = cols;
    this.rows = rows;

    offset = PApplet.parseInt (SPACING*2);
  }
  public MateMatrix(PApplet applet, OPC opc, int cols,int rows, int posX, int posY){
    this(applet, opc, cols, rows);
    this.posX = posX;
    this.posY = posY;

  }
  public void init() {

    crateWidth = SPACING * 4;

    for (int y = 0; y < rows; y++) {
      // in OPC led grids position x,y are their centers. We have to distribute centers over the height of the sketch
      float posY = applet.height / 2 + (SPACING * CRATE_H/2 * (-(rows-1) + y * 2));
      // print("y:"+posY);

      for (int x = 0; x < cols; x++) {
        int index = y * cols * PIXELS_PER_CRATE + x * PIXELS_PER_CRATE;
        float posX = offset + crateWidth * x;
       // print("\tx:"+posX);
        opc.ledGrid(index, CRATE_W, CRATE_H, posX, posY, SPACING, SPACING, 0, true, false);
      }

      // println();
    }
    enabled = true;

  }
  public void initMicroFest(){


    crateWidth = SPACING * 4;


    for(int y = 0; y < rows; y++){
      float posY  = applet.height / 2 + (SPACING * CRATE_H/2 * (-(rows-1) + y * 2));
      println(posY);
      for(int x = 0; x < cols; x++){
        int index = y * cols * PIXELS_PER_CRATE + x * PIXELS_PER_CRATE;
        float posX = offset + crateWidth * x;
        print("\tx:"+posX);
        opc.ledGrid(index, CRATE_W, CRATE_H, posX, posY, SPACING, SPACING, 0, true, false);
      }
      println();
    }

  }

  public void initMultiblock(JSONObject config){
    JSONArray blocks = config.getJSONArray("blocks");
    crateWidth = config.getInt("spacing") * config.getInt("crateW");
    int crateHeight = config.getInt("spacing") * config.getInt("crateH");
    int index = 0;
    for(int i = 0; i < blocks.size(); i++){
        float gap = 0;

        JSONObject block = blocks.getJSONObject(i);
        int rows = block.getInt("rows");
        String position = block.getString("position");
        if(position.equals("center")){
          // gap = offset + 20.0;
        }
        println(position);
        for(int y = 0; y < rows; y++){
          float posY;
          if(position.equals("center")){
            posY = crateHeight * rows / 2 + (crateHeight/2 * (-(rows-1) + y * 2));
          }else{
            posY =  applet.height/2 + (crateHeight/2 * (-(rows-1) + y *2));
          }

          println("posY : "+posY);
          int cols = block.getInt("cols");

          for(int x = 0; x < cols; x++ ){
            //int index = y * config.getInt("cols") * config.getInt("pixelsPerCrate") + x * config.getInt("pixelsPerCrate");
            float posX = crateWidth/2 + crateWidth * x;
            if(position.equals("right")){
                // right edge - 2 * crateWidth + x * crateWidth
                posX = width - cols*crateWidth + x * crateWidth;

            }else if(position.equals("center")){
              posX  = width/2 - (cols*crateWidth)/2 + crateWidth * x +crateWidth /4;
            }else if (position.equals("left")){
            //   posX = crateWidth/2 + crateWidth * x ;
            }

            print("\t posX: "+posX);
            opc.ledGrid(index, config.getInt("crateW"), config.getInt("crateH"), posX, posY, SPACING, SPACING, 0, true, false);
            index+=20;
          }

          println();
        }
        printArray(opc.pixelLocations);



    }


  }
  public float getCrateWidth(){
     return crateWidth;
  }

}
/**
   Metaball Animation class 
*/

class MetaBallsAnimation implements AudioReactiveAnimationInterface {
  private Blob[] blobs = new Blob[15];

  MetaBallsAnimation() {
    for (int i = 0; i < blobs.length; i++) {
      blobs[i] = new Blob(random(width), random(height));
    }
  }

  public void init() {
  }
  public void  displayFrame(FFT fft) {

    int i = 0;
    for (Blob b : blobs) {

      b.r = fft.getBand(i);

      i+=25;
    }


    loadPixels();

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int index = x + y * width;

        float sum = 0;
        for (Blob b : blobs) {
          float d = dist(x, y, b.pos.x, b.pos.y);
          sum += 120 * b.r / d;
        }

        pixels[index] = color(constrain(sum, 0, 360), 200, 200);
      }
    }

    updatePixels();
    for (Blob b : blobs) {

      b.update();
      b.show();
    }
  }
}
class MonjoriShader extends AbstractShaderAnimation {

  MonjoriShader(String shaderFile) {
    super(shaderFile);
  }

  protected void setAdditionalParams(FFT fft) {

    shader.set("graininess", constrain(fft.getBand(100)*820, 10, 3000)); // 10 -> 100
    shader.set("pace", constrain(fft.getBand(600)*100, 20, 800)); // 20 -> 80
    shader.set("twist", constrain(fft.getBand(800)*400, 0, 400)); // 0 -> 100
  }
}
class MyOPC extends OPC{
  public MyOPC(PApplet applet, String host, int port){
    super(applet, host, port);
  }
  public void setPixel(int number, byte[] c){
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      setPixelCount(number + 1);
    }

    packetData[offset] = c[0];
    packetData[offset + 1] = c[1];
    packetData[offset + 2] = c[2];
  }
}
// stolen from https://www.openprocessing.org/sketch/153224
class NervousWaves2 implements AudioReactiveAnimationInterface {
  private float t = 0;
  
  
  NervousWaves2() {
    
  }
  public void displayFrame(FFT fft) {
    float fc = frameCount * 0.2f;
    background(fc%240, 255,255);
    //background(140, 255, 255);
    //fill(frameCount%360, 200, 200);
    stroke(0);
    

    for (int x = 10; x < width; x += 10) {
      for (int y = 10; y < height; y += 10) {
        float n = noise((x % t)*0.5f, y * fft.getBand(400)* 0.5f, 100);
        pushMatrix();
        translate(x, y);
        rotate(TWO_PI * n);
        scale(2 * fft.getBand(y*x));
        fill(0);
        rect(-1, -1, 1, 1);
        
        popMatrix();
      }
    }
    t+=0.1f*fft.getBand(200)*12;
  }
}
/*
 * Simple Open Pixel Control client for Processing,
 * designed to sample each LED's color from some point on the canvas.
 *
 * Micah Elizabeth Scott, 2013
 * This file is released into the public domain.
 */




public class OPC implements Runnable
{
  Thread thread;
  Socket socket;
  OutputStream output, pending;
  String host;
  int port;

  int[] pixelLocations;
  byte[] packetData;
  byte firmwareConfig;
  String colorCorrection;
  boolean enableShowLocations;

  OPC(PApplet parent, String host, int port)
  {
    this.host = host;
    this.port = port;
    thread = new Thread(this);
    thread.start();
    this.enableShowLocations = true;
    parent.registerMethod("draw", this);
  }

  // Set the location of a single LED
  public void led(int index, int x, int y)
  {
    // For convenience, automatically grow the pixelLocations array. We do want this to be an array,
    // instead of a HashMap, to keep draw() as fast as it can be.
    if (pixelLocations == null) {
      pixelLocations = new int[index + 1];
    } else if (index >= pixelLocations.length) {
      pixelLocations = Arrays.copyOf(pixelLocations, index + 1);
    }

    pixelLocations[index] = x + width * y;
  }

  // Set the location of several LEDs arranged in a strip.
  // Angle is in radians, measured clockwise from +X.
  // (x,y) is the center of the strip.
  public void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed)
  {
    float s = sin(angle);
    float c = cos(angle);
    for (int i = 0; i < count; i++) {
      led(reversed ? (index + count - 1 - i) : (index + i),
        (int)(x + (i - (count-1)/2.0f) * spacing * c + 0.5f),
        (int)(y + (i - (count-1)/2.0f) * spacing * s + 0.5f));
    }
  }

  // Set the locations of a ring of LEDs. The center of the ring is at (x, y),
  // with "radius" pixels between the center and each LED. The first LED is at
  // the indicated angle, in radians, measured clockwise from +X.
  public void ledRing(int index, int count, float x, float y, float radius, float angle)
  {
    for (int i = 0; i < count; i++) {
      float a = angle + i * 2 * PI / count;
      led(index + i, (int)(x - radius * cos(a) + 0.5f),
        (int)(y - radius * sin(a) + 0.5f));
    }
  }

  // Set the location of several LEDs arranged in a grid. The first strip is
  // at 'angle', measured in radians clockwise from +X.
  // (x,y) is the center of the grid.
  public void ledGrid(int index, int stripLength, int numStrips, float x, float y,
               float ledSpacing, float stripSpacing, float angle, boolean zigzag,
               boolean flip)
  {
    float s = sin(angle + HALF_PI);
    float c = cos(angle + HALF_PI);
    for (int i = 0; i < numStrips; i++) {
      ledStrip(index + stripLength * i, stripLength,
        x + (i - (numStrips-1)/2.0f) * stripSpacing * c,
        y + (i - (numStrips-1)/2.0f) * stripSpacing * s, ledSpacing,
        angle, zigzag && ((i % 2) == 1) != flip);
    }
  }

  // Set the location of 64 LEDs arranged in a uniform 8x8 grid.
  // (x,y) is the center of the grid.
  public void ledGrid8x8(int index, float x, float y, float spacing, float angle, boolean zigzag,
                  boolean flip)
  {
    ledGrid(index, 8, 8, x, y, spacing, spacing, angle, zigzag, flip);
  }

  // Should the pixel sampling locations be visible? This helps with debugging.
  // Showing locations is enabled by default. You might need to disable it if our drawing
  // is interfering with your processing sketch, or if you'd simply like the screen to be
  // less cluttered.
  public void showLocations(boolean enabled)
  {
    enableShowLocations = enabled;
  }

  // Enable or disable dithering. Dithering avoids the "stair-stepping" artifact and increases color
  // resolution by quickly jittering between adjacent 8-bit brightness levels about 400 times a second.
  // Dithering is on by default.
  public void setDithering(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x01;
    else
      firmwareConfig |= 0x01;
    sendFirmwareConfigPacket();
  }

  // Enable or disable frame interpolation. Interpolation automatically blends between consecutive frames
  // in hardware, and it does so with 16-bit per channel resolution. Combined with dithering, this helps make
  // fades very smooth. Interpolation is on by default.
  public void setInterpolation(boolean enabled)
  {
    if (enabled)
      firmwareConfig &= ~0x02;
    else
      firmwareConfig |= 0x02;
    sendFirmwareConfigPacket();
  }

  // Put the Fadecandy onboard LED under automatic control. It blinks any time the firmware processes a packet.
  // This is the default configuration for the LED.
  public void statusLedAuto()
  {
    firmwareConfig &= 0x0C;
    sendFirmwareConfigPacket();
  }

  // Manually turn the Fadecandy onboard LED on or off. This disables automatic LED control.
  public void setStatusLed(boolean on)
  {
    firmwareConfig |= 0x04;   // Manual LED control
    if (on)
      firmwareConfig |= 0x08;
    else
      firmwareConfig &= ~0x08;
    sendFirmwareConfigPacket();
  }

  // Set the color correction parameters
  public void setColorCorrection(float gamma, float red, float green, float blue)
  {
    colorCorrection = "{ \"gamma\": " + gamma + ", \"whitepoint\": [" + red + "," + green + "," + blue + "]}";
    sendColorCorrectionPacket();
  }

  // Set custom color correction parameters from a string
  public void setColorCorrection(String s)
  {
    colorCorrection = s;
    sendColorCorrectionPacket();
  }

  // Send a packet with the current firmware configuration settings
  public void sendFirmwareConfigPacket()
  {
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }

    byte[] packet = new byte[9];
    packet[0] = (byte)0x00; // Channel (reserved)
    packet[1] = (byte)0xFF; // Command (System Exclusive)
    packet[2] = (byte)0x00; // Length high byte
    packet[3] = (byte)0x05; // Length low byte
    packet[4] = (byte)0x00; // System ID high byte
    packet[5] = (byte)0x01; // System ID low byte
    packet[6] = (byte)0x00; // Command ID high byte
    packet[7] = (byte)0x02; // Command ID low byte
    packet[8] = (byte)firmwareConfig;

    try {
      pending.write(packet);
    } catch (Exception e) {
      dispose();
    }
  }

  // Send a packet with the current color correction settings
  public void sendColorCorrectionPacket()
  {
    if (colorCorrection == null) {
      // No color correction defined
      return;
    }
    if (pending == null) {
      // We'll do this when we reconnect
      return;
    }

    byte[] content = colorCorrection.getBytes();
    int packetLen = content.length + 4;
    byte[] header = new byte[8];
    header[0] = (byte)0x00;               // Channel (reserved)
    header[1] = (byte)0xFF;               // Command (System Exclusive)
    header[2] = (byte)(packetLen >> 8);   // Length high byte
    header[3] = (byte)(packetLen & 0xFF); // Length low byte
    header[4] = (byte)0x00;               // System ID high byte
    header[5] = (byte)0x01;               // System ID low byte
    header[6] = (byte)0x00;               // Command ID high byte
    header[7] = (byte)0x01;               // Command ID low byte

    try {
      pending.write(header);
      pending.write(content);
    } catch (Exception e) {
      dispose();
    }
  }

  // Automatically called at the end of each draw().
  // This handles the automatic Pixel to LED mapping.
  // If you aren't using that mapping, this function has no effect.
  // In that case, you can call setPixelCount(), setPixel(), and writePixels()
  // separately.
  public void draw()
  {
    if (pixelLocations == null) {
      // No pixels defined yet
      return;
    }
    if (output == null) {
      return;
    }

    int numPixels = pixelLocations.length;
    int ledAddress = 4;

    setPixelCount(numPixels);
    loadPixels();

    for (int i = 0; i < numPixels; i++) {
      int pixelLocation = pixelLocations[i];
      int pixel = pixels[pixelLocation];

      packetData[ledAddress] = (byte)(pixel >> 16);
      packetData[ledAddress + 1] = (byte)(pixel >> 8);
      packetData[ledAddress + 2] = (byte)pixel;
      ledAddress += 3;

      if (enableShowLocations) {
        pixels[pixelLocation] = 0xFFFFFF ^ pixel;
      }
    }

    writePixels();

    if (enableShowLocations) {
      updatePixels();
    }
  }

  // Change the number of pixels in our output packet.
  // This is normally not needed; the output packet is automatically sized
  // by draw() and by setPixel().
  public void setPixelCount(int numPixels)
  {
    int numBytes = 3 * numPixels;
    int packetLen = 4 + numBytes;
    if (packetData == null || packetData.length != packetLen) {
      // Set up our packet buffer
      packetData = new byte[packetLen];
      packetData[0] = (byte)0x00;              // Channel
      packetData[1] = (byte)0x00;              // Command (Set pixel colors)
      packetData[2] = (byte)(numBytes >> 8);   // Length high byte
      packetData[3] = (byte)(numBytes & 0xFF); // Length low byte
    }
  }

  // Directly manipulate a pixel in the output buffer. This isn't needed
  // for pixels that are mapped to the screen.
  public void setPixel(int number, int c)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      setPixelCount(number + 1);
    }

    packetData[offset] = (byte) (c >> 16);
    packetData[offset + 1] = (byte) (c >> 8);
    packetData[offset + 2] = (byte) c;
  }

  // Read a pixel from the output buffer. If the pixel was mapped to the display,
  // this returns the value we captured on the previous frame.
  public int getPixel(int number)
  {
    int offset = 4 + number * 3;
    if (packetData == null || packetData.length < offset + 3) {
      return 0;
    }
    return (packetData[offset] << 16) | (packetData[offset + 1] << 8) | packetData[offset + 2];
  }

  // Transmit our current buffer of pixel values to the OPC server. This is handled
  // automatically in draw() if any pixels are mapped to the screen, but if you haven't
  // mapped any pixels to the screen you'll want to call this directly.
  public void writePixels()
  {
    if (packetData == null || packetData.length == 0) {
      // No pixel buffer
      return;
    }
    if (output == null) {
      return;
    }

    try {
      output.write(packetData);
    } catch (Exception e) {
      dispose();
    }
  }

  public void dispose()
  {
    // Destroy the socket. Called internally when we've disconnected.
    // (Thread continues to run)
    if (output != null) {
      println("Disconnected from OPC server");
    }
    socket = null;
    output = pending = null;
  }

  public void run()
  {
    // Thread tests server connection periodically, attempts reconnection.
    // Important for OPC arrays; faster startup, client continues
    // to run smoothly when mobile servers go in and out of range.
    for(;;) {

      if(output == null) { // No OPC connection?
        try {              // Make one!
          socket = new Socket(host, port);
          socket.setTcpNoDelay(true);
          pending = socket.getOutputStream(); // Avoid race condition...
          println("Connected to OPC server");
          sendColorCorrectionPacket();        // These write to 'pending'
          sendFirmwareConfigPacket();         // rather than 'output' before
          output = pending;                   // rest of code given access.
          // pending not set null, more config packets are OK!
        } catch (ConnectException e) {
          dispose();
        } catch (IOException e) {
          dispose();
        }
      }

      // Pause thread to avoid massive CPU load
      try {
        Thread.sleep(500);
      }
      catch(InterruptedException e) {
      }
    }
  }
}
class RectSplitAnimation extends AbstractSplitAnimation implements AudioReactiveAnimationInterface{

  protected PVector[] blocks;
  protected float offset;
  RectSplitAnimation(PVector[] blocks){
     this.blocks = blocks;
     this.offset = mm.SPACING/2;
 }


  public void displayFrame(FFT fft){
    background(0);
    float posX = 0;
    stroke(255);
    noFill();
    strokeWeight(mm.SPACING*0.75f);



    for(int i = 0; i <blocks.length; i++){
        PVector block = blocks[i];
        float blockW = block.x * mm.CRATE_W * mm.SPACING - mm.SPACING;
        float blockH = block.y * mm.CRATE_H * mm.SPACING - mm.SPACING;

        drawRect(offset+posX, offset*2, blockW, blockH, fft);
        posX += block.x * mm.CRATE_W * mm.SPACING;


    }
  }

  protected void drawRect(float x, float y, float w, float h, FFT fft){
      pushMatrix();
      rectMode(CENTER);
      translate(x+w/2,y+h/2);

      fill(255- 255*fft.getBand(40));

      float tmpW = w;
      float tmpH = h;
      w = constrain(w/(fft.getBand(40)+1), 0, w+offset);
      h = constrain(h/(fft.getBand(40)+1), 0, h+offset);
      stroke(map(w*h, 0, tmpW*tmpH, 0, 360), 255, 255);

      rect(0,0,w,h);


      popMatrix();
      rectMode(CORNER);
      noStroke();
  }

}
class Rings implements AudioReactiveAnimationInterface {

  private float seed = 0.001f;
  
  public void displayFrame(FFT fft) {
    background(0);
    stroke(145, 255,200);
    strokeWeight(30);
    noFill();
    for (int i = 0; i < 1200; i+=150) {
      float d = fft.getBand(i)*20;
      // println(d);
      ellipse(noise(seed, d)*width, map(d,0, 180, height, 0), d, d);
      seed+=0.002f;
    }
    noStroke();
  }
}
class SineWaveShader extends AbstractShaderAnimation {


  SineWaveShader(String shaderFile){
     super(shaderFile);
  }


  protected void setAdditionalParams(FFT fft) {
    shader.set("colorMult", constrain(fft.getBand(100), 0.5f, 1), constrain(fft.getBand(300), 0.5f, 2)); // 10 -> 100
    /*
    shader.set("coeffx", constrain(fft.getBand(60)*10, 10, 50)); // 20 -> 80
    shader.set("coeffy", constrain(fft.getBand(800), 0, 90)); // 0 -> 100
    shader.set("coeffz", constrain(fft.getBand(600)*10, 1, 200)); // 0 -> 100
    */
    shader.set("coeffx", fft.getBand(4)*9); // 20 -> 80
    shader.set("coeffy", fft.getBand(800)*70.0f); // 0 -> 100
    shader.set("coeffz", fft.getBand(600)*40); // 0 -> 100
  }
}
  public void settings() {  size(480, 500, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "MatrixAnimation" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

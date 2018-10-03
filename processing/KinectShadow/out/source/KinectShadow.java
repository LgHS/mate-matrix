import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.openkinect.processing.*; 
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

public class KinectShadow extends PApplet {



Kinect kinect;

OPC opc;
MateMatrix mm;

PShader shader;
PGraphics pg;
float minThresh = 0;
float maxThresh = 800;
PImage cam;
float t = 0;
int nbCratesX = 6;
int nbCratesY = 5;

int kinectFill = -1;

int occupation = 0;

public void settings() {
  int w = nbCratesX * mm.CRATE_W * mm.SPACING;
  int h = nbCratesY * mm.CRATE_H * mm.SPACING;
  size(w, h, P3D);
}

public void setup() {
  kinect = new Kinect(this);
  frameRate(400);

  kinect.initDepth();
  kinect.enableMirror(true);

  cam = createImage(kinect.width, kinect.height, RGB);
  pg = createGraphics(width, height, P3D);
  shader = loadShader("simple.glsl");
  colorMode(HSB, 360,255,255);

  opc = new OPC(this, "127.0.0.1", 7890);
  //opc.setDithering(false);
  //opc.setInterpolation(false);  
  // Set up your LED mapping here
  mm = new MateMatrix(this, opc, 6, 5);
  mm.init();
}

PImage third;

public void draw() {
  //background(130, 100);
  surface.setTitle(frameRate + "fps");
  occupation = 0;

  cam.loadPixels();

  minThresh = map(mouseX, 0, width, 0, 2048);
  maxThresh = map(mouseY, 0, height, 0, 2048);

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
  
  // shader
  shader.set("time", millis() * 0.001f);
  shader.set("occupation", occupationRatio);
  shader.set("cam", cam.get()); 
  shader.set("res", kinect.width*1.0f, kinect.height*1.0f);
  //shader.set("freq0", abs(sin(millis()*0.0001)));  
  
  pg.beginDraw();
  pg.shader(shader);
  //fill(degrees(abs(TWO_PI * sin(frameCount * 0.0002))), 150, 255);
  pg.rect(0, 0, width, height);
  pg.endDraw();

  //tint(255, 127);
  //pg.blend(cam, 0, 0, width, height, 0, 0, width, height, SUBTRACT);
  //image(img, 0, 0);  
  
  image(pg, 0, 0);
  //fill(0,100);
  //rect(0,0, width, height);
  
  fill(255);
  textSize(32);
  text(minThresh + " " + maxThresh, 20, 20);
  
}

public void exit() {
  background(0);
  super.exit();
}
  class MateMatrix {

  private OPC opc;
  
  private float offset;
  private PApplet applet;

  private int cols = 6;
  private int rows = 4;
  public static final int SPACING = 20;
  public static final int PIXELS_PER_CRATE = 20;
  public static final int CRATE_H = 5;
  public static final int CRATE_W = 4;

  public MateMatrix(PApplet applet, OPC opc) {
    this(applet, opc, 6, 4);
  }
  public MateMatrix(PApplet applet, OPC opc, int cols, int rows) {
    this.opc = opc;    
    this.applet = applet;
    this.cols = cols;
    this.rows = rows;
    
    offset = PApplet.parseInt (SPACING*2);
  }

  public void init() {
    
    float crateWidth = SPACING * 4;

    for (int y = 0; y < rows; y++) {
      // in OPC led grids position x,y are their centers. We have to distribute centers over the height of the sketch
      float posY = applet.height / 2 + (SPACING * CRATE_H/2 * (-(rows-1) + y * 2));
      for (int x = 0; x < cols; x++) {
        int index = y * cols * PIXELS_PER_CRATE + x * PIXELS_PER_CRATE;
        float posX = offset  + crateWidth * x;
        opc.ledGrid(index, CRATE_W, CRATE_H, posX, posY, SPACING, SPACING, 0, true, false);
      }
    }
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "KinectShadow" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

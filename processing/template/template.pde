// This is an empty Processing sketch with support for Fadecandy.

OPC opc;
MateMatrix mm;
float t = 0;
void setup()
{
  size(480, 400);
  opc = new OPC(this, "127.0.0.1", 7890);
  //opc.setDithering(false);
  //opc.setInterpolation(false);  
  // Set up your LED mapping here
  mm = new MateMatrix(this, opc);
  mm.init();
  rectMode(CENTER);
  frameRate(200);
  colorMode(HSB);
  textSize(80);
}

void draw()
{
  background(0);
  
   fill(abs(sin(t))*360, 255, 255);
   ellipse(mouseX, mouseY, 20,20);
}

void exit(){
 background(0);
 super.exit();
}

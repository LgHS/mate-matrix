// This is an empty Processing sketch with support for Fadecandy.

OPC opc;
MateMatrix mm;

void setup()
{
  size(600, 300);
  opc = new OPC(this, "127.0.0.1", 7890);

  // Set up your LED mapping here
  mm = new MateMatrix(this, opc);
  mm.init();
}

void draw()
{
  background(0);

  // Draw each frame here
}

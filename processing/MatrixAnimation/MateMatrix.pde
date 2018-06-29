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
    
    offset = int (SPACING*2);
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

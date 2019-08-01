/**
  Manages pixel mapping to OPC via the @Scanlime class
**/
class MateMatrix {

  private OPC opc;

  private PApplet applet;
  private float offset;
  private float crateWidth;
  private float crateHeight;
  private int posX = 0;
  private int posY = 0;
  private boolean enabled;

  private int[] pixelLocationsTmp;

  // config
  private int spacing;
  private int nbCrates;
  private int pixelsPerCrate;
  private int crateW;
  private int crateH;
  private int rows;
  private int cols;
  private boolean zigzag;
  private JSONObject config;

  public MateMatrix(PApplet applet, OPC opc, JSONObject _config){
    this.opc = opc;
    this.applet = applet;

    config = _config;

    spacing = config.getInt("spacing");
    nbCrates = config.getInt("nbCrates");
    pixelsPerCrate = config.getInt("pixelsPerCrate");
    crateW = config.getInt("crateW");
    crateH = config.getInt("crateH");
    rows = config.getInt("rows");
    cols = config.getInt("cols");
    zigzag = config.getBoolean("zigzag");

    offset = spacing * 2;
    crateWidth = spacing * crateW;
    crateHeight = spacing * crateH;
  }

  public void init() {
    init(0, 0, cols);
  }

  public void init(int indexOffset, int offsetX, int _cols) {
    println(indexOffset);
    for (int y = 0; y < rows; y++) {
      // in OPC led grids position x,y are their centers. We have to distribute centers over the height of the sketch
      float posY = applet.height / 2 + (spacing * crateH/2 * (-(rows-1) + y * 2));

      for (int x = 0; x < _cols; x++) {
        int index = y * _cols * pixelsPerCrate + x * pixelsPerCrate;
        if (zigzag) {
          if (y % 2 == 1){
            index = (y + 1) * _cols * pixelsPerCrate - (x+1) * pixelsPerCrate;
          }
        }

        float posX = (crateWidth * offsetX) + offset + crateWidth * x;

        opc.ledGrid(indexOffset + index, crateW, crateH, posX, posY, spacing, spacing, 0, true, false);
      }
    }
    enabled = true;
  }

  public void initMultiblock() {
   JSONArray blocks = config.getJSONArray("blocks");
   //int index = 0;
   for(int i = 0; i < blocks.size(); i++){
       JSONObject block = blocks.getJSONObject(i);
       int blockRows = block.getInt("rows");
       int blockCols = block.getInt("cols");
       int offsetX = blockCols * i;
       int ledIndex = blockRows * blockCols * 20 * i; // TODO change 20 to crate rows * crate cols

       init(ledIndex, offsetX, blockCols);
   }
  }


  float getCrateWidth() {
     return crateWidth;
  }

  float getCrateHeight() {
     return crateHeight;
  }

  public int getSpacing() {
    return spacing;
  }

  public int getNbCrates() {
    return nbCrates;
  }

  public int getPixelsPerCrate() {
    return pixelsPerCrate;
  }

  public int getCrateW() {
    return crateW;
  }

  public int getCrateH() {
    return crateH;
  }

  public int getRows() {
    return rows;
  }

  public int getCols() {
    return cols;
  }
}

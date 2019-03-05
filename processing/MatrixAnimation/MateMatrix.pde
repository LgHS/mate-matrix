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

  public MateMatrix(PApplet applet, OPC opc, JSONObject config){
    this.opc = opc;
    this.applet = applet;

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
    for (int y = 0; y < rows; y++) {
      // in OPC led grids position x,y are their centers. We have to distribute centers over the height of the sketch
      float posY = applet.height / 2 + (nbCrates * crateH/2 * (-(rows-1) + y * 2));

      for (int x = 0; x < cols; x++) {
        int index = y * cols * pixelsPerCrate + x * pixelsPerCrate;
        if (zigzag) {
          if (y % 2 == 1){
            index = (y + 1) * cols * pixelsPerCrate - (x+1) * pixelsPerCrate;          
          }
        }
        
        float posX = offset + crateWidth * x;
       
        opc.ledGrid(index, crateW, crateH, posX, posY, nbCrates, nbCrates, 0, true, false);
      }
    }
    enabled = true;
  }


  public void initMicroFest(){
    for(int y = 0; y < rows; y++){
      float posY  = applet.height / 2 + (spacing * crateH/2 * (-(rows-1) + y * 2));
      println(posY);
      for(int x = 0; x < cols; x++){
        int index = y * cols * pixelsPerCrate + x * pixelsPerCrate;
        float posX = offset + crateWidth * x;
        print("\tx:"+posX);
        opc.ledGrid(index, crateW, crateH, posX, posY, spacing, spacing, 0, true, false);
      }
      println();
    }
  }

  public void initMultiblock(JSONObject config){
    JSONArray blocks = config.getJSONArray("blocks");

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
            if (position.equals("right")) {
                // right edge - 2 * crateWidth + x * crateWidth
                posX = width - cols*crateWidth + x * crateWidth;

            } else if (position.equals("center")) {
              posX  = width/2 - (cols*crateWidth)/2 + crateWidth * x +crateWidth /4;
            } else if (position.equals("left")) {
            //   posX = crateWidth/2 + crateWidth * x ;
            }

            print("\t posX: "+posX);
            opc.ledGrid(index, crateW, crateH, posX, posY, spacing, spacing, 0, true, false);
            index+=20;
          }

          println();
        }
        printArray(opc.pixelLocations);
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

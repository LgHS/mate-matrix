/**
  Manages pixel mapping to OPC via the @Scanlime class
**/
class MateMatrix {

  private OPC opc;

  private float offset;
  private PApplet applet;
  private float crateWidth;
  private int cols = 9;
  private int rows = 5;
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

    offset = int (SPACING*2);
  }
  public MateMatrix(PApplet applet, OPC opc, int cols,int rows, int posX, int posY){
    this(applet, opc, cols, rows);
    this.posX = posX;
    this.posY = posY;

  }

  public void init(){
    init(false, false);
  }
  
  /**
    * 
    * The mapping between the display and the physical matrix
    *
    * @param boolean zigzag agencement of the crates (true : one row left to right and the other right to left)
    * 
   **/ 
  public void init(boolean zigzag, boolean reverse) {

    crateWidth = SPACING * 4;

    for (int y = 0; y < rows; y++) {
      // in OPC led grids position x,y are their centers. We have to distribute centers over the height of the sketch
      float posY = applet.height / 2 + (SPACING * CRATE_H/2 * (-(rows-1) + y * 2));

      for (int x = 0; x < cols; x++) {
        int index = y * cols * PIXELS_PER_CRATE + x * PIXELS_PER_CRATE;
        if(zigzag){
          if(y % 2 == 1){
            index = (y + 1) * cols * PIXELS_PER_CRATE - (x+1) * PIXELS_PER_CRATE ;          
          }
        }
        
        if (reverse) {
          float posX = applet.width - (offset + crateWidth * x);
        } else {
          float posX = offset + crateWidth * x;
        }
       
        opc.ledGrid(index, CRATE_W, CRATE_H, posX, posY, SPACING, SPACING, 0, true, false);
       // do I need to change last param (flip) ?
        //opc.ledGrid(index, CRATE_W, CRATE_H, posX, posY, SPACING, SPACING, 0, true, reverse);
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
  float getCrateWidth(){
     return crateWidth;
  }

}

import java.util.Arrays;

class DMXEffectsManager {
  private OPC opc;
  private int pixelCount;
  private color mainColor = color(0,0,0);
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
      color col = rgbForDMXChannels(
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
      color c = rgbForDMXChannels(DMXMapping.FRONT_LEFT_R, DMXMapping.FRONT_LEFT_G, DMXMapping.FRONT_LEFT_B);

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
        color  pixelColor = 255 << 24 | int(colors[i*3]) << 16 | int(colors[i*3+1]) << 8 | int(colors[i*3+2]);
        opc.setPixel(i*20+j, pixelColor );
      }

    }
  }

  void setMainColor(){
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

    color c = getDMXIntValue(DMXMapping.FULL_ON) << 24 | getDMXIntValue(DMXMapping.FULL_R) << 16 | getDMXIntValue(DMXMapping.FULL_G) << 8 | getDMXIntValue(DMXMapping.FULL_B);
    if(c == 0){
      c = mainColor;
    }

    for(int p = 0; p < pixelCount; p++){
      opc.setPixel(p, c);
    }
  }

  color rgbForDMXChannels(int r, int g, int b, int a){
    return colorFromValues(
        getDMXIntValue(r),
        getDMXIntValue(g),
        getDMXIntValue(b),
        a
      );

  }
  color rgbForDMXChannels(int r, int g, int b){
    return colorFromValues(
        getDMXIntValue(r),
        getDMXIntValue(g),
        getDMXIntValue(b),
        255
      );
  }
  // util function that returns a color from 4 bytes
  color colorFromValues(byte r, byte g, byte b, byte a){
    return colorFromValues(int(r), int(g), int(b), int(a));

  }
  color colorFromValues(int r, int g, int b, int a){
    color c = a << 24 | r << 16 | g << 8 | b;
    return c;
  }


  color HSBFromHue(byte h){
    return colorFromValues(h, (byte)(0XFF), (byte)(0xFF), (byte)(0xFF));
  }

// beware of the duplicate code !!
  byte getDMXValue(int channel ){
    // BE CAREFUL : first dmx channel is at index 6, last being 518
    return dmxMessage[messageOffset + channel];
  }
  int getDMXIntValue(int channel){
    return int(getDMXValue(channel));
  }
}

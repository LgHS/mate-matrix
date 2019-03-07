import java.util.Arrays;

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

  void show(){

    em.applyEffect(dmxMessage);
    opc.writePixels();
  }

  void manageMessage(Serial dmxSerial){

    try{
      dmxSerial.readBytes(dmxMessage);

      // check start sequence
      if (dmxMessage[0] == (byte)(0x7E)) {

        // if message label == 5 (dmx received)
        if (dmxMessage[1] == 5) {

          // lastDMX[2] & lastDMX[3] are the size of the message
          int msgLength = dmxMessage[2] << 8 | int(dmxMessage[3]);
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

  boolean isActive(){
    return mode != 0;
  }

  void setMode(int mode){
    this.mode = mode;
  }

  int getAnimationSelector(){

    return getDMXIntValue(DMXMapping.ANIM_SELECTION);
  }
  boolean getRandomAnim(){
    return getDMXIntValue(DMXMapping.RANDOM_ANIM) == 255;
  }

  byte getDMXValue(int channel ){
    // BE CAREFUL : first dmx channel is at index 6, last being 518
    return dmxMessage[messageOffset + channel];
  }
  int getDMXIntValue(int channel){
    return int(getDMXValue(channel));
  }

}

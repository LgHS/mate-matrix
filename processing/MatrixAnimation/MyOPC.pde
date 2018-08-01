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

class CratesAnimation implements AudioReactiveAnimationInterface {
  int x=0;
  int y = 0;
  public void displayFrame(FFT fft) {
    background(0);
    noStroke();
    if (random(10)>4) {
      float hue = map(x+y*frameCount%110, 0, 260, 110 , 330);
      fill(hue, 255, 200);
   
    } else {
      fill(0);
    }
    int posX = x * mm.getSpacing() * mm.getCrateW();
    int posY = y*mm.getSpacing() * mm.getCrateH();
    pushMatrix();
    
    translate(posX, posY);
   // rotate(TWO_PI*fft.getBand(400));
    //scale(fft.getBand(200));
    
    rect(0, 0 , mm.getCrateW() * mm.getSpacing(), mm.getCrateH() * mm.getSpacing());
    popMatrix();
    
    x++;
    y++;

    if (x > mm.getCols()) x=0;
    if (y> mm.getRows()) y=0;
  }
}

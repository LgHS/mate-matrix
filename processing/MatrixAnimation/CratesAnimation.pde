class CratesAnimation implements AudioReactiveAnimationInterface {
  int x=0;
  int y = 0;
  public void displayFrame(FFT fft) {
    
    noStroke();
    if (random(10)>4) {
      float hue = map(x+y*frameCount%110, 0, 260, 110 , 330);
      fill(hue, 255, 200);
   
    } else {
      fill(0);
    }
    int posX = x*mm.SPACING*mm.CRATE_W;
    int posY = y*mm.SPACING*mm.CRATE_H;
    pushMatrix();
    
    translate(posX, posY);
   // rotate(TWO_PI*fft.getBand(400));
    //scale(fft.getBand(200));
    
    rect(0, 0 , mm.CRATE_W*mm.SPACING, mm.CRATE_H*mm.SPACING);
    popMatrix();
    
    x++;y++;
    if(x > mm.cols)x=0;
    if(y> mm.rows)y=0;
  }
}

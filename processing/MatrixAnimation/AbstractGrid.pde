abstract class AbstractGrid implements AudioReactiveAnimationInterface{
  protected FFT fft;
  protected float offset;
  void displayFrame(FFT fft){
    this.fft = fft;
    background(0);

    noFill();
    stroke(255);
    colorMode(HSB);


    offset  = mm.SPACING/2;
    // hook
    changeDesignElements();

    for(int x = 0; x < mm.cols; x++){
      for(int y = 0; y < mm.rows; y++){
        float posX = offset+x*mm.CRATE_W*mm.SPACING;
        float posY = offset*2 + y * mm.CRATE_H*mm.SPACING;
        drawCrate(posX, posY, (mm.CRATE_W-1)*mm.SPACING+1, (mm.CRATE_H-1)*mm.SPACING+1 );
      }


    }

  }
  /** this is the hook to implement if we want to draw in each cell**/
  abstract protected void drawCrate(float x, float y, float w, float h);
  abstract protected void changeDesignElements();
}

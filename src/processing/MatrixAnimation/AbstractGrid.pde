abstract class AbstractGrid implements AudioReactiveAnimationInterface{
  protected FFT fft;
  protected float offset;
  void displayFrame(FFT fft){
    this.fft = fft;
    background(0);

    noFill();
    stroke(255);
    colorMode(HSB);


    offset  = mm.getSpacing() / 2;
    // hook
    changeDesignElements();

    for(int x = 0; x < mm.getCols(); x++){
      for(int y = 0; y < mm.getRows(); y++){
        float posX = offset+x*mm.getCrateW() * mm.getSpacing();
        float posY = offset*2 + y * mm.getCrateH() * mm.getSpacing();
        drawCrate(posX, posY, (mm.getCrateW() - 1) * mm.getSpacing() + 1, (mm.getCrateH() - 1) * mm.getSpacing() + 1);
      }


    }

  }
  /** this is the hook to implement if we want to draw in each cell**/
  abstract protected void drawCrate(float x, float y, float w, float h);
  abstract protected void changeDesignElements();
}

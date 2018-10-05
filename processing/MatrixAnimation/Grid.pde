class Grid extends AbstractGrid{
  public void drawCrate(float x, float y,float w, float h ) {
    pushMatrix();
    translate(x-mm.SPACING, y-mm.SPACING*1.5);
    stroke(80*noise(millis()*0.01)*fft.spectrum[4]*10, 255,255);
    if(millis() % 1000 < 400){
      float posY = mm.SPACING;
      line(mm.SPACING, posY, w*.75, posY );
      line(-mm.SPACING, 4*posY, w*.75, 4*posY );
    }else{
      
      rect(mm.SPACING, mm.SPACING, w, h);
    }
    popMatrix();
  }

  protected void changeDesignElements(){
    strokeWeight(3.5* fft.spectrum[6] *30);
  }
}

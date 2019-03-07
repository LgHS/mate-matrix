class Grid extends AbstractGrid{
  public void drawCrate(float x, float y,float w, float h ) {
    pushMatrix();
    translate(x-mm.getSpacing(), y-mm.getSpacing()*1.5);
    stroke(80*noise(millis()*0.01)*fft.spectrum[4]*10, 255,255);
    if(millis() % 1000 < 400){
      float posY = mm.getSpacing();
      line(mm.getSpacing(), posY, w*.75, posY );
      line(-mm.getSpacing(), 4*posY, w*.75, 4*posY );
    }else{
      
      rect(mm.getSpacing(), mm.getSpacing(), w, h);
    }
    popMatrix();
  }

  protected void changeDesignElements(){
    strokeWeight(3.5* fft.spectrum[6] *30);
  }
}

class Grid extends AbstractGrid{
  public void drawCrate(float x, float y,float w, float h ) {
    pushMatrix();
    translate(x-mm.SPACING, y-mm.SPACING*1.5);
    stroke(240*noise(millis()*0.01)*fft.spectrum[4]*10, 255,255);
    if(millis() % 1000 < 400){
      float posY = mm.SPACING;
      float xOffset = abs(sin(millis()))*8*mm.SPACING;
      //line(mm.SPACING, posY, w*.75, posY );
      //line(mm.SPACING*3, 4*posY, mm.SPACING*2+w*.75, 4*posY );
      line(xOffset+mm.SPACING, posY, xOffset+w*.75, posY );
      line(xOffset+mm.SPACING*3, 4*posY, xOffset+mm.SPACING*2+w*.75, 4*posY );
    }else{
      
      rect(mm.SPACING, mm.SPACING, w, h);
    }
    popMatrix();
  }

  protected void changeDesignElements(){
    strokeWeight(3.5* fft.spectrum[6] *30);
  }
}

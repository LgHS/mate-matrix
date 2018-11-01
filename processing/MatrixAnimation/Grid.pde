class Grid extends AbstractGrid{
  public void drawCrate(float x, float y,float w, float h ) {
    
    pushMatrix();
    translate(x-mm.SPACING, y-mm.SPACING*1.5);
    println(fft.getScaledBand(2));
    if(fft.getScaledBand(2)>8){
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
    strokeWeight(1.5* fft.getScaledBand(6));
    
    stroke(130+noise(millis()*0.01)*fft.getScaledBand(4)*.5, 255,255);
    
  }
}

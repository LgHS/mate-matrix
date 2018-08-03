class Grid extends AbstractGrid{
  public void drawCrate(float x, float y,float w, float h ) {
    pushMatrix();
    translate(x, y);
    stroke(120+fft.getBand(250)*10, 255,255);
    if(millis() % 1000 < 5){
    }else{
      
      rect(sin(fft.getBand(20)*10)*3*mm.SPACING,mm.SPACING*fft.getBand(200), w, h*sin(fft.getBand(150)));
    }
    popMatrix();
  }

  protected void changeDesignElements(){
    strokeWeight(1.5*fft.getAvg(30) );
  }
}

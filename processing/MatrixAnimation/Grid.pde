class Grid extends AbstractGrid{
  public void drawCrate(float x, float y,float w, float h ) {
    pushMatrix();
    translate(x, y);

    rect(0,0, w, h  );
    popMatrix();
  }

  protected void changeDesignElements(){
    strokeWeight(3*fft.getAvg(30) );
  }
}

class Grid implements AudioReactiveAnimationInterface{

  void displayFrame(FFT fft){

    background(0);

    noFill();
    stroke(255);
    colorMode(HSB);
    strokeWeight(0.3+3*fft.getBand(80) );
    int offset  = mm.SPACING/2;
    for(int x = 0; x < mm.cols; x++){
      for(int y = 0; y < mm.rows; y++){
          pushMatrix();
          translate(offset+x*4*mm.SPACING, offset*2 + y * mm.CRATE_H*mm.SPACING);

          rect(0,0, (mm.CRATE_W-1)*mm.SPACING+1, (mm.CRATE_H-1)*mm.SPACING+1);
          popMatrix();
      }


    }
    
  }
}

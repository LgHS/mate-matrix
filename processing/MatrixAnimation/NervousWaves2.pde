// stolen from https://www.openprocessing.org/sketch/153224
class NervousWaves2 implements AudioReactiveAnimationInterface {
  private float t = 0;
  
  
  NervousWaves2() {
    
  }
  public void displayFrame(FFT fft) {
    float fc = frameCount * 0.2;
    background(fc%240, 255,255);
    //background(140, 255, 255);
    //fill(frameCount%360, 200, 200);
    stroke(0);
    

    for (int x = 10; x < width; x += 10) {
      for (int y = 10; y < height; y += 10) {
        float n = noise((x % t)*0.5, fft.spectrum[10], y*fft.spectrum[10]);
        pushMatrix();
        translate(x, y);
        rotate(TWO_PI * n);
        scale(fft.spectrum[35]*y);
        fill(0);
        rect(-1, -1, 1, 1);
        
        popMatrix();
      }
    }
    t+=0.1*fft.spectrum[2]*2;
  }
}

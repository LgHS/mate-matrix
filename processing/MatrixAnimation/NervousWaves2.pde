// stolen from https://www.openprocessing.org/sketch/153224
class NervousWaves2 implements AudioReactiveAnimationInterface {
  private float t = 0;
  
  
  NervousWaves2() {
    
  }
  public void displayFrame(FFT fft) {
    float fc = frameCount * 0.06;
    background(frameCount%360, 255, 255);
    //background(140, 255, 255);
    //fill(frameCount%360, 200, 200);

    for (int x = 10; x < width; x += 10) {
      for (int y = 10; y < height; y += 10) {
        float n = noise((x % t)*5, y * 0.5, fft.getBand(x+y*10));
        pushMatrix();
        translate(x, y);
        rotate(TWO_PI * n);
        scale(3.5 * n);
        //fill(fft.getBand(100)%255);
        rect(0.5, 0, 2, 1);
        
        popMatrix();
      }
    }
    t+=0.1;
  }
}

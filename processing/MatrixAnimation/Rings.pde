class Rings implements AudioReactiveAnimationInterface {

  private float seed = 0.001;
  
  public void displayFrame(FFT fft) {
    background(0);
    stroke(145, 255,200);
    strokeWeight(30);
    noFill();
    for (int i = 0; i < 1200; i+=150) {
      float d = fft.getBand(i)*20;
      // println(d);
      ellipse(noise(seed, d)*width, map(d,0, 180, height, 0), d, d);
      seed+=0.002;
    }
    noStroke();
  }
}

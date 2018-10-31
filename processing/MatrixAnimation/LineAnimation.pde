class LineAnimation implements AudioReactiveAnimationInterface {

  float t = 0.003;
  Amplitude ampl;
  LineAnimation(Amplitude ampl) {
    this.ampl = ampl;
  }
  public void displayFrame(FFT fft) {
    background(0,200);
    stroke(255);
    strokeWeight(10);

    // println(in.mix.level());
    float h = abs(sin(t))*height;
    float w = abs(cos(t))*width;
    //stroke(map(h,0,height, 0, 130),255,255);
    stroke(255);
    line(0, h, width, h);
    //stroke(map(w,0,width, 160, 360),255,255);
    stroke(255);
    line(w, 0, w, height);
    line(width-w, 0, width-w, height);
    t+=fft.getBand(6)*0.4;
    
    strokeWeight(1);
  }
}

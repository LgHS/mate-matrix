class LineAnimation implements AudioReactiveAnimationInterface {

  float t = 0.003;
  AudioInput in;
  LineAnimation(AudioInput in) {
    this.in = in;
  }
  public void displayFrame(FFT fft) {
    background(0,200);
    stroke(255);
    strokeWeight(18);
    for (int i = 0; i < in.mix.level()*50; i++){
      // println(in.mix.level());
      float h = abs(sin(t))*height+0.3*i;
      float w = abs(cos(t))*width+0.3*i;
      //stroke(map(h,0,height, 0, 130),255,255);
      stroke(255);
      line(i*20, h, width-i*20, h);
      //stroke(map(w,0,width, 160, 360),255,255);
      stroke(255);
      line(w, i*20, w, height-i*20);
      t+=0.003;
    }
    strokeWeight(1);
  }
}

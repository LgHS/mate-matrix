 // stolen from https://www.openprocessing.org/sketch/514836
class BreathingLines implements AudioReactiveAnimationInterface {
  int numLines = 24;
  float theta = 0;
  AudioInput in;
  BreathingLines(AudioInput in){
    this.in = in;
  }
  public void displayFrame(FFT fft) {
    background(0);
    stroke(255);
    fill(255);
    strokeCap(PROJECT);
    //line(width/2, height/4, width/2, 3*height/4);
    //int frame = (int) (30 * sin(theta));
    for (int i = 0; i < numLines; i++) {
      float x = (i+1) * ((float) width/(numLines+1));
      float distFromCenter = dist(x, 0, width/2, 0);
      float waveOffset = map(distFromCenter, 0, width/2, 0, 100);
      float wave = 20 * sin((HALF_PI)* sin((-frameCount + waveOffset) / 40.0)) + 20;
      strokeWeight(abs(wave));
      stroke(wave*3, 200, 255);
      line(x, 0, x, height/2 );
      stroke(wave, 200, 255);
      line(x, height/2, x, height );
    }

    theta+= PI/60;
  }
}

class Logo implements AudioReactiveAnimationInterface {
  PImage logo;
  AudioInput in;
  float t = 0.1;
  float scale = 1.2;
  
  PVector pos;
  PVector velocity;
  
  BeatDetect beat;
  
  Logo(AudioInput in) {
    logo = loadImage("fesses.png");
    this.in = in;
    beat = new BeatDetect();
    pos = new PVector(width/2, height/2);
    velocity = new PVector(2,0);
  }
  public void displayFrame(FFT fft) {
    imageMode(CENTER);
    background(abs(sin(fft.getBand(60))*200));
    if(beat.isOnset()) scale = 1.2;
    //scale(0.8);
    image(logo, pos.x, pos.y);
    //fft.getBand(20), fft.getBand(40);  
    
    
    if(pos.x > width - logo.width/2 || pos.x < logo.width/2){
      velocity.x *= -1;
    }
    
    
    pos.add(velocity);
    t+=0.1;
  }
}

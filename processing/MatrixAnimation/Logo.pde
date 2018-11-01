
class Logo implements AudioReactiveAnimationInterface {
  PImage logo;
  Amplitude ampl;
  float t = 0.1;
  float scale = 1.2;
  
  PVector pos;
  PVector velocity;
  
  
  
  Logo(Amplitude ampl) {
    logo = loadImage("logoKikk.png");
    this.ampl = ampl;
    
    pos = new PVector(width/2, 0+logo.height/2 + 50);
    velocity = new PVector(2,0);
  }
  public void displayFrame(FFT fft) {
    imageMode(CENTER);
    background(abs(sin(fft.spectrum[2])*200));
    image(logo, pos.x, pos.y);
    //fft.getBand(20), fft.getBand(40);  
    
    
    if(pos.x > width - logo.width/2 || pos.x < logo.width/2){
      velocity.x *= -1;
    }
    
    
    pos.add(velocity);
    t+=0.1;
  }
}

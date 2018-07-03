class AnimationRunner {
  ArrayList<AudioReactiveAnimationInterface> anims = new ArrayList<AudioReactiveAnimationInterface>();
  int animIndex=0;
  long start = 0;
  int min = 60000;
  int[] durations = {5*min, 2*min, 2*min, 3*min, min/2, min*3, min*8};
  AudioInput in;
  FFT fft;

  AnimationRunner(AudioInput in, FFT fft) {
    anims.add(new MetaBallsAnimation());
    //anims.add(new NervousWaves2());
    anims.add(new LineAnimation(input));
    anims.add(new BreathingLines(input));
    anims.add(new MonjoriShader("monjori.glsl"));
    anims.add(new Logo(input));
    anims.add(new CratesAnimation());
    anims.add(new SineWaveShader("sinewave.glsl"));
    anims.add(new GenericShader("spiral.glsl"));
    this.in = in;
    this.fft = fft;
    start = millis();
  }

  public void run() {
    if (in.mix == null) {
      anims.get(5).displayFrame(fft);
    } else {
      fft.forward(in.mix);
      anims.get(animIndex).displayFrame(fft);
      
      
      if (millis() - start > (animIndex < durations.length ? durations[animIndex] : 10000)) {
        start = millis();
        animIndex = int(random(0, anims.size()));
      }
    }
  }
  // xxx duration should be in the Animation class
  private int getDuration(){
    return int(random(5000, 15000));
  }
  public void selectAnimation(){
    int index = int(random(0, anims.size()));
    selectAnimation(index);
  }
  public void selectAnimation(int i){
    if(i > anims.size() -1){
      i = 0;
    }  
    animIndex = i;
    
    start = millis();
  }
}

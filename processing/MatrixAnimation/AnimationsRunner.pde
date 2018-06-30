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
    anims.add(new MonjoriShader());
    anims.add(new Logo(input));
    anims.add(new CratesAnimation());
    anims.add(new SineWaveShader());
    this.in = in;
    this.fft = fft;
    start = millis();
  }

  public void run() {
    if (in.mix == null) {
      anims.get(5).displayFrame(fft);
    } else {
      fft.forward(in.mix);
      anims.get(1).displayFrame(fft);
      
      
      if (millis() - start > durations[animIndex]) {
        start = millis();
        animIndex = int(random(0, anims.size()));
      }
    }
  }
}

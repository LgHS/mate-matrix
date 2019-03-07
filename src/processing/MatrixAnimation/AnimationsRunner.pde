class AnimationRunner {
  ArrayList<AudioReactiveAnimationInterface> anims = new ArrayList<AudioReactiveAnimationInterface>();
  int animIndex=0;
  long start = 0;
  int sec = 1000;
 // int[] durations = {5*sec, 2*sec, 2*sec, 3*sec, sec/2, sec*3, sec*8};
  int[] durations = {};
  boolean auto=true;

  Amplitude ampl;
  FFT fft;
//  PVector[] blocks = new PVector[]{new PVector(3,3), new PVector(6,3), new PVector(3,3)}
  AnimationRunner(Amplitude ampl, FFT fft) {
    anims.add(new Grid());
    anims.add(new AudioReactiveShader("rainbow.glsl", new int[]{2, 12}));
    anims.add(new AudioReactiveShader("nebula.glsl", new int[]{2}));
    anims.add(new MetaBallsAnimation());
    //anims.add(new NervousWaves2());
    anims.add(new LineAnimation(ampl));
    anims.add(new BreathingLines(ampl));
    anims.add(new MonjoriShader("monjori.glsl"));
    // anims.add(new Logo(in));
    anims.add(new CratesAnimation());
    anims.add(new SineWaveShader("sinewave.glsl"));
    anims.add(new GenericShader("spiral.glsl"));
    anims.add(new AudioReactiveShader("sinewave2.glsl", new int[]{2}));

    // TODO : retrieve blocks configuration from json file
    anims.add(new RectSplitAnimation(new PVector[]{new PVector(2,5), new PVector(3,5), new PVector(2,5)}));
    this.ampl = ampl;
    this.fft = fft;
    start = millis();
  }

  public void run() {
    float volume = ampl.analyze();

    //if (volume < 0.06) {
      //anims.get(5).displayFrame(fft);
    //} else {
      fft.analyze();
      anims.get(animIndex).displayFrame(fft);

      if (auto) {
        if (millis() - start > (animIndex < durations.length ? durations[animIndex] : random(1000,5000))) {
          start = millis();
          animIndex = int(random(0, anims.size()));
        }
      }
    //}
  }
  // xxx duration should be in the Animation class
  private int getDuration() {
    return int(random(5000, 15000));
  }
  public void selectAnimation() {
    int index = int(random(0, anims.size()));
    selectAnimation(index);
  }
  public void selectAnimation(int i) {
    if (i > anims.size() -1) {
      i = 0;
    }
    animIndex = i;

    start = millis();
  }
  public void choseAnimFromDMX(int val){
    // if dmx fader is off no choice
    if(val == 0){
      return;
    }
    int animIndex = floor(map(val, 1, 255, 0, anims.size()));
    selectAnimation(animIndex);
  }

  public void toggleAutoMode() {
    auto = !auto;
    println("auto mode: ", auto?"enabled":"disabled");
  }
}

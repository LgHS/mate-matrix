class SineWaveShader extends AbstractShaderAnimation {


  SineWaveShader(String shaderFile){
     super(shaderFile);
  }


  protected void setAdditionalParams(FFT fft) {
    shader.set("colorMult", constrain(fft.spectrum[2]*15, 0.5, 1), constrain(fft.spectrum[10]*10, 0.5, 2)); // 10 -> 100
    /*
    shader.set("coeffx", constrain(fft.getBand(60)*10, 10, 50)); // 20 -> 80
    shader.set("coeffy", constrain(fft.getBand(800), 0, 90)); // 0 -> 100
    shader.set("coeffz", constrain(fft.getBand(600)*10, 1, 200)); // 0 -> 100
    */
    shader.set("coeffx", fft.spectrum[2]*9); // 20 -> 80
    shader.set("coeffy", fft.spectrum[10]*70.0); // 0 -> 100
    shader.set("coeffz", fft.spectrum[4]*40); // 0 -> 100
  }
}

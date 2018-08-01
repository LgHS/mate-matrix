class SineWaveShader extends AbstractShaderAnimation {

  
  SineWaveShader(String shaderFile){
     super(shaderFile);
  }


  protected void setAdditionalParams(FFT fft) {
    shader.set("colorMult", constrain(fft.getBand(100), 0.5, 5), constrain(fft.getBand(300), 0.5, 2.0)); // 10 -> 100
    shader.set("coeffx", constrain(fft.getBand(600)*100, 10, 50)); // 20 -> 80
    shader.set("coeffy", constrain(fft.getBand(800)*100, 0, 90)); // 0 -> 100
    shader.set("coeffz", constrain(fft.getBand(1000)*100, 1, 200)); // 0 -> 100
  }
}

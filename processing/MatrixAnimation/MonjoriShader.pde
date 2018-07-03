class MonjoriShader extends AbstractShaderAnimation {

  MonjoriShader(String shaderFile) {
    super(shaderFile);
  }

  protected void setAdditionalParams(FFT fft) {

    shader.set("graininess", constrain(fft.getBand(100)*20, 10, 100)); // 10 -> 100
    shader.set("pace", constrain(fft.getBand(600)*100, 20, 80)); // 20 -> 80
    shader.set("twist", constrain(fft.getBand(800)*100, 0, 100)); // 0 -> 100
  }
}

class MonjoriShader extends AbstractShaderAnimation {

  MonjoriShader(String shaderFile) {
    super(shaderFile);
  }

  protected void setAdditionalParams(FFT fft) {

    shader.set("graininess", constrain(fft.getBand(100)*820, 10, 3000)); // 10 -> 100
    shader.set("pace", constrain(fft.getBand(600)*100, 20, 800)); // 20 -> 80
    shader.set("twist", constrain(fft.getBand(800)*400, 0, 400)); // 0 -> 100
  }
}

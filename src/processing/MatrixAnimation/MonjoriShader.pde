class MonjoriShader extends AbstractShaderAnimation {

  MonjoriShader(String shaderFile) {
    super(shaderFile);
  }

  protected void setAdditionalParams(FFT fft) {

    shader.set("graininess", constrain(fft.spectrum[2]*3000, 10, 3000)); // 10 -> 100
    shader.set("pace", constrain(fft.spectrum[12]*800, 20, 800)); // 20 -> 80
    shader.set("twist", constrain(fft.spectrum[8]*400, 0, 400)); // 0 -> 100
  }
}

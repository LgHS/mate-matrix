class GenericShader extends AbstractShaderAnimation {

  GenericShader(String shaderFile) {
    //this.shader = loadShader(shaderFile);
    super(shaderFile);
  }
  public void displayFrame(FFT fft) {
    shader.set("time", (float) millis()/1000.0);
    shader.set("resolution", float(pg.width), float(pg.height));

    pg.beginDraw();
    pg.shader(shader);
    noStroke();
    pg.rect(0, 0, pg.width, pg.height);
    pg.endDraw();

    image(pg, 0, 0);
  }

  protected void setAdditionalParams(FFT fft) {
  }
}

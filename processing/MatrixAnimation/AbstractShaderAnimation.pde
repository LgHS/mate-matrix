abstract class AbstractShaderAnimation implements AudioReactiveAnimationInterface {
  protected PShader shader;
  protected PGraphics pg;

  AbstractShaderAnimation(String shaderFile) {
    shader = loadShader(shaderFile);
    pg = createGraphics(width, height, P3D);
  }
  public void displayFrame(FFT fft) {

    shader.set("time", (float) millis()/100.0);
    shader.set("resolution", float(pg.width), float(pg.height));
    setAdditionalParams(fft);
    pg.beginDraw();
    pg.shader(shader);
    pg.rect(0, 0, pg.width, pg.height);
    pg.endDraw();

    image(pg, 0, 0);
  }

  protected abstract void setAdditionalParams(FFT fft);
}

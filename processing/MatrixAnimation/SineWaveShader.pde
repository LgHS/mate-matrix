class SineWaveShader implements AudioReactiveAnimationInterface {
  PShader shader;
  PGraphics pg;
  SineWaveShader() {
    shader = loadShader("sinewave.glsl");
    pg = createGraphics(width, height, P3D);
  }
  public void displayFrame(FFT fft) {
    shader.set("time", (float) millis()/100.0);
    shader.set("resolution", float(pg.width), float(pg.height));

    shader.set("colorMult", constrain(fft.getBand(100), 0.5, 5), constrain(fft.getBand(300), 0.5, 2.0)); // 10 -> 100
    shader.set("coeffx", constrain(fft.getBand(600)*100, 10, 50)); // 20 -> 80
    shader.set("coeffy", constrain(fft.getBand(800)*100, 0, 90)); // 0 -> 100
    shader.set("coeffz", constrain(fft.getBand(800)*100, 1, 200)); // 0 -> 100

    pg.beginDraw();
    pg.shader(shader);
    pg.rect(0, 0, pg.width, pg.height);
    pg.endDraw();

    image(pg, 0, 0);
  }
}

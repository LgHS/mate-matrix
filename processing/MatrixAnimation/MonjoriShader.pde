class MonjoriShader implements AudioReactiveAnimationInterface {
  PShader shader;
  PGraphics pg;
  MonjoriShader() {
    shader = loadShader("monjori.glsl");
    pg = createGraphics(width, height, P3D);
  }
  public void displayFrame(FFT fft) {
    shader.set("time", (float) millis()/100.0);
    shader.set("resolution", float(pg.width), float(pg.height));

    shader.set("graininess", constrain(fft.getBand(100)*100, 10, 100)); // 10 -> 100
    shader.set("pace", constrain(fft.getBand(600)*100, 20, 80)); // 20 -> 80
    shader.set("twist", constrain(fft.getBand(800)*100, 0, 100)); // 0 -> 100

    pg.beginDraw();
    pg.shader(shader);
    pg.rect(0, 0, pg.width, pg.height);
    pg.endDraw();

    image(pg, 0, 0);
  }
}

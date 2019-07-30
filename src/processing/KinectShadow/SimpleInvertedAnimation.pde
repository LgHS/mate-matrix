class SimpleInvertedAnimation implements AnimationInterface {
    PShader shader;

    public SimpleInvertedAnimation() {
        shader = loadShader("inverted_shadow.glsl");
    }

    public void beforeDraw() {
        
    }

    public PGraphics draw(PGraphics pg, PImage pointCloudImage, float occupationRatio) {
        shader.set("time", millis() * 0.001);
        shader.set("res", kinect.width*1.0f, kinect.height*1.0f);
        shader.set("occupation", occupationRatio);
        shader.set("cam", cam.get());

        pg.beginDraw();
        pg.shader(shader);
        pg.rect(0, 0, width, height);
        pg.endDraw();
        return pg;
    }

    public int duration() {
        return 3000;
    }
}
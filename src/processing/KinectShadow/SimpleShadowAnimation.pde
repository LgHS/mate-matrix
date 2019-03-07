class SimpleShadowAnimation implements AnimationInterface {
    PShader shader;

    public SimpleShadowAnimation() {
        shader = loadShader("simple_shadow.glsl");
    }

    public void beforeDraw() {
        
    }

    public PGraphics draw(PGraphics pg, PImage pointCloudImage, float occupationRatio) {
        shader.set("time", millis() * 0.001);
        shader.set("resolution", kinect.width*1.0f, kinect.height*1.0f);
        shader.set("occupation", occupationRatio);
        shader.set("cam", cam.get()); 

        pg.beginDraw();
        pg.shader(shader);
        pg.rect(0, 0, width, height);
        pg.endDraw();
        return pg;
    }

    public int duration() {
        return 10000;
    }
}
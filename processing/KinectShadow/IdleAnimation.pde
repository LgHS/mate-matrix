class IdleAnimation implements AnimationInterface {
    PShader shader;

    public IdleAnimation() {
        shader = loadShader("idle.glsl");
    }

    public void beforeDraw() {
        
    }

    public PGraphics draw(PGraphics pg, PImage pointCloudImage, float occupationRatio) {
        shader.set("time", millis() * 0.001);
        shader.set("res", kinect.width*1.0f, kinect.height*1.0f);

        pg.beginDraw();
        pg.shader(shader);
        pg.rect(0, 0, width, height);
        pg.endDraw();
        return pg;
    }

    public int duration() {
        // this makes no sense for idle animation
        return 0;
    }
}
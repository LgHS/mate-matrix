class ShadowAnimation implements AnimationInterface {
    PShader shader;
    ArrayList<String> shaderList = new ArrayList<String>();
    int index = -1;

    public ShadowAnimation() {
        // shaderList.add("crazy_wave.glsl");
        // shaderList.add("riples.glsl");
        // shaderList.add("plasma.glsl");
        //shaderList.add("simple_shadow.glsl");
        shaderList.add("simple_simple_shadow.glsl");
    }

    public void beforeDraw() {
        index = index < shaderList.size() - 1 ? ++index : 0;
        shader = loadShader(shaderList.get(index));
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
        return 60000;
    }
}
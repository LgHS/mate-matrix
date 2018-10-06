interface AnimationInterface {
    public PGraphics draw(PGraphics pg, PImage pointCloudImage, float occupationRatio);
    public void beforeDraw();
    public int duration();
}

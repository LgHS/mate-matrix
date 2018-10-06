class FFT extends processing.sound.FFT {

    public float[] smoothed;
    public float smoothFactor = 0.2;
    protected float scaleFactor = 80.0;

    FFT(PApplet applet, int bands){
        super(applet, bands);
        smoothed = new float[bands];
    }
    public float getBand(int b){
         
        return smoothed[b];
    }

    public float getScaledBand(int b){
        return getBand(b) * scaleFactor;
    }

    public float[] analyze(){
        
        float[] value = super.analyze();
        for(int i  = 0; i < value.length; i++){
            smoothed[i] += (value[i] - smoothed[i]) * smoothFactor;
        }
        return spectrum;
    }

    public void setScaleFactor(float factor){
        scaleFactor = factor;
    }
    public void setScaleFactor(int factor){
        scaleFactor = factor * 1.0f;
    }

}
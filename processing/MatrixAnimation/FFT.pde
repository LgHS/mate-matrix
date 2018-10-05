class FFT extends processing.sound.FFT {

    public float[] smoothed;
    public float smoothFactor = 0.2;


    FFT(PApplet applet, int bands){
        super(applet, bands);
        smoothed = new float[bands];
    }
    public float getBand(int i){
         return spectrum[i];
        //return smoothed[i];
    }

    public float[] analyze(){
        
        float[] value = super.analyze();
        for(int i  = 0; i < value.length; i++){
            smoothed[i] += (value[i] - smoothed[i]) * smoothFactor;
        }
        return spectrum;
    }

}
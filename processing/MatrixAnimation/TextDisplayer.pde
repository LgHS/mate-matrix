class TextDisplayer {

    protected float seed = 0.1; 
    protected float xOffset=0;   
    protected String[] words = {"MERCI"};
    // quick and durty way to display text
    public void displayText(){
       // xOffset += sin(noise(seed)*TWO_PI);
        // number of cols hardcoded to fit specifig configuration
        float posX = 3 * mm.SPACING * mm.CRATE_W;
        float posY = height/2;
       // int wordIndex = int(floor(noise(millis()*0.001)*words.length));
        background(0);
        rectMode(CORNER);
        fill(255);
        textSize(150);
        textAlign(CENTER, CENTER);
        text(words[0].toUpperCase(), posX, -20, (mm.cols - 3) * mm.SPACING * mm.CRATE_W, height);
        seed+=0.1;
    }
}
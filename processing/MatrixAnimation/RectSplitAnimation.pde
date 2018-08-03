class RectSplitAnimation extends AbstractSplitAnimation implements AudioReactiveAnimationInterface{

  protected PVector[] blocks;
  protected float offset;
  RectSplitAnimation(PVector[] blocks){
     this.blocks = blocks;
     this.offset = mm.SPACING/2;
 }


  public void displayFrame(FFT fft){
    background(0);
    float posX = 0;
    stroke(255);
    noFill();
    strokeWeight(mm.SPACING*0.75);



    for(int i = 0; i <blocks.length; i++){
        PVector block = blocks[i];
        float blockW = block.x * mm.CRATE_W * mm.SPACING - mm.SPACING;
        float blockH = block.y * mm.CRATE_H * mm.SPACING - mm.SPACING;

        drawRect(offset+posX, offset*2, blockW, blockH, fft);
        posX += block.x * mm.CRATE_W * mm.SPACING;


    }
  }

  protected void drawRect(float x, float y, float w, float h, FFT fft){
      pushMatrix();
      rectMode(CENTER);
      translate(x+w/2,y+h/2);

      fill(255- 255*fft.getBand(40));

      float tmpW = w;
      float tmpH = h;
      w = constrain(w/(fft.getBand(40)+1), 0, w+offset);
      h = constrain(h/(fft.getBand(40)+1), 0, h+offset);
      stroke(map(w*h, 0, tmpW*tmpH, 0, 360), 255, 255);

      rect(0,0,w,h);


      popMatrix();
      rectMode(CORNER);
      noStroke();
  }

}

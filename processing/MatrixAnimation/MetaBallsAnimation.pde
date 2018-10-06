/**
   Metaball Animation class 
*/

class MetaBallsAnimation implements AudioReactiveAnimationInterface {
  private Blob[] blobs = new Blob[30];

  MetaBallsAnimation() {
    for (int i = 0; i < blobs.length; i++) {
      blobs[i] = new Blob(random(width), random(height));
    }
  }

  public void init() {
  }
  public void  displayFrame(FFT fft) {

    int i = 0;
    for (Blob b : blobs) {

      b.r = fft.spectrum[i]*40;

      i++;
    }


    loadPixels();

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int index = x + y * width;

        float sum = 0;
        for (Blob b : blobs) {
          float d = dist(x, y, b.pos.x, b.pos.y);
          sum += 220 * b.r / d;
        }

        pixels[index] = color(constrain(sum, 0, 360), 200, 200);
      }
    }

    updatePixels();
    for (Blob b : blobs) {

      b.update();
      b.show();
    }
  }
}

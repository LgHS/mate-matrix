class Blob {
   // no encapsulation but we know what we're doing, right?
   PVector pos;
   float r;
   PVector vel;
   public Blob(float x, float y){
       pos = new PVector(x, y);
       r = random(50,100);
       vel = PVector.random2D();
       vel.mult(random(0.5,1.5));
   }
  
  public void show(){
     noFill();
     noStroke();
     //stroke(0);
     //strokeWeight(4);
     ellipse(pos.x, pos.y, r*2, r*2);
  }
  
  public void update(){
    pos.add(vel);
    if(pos.x < 0 || pos.x > width){
       vel.x *= -1; 
    }
    
    if(pos.y < 0 || pos.y > height){
       vel.y *= -1; 
    }
  }
  
}

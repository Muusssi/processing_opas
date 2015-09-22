class Pelihahmo {
  float x = 100;
  float y = 100;
  
  PImage kuva;
  
  Pelihahmo(PImage kuva) {
    this.kuva = kuva;
  }
  
  void aseta(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void piirra() {
    println("perii kummasti");
    background(100);
    image(kuva, x-kuva.width/2, y-kuva.height/2);
  }
  
  
}
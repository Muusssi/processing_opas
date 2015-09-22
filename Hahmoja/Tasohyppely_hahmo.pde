class Tasohyppely_hahmo extends Pelihahmo {
  private float liikutus_nopeus = 5;
  private float y_nopeus = 0;
  private float painovoima = 0.3;
  private float hyppy_nopeus = 10;
  
  Tasohyppely_hahmo(PImage kuva) {
    super(kuva);
  }
  
  void aseta(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void piirra() {
    tipu();
    background(100);
    image(kuva, x, y-kuva.height);
  }
  
  void liiku_nuolilla() {
    if (keyPressed) {
      if (keyCode == 37) {
        x = constrain(x-liikutus_nopeus, 0, width-kuva.width);
      }
      else if (keyCode == 39) {
        x = constrain(x+liikutus_nopeus, 0, width-kuva.width);
      }
    }
  }
  
  void hypi() {
    if (keyCode == 32 && y_nopeus == 0)
      y_nopeus = -hyppy_nopeus;
  }
  
  private void tipu() {
    if (y < height) {
      y_nopeus += painovoima;
    }
    else if (y_nopeus > 0) {
      y_nopeus = 0;
    }
    y = constrain(y+y_nopeus, 0, height);
  }

}
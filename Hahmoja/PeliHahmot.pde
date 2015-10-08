// Painike koodeja
final int VASEN_NUOLI = 37;
final int YLOS_NUOLI = 38;
final int OIKEA_NUOLI = 39;
final int ALAS_NUOLI = 40;
final int VALILYONTI = 32;

ArrayList<Taso> tasot = new ArrayList<Taso>();

void piirra_tasot() {
  for (int i=0; i<tasot.size(); i++) {
    tasot.get(i).piirra();
  }
}

class Taso {
  float x, y;
  float pituus;
  
  Taso(float x, float korkeus, float pituus) {
    this.x = x;
    this.y = height-korkeus;
    this.pituus = pituus;
    tasot.add(this);
  }
  
  void piirra() {
    line(x, y, x+pituus, y);
  }
  
  boolean onko_kohdalla(Tasohyppelyhahmo hahmo) {
    if (hahmo.x+hahmo.kuva.width/2 >= this.x 
        && hahmo.x+hahmo.kuva.width/2 <= this.x+this.pituus) {
      return true;
    }
    return false;
  }
  
  boolean onko_paalla(Tasohyppelyhahmo hahmo) {
    if (hahmo.y <= this.y) {
      return onko_kohdalla(hahmo);
    }
    return false;
  }
  
  boolean onko_alla(Tasohyppelyhahmo hahmo) {
    if (hahmo.y > this.y) {
      return onko_kohdalla(hahmo);
    }
    return false;
  }
  
}


class Tasohyppelyhahmo {
  float x = 100;
  float y = 100;
  PImage kuva;
  private float liikutus_nopeus = 5;
  private float y_nopeus = 0;
  private float putoamiskiihtyvyys = 0.3;
  private float hyppy_nopeus = 8;
  private boolean viimeksi_vasemmalle = false;
  
  Tasohyppelyhahmo(PImage kuva) {
    this.kuva = kuva;
  }
  
  void aseta(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void piirra() {
    tipu();
    pushMatrix();
    if (viimeksi_vasemmalle) {
      scale(-1.0, 1.0);
      image(kuva, -x-kuva.width, y-kuva.height);
    }
    else {
      image(kuva, x, y-kuva.height);
    }
    popMatrix();
  }
  
  void liiku_oikealle() {
    x = constrain(x+liikutus_nopeus, 0, width-kuva.width);
    viimeksi_vasemmalle = false;
  }
  
  void liiku_vasemmalle() {
    x = constrain(x-liikutus_nopeus, 0, width-kuva.width);
    viimeksi_vasemmalle = true;
  }
  
  void hyppaa() {
    if (y_nopeus == 0) {
      y_nopeus = -hyppy_nopeus;
    }
  }
  
  private void tipu() {
    float lattia = seuraava_lattia();
    float katto = seuraava_katto();
    if (y < lattia && y+kuva.height > katto) {
      y_nopeus += putoamiskiihtyvyys;
    }
    else if (y_nopeus > 0) {
      y_nopeus = 0;
    }
    if (y-kuva.height <= katto && y_nopeus < 0) {
      y_nopeus = 0;
    }
    y = constrain(y+y_nopeus, katto+kuva.height, lattia);
  }
  
  private float seuraava_katto() {
    float katto = -300;
    for (int i=0; i<tasot.size(); i++) {
      Taso taso = tasot.get(i);
      if (taso.y > katto && taso.onko_alla(this)) {
        katto = taso.y;
      }
    }
    return katto;
  }
  
  private float seuraava_lattia() {
    float lattia = height;
    for (int i=0; i<tasot.size(); i++) {
      Taso taso = tasot.get(i);
      if (taso.y < lattia && taso.onko_paalla(this)) {
        lattia = taso.y;
      }
    }
    return lattia;
  }

}
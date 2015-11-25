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
  boolean viimeksi_vasemmalle = false;
  
  Tasohyppelyhahmo(PImage kuva) {
    this.kuva = kuva;
  }
  
  void aseta(float x, float korkeus) {
    this.x = x;
    this.y = height-korkeus;
  }
  
  void aseta_nopeus(float nopeus) {
    liikutus_nopeus = nopeus;
  }
  
  void aseta_hyppynopeus(float nopeus) {
    liikutus_nopeus = nopeus;
  }
  
  float etaisyys_sivusuunnassa(Tasohyppelyhahmo toinen_hahmo) {
    if (x+kuva.width < toinen_hahmo.x) {
      return toinen_hahmo.x - (x+kuva.width);
    }
    else if (x > toinen_hahmo.x+toinen_hahmo.kuva.width) {
      return x - (toinen_hahmo.x+toinen_hahmo.kuva.width);
    }
    else {
      return 0;
    }
  }
  
  boolean koskee(Tasohyppelyhahmo toinen_hahmo) {
    if (x+kuva.width < toinen_hahmo.x) {
      return false;
    }
    else if (x > toinen_hahmo.x+toinen_hahmo.kuva.width) {
      return false;
    }
    else if (y+kuva.height < toinen_hahmo.y) {
      return false;
    }
    else if (y > toinen_hahmo.y+toinen_hahmo.kuva.height) {
      return false;
    }
    return true;
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
  
  void hyppy() {
    if (y_nopeus == 0) {
      y_nopeus = -hyppy_nopeus;
    }
  }
  
  void liiku_itsestaan(float vasen_reuna, float oikea_reuna) {
    if (liikutus_nopeus > 0 && (x+kuva.width/2 > oikea_reuna || x+kuva.width >= width)) {
      liikutus_nopeus = -liikutus_nopeus;
      viimeksi_vasemmalle = true;
    }
    else if (liikutus_nopeus < 0 && (x+kuva.width/2 < vasen_reuna || x <= 0)) {
      liikutus_nopeus = -liikutus_nopeus;
      viimeksi_vasemmalle = false;
    } 
    x = constrain(x+liikutus_nopeus, 0, width-kuva.width);
    this.tipu();
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
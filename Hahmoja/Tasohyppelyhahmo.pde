/* Tommi Oinonen 2016 - versio 2.0
 * 2D tasohyppely pelin hahmoihin ja tasoihin toteuttava koodi.
 * Kopioi tämä koko tiedosto projektiisi niin voit käyttää 
 * hahmoja pelissäsi. 
 */

// Painike koodeja
final int VASEN_NUOLI = 37;
final int YLOS_NUOLI = 38;
final int OIKEA_NUOLI = 39;
final int ALAS_NUOLI = 40;
final int VALILYONTI = 32;

ArrayList<Taso> tasot = new ArrayList<Taso>();

float maailman_leveys = 1200;
float maailman_korkeus = 800;

float kameran_siirto_x = 0;
float kameran_siirto_y = 0;

void piirra_tasot() {
  for (int i=0; i<tasot.size(); i++) {
    tasot.get(i).piirra();
  }
}

// Taso, jonka päällä hamot voivat hyppiä
class Taso {
  float x, y;
  float pituus;
  color vari = color(0, 0, 0);
  
  Taso(float x, float korkeus, float pituus) {
    this.x = x;
    this.y = korkeus;
    this.pituus = pituus;
    tasot.add(this);
  }

  void aseta_vari(int pun, int vih, int sin) {
    this.vari = color(pun, vih, sin);
  }
  
  void piirra() {
    stroke(this.vari);
    line(x+kameran_siirto_x, height-y-kameran_siirto_y, x+kameran_siirto_x+pituus, height-y-kameran_siirto_y);
  }
  
  boolean onko_kohdalla(Tasohyppelyhahmo hahmo) {
    // Hahmo on tason kohdalla eli törmää tasoon pystysuunnassa jos vähintään 
    // puolet hamon leveydestä on tason päällä.
    if (hahmo.x+hahmo.kuva.width/2 >= this.x 
        && hahmo.x+hahmo.kuva.width/2 <= this.x+this.pituus) {
      return true;
    }
    return false;
  }
  
  boolean onko_paalla(Tasohyppelyhahmo hahmo) {
    if (hahmo.y >= this.y) {
      return onko_kohdalla(hahmo);
    }
    return false;
  }
  
  boolean onko_alla(Tasohyppelyhahmo hahmo) {
    if (hahmo.y < this.y) {
      return onko_kohdalla(hahmo);
    }
    return false;
  }
  
}


class Tasohyppelyhahmo {
  float x = 0;
  float y = 0;
  PImage kuva;
  private float liikutus_nopeus = 5;
  private float y_nopeus = 0;
  private float putoamiskiihtyvyys = -0.3;
  private float hyppynopeus = 8;
  boolean viimeksi_vasemmalle = false;
  
  Tasohyppelyhahmo(PImage kuva) {
    this.kuva = kuva;
  }
  
  void aseta(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void aseta_nopeus(float nopeus) {
    this.liikutus_nopeus = nopeus;
  }
  
  void aseta_hyppynopeus(float nopeus) {
    this.hyppynopeus = nopeus;
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
      image(kuva, -(x+kuva.width+kameran_siirto_x), height-kameran_siirto_y-y-kuva.height);
    }
    else {
      image(kuva, x+kameran_siirto_x, height-kameran_siirto_y-y-kuva.height);
    }
    popMatrix();
  }
  
  void liiku_oikealle() {
    x = constrain(x+liikutus_nopeus, 0, maailman_leveys-kuva.width);
    viimeksi_vasemmalle = false;
  }
  
  void liiku_vasemmalle() {
    x = constrain(x-liikutus_nopeus, 0, maailman_leveys-kuva.width);
    viimeksi_vasemmalle = true;
  }
  
  void hyppy() {
    if (y_nopeus == 0) {
      y_nopeus = hyppynopeus;
    }
  }
  
  void liiku_itsestaan(float vasen_reuna, float oikea_reuna) {
    if (liikutus_nopeus > 0 && (x+kuva.width/2 > oikea_reuna || x+kuva.width >= maailman_leveys)) {
      liikutus_nopeus = -liikutus_nopeus;
      liiku_oikealle();
    }
    else if (liikutus_nopeus < 0 && (x+kuva.width/2 < vasen_reuna || x <= 0)) {
      liikutus_nopeus = -liikutus_nopeus;
      liiku_vasemmalle();
    } 
  }
  
  private void tipu() {
    float lattia = seuraava_lattia();
    float katto = seuraava_katto();
    
    if (y > lattia && y <= katto) {
      y_nopeus += putoamiskiihtyvyys;
    }
    else if (y_nopeus < 0) {
      y_nopeus = 0;
    }
    if (y+kuva.height >= katto && y_nopeus > 0) {
      y_nopeus = 0;
    }
    y = constrain(y+y_nopeus, lattia, katto+kuva.height);
  }
  
  private float seuraava_katto() {
    float katto = maailman_korkeus-kuva.height;
    for (int i=0; i<tasot.size(); i++) {
      Taso taso = tasot.get(i);
      if (taso.y < katto && taso.onko_alla(this)) {
        katto = taso.y;
      }
    }
    return katto;
  }
  
  private float seuraava_lattia() {
    float lattia = 0;
    for (int i=0; i<tasot.size(); i++) {
      Taso taso = tasot.get(i);
      if (taso.y > lattia && taso.onko_paalla(this)) {
        lattia = taso.y;
      }
    }
    return lattia;
  }

  public void seuraa_kameralla() {
    //println("kameran_siirto_y: "+kameran_siirto_y);
    if (x+kameran_siirto_x > 2*width/3)
      kameran_siirto_x = constrain(kameran_siirto_x-liikutus_nopeus, -maailman_leveys+width, 0);
    else if (x+kameran_siirto_x < width/3)
      kameran_siirto_x = constrain(kameran_siirto_x+liikutus_nopeus, -maailman_leveys+width, 0);

    if (y_nopeus > 0 && y-kameran_siirto_y > 2*height/3)
      kameran_siirto_y = constrain(kameran_siirto_y-y_nopeus, -maailman_korkeus+height, 0);
    else if (y_nopeus < 0 && y+kameran_siirto_y < 2*height/5)
      kameran_siirto_y = constrain(kameran_siirto_y-y_nopeus, -maailman_korkeus+height, 0);
  }
  
}

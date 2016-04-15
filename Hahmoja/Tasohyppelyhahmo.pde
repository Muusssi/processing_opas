/* Tommi Oinonen 2016 - versio 2.7
 * 2D-tasohyppelypelin hahmoihin ja tasoihin tarvittava koodi.
 * Kopioi tämä koko tiedosto projektiisi niin voit käyttää
 * hahmoja pelissäsi.
 */

import java.util.Collections;
import java.util.Comparator;

// Painike koodeja
final int VASEN_NUOLI = 37;
final int YLOS_NUOLI = 38;
final int OIKEA_NUOLI = 39;
final int ALAS_NUOLI = 40;
final int VALILYONTI = 32;

ArrayList<Taso> tasot = new ArrayList<Taso>();
ArrayList<Taso> tasotKorkeudenMukaan = new ArrayList<Taso>();

ArrayList<Seina> seinat = new ArrayList<Seina>();
ArrayList<Seina> seinatJarjestyksessa = new ArrayList<Seina>();

float maailman_leveys = 1200;
float maailman_korkeus = 10000;

float kameran_siirto_x = 0;
float kameran_siirto_y = 0;
boolean koordinaatisto_alustettu = false;

public void alusta_koordinaatisto() {
  pushMatrix();
  translate(kameran_siirto_x, height+kameran_siirto_y);
  scale(1, -1);
  pushMatrix();
  koordinaatisto_alustettu = true;
}

public float mouse_x() {
  return mouseX - kameran_siirto_x;
}

public float mouse_y() {
  return height - mouseY -kameran_siirto_y;
}

public class Tausta {
  PImage kuva;

  public Tausta (PImage kuva) {
    this.kuva = kuva;
    maailman_leveys = kuva.width;
    maailman_korkeus = kuva.height;

    if (!koordinaatisto_alustettu) {
      alusta_koordinaatisto();
    }

  }

  void piirra() {
    pushMatrix();
    image(kuva, kameran_siirto_x, -kameran_siirto_y+height-kuva.height);
    popMatrix();
  }

}

// Piirtää näkyvissä olevat tasot
void piirra_tasot() {
  for (int i=0; i<tasot.size(); i++) {
    Taso t = tasotKorkeudenMukaan.get(i);
    if (t.y > height-kameran_siirto_y) {
      return;
    }
    else if (t.y > -kameran_siirto_y) {
      if (t.x+t.pituus > -kameran_siirto_x && t.x < width-kameran_siirto_x)
        t.piirra();
    }
  }
}

void piirra_seinat() {
  for (int i=0; i<seinat.size(); i++) {
    Seina s = seinatJarjestyksessa.get(i);
    if (s.x > width-kameran_siirto_x) {
      return;
    }
    else if (s.x > -kameran_siirto_x) {
      if (s.y+s.korkeus > -kameran_siirto_y && s.y < height-kameran_siirto_y)
        s.piirra();
    }
  }
}


class Seina {
  float x, y;
  float korkeus;
  color vari = color(0, 0, 0);
  private boolean olemassa = true;

  Seina(float x, float y, float korkeus) {
    this.x = x;
    this.y = y;
    this.korkeus = korkeus;
    seinat.add(this);
    seinatJarjestyksessa = new ArrayList<Seina>(seinat);
    Collections.sort(seinatJarjestyksessa, new SeinaVertailija());
    if (!koordinaatisto_alustettu) {
      alusta_koordinaatisto();
    }
  }

  void piirra() {
    line(x, y, x, y+korkeus);
  }

  boolean kohdalla(Tasohyppelyhahmo hahmo) {
    if (hahmo.y+hahmo.kuva.height > this.y
        && hahmo.y < this.y+this.korkeus) {
      return true;
    }
    return false;
  }

  void poista() {
    if (olemassa) {
      seinat.remove(this);
      seinatJarjestyksessa = new ArrayList<Seina>(seinat);
      Collections.sort(seinatJarjestyksessa, new SeinaVertailija());
      olemassa = false;
    }
  }

  void palauta() {
    if (!olemassa) {
      seinat.add(this);
      seinatJarjestyksessa = new ArrayList<Seina>(seinat);
      Collections.sort(seinatJarjestyksessa, new SeinaVertailija());
      olemassa = true;
    }
  }

}

// Taso, jonka päällä hahmot voivat hyppiä
class Taso {
  float x, y;
  float pituus;
  color vari = color(0, 0, 0);
  private boolean olemassa = true;

  Taso(float x, float korkeus, float pituus) {
    this.x = x;
    this.y = korkeus;
    this.pituus = pituus;
    tasot.add(this);
    tasotKorkeudenMukaan = new ArrayList<Taso>(tasot);
    Collections.sort(tasotKorkeudenMukaan, new TasoKorkeusVertailija());
    if (!koordinaatisto_alustettu) {
      alusta_koordinaatisto();
    }
  }

  void poista() {
    if (olemassa) {
      tasot.remove(this);
      tasotKorkeudenMukaan = new ArrayList<Taso>(tasot);
      Collections.sort(tasotKorkeudenMukaan, new TasoKorkeusVertailija());
      olemassa = false;
    }
  }

  void palauta() {
    if (!olemassa) {
      tasot.add(this);
      tasotKorkeudenMukaan = new ArrayList<Taso>(tasot);
      Collections.sort(tasotKorkeudenMukaan, new TasoKorkeusVertailija());
      olemassa = true;
    }

  }


  void aseta_vari(int pun, int vih, int sin) {
    this.vari = color(pun, vih, sin);
  }

  void piirra() {
    stroke(this.vari);
    line(x, y, x+pituus, y);

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

/*Tasojen järjestäjät */
public class TasoKorkeusVertailija implements Comparator<Taso> {
  @Override
  public int compare(Taso t1, Taso t2) {
    if (t1.y < t2.y)
      return -1;
    else if (t1.y > t2.y)
      return 1;
    else
      return 0;
  }
}

/*Tasojen järjestäjät */
public class SeinaVertailija implements Comparator<Seina> {
  @Override
  public int compare(Seina t1, Seina t2) {
    if (t1.x < t2.x)
      return -1;
    else if (t1.y > t2.y)
      return 1;
    else
      return 0;
  }
}


class Tasohyppelyhahmo {
  float x = 0;
  float y = 0;
  PImage kuva;
  public float liikutus_nopeus = 5;
  public float y_nopeus = 0;
  public float putoamiskiihtyvyys = -0.3;
  public float hyppynopeus = 8;
  boolean viimeksi_vasemmalle = false;
  public boolean kaksoishyppy = false;

  Tasohyppelyhahmo(PImage kuva) {
    this.kuva = kuva;
    if (!koordinaatisto_alustettu) {
      alusta_koordinaatisto();
    }
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

  void tyonna(Tasohyppelyhahmo toinen_hahmo) {
    if (this.x < toinen_hahmo.x) {
      toinen_hahmo.x -= toinen_hahmo.x - this.x - this.kuva.width;
    }
    else {
      toinen_hahmo.x += this.x - toinen_hahmo.x - toinen_hahmo.kuva.width;
    }
  }

  void piirra() {
    tipu();
    pushMatrix();
    if (viimeksi_vasemmalle) {
      scale(-1.0, -1.0);
      image(kuva, -(x+kuva.width), -y-kuva.height);
    }
    else {
      scale(1.0, -1.0);
      image(kuva, x, -y-kuva.height);
    }
    popMatrix();
  }


  float seuraava_oikea_seina() {
    float oikea_seina = maailman_leveys;
    for (int i=seinat.size()-1; i>=0; i--) {
      Seina s = seinatJarjestyksessa.get(i);
      if (s.x<=this.x) {
        return oikea_seina;
      }
      if (s.kohdalla(this)) {
        oikea_seina = s.x;
      }
    }
    return oikea_seina;
  }

  float seuraava_vasen_seina() {
    float vasen_seina = 0;
    for (int i=0; i<seinat.size(); i++) {
      Seina s = seinatJarjestyksessa.get(i);
      if (s.x>=this.x+this.kuva.width) {
        return vasen_seina;
      }
      if (s.kohdalla(this)) {
        vasen_seina = s.x;
      }
    }
    return vasen_seina;
  }

  void liiku_oikealle() {
    x = constrain(x+liikutus_nopeus, 0, seuraava_oikea_seina()-kuva.width);
    viimeksi_vasemmalle = false;
  }

  void liiku_vasemmalle() {
    x = constrain(x-liikutus_nopeus, seuraava_vasen_seina(), maailman_leveys-kuva.width);
    viimeksi_vasemmalle = true;
  }

  void hyppy() {
    if (y_nopeus == 0) {
      y_nopeus = hyppynopeus;
      kaksoishyppy = false;
    }
    else if (!kaksoishyppy) {
      y_nopeus = hyppynopeus;
      kaksoishyppy = true;
    }
  }

  void liiku_itsestaan(float vasen_reuna, float oikea_reuna) {
    if ((x <= vasen_reuna && viimeksi_vasemmalle) || (x >= oikea_reuna && !viimeksi_vasemmalle)) {
      viimeksi_vasemmalle = !viimeksi_vasemmalle;
    }
    if (viimeksi_vasemmalle) {
      liiku_vasemmalle();
    }
    else if (!viimeksi_vasemmalle) {
      liiku_oikealle();
    }
  }

  public void tipu() {
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
    x = constrain(x, seuraava_vasen_seina(), seuraava_oikea_seina()+kuva.width);
  }

  public float seuraava_katto() {
    float katto = maailman_korkeus;
    for (int i=tasotKorkeudenMukaan.size()-1; i>=0; i--) {
      Taso taso = tasotKorkeudenMukaan.get(i);
      if (taso.y < y) {
        return katto;
      }
      if (taso.y < katto && taso.onko_alla(this)) {
        katto = taso.y;
      }
    }
    return katto;
  }

  public float seuraava_lattia() {
    float lattia = 0;
    for (int i=0; i<tasotKorkeudenMukaan.size(); i++) {
      Taso taso = tasotKorkeudenMukaan.get(i);
      if (taso.y > y)
        return lattia;
      if (taso.y > lattia && taso.onko_paalla(this)) {
        lattia = taso.y;
      }
    }
    return lattia;
  }

  public void kohdista_kamera() {
    kameran_siirto_x = constrain(-x+width/2, -maailman_leveys+width, 0);
    kameran_siirto_y = constrain(-y+height/2, -maailman_korkeus+height, 0);
  }

  public void seuraa_kameralla() {
    float kameran_liikutus_nopeus_x = liikutus_nopeus;
    float kameran_liikutus_nopeus_y = liikutus_nopeus;

    if (x+kameran_siirto_x > width || x+kameran_siirto_x < 0) {
      kameran_liikutus_nopeus_x = width/8;
    }
    if (x+kameran_siirto_x > 2*width/3) {
      kameran_siirto_x = constrain(kameran_siirto_x-kameran_liikutus_nopeus_x, -maailman_leveys+width, 0);
    }
    else if (x+kameran_siirto_x < width/3) {
      kameran_siirto_x = constrain(kameran_siirto_x+kameran_liikutus_nopeus_x, -maailman_leveys+width, 0);
    }

    if (y_nopeus != 0) {
      kameran_liikutus_nopeus_y = -y_nopeus;
    }
    else if (y <= -kameran_siirto_y) {
      kameran_liikutus_nopeus_y = height/8;
    }
    else if (y >= height+kameran_siirto_y) {
    //else if (y > 0) {
      kameran_liikutus_nopeus_y = -height/8;
    }
    if ((y+kameran_siirto_y > 2*height/3 && y_nopeus>=0) || (y+kameran_siirto_y < 2*height/5 && y_nopeus<=0)) {
      kameran_siirto_y = constrain(kameran_siirto_y+kameran_liikutus_nopeus_y, -maailman_korkeus+height, 0);
    }
    popMatrix();
    pushMatrix();
    translate(kameran_siirto_x, kameran_siirto_y);

  }

}

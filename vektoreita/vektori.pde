// piirtämistä varten
float[] origo = null;
float skaala = 50;

void koordinaatisto() {
  // Piirtää koordinaatti akselit
  if (origo == null) {
    asetaOrigoKeskelle();
  }
  //x-akseli
  line(origo[0], 0, origo[0], height);
  line(origo[0]+skaala, origo[1]-5, origo[0]+skaala, origo[1]+5);
  line(origo[0]-skaala, origo[1]-5, origo[0]-skaala, origo[1]+5);
  //y-akseli
  line(0, origo[1], width, origo[1]);
  line(origo[0]-5, origo[1]-skaala, origo[0]+5, origo[1]-skaala);
  line(origo[0]-5, origo[1]+skaala, origo[0]+5, origo[1]+skaala);
}

void asetaOrigoKeskelle() {
  origo = new float[2];
  origo[0] = width/2;
  origo[1] = height/2;
}



/* Yksinkerainen Vektori luokka, jonka rakenne on hahmoteltu,
 * mutta joitain metodeita ei ole vielä kirjoitettu. Voit yrittää
 * itse toteuttaa metodit joissa TODO merkintä.*/

class Vektori {
  float[] arvot;

  Vektori(float[] arvot) {
    this.arvot = new float[arvot.length];
    arrayCopy(arvot, this.arvot);
  }

  Vektori(float i, float j, float k) {
    this.arvot = new float[3];
    // TODO
  }
  
  Vektori(float i, float j) {
    this.arvot = new float[2];
    this.arvot[0] = i;
    this.arvot[1] = j;
  }

  Vektori summa(Vektori v) {
    // TODO
    return new Vektori(new float[2]);
  }

  Vektori erotus(Vektori v) {
    // TODO
    return new Vektori(new float[2]);
  }

  Vektori pistetulo(Vektori v) {
    // TODO
    return new Vektori(new float[2]);
  }

  float pituus() {
    // TODO
    return 0;
  }

  Vektori normalisoitu() {
    // TODO
    return new Vektori(new float[2]);
  }

  boolean yhtasuuri(Vektori v) {
    // TODO
    return false;
  }

  void tulosta() {
    String rivi = "[";
    for (int i=0; i<arvot.length; i++) {
      rivi += arvot[i];
      if (i < arvot.length-1) {
        rivi += ", ";
      }
    }
    println(rivi+"]");
  }

  void piirra() {
    // Piirtää vektorin 2D koordinaatistoon eli jättää muut dimensiot huomiotta
    if (origo == null) {
      asetaOrigoKeskelle();
    }
    line(origo[0], origo[1], origo[0]+arvot[0]*skaala, origo[1]-arvot[1]*skaala);
    ellipse(origo[0]+arvot[0]*skaala, origo[1]-arvot[1]*skaala, 10, 10);
  }



}
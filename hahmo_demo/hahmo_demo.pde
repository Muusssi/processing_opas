import tui.*;
import hahmot.*;

Tasohyppelyhahmo hahmo;
Pelikentta pelikentta;


void setup() {
  size(1000, 800, P2D);
  TUI.aloita(this);
  pelikentta = new Pelikentta(this, 1800, 2000);
  hahmo = pelikentta.luo_tasohyppelyhahmo(loadImage("hahmo.png"));
  hahmo.kohdista_kamera();

  pelikentta.luo_taso(0, 110, 300);
  pelikentta.luo_taso(300, 250, 300);
  pelikentta.luo_taso(600, 400, 300);
  pelikentta.luo_taso(1300, 400, 300);
}

void draw() {
  background(200);
  hahmo.piirra();
  pelikentta.piirra_tasot();

  // Jos jokin a näppäin on painettu
  if (TUI.nappain_painettu('A')) {
    hahmo.liiku_vasemmalle();
  }
  else if (TUI.nappain_painettu('D')) {
    hahmo.liiku_oikealle();
  }
}

// Tämä metodi suoritetaan aina kun jokin näppäin painetaan pohjaan
void keyPressed() {
  // Jotta nappitarkkailija toimii näppäinten painallukset pitää raportoida
  TUI.huomaa_painallus();
  if (keyCode == 32) {
    hahmo.hyppy();
  }
}

// Tämä metodi suoritetaan aina kun jokin näppäin vapautetaan
void keyReleased() {
  // Jotta nappitarkkailija toimii näppäinten vapautukset pitää raportoida
  TUI.huomaa_vapautus();
}


void mousePressed() {
  println(pelikentta.mouse_x(), pelikentta.mouse_y());
}

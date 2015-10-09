Tasohyppelyhahmo p, p2;

void setup() {
  size(1000, 800);
  p = new Tasohyppelyhahmo(loadImage("velho.png"));
  p2 = new Tasohyppelyhahmo(loadImage("tiikeri.png"));
  p2.aseta_nopeus(2);
  new Taso(0,300,200);
  new Taso(50,200,200);
  new Taso(150,100,200);
}

void draw() {
  background(200);
  if (keyPressed) {
    if (keyCode == VASEN_NUOLI) {
      p.liiku_vasemmalle();
    }
    else if (keyCode == OIKEA_NUOLI) {
      p.liiku_oikealle();
    }
  }
  if (p.koskee(p2)) {
    p.aseta(600, 000);
  }
  piirra_tasot();
  p2.liiku_itsestaan(0,200);
  p.piirra();
  p2.piirra();
}

void keyPressed() {
  if (keyCode == VALILYONTI) {
    p.hyppy();
  }
}
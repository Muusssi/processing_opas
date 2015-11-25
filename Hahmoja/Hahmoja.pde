Tasohyppelyhahmo p, p2;
Suihke s;
void setup() {
  size(1000, 800);
  p = new Tasohyppelyhahmo(loadImage("velho.png"));
  s = new Suihke(50, 50, 1, 0);
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
  p2.liiku_itsestaan(0,500);
  p.piirra();
  p2.piirra();
  if (keyPressed && key == 'a') {
    if (p.viimeksi_vasemmalle == true) {
      s.aseta(p.x, p.y-50);
      s.aseta_suunta(-1,0);
    }
      
    else {
      s.aseta(p.x+50, p.y-50);
      s.aseta_suunta(1,0);
    }
    s.piirra(true);
  }
  else
    s.piirra(false);

  if (s.osuuko(p2.x+50, p2.y-40, 50))
    p2.hyppy();

}

void keyPressed() {
  if (keyCode == VALILYONTI) {
    p.hyppy();
  }
}
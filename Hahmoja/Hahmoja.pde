Tasohyppelyhahmo p;

void setup() {
  size(1000, 800);
  p = new Tasohyppelyhahmo(loadImage("kala.png"));
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
  piirra_tasot();
  p.piirra();
}

void keyPressed() {
  if (keyCode == VALILYONTI) {
      p.hyppaa();
    }
}
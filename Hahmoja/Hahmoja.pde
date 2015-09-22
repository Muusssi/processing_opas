Tasohyppely_hahmo p;

void setup() {
  size(500, 400);
  p = new Tasohyppely_hahmo(loadImage("cat.png"));
}

void draw() {
  p.liiku_nuolilla();
  p.piirra();
}

void keyPressed() {
  p.hypi();
  println(keyCode);
}
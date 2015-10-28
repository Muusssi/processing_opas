Vektori a,b,c;

void setup() {
  size(400,300);
  koordinaatisto();
  noLoop();
  float[] v = new float[2];
  v[0] = 1;
  v[1] = 1;
  a = new Vektori(v);
  b = new Vektori(v);
  a.summa(a).piirra();

}

void draw() {

}
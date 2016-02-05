Vektori a,b,c;

void setup() {
  size(400,300);
  koordinaatisto();
  noLoop();
  a = new Vektori(1,1);
  b = new Vektori(-1,-2);
  print("a=");
  a.tulosta();
  print("b=");
  b.tulosta();
  a.piirra();
  b.piirra();
  
  Vektori c = a.summa(b);
  print("a+b=");
  c.tulosta();
  c.piirra();
  


}

void draw() {}

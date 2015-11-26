Pallo p, p2;

void setup() {
    size(600,400);
    p = new PomppuPallo(100, 50, 50);
    p.putoamis_kiihtyvyys = 0.3;
    p2 = new RandomPallo(50);
    
}

void draw() {
    background(200);
    p.liiku();
    p.piirra();
    p2.liiku();
    p2.piirra();
}
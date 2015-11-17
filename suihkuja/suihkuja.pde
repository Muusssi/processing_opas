Suihke s;

void setup() {
    size(600,400);
    s = new Suihke(50, 50, 2, 1);
}

void draw() {
    background(200);
    if (mousePressed) {
        s.aseta(mouseX, mouseY);
        s.aseta_suunta(-mouseX+pmouseX,-mouseY+pmouseY);
        s.piirra(true);
    }
    else
        s.piirra(false);
}
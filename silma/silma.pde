
void setup() {
    size(512, 512);
}

void draw() {
    // Kaksi silmää jotka katosovat kursoria
    silma(200, 200, 100, mouseX, mouseY);
    silma(400, 200, 100, mouseX, mouseY);
}


// Funktio joka piirtää silmän
// Kopioi tämä ohjelmaasi niin voit piirtää silmiä
float SILMAN_ETAISYYS = 150;
void silma(float x, float y, float halkaisija, float kohde_x, float kohde_y) {
    float etaisyys = dist(kohde_x, kohde_y, 0, x, y, SILMAN_ETAISYYS);
    float pupilli = halkaisija/3;
    fill(255);
    ellipse(x, y, halkaisija, halkaisija);
    fill(0);
    ellipse(x+((kohde_x - x)/etaisyys)*pupilli, y+((kohde_y - y)/etaisyys)*pupilli, pupilli, pupilli);
}




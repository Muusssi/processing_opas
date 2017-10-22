float pallon_korkeus = 50;
float pallon_nopeus_alaspain = 1;
float painovoima = 0.1;

void setup() {
  size(300, 400);
}

void draw() {
  background(200);
  // Piirra pallo
  ellipse(150, pallon_korkeus, 30, 30);
  // Painovoima vetää alas
  pallon_nopeus_alaspain = pallon_nopeus_alaspain + painovoima;
  // Jos osuu maahan -> pomppaa
  if (pallon_korkeus >= height - 15) {
    pallon_nopeus_alaspain = -0.98*pallon_nopeus_alaspain;
  }
  // Liikuta palloa
  pallon_korkeus = pallon_korkeus + pallon_nopeus_alaspain;
}
import tui.*;

Tank tank, tank2, tank3;
boolean ground_unstable = true;

Tank turn;

void setup() {
  fullScreen(P2D);
  //size(1200, 800, P2D);
  frameRate(20);
  TUI.aloita(this);
  generate_ground();
  tank = new Tank();
  add_tank(0);
  add_tank(0);
  add_tank(1);
  add_tank(1);
  add_tank(1);
  add_tank(2);
  add_tank(2);
  add_tank(2);
}

void draw() {
  background(200);
  if (ground_unstable) {
    ellipse(50, 50, 50, 50);
    update_ground_layer();
  }
  draw_ground();
  draw_tanks();
  tank.draw_power();
  tanks_fight();
  if (TUI.nappain_painettu('W')) {
    tank.lift_barrel();
  }
  else if (TUI.nappain_painettu('S')) {
    tank.lower_barrel();
  }
  if (TUI.nappain_painettu('A')) {
    tank.move_left();
  }
  else if (TUI.nappain_painettu('D')) {
    tank.move_rigth();
  }

  if (TUI.nappain_painettu('E')) {
    tank.increase_power();
  }
  else if (TUI.nappain_painettu('Q')) {
    tank.decrease_power();
  }

  draw_projectiles();

}




void keyPressed() {
  TUI.huomaa_painallus();
  if (keyCode == ' ') {
    tank.shoot();
  }
}

void keyReleased() {
  TUI.huomaa_vapautus();
}
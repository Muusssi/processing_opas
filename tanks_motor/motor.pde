
int[] ground;
PGraphics ground_layer;
ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
ArrayList<Tank> tanks = new ArrayList<Tank>();

final float GRAVITY = 0.3;
final float MAX_STEEPNESS = 2;
final int TANK_WIDTH = 30;
final int TANK_HEIGHT = 15;
final int TANK_TOWER_RADIUS = 20;
final int TANK_BARREL_LENGTH = 30;
final float TANK_MAX_POWER = 20;
final float TANK_MIN_POWER = 3;
final float FUEL_CONSUMPTION = 1;

color[] team_colors = {
  color(255, 0, 0),
  color(0, 255, 0),
  color(0, 0, 255),
};

Tank add_tank(int team) {
  Tank tank = new Tank();
  tank.x = random(50, width-50);
  tank.team = team;
  return tank;
}

void draw_tanks() {
  for (int i = tanks.size() - 1; i >= 0 ; i--) {
    Tank tank = tanks.get(i);
    tank.draw();
    if (tank.health <= 0) {
      tanks.remove(i);
    }
  }
}

void tanks_fight() {
  for (int i = tanks.size() - 1; i >= 0 ; i--) {
    Tank tank = tanks.get(i);
    tank.fight();
  }
}

class Tank {
  float x;
  int direction = -1;
  float barrel_angle = 0;
  float health = 15;
  float power = 10;
  float fuel = 300;

  int team = 0;
  Tank target_enemy = null;
  int target_angle = 0;
  Projectile previous_projectile = null;

  public Tank() {
    this.x = 100;
    tanks.add(this);
  }

  void move_left() {
    if (fuel > 0) {
      x -= 1;
      fuel -= FUEL_CONSUMPTION;
    }
    direction = -1;
  }

  void move_rigth() {
    if (fuel > 0) {
      x += 1;
      fuel -= FUEL_CONSUMPTION;
    }
    direction = 1;
  }

  float aim_x() {
    return direction * cos(radians(this.barrel_angle));
  }

  float aim_y() {
    return -sin(radians(this.barrel_angle));
  }

  float y() {
    return ground[int(this.x)];
  }

  void lift_barrel() {
    if (barrel_angle < 85) {
      barrel_angle += 1;
    }
  }

  void lower_barrel() {
    if (barrel_angle > 0) {
      barrel_angle -= 1;
    }
  }

  void increase_power() {
    if (power < TANK_MAX_POWER) {
      power += 0.1;
    }
  }

  void decrease_power() {
    if (power > TANK_MIN_POWER) {
      power -= 0.1;
    }
  }

  void draw_power() {
    pushStyle();
    fill(255);
    rect(50, 50, (TANK_MAX_POWER - TANK_MIN_POWER)/TANK_MAX_POWER*100, 30);
    fill(250, 0, 0);
    rect(50, 50, (power - TANK_MIN_POWER)/TANK_MAX_POWER*100, 30);
    popStyle();
  }

  void draw() {
    pushStyle();
    fill(team_colors[team]);
    line(this.x, y() - TANK_HEIGHT,
         aim_x()*TANK_BARREL_LENGTH + this.x,
         aim_y()*TANK_BARREL_LENGTH + y() - TANK_HEIGHT);
    ellipse(this.x, y() - TANK_HEIGHT, TANK_TOWER_RADIUS, TANK_TOWER_RADIUS);
    rect(this.x - TANK_WIDTH/2, y() - TANK_HEIGHT, TANK_WIDTH, TANK_HEIGHT);
    popStyle();
  }

  void shoot() {
    previous_projectile = new Projectile(
        aim_x()*TANK_BARREL_LENGTH + this.x,
        aim_y()*TANK_BARREL_LENGTH + y() - TANK_HEIGHT,
        aim_x()*power, aim_y()*power);
  }

  Tank nearest_enemy() {
    Tank nearest_enemy = null;
    float distance = 2*width;
    for (int i = 0; i < tanks.size(); ++i) {
      Tank tank = tanks.get(i);
      if (tank != this && team != tank.team && this.distance(tank) < distance) {
        nearest_enemy = tank;
        distance = this.distance(tank);
      }
    }
    if (nearest_enemy != null) {
      aim(nearest_enemy.x, nearest_enemy.y());
    }
    return nearest_enemy;
  }

  void aim(float target_x, float target_y) {
    if (target_x < this.x) {
      direction = -1;
    }
    else {
      direction = 1;
    }
    if (target_y < y()) {
      target_angle = 45;
    }
    else {
      target_angle = 5;
    }

    if (previous_projectile != null) {
      float projectile_dist = abs(previous_projectile.x - x);
      float enemy_dist = abs(target_x - x);
      if (abs(projectile_dist - enemy_dist) > 5) {
        if (projectile_dist > enemy_dist) {
          power *= 0.8;
        }
        else {
          power *= 1.1;
        }
      }
    }
    else {
      power = (TANK_MAX_POWER + TANK_MIN_POWER)/2;
    }
  }

  void fight() {
    if (health > 0) {
      if (target_enemy != null) {
        if (target_angle < barrel_angle) {
          lower_barrel();
        }
        else if (target_angle > barrel_angle) {
          lift_barrel();
        }
        else {
          if (previous_projectile == null || previous_projectile.dead) {
            aim(target_enemy.x, target_enemy.y());
            shoot();
            target_enemy = nearest_enemy();
          }
        }
      }
      else {
        target_enemy = nearest_enemy();
      }
    }
  }

  float distance(Tank other_tank) {
    return abs(this.x - other_tank.x);
  }

}

boolean draw_projectiles() {
  for (int i = projectiles.size() - 1; i >= 0; --i) {
    Projectile p = projectiles.get(i);
    p.draw();
    if (p.dead) {
      projectiles.remove(i);
    }
  }
  return false;
}

public class Projectile {
  float x, y;
  float vx, vy;
  boolean dead = false;
  float explosion_radius = 20;
  float damage = 10;

  public Projectile(float x, float y, float vx, float vy) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    projectiles.add(this);
  }

  void hit() {
    for (int i = 0; i < tanks.size(); ++i) {
      Tank tank = tanks.get(i);
      float dist = dist(tank.x, tank.y(), x, y);
      if (dist < explosion_radius/2) {
        tank.health -= damage;
      }
      else if (dist < explosion_radius) {
        tank.health -= damage/2;
      }
    }
    for (int i = -int(explosion_radius); i < int(explosion_radius); ++i) {
      int pos = int(x) + i;
      if (pos >= 0 && pos < width) {
        float diff = sqrt(sq(explosion_radius) - sq(i));
        if (ground[pos] < y - diff) {
          ground[pos] += 2*diff;
        }
        else if (ground[pos] < y + diff) {
          ground[pos] += y + diff - ground[pos];
        }
      }
    }
    ground_layer = null;
    update_ground_layer();
  }

  void draw() {
    x += vx;
    y += vy;
    vy += GRAVITY;
    ellipse(x, y, 10, 10);
    if (x > 0 && x < width && (y > ground[int(x)] || hits_tank())) {
      hit();
      new Explosion(x, y, explosion_radius);
      dead = true;
    }
    else if (y > height + 50) {
      dead = true;
    }
  }

  boolean hits_tank() {
    for (int i = 0; i < tanks.size(); ++i) {
      Tank tank = tanks.get(i);
      if (x > tank.x - TANK_WIDTH/2 && x < tank.x + TANK_WIDTH/2) {
        if (y > tank.y() - TANK_HEIGHT && y < tank.y()) {
          return true;
        }
      }
    }
    return false;
  }
}

public class Explosion extends Projectile{
  int ttl = 2;
  public Explosion(float x, float y, float radius) {
    super(x, y, 0, 0);
    explosion_radius = radius;
  }

  void draw() {
    pushStyle();
    fill(255, 0, 0);
    ellipse(x, y, 2*explosion_radius, 2*explosion_radius);
    popStyle();
    if (ttl <= 0) {
      dead = true;
    }
    ttl--;
  }

}


void generate_ground() {
  ground = new int[width];
  float ground_level = height/2;
  float steepness = 0;
  for (int i = 0; i < width; ++i) {
    steepness = constrain(steepness + randomGaussian()/2, -MAX_STEEPNESS, MAX_STEEPNESS);
    ground_level += steepness;
    ground[i] = int(ground_level);
    if (ground_level < 100) {
      steepness += MAX_STEEPNESS;
    }
    else if (ground_level > height - 100) {
      steepness -= MAX_STEEPNESS;
    }
  }
  ground_layer = null;
  update_ground_layer();
}

void update_ground_layer() {
  ground_unstable = false;
  //for (int k = 0; k < 3; ++k) {
  for (int i = 0; i < width; ++i) {
    if (i > 1) {
      int diff = ground[i - 1] - ground[i];
      // slide
      if (diff > MAX_STEEPNESS || -diff > MAX_STEEPNESS) {
        ground[i - 1] -= int(0.5*diff);
        ground[i] += int(0.5*diff);
        ground_unstable = true;
        ground_layer = null;
      }
    }
  }
  //}
  if (ground_layer == null) {
    ground_layer = createGraphics(width, height);
    ground_layer.beginDraw();
    ground_layer.stroke(70, 130, 0);
    for (int i = 0; i < width; ++i) {
      ground_layer.line(i, ground[i], i, height);
    }
    ground_layer.endDraw();
  }
}

void draw_ground() {
  image(ground_layer, 0, 0);
}
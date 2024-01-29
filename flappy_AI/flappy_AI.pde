import java.util.*;

final float GRAVITY = 0.05;
final float BIRD_POSITION = 200;
final float BIRD_RADIUS = 15;
final int BIRD_COUNT = 10000;
final int TOP_N = 100;
final float HOLE_RADIUS = 150;
final float HOLE_WIDTH = 50;
final int HOLE_FREQUENCY = 300;
final float SPEED = 3;
final float FLAP_STRENGTH = 4;

int points = 0;
int rounds = 0;
int record = 0;

boolean active = false;
boolean show_brain = false;
int starting_frame = 0;
int next_hole_frame = -1;

Hole next_hole = null;
Hole hole_after_that = null;
Bird best_bird = null;
Bird best_bird_ever = null;

Node distance_node = new DistanceNode();

PImage img;

void setup() {
  //size(1000, 800, P2D);
  img = loadImage("Flappy_Bird.png");
  fullScreen(P2D);
  frameRate(200);
  restart();
}

void draw() {
  if (active) {
    background(41,170,7);
    draw_holes();
    if (show_brain && best_bird != null) {
      best_bird.brains.draw();
    }
    draw_birds();

    text("Points: " + points, 50, 50);
    text("Record: " + record, 50, 75);
    text("Round: " + rounds, 50, 100);
    text("Time: " + (frameCount - starting_frame), 150, 50);
    if (best_bird_ever != null) {
      text("Record time: " + best_bird_ever.time, 150, 75);
    }



    if (next_hole != null) {
      ellipse(next_hole.x, next_hole.position, 10, 10);
    }
    if (hole_after_that != null) {
      rect(hole_after_that.x, hole_after_that.position, 10, 10);
    }
    if (frameCount == next_hole_frame) {
      new Hole();
      next_hole_frame = frameCount + HOLE_FREQUENCY - 10*points;
    }
  }
}

void keyPressed() {
  if (!active) {
    restart();
  }
  else if (keyCode == 'B') {
    show_brain = !show_brain;
  }
  else if (keyCode == 'K') {
    kill_all_birds();
  }
}

void restart() {
  active = true;
  points = 0;
  rounds++;

  ArrayList<Bird> top_n = new ArrayList<Bird>();
  if (birds.size() > 0) {
    Collections.sort(birds);
    for (int i = 0; i < TOP_N; ++i) {
      top_n.add(birds.get(i));
    }
  }

  holes.clear();
  birds.clear();
  for (int t = 0; t < top_n.size(); ++t) {
    Bird b = new Bird(top_n.get(t), false);
    if (t == 0) {
      best_bird = b;
    }
  }
  for (int i = 0; i < BIRD_COUNT/TOP_N; ++i) {
    if (top_n.size() > 0) {
      for (int t = 0; t < top_n.size(); ++t) {
        new Bird(top_n.get(t), true);
      }
    }
    else {
      for (int t = 0; t < TOP_N; ++t) {
        new Bird();
      }
    }
  }
  starting_frame = frameCount;
  next_hole_frame = frameCount + HOLE_FREQUENCY - points;
}

void end_round() {
  active = false;
  if (best_bird_ever == null || best_bird_ever.time < best_bird.time) {
    best_bird_ever = best_bird;
  }
  if (points > record) {
    record = points;
  }
  restart();
}


ArrayList<Bird> birds = new ArrayList<Bird>();

void draw_birds() {
  int alive_birds = 0;
  for (int i = 0; i < birds.size(); ++i) {
    if (birds.get(i).draw()) {
      alive_birds++;
    }
  }
  text("Birds alive: " + alive_birds, 150, 100);
  if (alive_birds == 0) {
    end_round();
  }
}

void kill_all_birds() {
  for (Bird bird : birds) {
    if (bird.alive) {
      bird.die();
    }
  }
}

public class Bird implements Comparable<Bird> {
  boolean alive = true;
  float y = 0;
  float vy = 0;
  int points = 0;
  int time = 0;
  Network brains;
  boolean best = false;

  public Bird () {
    birds.add(this);
    y = height/2;
    brains = new Network(5, 7, input_layer());
  }

  public Bird (Bird parent, boolean mutate) {
    birds.add(this);
    y = height/2;
    y = random(height/4, 3*height/4);
    brains = new Network(parent.brains, input_layer(), mutate);
  }

  ArrayList<Node> input_layer() {
    ArrayList<Node> input_layer = new ArrayList<Node>();
    input_layer.add(distance_node);
    input_layer.add(new TargetHeightNode(this));
    //input_layer.add(new FollowingTargetHeightNode(this));
    input_layer.add(new HeightNode(this));
    //input_layer.add(new DepthNode(this));
    input_layer.add(new SpeedNode(this));
    return input_layer;
  }

  void die() {
    this.alive = false;
    this.points = points;
    int off_target = int(abs(height/2 - y));
    if (next_hole != null) {
      off_target = int(abs(height/2 - y));
    }
    this.time = frameCount - starting_frame - off_target;
  }

  boolean draw() {
    if (alive) {
      y += vy;
      vy += GRAVITY;
      if (flap_or_not()) {
        flap();
      }
      pushStyle();
      if (this == best_bird) {
        fill(0,0,200);
        line(BIRD_POSITION - 50, y, BIRD_POSITION + 50, y);
      }
      image(img, BIRD_POSITION - img.width/2, y - img.height/2);
      //ellipse(BIRD_POSITION, y, 2*BIRD_RADIUS, 2*BIRD_RADIUS);
      popStyle();
      if (this.y > height || this.y < 0) {
        die();
      }
    }
    return this.alive;
  }

  boolean flap_or_not() {
    if (this.brains.value() > 0) {
      return true;
    }
    return false;
  }

  boolean simple_flap_or_not() {
    if (next_hole != null && next_hole.position + HOLE_RADIUS <= this.y + BIRD_RADIUS + 5) {
      return true;
    }
    return false;
  }

  void flap() {
    vy = -FLAP_STRENGTH;
  }

  @Override
  public int compareTo(Bird bird) {
    return bird.time - this.time;
  }

}


ArrayList<Hole> holes = new ArrayList<Hole>();

void draw_holes() {
  next_hole = null;
  hole_after_that = null;
  for (int i = holes.size() - 1; i >= 0; --i) {
    holes.get(i).draw();
  }
}

public class Hole {
  float position;
  float x;
  boolean passed = false;

  public Hole () {
    x = 1.5*width;
    position = random(100, height - 100);
    holes.add(this);
  }

  void draw() {
    x -= SPEED;
    if (x + HOLE_WIDTH < 0) {
      holes.remove(this);
      return;
    }

    Bird bird = null;
    for (int i = 0; i < birds.size(); ++i) {
      bird = birds.get(i);

      if (x < BIRD_POSITION && BIRD_POSITION < x + HOLE_WIDTH) {
        if (bird.y - BIRD_RADIUS < position - HOLE_RADIUS + points ||
            bird.y + BIRD_RADIUS > position + HOLE_RADIUS - points) {
          bird.die();
        }
      }
      else if (!passed && x + HOLE_WIDTH < BIRD_POSITION) {
        passed = true;
        points++;
      }
    }
    pushStyle();
    fill(240,7,12);
    rect(x, 0, HOLE_WIDTH, position - HOLE_RADIUS + points);
    rect(x, position + HOLE_RADIUS - points, HOLE_WIDTH, height - HOLE_RADIUS + points - position);
    popStyle();
    if (!passed) {
      hole_after_that = next_hole;
      next_hole = this;
    }
  }

}

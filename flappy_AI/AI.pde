
public class DistanceNode extends InputNode {
  public DistanceNode () {
    super("Dist");
  }
  float value() {
    if (next_hole == null) {
      return 1;
    }
    else {
      return min(1, (next_hole.x - BIRD_POSITION)/width);
    }
  }
}

public class TargetHeightNode extends InputNode {
  Bird bird;
  public TargetHeightNode (Bird bird) {
    super("Target");
    this.bird = bird;
  }
  float value() {
    if (next_hole == null) {
      return 0;
    }
    else {
      return (next_hole.position - bird.y)*2/height;
    }
  }
}

public class FollowingTargetHeightNode extends InputNode {
  Bird bird;
  public FollowingTargetHeightNode (Bird bird) {
    super("Next");
    this.bird = bird;
  }
  float value() {
    if (hole_after_that == null) {
      return 0;
    }
    else {
      return (hole_after_that.position - bird.y)*2/height;
    }
  }
}

public class MiddleNode extends InputNode {
  Bird bird;
  public MiddleNode (Bird bird) {
    super("Height");
    this.bird = bird;
  }
  float value() {
    return (bird.y - height/2)/height;
  }
}

public class HeightNode extends InputNode {
  Bird bird;
  public HeightNode (Bird bird) {
    super("Height");
    this.bird = bird;
  }
  float value() {
    return (height - bird.y)/height;
  }
}

public class DepthNode extends InputNode {
  Bird bird;
  public DepthNode (Bird bird) {
    super("Depth");
    this.bird = bird;
  }
  float value() {
    return (bird.y)/height;
  }
}

public class SpeedNode extends InputNode {
  Bird bird;
  public SpeedNode (Bird bird) {
    super("Speed");
    this.bird = bird;
  }
  float value() {
    return bird.vy/FLAP_STRENGTH;
    //return bird.vy;
  }
}

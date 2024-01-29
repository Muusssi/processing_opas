final float MUTATION_CHANCE = 0.1;
final float MUTATION_SIZE = 0.9;

public abstract class Node {
  abstract float value();
}


public class NeuralNode extends Node {

  float value;
  float[] bias;
  float[] weigth;
  ArrayList<Node> previous_layer;
  int updated_previously = -1;


  public NeuralNode (ArrayList<Node> previous_layer) {
    this.bias = new float[previous_layer.size()];
    this.weigth = new float[previous_layer.size()];
    this.previous_layer = previous_layer;
    for (int i = 0; i < previous_layer.size(); ++i) {
      this.bias[i] = random(-2, 2);
      this.weigth[i] = random(-2, 2);
    }
  }

  public NeuralNode (Node parent, ArrayList<Node> previous_layer, boolean mutate) {
    NeuralNode parent_neuron = (NeuralNode) parent;
    this.bias = parent_neuron.bias.clone();
    this.weigth = parent_neuron.weigth.clone();
    this.previous_layer = previous_layer;
    if (mutate) {
      for (int i = 0; i < previous_layer.size(); ++i) {
        if (random(0, 1) < MUTATION_CHANCE/2) {
          bias[i] = random(-2, 2);
        }
        else if (random(0, 1) < MUTATION_CHANCE) {
          bias[i] += random(-MUTATION_SIZE, MUTATION_SIZE);
        }
        if (random(0, 1) < MUTATION_CHANCE/2) {
          weigth[i] = random(-2, 2);
        }
        else if (random(0, 1) < MUTATION_CHANCE) {
          weigth[i] += random(-MUTATION_SIZE, MUTATION_SIZE);
        }
      }
    }
  }

  float value() {
    if (frameCount > updated_previously) {
      value = 0;
      for (int i = 0; i < previous_layer.size(); ++i) {
        value += bias[i] + weigth[i]*previous_layer.get(i).value();
      }
      value /= previous_layer.size();
      if (value < 0) value = 0;
    }
    updated_previously = frameCount;
    return value;
  }

}

public class InputNode extends Node {
  String name;
  public InputNode (String name) {
    this.name = name;
  }

  float value() {
    return 0.1;
  }
}

public class Network {

  ArrayList<Node> first_layer;

  ArrayList<ArrayList<Node>> layers = new ArrayList<ArrayList<Node>>();
  Node result;

  public Network (int depth, int network_width, ArrayList<Node> first_layer) {
    this.first_layer = first_layer;
    layers.add(first_layer);
    for (int d = 0; d < depth; ++d) {
      ArrayList<Node> layer = new ArrayList<Node>();
      for (int i = 0; i < network_width; ++i) {
        layer.add(new NeuralNode(layers.get(layers.size() - 1)));
      }
      layers.add(layer);
    }
    ArrayList<Node> result_layer = new ArrayList<Node>();
    result = new NeuralNode(layers.get(layers.size() - 1));
    result_layer.add(result);
    layers.add(result_layer);
  }

  public Network (Network parent, ArrayList<Node> first_layer, boolean mutate) {
    this.first_layer = first_layer;
    layers.add(first_layer);
    for (int d = 1; d < parent.layers.size(); ++d) {
      ArrayList<Node> layer = new ArrayList<Node>();
      for (int i = 0; i < parent.layers.get(d).size(); ++i) {
        layer.add(new NeuralNode(parent.layers.get(d).get(i), layers.get(layers.size() - 1), mutate));
      }
      layers.add(layer);
    }
    result = layers.get(layers.size() - 1).get(0);
  }

  float value() {
    return result.value();
  }

  void draw() {
    pushStyle();
    final int GRID = 50;
    rect(2*width/3, 0, 2*width/3, height);

    ArrayList<Node> previous_layer = null;
    for (int l = 0; l < layers.size(); ++l) {
      for (int i = 0; i < layers.get(l).size(); ++i) {
        Node node = layers.get(l).get(i);
        if (node.value() > 0) {
          fill(map(node.value(), 0, 1, 0, 255), 0, 0);
        }
        else if (node.value() < 0) {
          fill(0, 0, map(node.value(), 0, -1, 0, 255));
        }
        else {
          fill(0);
        }
        ellipse((i+1)*GRID + 2*width/3, (l+1)*GRID*3, 30, 30);
        text(node.value(), (i+1)*GRID + 2*width/3, (l+1)*GRID*3 + GRID);
        if (previous_layer != null) {
          NeuralNode nnode = (NeuralNode) node;
          for (int p = 0; p < previous_layer.size(); ++p) {
            if (previous_layer.get(p).value()*nnode.weigth[p] + nnode.bias[p] > 0.1) {
              stroke(255,0,0);
              line((i+1)*GRID + 2*width/3, (l+1)*GRID*3, (p+1)*GRID + 2*width/3, (l)*GRID*3);
            }
            else if (previous_layer.get(p).value()*nnode.weigth[p] + nnode.bias[p] > 0.1) {
              stroke(0,0,255);
              line((i+1)*GRID + 2*width/3, (l+1)*GRID*3, (p+1)*GRID + 2*width/3, (l)*GRID*3);
            }

          }
        }

      }
      previous_layer = layers.get(l);
    }
    popStyle();
  }

}

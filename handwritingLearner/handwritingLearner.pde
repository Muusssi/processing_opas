
StringList chars = new StringList();
ArrayList<float[][]> charPointList = new ArrayList<float[][]>();


ArrayList<float[]> pointList = new ArrayList<float[]>();
float[] point;

void setup() {
  size(400,400);
  textSize(50);
}

void draw() {
  
}

void mouseDragged() {
  ellipse(mouseX,mouseY,30,30);
  point = new float[2];
  point[0] = mouseX;
  point[1] = mouseY;
  pointList.add(point);
}

void keyPressed() {
  float[][] array = normalize(choosePoints(pointList));
  drawPointList(array);
  if (keyCode >= 65 && keyCode <= 90) {
    chars.append(getFromKey(keyCode));
    charPointList.add(array);
  }
  else if (keyCode == 91) {
    chars.append("Å");
    charPointList.add(array);
  }
  else if (keyCode == 222) {
    chars.append("Ä");
    charPointList.add(array);
  }
  else if (keyCode == 59) {
    chars.append("Ö");
    charPointList.add(array);
  }
  else if (keyCode >= 48 && keyCode<=57) {
    chars.append(str(keyCode-48));
    charPointList.add(array);
  }
  else if (keyCode == 32) {
    int bestGuess = -1;
    float minDTW = 1000000;
    float dtw;
    for (int i=0; i<charPointList.size(); i++) {
      dtw = DTWdistance(array, charPointList.get(i));
      if (dtw < minDTW) {
        bestGuess = i;
        minDTW = dtw;
      }
    }
    
    if (bestGuess >= 0) {
      fill(0);
      text(chars.get(bestGuess),55,55);
      fill(255);
      print(chars.get(bestGuess)+": ");
      println(minDTW);
    }
  }
  else {
    println("Not added char");
  }
  pointList = new ArrayList<float[]>();
}

void drawPointList(float[][] pointArray) {
  background(200);
  for (int i=0; i<pointArray.length;i++) {
    ellipse(pointArray[i][0]*width,pointArray[i][1]*height,30,30);
  }
}

String[] letters = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
String getFromKey(int keyNum) {
  return letters[keyNum-65];
}
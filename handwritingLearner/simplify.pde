int usedPoints = 20;


float[][] choosePoints(ArrayList<float[]> pointList) {
  float[] point;
  float[][] chosenPoints = new float[usedPoints][2];
  for (int i=0; i<usedPoints; i++) {
    point = new float[2];
    chosenPoints[i] = pointList.get(i*pointList.size()/usedPoints);
  }
  return chosenPoints;
}

float[][] normalize(float[][] pointArray) {
  float[][] normalized = new float[pointArray.length][2];
  float maxWidth = 0;
  float minWidth = 2000;
  float maxHeight = 0;
  float minHeight = 2000;
  //float xSum = 0;
  //float ySum = 0;
  for (int i=0; i<pointArray.length; i++) {
    if (pointArray[i][0] > maxWidth)
      maxWidth = pointArray[i][0];
    if (pointArray[i][0] < minWidth)
      minWidth = pointArray[i][0];
    if (pointArray[i][1] > maxHeight)
      maxHeight = pointArray[i][1];
    if (pointArray[i][1] < minHeight)
      minHeight = pointArray[i][1];
    //xSum += pointArray[i][0]; ySum += pointArray[i][1];
  }
  for (int i=0; i<pointArray.length; i++) {
    normalized[i][0] = map(pointArray[i][0], minWidth, maxWidth, 0, 1);
    normalized[i][1] = map(pointArray[i][1], minHeight, maxHeight, 0, 1);
  }
  return normalized;
}
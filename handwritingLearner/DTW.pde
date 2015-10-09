
float DTWdistance(float[][] pointArray1,float[][] pointArray2) {
  float[][] DTWtable = new float[pointArray1.length+1][pointArray2.length+1];
  for (int i=1; i<=pointArray1.length; i++) {
    DTWtable[i][0] = 99999999;
  }
  
  for (int j=1; j<=pointArray2.length; j++) {
    DTWtable[0][j] = 99999999;
  }
  DTWtable[0][0] = 0;
  
  
  for (int i=0; i<pointArray1.length; i++) {
    for (int j=0; j<pointArray2.length; j++) {
      DTWtable[i+1][j+1] = dist(pointArray1[i][0],pointArray1[i][1],pointArray2[j][0],pointArray2[j][1]);
      if (i>0 && j>0) {
        DTWtable[i+1][j+1] += min(DTWtable[i][j+1],DTWtable[i+1][j],DTWtable[i][j]);
      }
    }
  }
  return DTWtable[pointArray1.length][pointArray2.length];
}